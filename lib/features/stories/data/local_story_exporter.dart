import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:story_video_encoder/story_video_encoder.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/rendering/story_canvas.dart';
import '../domain/music_track.dart';
import '../domain/story_film.dart';
import 'story_exporter.dart';
import 'story_files.dart';

/// The photo library, behind a seam for tests.
class StoryGallery {
  const StoryGallery();

  Future<bool> hasAccess() => Gal.hasAccess();
  Future<bool> requestAccess() => Gal.requestAccess();
  Future<void> putImage(String path) => Gal.putImage(path);
  Future<void> putVideo(String path) => Gal.putVideo(path);
}

typedef StoryShareSheet = Future<ShareResult> Function(ShareParams params);

Future<ShareResult> _systemShareSheet(ShareParams params) =>
    SharePlus.instance.share(params);

/// [StoryExporter] that renders on the device: images with [StoryCanvas],
/// videos frame by frame into the native [StoryVideoEncoder].
class LocalStoryExporter implements StoryExporter {
  LocalStoryExporter({
    StoryFiles files = const StoryFiles(),
    StoryShareSheet shareSheet = _systemShareSheet,
    StoryGallery gallery = const StoryGallery(),
    this.staleAfter = const Duration(minutes: 30),
  }) : _files = files,
       _shareSheet = shareSheet,
       _gallery = gallery;

  final StoryFiles _files;
  final StoryShareSheet _shareSheet;
  final StoryGallery _gallery;

  /// Exports older than this are deleted when a new export starts (a share
  /// target has long copied them); all of them go on the next app start.
  final Duration staleAfter;

  /// Music fades out over the last 1.5 s of a video.
  static const musicFadeOut = Duration(milliseconds: 1500);

  @override
  Future<File> exportImage(BuildContext context, Widget page) async {
    final canvas = StoryCanvas.fromContext(context);
    try {
      await _deleteStaleExports();
      final png = await canvas.renderPng(page);
      final file = await _files.newFile('png');
      await file.writeAsBytes(png, flush: true);
      AppLogger.event('story_image_exported');
      return file;
    } finally {
      canvas.dispose();
    }
  }

  @override
  Future<File> exportVideo(
    BuildContext context,
    StoryFilm film, {
    MusicTrack? music,
    Duration musicStart = Duration.zero,
    void Function(double progress)? onProgress,
    StoryExportCancel? cancel,
  }) async {
    // Everything taken from the context before the first await.
    final bundle = DefaultAssetBundle.of(context);
    final imageConfiguration = createLocalImageConfiguration(context);
    var canvas = StoryCanvas.fromContext(context);
    final smallCanvas = StoryCanvas.fromContext(context, pixelRatio: 2);

    void checkCancelled() {
      if (cancel?.isCancelled ?? false) throw const StoryExportCancelled();
    }

    File? audio;
    File? output;
    StoryVideoSession? session;
    final keptImages = <_KeptImage>[];
    try {
      await _deleteStaleExports();
      checkCancelled();
      output = await _files.newFile('mp4');
      if (music != null) {
        audio = await _copyMusic(bundle, music);
      }
      // Decoded once and kept alive for every frame.
      for (final image in film.images) {
        keptImages.add(await _KeptImage.load(image, imageConfiguration));
        checkCancelled();
      }

      final fadeOut = Duration(
        microseconds: math.min(
          musicFadeOut.inMicroseconds,
          film.duration.inMicroseconds ~/ 2,
        ),
      );
      Future<StoryVideoSession> start(StoryCanvas canvas) {
        final size = canvas.pixelSize;
        return StoryVideoEncoder.start(
          outputPath: output!.path,
          width: size.width.round(),
          height: size.height.round(),
          fps: film.fps,
          audioPath: audio?.path,
          audioStart: audio == null ? null : musicStart,
          fadeOut: audio == null ? null : fadeOut,
        );
      }

      try {
        session = await start(canvas);
      } on UnsupportedVideoSizeException {
        // Older encoders stop below 1080p: 720×1280 still looks fine in
        // Stories.
        AppLogger.event('story_video_720p_fallback');
        canvas = smallCanvas;
        session = await start(canvas);
      }

      final frameCount = film.frameCount;
      for (var index = 0; index < frameCount; index++) {
        checkCancelled();
        final time = Duration(
          microseconds: (index * Duration.microsecondsPerSecond / film.fps)
              .round(),
        );
        final rgba = await canvas.renderRgba(
          Builder(builder: (context) => film.buildFrame(context, time)),
        );
        checkCancelled();
        // Completes once the encoder consumed the frame: one in flight.
        await session.addFrame(rgba);
        onProgress?.call(0.97 * (index + 1) / frameCount);
      }
      checkCancelled();
      final path = await session.finish();
      if (cancel?.isCancelled ?? false) {
        await _deleteQuietly(File(path));
        throw const StoryExportCancelled();
      }
      onProgress?.call(1);
      AppLogger.event('story_video_exported');
      return File(path);
    } catch (error) {
      // Stops the encoder (it deletes its partial files) and removes ours.
      await session?.cancel();
      if (output != null) await _deleteQuietly(output);
      if (error is! StoryExportCancelled) {
        AppLogger.event('story_video_failed');
      }
      rethrow;
    } finally {
      for (final image in keptImages) {
        image.release();
      }
      canvas.dispose();
      smallCanvas.dispose();
      if (audio != null) await _deleteQuietly(audio);
    }
  }

  @override
  Future<bool> share(BuildContext context, File file, {String? text}) async {
    // iPad needs an anchor for the share popover.
    final box = context.findRenderObject();
    final origin = box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    final result = await _shareSheet(
      ShareParams(
        text: text,
        files: [XFile(file.path, mimeType: _mimeType(file.path))],
        sharePositionOrigin: origin,
      ),
    );
    AppLogger.event('story_shared_${result.status.name}');
    return result.status == ShareResultStatus.success;
  }

  @override
  Future<void> saveToGallery(File file) async {
    if (!await _gallery.hasAccess() && !await _gallery.requestAccess()) {
      throw const StoryGalleryAccessDenied();
    }
    try {
      if (_isVideo(file.path)) {
        await _gallery.putVideo(file.path);
      } else {
        await _gallery.putImage(file.path);
      }
    } on GalException catch (error) {
      if (error.type == GalExceptionType.accessDenied) {
        throw const StoryGalleryAccessDenied();
      }
      rethrow;
    }
    AppLogger.event('story_saved_to_gallery');
  }

  /// The encoder reads music from a file; bundled assets are not files.
  Future<File> _copyMusic(AssetBundle bundle, MusicTrack music) async {
    final data = await bundle.load(music.assetPath);
    final dir = await _files.directory();
    final extension = p.extension(music.assetPath);
    final file = File(p.join(dir.path, 'music_${music.id}$extension'));
    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    return file;
  }

  Future<void> _deleteStaleExports() async {
    final dir = await _files.directory(create: false);
    if (!await dir.exists()) return;
    final cutoff = DateTime.now().subtract(staleAfter);
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      try {
        if ((await entity.lastModified()).isBefore(cutoff)) {
          await entity.delete();
        }
      } on FileSystemException {
        // In use or already gone; the app-start cleanup gets it.
      }
    }
  }

  static Future<void> _deleteQuietly(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // Already gone.
    }
  }

  static bool _isVideo(String path) =>
      p.extension(path).toLowerCase() == '.mp4';

  static String _mimeType(String path) =>
      _isVideo(path) ? 'video/mp4' : 'image/png';
}

/// Keeps one decoded image in the image cache while a video renders, so
/// every frame finds it ready.
class _KeptImage {
  _KeptImage._(this._stream, this._listener);

  final ImageStream _stream;
  final ImageStreamListener _listener;

  static Future<_KeptImage> load(
    ImageProvider provider,
    ImageConfiguration configuration,
  ) async {
    final completer = Completer<void>();
    void done() {
      if (!completer.isCompleted) completer.complete();
    }

    final stream = provider.resolve(configuration);
    final listener = ImageStreamListener(
      (_, _) => done(),
      // A broken photo is drawn as the template's placeholder.
      onError: (_, _) => done(),
    );
    stream.addListener(listener);
    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {},
    );
    return _KeptImage._(stream, listener);
  }

  void release() => _stream.removeListener(_listener);
}
