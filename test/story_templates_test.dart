import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/core/rendering/story_canvas.dart';
import 'package:life_threads/features/stories/domain/story_template.dart';
import 'package:life_threads/features/stories/presentation/story_template_film.dart';
import 'package:life_threads/features/stories/presentation/templates/story_templates.dart';

import 'support/story_fixtures.dart';

/// The app theme plus the Arabic fallback a phone adds by itself.
final _theme = AppTheme.dark.copyWith(
  textTheme: AppTheme.dark.textTheme.apply(fontFamilyFallback: ['SF Arabic']),
);

/// Set STORY_SAMPLES_DIR to keep the rendered PNGs for a look.
final _samplesDir = Platform.environment['STORY_SAMPLES_DIR'];

void main() {
  late Directory dir;

  setUpAll(() async {
    await loadStoryFontsIfAvailable();
  });

  setUp(() {
    dir = Directory.systemTemp.createTempSync('story_templates_test');
  });

  tearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<img.Image> render(
    WidgetTester tester,
    Widget page, {
    Locale locale = const Locale('en'),
    String? sample,
  }) async {
    final png = await tester.runAsync(() async {
      final canvas = StoryCanvas(locale: locale, theme: _theme);
      try {
        return await canvas.renderPng(page);
      } finally {
        canvas.dispose();
      }
    });
    final samples = _samplesDir;
    if (samples != null && sample != null) {
      Directory(samples).createSync(recursive: true);
      File('$samples/$sample.png').writeAsBytesSync(png!);
    }
    return img.decodePng(png!)!;
  }

  for (final template in StoryTemplate.values) {
    for (final count in [1, 3, 6]) {
      for (final locale in const [Locale('en'), Locale('ar')]) {
        testWidgets('${template.name} with $count memories renders 1080x1920 '
            '(${locale.languageCode})', (tester) async {
          final memories = storyMemories(
            dir,
            count,
            arabic: locale.languageCode == 'ar',
          );
          final image = await render(
            tester,
            StoryPage(
              template: template,
              memories: memories,
              caption: defaultStoryCaption(memories),
            ),
            locale: locale,
            sample: '${template.name}_${count}_${locale.languageCode}',
          );
          expect(image.width, 1080);
          expect(image.height, 1920);
          // Dark wall in the bottom corner, like the app.
          final corner = image.getPixel(8, 1910);
          expect(corner.r + corner.g + corner.b, lessThan(150));
        });
      }
    }
  }

  testWidgets('the single template shows the memory photo full-bleed', (
    tester,
  ) async {
    final memories = storyMemories(dir, 1);
    final image = await render(
      tester,
      StoryPage(template: StoryTemplate.single, memories: memories),
    );
    // Upper part of the photo: the first memory's colour (230, 140, 90).
    final pixel = image.getPixel(540, 600);
    expect(pixel.r, closeTo(230, 30));
    expect(pixel.g, closeTo(140, 30));
    expect(pixel.b, closeTo(90, 30));
  });

  testWidgets('film frames are deterministic and change over time', (
    tester,
  ) async {
    final memories = storyMemories(dir, 3);
    final film = StoryTemplateFilm(
      template: StoryTemplate.thread,
      memories: memories,
      caption: 'Our year',
    );
    final frames = await tester.runAsync(() async {
      final canvas = StoryCanvas(
        logicalSize: const Size(360, 640),
        pixelRatio: 1,
      );
      try {
        Future<List<int>> at(Duration time) => canvas.renderRgba(
          Builder(builder: (context) => film.buildFrame(context, time)),
        );
        return [
          await at(const Duration(seconds: 3)),
          await at(const Duration(seconds: 3)),
          await at(const Duration(milliseconds: 600)),
        ];
      } finally {
        canvas.dispose();
      }
    });
    expect(frames![0], equals(frames[1]));
    expect(frames[0], isNot(equals(frames[2])));
  });

  test('films last 15–20 s at 30 fps for every template and count', () {
    final memories = storyMemories(dir, 6);
    for (final template in StoryTemplate.values) {
      for (var count = 1; count <= 6; count++) {
        final film = StoryTemplateFilm(
          template: template,
          memories: memories.take(count).toList(),
        );
        expect(film.fps, 30);
        expect(film.duration.inMilliseconds, inInclusiveRange(15000, 20000));
        expect(
          film.frameCount,
          (film.duration.inMicroseconds * 30 / 1000000).round(),
        );
        expect(film.images, hasLength(count));
      }
    }
  });
}
