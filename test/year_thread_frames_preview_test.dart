// Renders sample frames of Thread of the Year (film and year image) to PNG
// files for review, with the fonts and photos the store screenshots use.
// Only runs on macOS (system fonts); the files land in
// $TMPDIR/year_thread_frames.
@TestOn('mac-os')
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/core/rendering/story_canvas.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/year_thread/domain/year_thread.dart';
import 'package:life_threads/features/year_thread/domain/year_thread_timeline.dart';
import 'package:life_threads/features/year_thread/presentation/pages/year_thread_page.dart';
import 'package:life_threads/features/year_thread/presentation/year_thread_film.dart';
import 'package:life_threads/features/year_thread/presentation/year_thread_image_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../tool/store_screenshots/fonts.dart';
import 'support/on_this_day_fakes.dart';
import 'support/year_thread_fixtures.dart';

class _SampleRepository extends MemoryRepository {
  _SampleRepository(this.photos);

  final String photos;

  @override
  Future<MemoryState> build() async => sampleYear(photoDir: photos);
}

ThemeData _theme() => AppTheme.dark.copyWith(
  textTheme: AppTheme.dark.textTheme.apply(
    fontFamily: 'Avenir',
    fontFamilyFallback: const ['SF Arabic'],
  ),
);

void main() {
  final out = Directory(
    '${Platform.environment['TMPDIR'] ?? Directory.systemTemp.path}'
    '/year_thread_frames',
  );
  final photos = Directory('store_listing_assets/store_moments').absolute.path;

  testWidgets('renders sample frames', (tester) async {
    await tester.runAsync(loadStoreFonts);
    out.createSync(recursive: true);
    // flutter_test draws shadows without blur; the app does not.
    debugDisableShadows = false;
    final year = YearThread.year(sampleYear(photoDir: photos), 2025);
    final film = YearThreadFilm(stats: year.stats, memories: year.suggested);
    final timeline = film.timeline;
    final transition = YearThreadTimeline.transitionOf(timeline.shots[1]);
    final times = <String, Duration>{
      'a_title': const Duration(milliseconds: 2200),
      'b_title_fade': timeline.title - const Duration(milliseconds: 300),
      'c_first_shot': timeline.shotStart(0) + const Duration(seconds: 2),
      'd_rope_drawing':
          timeline.shotStart(1) +
          Duration(microseconds: transition.inMicroseconds ~/ 2),
      'e_second_shot': timeline.shotStart(1) + const Duration(seconds: 2),
      'f_closing_zoom':
          timeline.closingStart + const Duration(milliseconds: 900),
      'g_closing': timeline.closingStart + const Duration(seconds: 4),
    };

    for (final lang in ['en', 'ar']) {
      final theme = _theme();
      await tester.runAsync(() async {
        final canvas = StoryCanvas(locale: Locale(lang), theme: theme);
        try {
          for (final MapEntry(:key, :value) in times.entries) {
            final png = await canvas.renderPng(
              Builder(builder: (context) => film.buildFrame(context, value)),
            );
            File('${out.path}/${lang}_$key.png').writeAsBytesSync(png);
          }
          final image = await canvas.renderPng(
            YearThreadImagePage(stats: year.stats, memories: year.suggested),
          );
          File('${out.path}/${lang}_year_image.png').writeAsBytesSync(image);
        } finally {
          canvas.dispose();
        }
      });
    }
    debugDisableShadows = true;
    // ignore: avoid_print
    print('Year thread frames: ${out.path}');
  });

  testWidgets('renders the screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.runAsync(loadStoreFonts);
    out.createSync(recursive: true);
    tester.view.physicalSize = const Size(780, 3000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    for (final lang in ['en', 'ar']) {
      const key = ValueKey('screen');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            memoryRepositoryProvider.overrideWith(
              () => _SampleRepository(photos),
            ),
            premiumEntitlementProvider.overrideWith(
              () => FakePremium(isPremium: false),
            ),
          ],
          child: MaterialApp(
            theme: _theme(),
            locale: Locale(lang),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const RepaintBoundary(
              key: key,
              child: YearThreadPage(initialYear: 2025),
            ),
          ),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        await tester.pump(const Duration(milliseconds: 100));
      }
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        File(
          '${out.path}/${lang}_screen.png',
        ).writeAsBytesSync(bytes!.buffer.asUint8List());
      });
      await tester.pumpWidget(const SizedBox());
    }
  });
}
