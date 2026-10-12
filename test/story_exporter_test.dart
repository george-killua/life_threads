import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/features/stories/data/local_story_exporter.dart';
import 'package:life_threads/features/stories/data/music_catalog.dart';
import 'package:life_threads/features/stories/data/story_exporter.dart';
import 'package:life_threads/features/stories/data/story_files.dart';
import 'package:life_threads/features/stories/domain/story_film.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_video_encoder/story_video_encoder.dart';

/// Three frames, each a different colour.
class _TinyFilm extends StoryFilm {
  const _TinyFilm();

  @override
  Duration get duration => const Duration(milliseconds: 100);

  @override
  Widget buildFrame(BuildContext context, Duration time) {
    final shade = (time.inMilliseconds * 2).clamp(0, 255);
    return ColoredBox(color: Color.fromARGB(255, shade, 0, 0));
  }
}

class _FakeGallery extends StoryGallery {
  _FakeGallery({this.allowed = true});

  final bool allowed;
  final saved = <String>[];

  @override
  Future<bool> hasAccess() async => allowed;

  @override
  Future<bool> requestAccess() async => allowed;

  @override
  Future<void> putImage(String path) async => saved.add('image:$path');

  @override
  Future<void> putVideo(String path) async => saved.add('video:$path');
}

void main() {
  late Directory temp;
  late StoryFiles files;
  late List<MethodCall> calls;
  late Map<String, Object? Function(MethodCall call)> handlers;
  // Whether the music copy existed while the encoder started.
  int? musicBytesAtStart;

  setUp(() {
    temp = Directory.systemTemp.createTempSync('story_exporter_test');
    files = StoryFiles(temporaryDirectory: () async => temp);
    calls = [];
    musicBytesAtStart = null;
    handlers = {
      'start': (call) {
        final audio = (call.arguments as Map)['audioPath'] as String?;
        if (audio != null) musicBytesAtStart = File(audio).lengthSync();
        return 1;
      },
      'addFrame': (_) => null,
      'finish': (call) {
        final start = calls.firstWhere((c) => c.method == 'start');
        final path = (start.arguments as Map)['outputPath'] as String;
        File(path).writeAsBytesSync([0, 0, 0, 24]);
        return path;
      },
      'cancel': (_) => null,
    };
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(StoryVideoEncoder.channel, (call) async {
          calls.add(call);
          return handlers[call.method]!(call);
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(StoryVideoEncoder.channel, null);
    if (temp.existsSync()) temp.deleteSync(recursive: true);
  });

  Future<BuildContext> pumpContext(WidgetTester tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    return captured;
  }

  List<File> storyFiles() {
    final dir = Directory('${temp.path}/${StoryFiles.folderName}');
    if (!dir.existsSync()) return const [];
    return dir.listSync().whereType<File>().toList();
  }

  testWidgets('exports an image as a 1080x1920 PNG in the temp folder', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final exporter = LocalStoryExporter(files: files);
    final file = await tester.runAsync(
      () => exporter.exportImage(
        context,
        const ColoredBox(color: Color(0xFF00FF00)),
      ),
    );
    expect(file!.path, startsWith(temp.path));
    expect(file.path, endsWith('.png'));
    final png = img.decodePng(file.readAsBytesSync())!;
    expect([png.width, png.height], [1080, 1920]);
  });

  testWidgets('feeds every frame to the encoder with progress and music', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final exporter = LocalStoryExporter(files: files);
    final progress = <double>[];
    final track = bundledMusicTracks.first;
    final asset = await tester.runAsync(() => rootBundle.load(track.assetPath));

    final file = await tester.runAsync(
      () => exporter.exportVideo(
        context,
        const _TinyFilm(),
        music: track,
        onProgress: progress.add,
      ),
    );

    expect(file!.existsSync(), isTrue);
    expect(file.path, endsWith('.mp4'));
    final start = calls.first;
    expect(start.method, 'start');
    final args = start.arguments as Map;
    expect(args['width'], 1080);
    expect(args['height'], 1920);
    expect(args['fps'], 30);
    // Faded over 1.5 s, or half the film when it is shorter.
    expect(args['fadeOutUs'], 50000);
    expect(args['audioPath'], contains(StoryFiles.folderName));
    expect(musicBytesAtStart, asset!.lengthInBytes);
    // The music copy is gone afterwards.
    expect(File(args['audioPath'] as String).existsSync(), isFalse);

    final frames = calls.where((call) => call.method == 'addFrame').toList();
    expect(frames, hasLength(3));
    expect([for (final f in frames) (f.arguments as Map)['index']], [0, 1, 2]);
    expect(
      ((frames.first.arguments as Map)['rgba'] as Uint8List).length,
      1080 * 1920 * 4,
    );
    expect(calls.last.method, 'finish');
    expect(progress, isNotEmpty);
    for (var i = 1; i < progress.length; i++) {
      expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
    }
    expect(progress.last, 1.0);
  });

  testWidgets('without music no audio is passed', (tester) async {
    final context = await pumpContext(tester);
    final exporter = LocalStoryExporter(files: files);
    await tester.runAsync(
      () => exporter.exportVideo(context, const _TinyFilm()),
    );
    final args = calls.first.arguments as Map;
    expect(args['audioPath'], isNull);
    expect(args['fadeOutUs'], isNull);
  });

  testWidgets('cancel stops the encoder and deletes partial files', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final exporter = LocalStoryExporter(files: files);
    final cancel = StoryExportCancel();
    handlers['addFrame'] = (call) {
      cancel.cancel();
      return null;
    };
    handlers['start'] = (call) {
      // The native side has begun writing.
      File(
        (call.arguments as Map)['outputPath'] as String,
      ).writeAsBytesSync([1]);
      return 1;
    };

    final error = await tester.runAsync(() async {
      try {
        await exporter.exportVideo(
          context,
          const _TinyFilm(),
          music: bundledMusicTracks.first,
          cancel: cancel,
        );
        return null;
      } catch (error) {
        return error;
      }
    });

    expect(error, isA<StoryExportCancelled>());
    expect(calls.map((call) => call.method), contains('cancel'));
    expect(calls.map((call) => call.method), isNot(contains('finish')));
    expect(storyFiles(), isEmpty, reason: 'no mp4 and no music copy left');
  });

  testWidgets('an encoder failure cleans up and is rethrown', (tester) async {
    final context = await pumpContext(tester);
    final exporter = LocalStoryExporter(files: files);
    handlers['addFrame'] = (_) =>
        throw PlatformException(code: 'encoder_failure', message: 'boom');

    final error = await tester.runAsync(() async {
      try {
        await exporter.exportVideo(context, const _TinyFilm());
        return null;
      } catch (error) {
        return error;
      }
    });

    expect(error, isA<VideoEncoderException>());
    expect(storyFiles(), isEmpty);
  });

  testWidgets('falls back to 720x1280 when the device cannot encode 1080p', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final exporter = LocalStoryExporter(files: files);
    handlers['start'] = (call) {
      if ((call.arguments as Map)['width'] == 1080) {
        throw PlatformException(code: 'unsupported_size', message: 'no');
      }
      return 2;
    };

    await tester.runAsync(
      () => exporter.exportVideo(context, const _TinyFilm()),
    );

    final starts = calls.where((call) => call.method == 'start').toList();
    expect(starts, hasLength(2));
    expect((starts.last.arguments as Map)['width'], 720);
    expect((starts.last.arguments as Map)['height'], 1280);
    final frame = calls.firstWhere((call) => call.method == 'addFrame');
    expect(
      ((frame.arguments as Map)['rgba'] as Uint8List).length,
      720 * 1280 * 4,
    );
  });

  testWidgets('a new export deletes exports older than half an hour', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    final dir = await tester.runAsync(files.directory);
    final old = File('${dir!.path}/old.png')..writeAsBytesSync([1]);
    old.setLastModifiedSync(DateTime.now().subtract(const Duration(hours: 2)));
    final recent = File('${dir.path}/recent.png')..writeAsBytesSync([1]);

    await tester.runAsync(
      () => LocalStoryExporter(
        files: files,
      ).exportImage(context, const SizedBox.expand()),
    );

    expect(old.existsSync(), isFalse);
    expect(recent.existsSync(), isTrue, reason: 'may still be shared');
  });

  test('deleteExportedStories removes every story file', () async {
    final dir = await files.directory();
    File('${dir.path}/a.mp4').writeAsBytesSync([1]);
    File('${dir.path}/music_x.m4a').writeAsBytesSync([1]);
    await files.deleteExportedStories();
    expect(dir.existsSync(), isFalse);
    // Nothing to delete is fine too.
    await files.deleteExportedStories();
  });

  test('saveToGallery saves videos as videos and reports a denial', () async {
    final dir = await files.directory();
    final video = File('${dir.path}/story.mp4')..writeAsBytesSync([1]);
    final gallery = _FakeGallery();
    await LocalStoryExporter(
      files: files,
      gallery: gallery,
    ).saveToGallery(video);
    expect(gallery.saved, ['video:${video.path}']);

    expect(
      LocalStoryExporter(
        files: files,
        gallery: _FakeGallery(allowed: false),
      ).saveToGallery(video),
      throwsA(isA<StoryGalleryAccessDenied>()),
    );
  });

  testWidgets('share opens the system share sheet with the file', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    ShareParams? sent;
    final exporter = LocalStoryExporter(
      files: files,
      shareSheet: (params) async {
        sent = params;
        return const ShareResult('instagram', ShareResultStatus.success);
      },
    );
    final file = File('${temp.path}/story.mp4')..writeAsBytesSync([1]);

    final shared = await exporter.share(context, file);

    expect(shared, isTrue);
    expect(sent!.files!.single.path, file.path);
    expect(sent!.files!.single.mimeType, 'video/mp4');
  });
}
