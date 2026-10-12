// Thread of the Year film: its schedule, the 20 s story cut, and frames that
// only depend on the time.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/rendering/story_canvas.dart';
import 'package:life_threads/features/year_thread/domain/year_thread.dart';
import 'package:life_threads/features/year_thread/domain/year_thread_timeline.dart';
import 'package:life_threads/features/year_thread/presentation/year_thread_film.dart';
import 'package:life_threads/features/year_thread/presentation/year_thread_image_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/year_thread_fixtures.dart';

YearThreadFilm filmOf(int count, {YearThreadCut cut = YearThreadCut.full}) {
  final memories = [
    for (var i = 0; i < count; i++)
      candidate(yearMemory('m$i', DateTime(2025, i % 12 + 1, 3))),
  ];
  return YearThreadFilm(
    stats: YearThreadStats.of(2025, memories),
    memories: memories,
    cut: cut,
  );
}

void main() {
  group('timeline', () {
    test('the full film lasts 30 to 45 s for 3 to 12 memories', () {
      for (var count = 3; count <= 12; count++) {
        final seconds = filmOf(count).duration.inMilliseconds / 1000;
        expect(seconds, inInclusiveRange(30, 45), reason: '$count memories');
      }
    });

    test('the story cut is exactly 20 s with up to 8 memories', () {
      for (var count = 3; count <= 12; count++) {
        final film = filmOf(count, cut: YearThreadCut.story);
        expect(film.duration, const Duration(seconds: 20));
        expect(film.frameCount, 600);
        expect(film.memories.length, count.clamp(3, 8));
      }
    });

    test('the story keeps the first and last memory, spread in order', () {
      final memories = [for (var i = 0; i < 12; i++) i];

      expect(YearThreadCut.story.pick(memories), [0, 2, 3, 5, 6, 8, 9, 11]);
      expect(YearThreadCut.full.pick(memories), memories);
      expect(YearThreadCut.story.pick([1, 2, 3]), [1, 2, 3]);
    });

    test('frame count follows the duration at 30 fps', () {
      final film = filmOf(8);

      expect(film.fps, 30);
      expect(
        film.frameCount,
        (film.duration.inMicroseconds * 30 / 1000000).round(),
      );
    });

    test('title, one slot per memory in order, then closing', () {
      final film = filmOf(5);
      final timeline = film.timeline;

      expect(timeline.shots, hasLength(5));
      expect(timeline.at(Duration.zero).part, YearThreadPart.title);
      expect(
        timeline.at(timeline.title - const Duration(milliseconds: 1)).part,
        YearThreadPart.title,
      );
      for (var i = 0; i < 5; i++) {
        final start = timeline.shotStart(i);
        final moment = timeline.at(start);
        expect(moment.part, YearThreadPart.shot);
        expect(moment.index, i);
        expect(moment.elapsed, Duration.zero);
        final end = timeline.at(
          start + timeline.shots[i] - const Duration(milliseconds: 1),
        );
        expect(end.index, i);
      }
      expect(timeline.at(timeline.closingStart).part, YearThreadPart.closing);
      expect(timeline.at(film.duration).part, YearThreadPart.closing);
      expect(
        timeline.title +
            timeline.shots.fold(Duration.zero, (a, b) => a + b) +
            timeline.closing,
        film.duration,
      );
    });

    test('a shot leaves time to look after the camera arrives', () {
      for (final cut in YearThreadCut.values) {
        for (var count = 3; count <= 12; count++) {
          final timeline = filmOf(count, cut: cut).timeline;
          for (final shot in timeline.shots) {
            expect(
              shot - YearThreadTimeline.transitionOf(shot),
              greaterThanOrEqualTo(const Duration(milliseconds: 1000)),
            );
          }
        }
      }
    });

    test('only memories with photos are pre-decoded', () {
      final film = YearThreadFilm(
        stats: YearThreadStats.of(2025, const []),
        memories: [
          candidate(yearMemory('a', DateTime(2025, 1), photo: '/a.jpg')),
          candidate(yearMemory('b', DateTime(2025, 2))),
          candidate(
            yearMemory('c', DateTime(2025, 3), photo: 'assets/demo/c.jpg'),
          ),
        ],
      );

      expect(film.images, hasLength(2));
      expect(film.images.last, isA<AssetImage>());
    });
  });

  group('frames', () {
    Future<List<int>> render(
      WidgetTester tester,
      YearThreadFilm film,
      Duration time, {
      Locale locale = const Locale('en'),
    }) async {
      final png = await tester.runAsync(() async {
        final canvas = StoryCanvas(pixelRatio: 1, locale: locale);
        try {
          return await canvas.renderPng(
            Builder(builder: (context) => film.buildFrame(context, time)),
          );
        } finally {
          canvas.dispose();
        }
      });
      return png!;
    }

    testWidgets('the same time always gives the same frame', (tester) async {
      final film = filmOf(6);
      final timeline = film.timeline;
      final times = [
        const Duration(milliseconds: 1500),
        timeline.title - const Duration(milliseconds: 200),
        timeline.shotStart(2) + const Duration(milliseconds: 400),
        timeline.shotStart(4) + const Duration(seconds: 2),
        timeline.closingStart + const Duration(milliseconds: 900),
        film.duration,
      ];
      for (final time in times) {
        final first = await render(tester, film, time);
        final again = await render(tester, filmOf(6), time);
        expect(again, first, reason: '$time');
      }
      // And the film does move.
      expect(
        await render(tester, film, times[2]),
        isNot(await render(tester, film, times[3])),
      );
    });

    testWidgets('shows the title, each memory and the closing stats', (
      tester,
    ) async {
      final film = filmOf(4);
      final timeline = film.timeline;
      final l10n = lookupAppLocalizations(const Locale('en'));

      Future<void> show(Duration time) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Center(
              child: SizedBox.fromSize(
                size: StoryCanvas.storyLogicalSize,
                child: Builder(
                  builder: (context) => film.buildFrame(context, time),
                ),
              ),
            ),
          ),
        );
      }

      await show(const Duration(seconds: 2));
      expect(find.text('2025'), findsOneWidget);
      expect(find.text('4 memories'), findsOneWidget);
      expect(find.text(l10n.yearThreadTitle.toUpperCase()), findsOneWidget);

      for (var i = 0; i < 4; i++) {
        await show(timeline.shotStart(i) + const Duration(seconds: 2));
        expect(find.text('Memory m$i'), findsWidgets, reason: 'shot $i');
      }

      await show(film.duration);
      expect(find.text(l10n.yearThreadClosingLine), findsOneWidget);
      expect(find.text('4 months'), findsOneWidget);
    });

    testWidgets('the thread runs right to left in Arabic', (tester) async {
      final film = filmOf(3);
      final time = film.timeline.shotStart(1) + const Duration(seconds: 2);

      Future<double> previousMinusCurrent(Locale locale) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Center(
              child: SizedBox.fromSize(
                size: StoryCanvas.storyLogicalSize,
                child: Builder(
                  builder: (context) => film.buildFrame(context, time),
                ),
              ),
            ),
          ),
        );
        return tester.getCenter(find.text('Memory m0')).dx -
            tester.getCenter(find.text('Memory m1')).dx;
      }

      expect(await previousMinusCurrent(const Locale('en')), lessThan(0));
      expect(await previousMinusCurrent(const Locale('ar')), greaterThan(0));
      expect(find.text('فبراير'), findsWidgets);
    });

    testWidgets('the year image shows photos first, at most nine', (
      tester,
    ) async {
      final memories = [
        for (var i = 0; i < 11; i++)
          candidate(
            yearMemory(
              'm$i',
              DateTime(2025, i + 1),
              photo: i.isOdd ? '/p$i.jpg' : null,
            ),
          ),
      ];
      final tiles = YearThreadImagePage.tilesOf(memories);

      expect(tiles, hasLength(9));
      expect(tiles.take(5).every((memory) => memory.hasPhoto), isTrue);
      expect(tiles.skip(5).any((memory) => memory.hasPhoto), isFalse);
    });
  });
}
