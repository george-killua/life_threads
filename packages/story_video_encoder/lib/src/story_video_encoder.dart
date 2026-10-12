import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'exceptions.dart';

/// Entry point: starts native encoding sessions.
///
/// ```dart
/// final session = await StoryVideoEncoder.start(
///   outputPath: '${tmp.path}/story.mp4',
///   width: 1080,
///   height: 1920,
///   audioPath: '${tmp.path}/music.m4a',
///   fadeOut: const Duration(seconds: 2),
/// );
/// try {
///   for (var i = 0; i < 600; i++) {
///     await session.addFrame(await renderFrameRgba(i)); // backpressure
///   }
///   final path = await session.finish();
/// } catch (_) {
///   await session.cancel();
///   rethrow;
/// }
/// ```
abstract final class StoryVideoEncoder {
  /// The method channel shared by all sessions. Exposed for tests.
  @visibleForTesting
  static const MethodChannel channel =
      MethodChannel('dev.gkcoding.lifethreads/story_video_encoder');

  /// Largest supported dimension; H.264 level 5.2 tops out at 4096.
  static const int maxDimension = 4096;

  /// Starts an encoding session writing an H.264 MP4 to [outputPath].
  ///
  /// * [width] and [height] must be even (H.264 4:2:0 chroma); multiples of
  ///   16 are the safest choice on older Android encoders (1080 is fine on
  ///   every device that matters, but 720×1280 is the fallback).
  /// * Frames are timestamped `index / fps`, so the video lasts
  ///   `frameCount / fps` seconds regardless of how fast frames are added.
  /// * [audioPath]: optional audio file (AAC `.m4a` recommended; anything the
  ///   platform can decode works). It is read from [audioStart], trimmed to
  ///   the video length and, if [fadeOut] is set, faded to silence over the
  ///   last [fadeOut] of the video.
  ///
  /// Throws [ArgumentError] for invalid arguments and
  /// [UnsupportedVideoSizeException] when the device cannot encode the size.
  static Future<StoryVideoSession> start({
    required String outputPath,
    required int width,
    required int height,
    int fps = 30,
    int bitRate = 8000000,
    String? audioPath,
    Duration? audioStart,
    Duration? fadeOut,
  }) async {
    if (outputPath.isEmpty) {
      throw ArgumentError.value(outputPath, 'outputPath', 'must not be empty');
    }
    _checkDimension(width, 'width');
    _checkDimension(height, 'height');
    if (fps < 1 || fps > 120) {
      throw RangeError.range(fps, 1, 120, 'fps');
    }
    if (bitRate < 100000 || bitRate > 100000000) {
      throw RangeError.range(bitRate, 100000, 100000000, 'bitRate');
    }
    if (audioPath != null && audioPath.isEmpty) {
      throw ArgumentError.value(audioPath, 'audioPath', 'must not be empty');
    }
    if (audioPath == null && (audioStart != null || fadeOut != null)) {
      throw ArgumentError('audioStart and fadeOut require audioPath');
    }
    if (audioStart != null && audioStart.isNegative) {
      throw ArgumentError.value(audioStart, 'audioStart', 'must not be negative');
    }
    if (fadeOut != null && fadeOut <= Duration.zero) {
      throw ArgumentError.value(fadeOut, 'fadeOut', 'must be positive');
    }

    final id = await _invoke<int>('start', <String, Object?>{
      'outputPath': outputPath,
      'width': width,
      'height': height,
      'fps': fps,
      'bitRate': bitRate,
      'audioPath': audioPath,
      'audioStartUs': audioStart?.inMicroseconds,
      'fadeOutUs': fadeOut?.inMicroseconds,
    });
    if (id == null) {
      throw const VideoEncoderException('Platform returned no session id');
    }
    return StoryVideoSession._(
      id: id,
      outputPath: outputPath,
      width: width,
      height: height,
      fps: fps,
    );
  }

  static void _checkDimension(int value, String name) {
    if (value < 2 || value > maxDimension) {
      throw RangeError.range(value, 2, maxDimension, name);
    }
    if (value.isOdd) {
      throw ArgumentError.value(value, name, 'must be even');
    }
  }

  static Future<T?> _invoke<T>(String method, Map<String, Object?> args) async {
    try {
      return await channel.invokeMethod<T>(method, args);
    } on PlatformException catch (e) {
      throw StoryVideoException.fromPlatform(e);
    }
  }
}

/// Lifecycle of a [StoryVideoSession].
enum StoryVideoSessionState { encoding, finishing, finished, cancelled, failed }

/// One video being encoded. Obtain it from [StoryVideoEncoder.start].
class StoryVideoSession {
  StoryVideoSession._({
    required this.id,
    required this.outputPath,
    required this.width,
    required this.height,
    required this.fps,
  });

  /// Native session id.
  final int id;
  final String outputPath;
  final int width;
  final int height;
  final int fps;

  StoryVideoSessionState _state = StoryVideoSessionState.encoding;
  StoryVideoSessionState get state => _state;

  int _frameCount = 0;

  /// Number of frames handed to [addFrame] so far.
  int get frameCount => _frameCount;

  /// Length of the video so far (`frameCount / fps`).
  Duration get duration =>
      Duration(microseconds: _frameCount * Duration.microsecondsPerSecond ~/ fps);

  /// Byte length every frame must have (`width * height * 4`).
  int get frameByteLength => width * height * 4;

  /// Appends one frame: tightly packed RGBA8888, top row first, exactly
  /// [frameByteLength] bytes (what `ui.Image.toByteData(format:
  /// ImageByteFormat.rawRgba)` returns). Alpha is ignored.
  ///
  /// The returned future completes once the native encoder has consumed the
  /// pixels, so awaiting it before rendering the next frame keeps at most
  /// one frame in flight (backpressure).
  ///
  /// Throws [ArgumentError] / [StateError] synchronously for a wrong length
  /// or a session that is not encoding.
  Future<void> addFrame(Uint8List rgba) {
    _requireState(StoryVideoSessionState.encoding, 'addFrame');
    if (rgba.lengthInBytes != frameByteLength) {
      throw ArgumentError.value(
        rgba.lengthInBytes,
        'rgba.lengthInBytes',
        'expected $frameByteLength bytes ($width×$height×4)',
      );
    }
    final index = _frameCount++;
    return _guard(() => StoryVideoEncoder._invoke<void>('addFrame', {
          'id': id,
          'index': index,
          'rgba': rgba,
        }));
  }

  /// Finishes the video (and muxes the audio track, if any) and returns the
  /// path of the finished MP4 ([outputPath]).
  ///
  /// Throws [StateError] synchronously when no frame was added or the
  /// session is not encoding any more.
  Future<String> finish() {
    _requireState(StoryVideoSessionState.encoding, 'finish');
    if (_frameCount == 0) {
      throw StateError('finish() needs at least one frame');
    }
    _state = StoryVideoSessionState.finishing;
    return _finish();
  }

  Future<String> _finish() async {
    final path = await _guard(() => StoryVideoEncoder._invoke<String>(
          'finish',
          {'id': id, 'frameCount': _frameCount},
        ));
    final result = path ?? outputPath;
    if (_state == StoryVideoSessionState.cancelled) {
      // cancel() arrived while the platform was already finishing.
      try {
        File(result).deleteSync();
      } on FileSystemException {
        // Already gone.
      }
      throw const StoryVideoException('cancelled', 'Cancelled while finishing');
    }
    _state = StoryVideoSessionState.finished;
    return result;
  }

  /// Stops encoding and deletes the partial output. Safe to call at any
  /// time; does nothing after the session finished, failed or was cancelled.
  /// If [finish] is already running, its future then fails with a
  /// [StoryVideoException] (code `cancelled`) and the file is deleted.
  Future<void> cancel() async {
    if (_state == StoryVideoSessionState.finishing) {
      _state = StoryVideoSessionState.cancelled;
      return;
    }
    if (_state != StoryVideoSessionState.encoding) return;
    _state = StoryVideoSessionState.cancelled;
    try {
      await StoryVideoEncoder._invoke<void>('cancel', {'id': id});
    } on EncoderSessionException {
      // Already gone on the native side (e.g. it failed and cleaned up).
    }
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on StoryVideoException {
      // The native side releases everything and deletes partial files on
      // failure, so the session cannot be used any more.
      if (_state != StoryVideoSessionState.cancelled) {
        _state = StoryVideoSessionState.failed;
      }
      rethrow;
    }
  }

  void _requireState(StoryVideoSessionState expected, String method) {
    if (_state != expected) {
      throw StateError('$method() called on a session that is ${_state.name}');
    }
  }
}
