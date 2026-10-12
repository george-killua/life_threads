// Thread of the Year screen (preview free, export Premium) and its wall card
// in December and January.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_feature.dart';
import 'package:life_threads/features/stories/data/story_exporter.dart';
import 'package:life_threads/features/stories/domain/music_track.dart';
import 'package:life_threads/features/stories/domain/story_film.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/features/year_thread/data/year_thread_providers.dart';
import 'package:life_threads/features/year_thread/presentation/pages/year_thread_page.dart';
import 'package:life_threads/features/year_thread/presentation/widgets/year_thread_player.dart';
import 'package:life_threads/features/year_thread/presentation/widgets/year_thread_wall_card.dart';
import 'package:life_threads/features/year_thread/presentation/year_thread_image_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/on_this_day_fakes.dart';
import 'support/year_thread_fixtures.dart';

class FakeYearRepository extends MemoryRepository {
  FakeYearRepository(this.initial);

  final MemoryState initial;

  @override
  Future<MemoryState> build() async => initial;
}

class FakeExporter implements StoryExporter {
  FakeExporter({this.waitForCancel = false});

  /// Keeps "rendering" until the export is cancelled.
  final bool waitForCancel;
  final films = <StoryFilm>[];
  final music = <MusicTrack?>[];
  final pages = <Widget>[];
  final shared = <File>[];
  final saved = <File>[];

  File _file(String extension) =>
      File('${Directory.systemTemp.path}/year_thread_test.$extension')
        ..writeAsStringSync('test');

  @override
  Future<File> exportVideo(
    BuildContext context,
    StoryFilm film, {
    MusicTrack? music,
    void Function(double progress)? onProgress,
    StoryExportCancel? cancel,
  }) async {
    films.add(film);
    this.music.add(music);
    onProgress?.call(0.5);
    while (waitForCancel) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (cancel?.isCancelled ?? false) throw const StoryExportCancelled();
    }
    return _file('mp4');
  }

  @override
  Future<File> exportImage(BuildContext context, Widget page) async {
    pages.add(page);
    return _file('png');
  }

  @override
  Future<bool> share(BuildContext context, File file, {String? text}) async {
    shared.add(file);
    return true;
  }

  @override
  Future<void> saveToGallery(File file) async => saved.add(file);
}

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('screen', () {
    Future<FakeExporter> pumpPage(
      WidgetTester tester, {
      required bool isPremium,
      MemoryState? state,
      FakeExporter? exporter,
    }) async {
      final fake = exporter ?? FakeExporter();
      await tester.binding.setSurfaceSize(const Size(800, 3200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const YearThreadPage(initialYear: 2025),
          ),
          GoRoute(
            path: RouteNames.upgrade,
            builder: (context, state) =>
                Text('UPGRADE ${(state.extra as PremiumFeature?)?.name}'),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            memoryRepositoryProvider.overrideWith(
              () => FakeYearRepository(state ?? sampleYear()),
            ),
            premiumEntitlementProvider.overrideWith(
              () => FakePremium(isPremium: isPremium),
            ),
            storyExporterProvider.overrideWithValue(fake),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await settle(tester);
      return fake;
    }

    Future<void> tapKey(WidgetTester tester, String key) async {
      await tester.tap(find.byKey(ValueKey(key)));
      await settle(tester);
    }

    testWidgets('lists the suggested memories of the year', (tester) async {
      await pumpPage(tester, isPremium: false);

      expect(find.text('2025 · 8 memories · 5 places'), findsOneWidget);
      expect(find.text('8 of 12'), findsOneWidget);
      expect(find.text('Our first dance'), findsOneWidget);
      expect(find.text('A quiet Sunday'), findsOneWidget);
    });

    testWidgets('free users can watch the preview', (tester) async {
      final exporter = await pumpPage(tester, isPremium: false);

      await tapKey(tester, 'year-thread-preview');

      expect(find.byType(YearThreadPlayer), findsOneWidget);
      expect(find.textContaining('UPGRADE'), findsNothing);
      await tester.pump(const Duration(seconds: 6));
      expect(find.text('Our first dance'), findsWidgets);

      await tester.tap(find.byTooltip('Close'));
      await settle(tester);
      expect(find.byType(YearThreadPlayer), findsNothing);
      expect(exporter.films, isEmpty);
    });

    testWidgets('exporting the video needs Premium', (tester) async {
      final exporter = await pumpPage(tester, isPremium: false);

      await tapKey(tester, 'year-thread-export-video');

      expect(find.text('UPGRADE threadOfTheYear'), findsOneWidget);
      expect(exporter.films, isEmpty);
    });

    testWidgets('exporting the image needs Premium', (tester) async {
      final exporter = await pumpPage(tester, isPremium: false);

      await tapKey(tester, 'year-thread-export-image');

      expect(find.text('UPGRADE threadOfTheYear'), findsOneWidget);
      expect(exporter.pages, isEmpty);
    });

    testWidgets('Premium exports the film, then shares and saves it', (
      tester,
    ) async {
      final exporter = await pumpPage(tester, isPremium: true);

      await tapKey(tester, 'year-thread-export-video');

      expect(exporter.films, hasLength(1));
      expect(
        exporter.films.single.duration.inSeconds,
        inInclusiveRange(30, 45),
      );
      expect(exporter.music.single, isNull);
      expect(find.text('Your film is ready'), findsOneWidget);

      await tester.tap(find.text('Share'));
      await settle(tester);
      expect(exporter.shared, hasLength(1));

      await tester.tap(find.text('Save to Photos'));
      await settle(tester);
      expect(exporter.saved, hasLength(1));
      expect(find.text('Saved to your photos.'), findsOneWidget);
    });

    testWidgets('the story cut exports 20 s', (tester) async {
      final exporter = await pumpPage(tester, isPremium: true);

      await tester.tap(find.text('Story · 20 s'));
      await settle(tester);
      await tapKey(tester, 'year-thread-export-video');

      expect(exporter.films.single.duration, const Duration(seconds: 20));
    });

    testWidgets('Premium exports the My year image', (tester) async {
      final exporter = await pumpPage(tester, isPremium: true);

      await tapKey(tester, 'year-thread-export-image');

      expect(exporter.pages.single, isA<YearThreadImagePage>());
      expect(find.text('Your image is ready'), findsOneWidget);
    });

    testWidgets('an export can be cancelled', (tester) async {
      final exporter = await pumpPage(
        tester,
        isPremium: true,
        exporter: FakeExporter(waitForCancel: true),
      );

      await tester.tap(find.byKey(const ValueKey('year-thread-export-video')));
      for (var i = 0; i < 3; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(find.text('Making your film…'), findsOneWidget);
      expect(find.text('50 %'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await settle(tester);

      expect(exporter.films, hasLength(1));
      expect(find.text('Making your film…'), findsNothing);
      expect(find.text('Your film is ready'), findsNothing);
    });

    testWidgets('memories can be removed, swapped and added back', (
      tester,
    ) async {
      // 13 memories: one stays out of the suggested 12.
      final state = yearState([
        for (var i = 0; i < 13; i++)
          yearMemory(
            'm$i',
            DateTime(2025, i % 12 + 1, 1 + i),
            title: 'Moment $i',
          ),
      ]);
      await pumpPage(tester, isPremium: false, state: state);
      expect(find.text('12 of 12'), findsOneWidget);
      expect(find.text('Moment 12'), findsNothing);

      await tester.tap(find.byTooltip('Swap').first);
      await settle(tester);
      expect(find.text('Choose a memory from 2025'), findsOneWidget);
      await tester.tap(find.text('Moment 12'));
      await settle(tester);
      expect(find.text('Moment 12'), findsOneWidget);
      expect(find.text('Moment 0'), findsNothing);
      expect(find.text('12 of 12'), findsOneWidget);

      await tester.tap(find.byTooltip('Remove').first);
      await settle(tester);
      expect(find.text('11 of 12'), findsOneWidget);

      await tester.tap(find.text('Add a memory'));
      await settle(tester);
      await tester.tap(find.text('Moment 0'));
      await settle(tester);
      expect(find.text('12 of 12'), findsOneWidget);
      expect(find.text('Moment 0'), findsOneWidget);

      await tester.tap(find.text('Use suggestions'));
      await settle(tester);
      expect(find.text('Moment 12'), findsNothing);
      expect(find.text('Use suggestions'), findsNothing);
    });

    testWidgets('fewer than 3 memories cannot be exported', (tester) async {
      await pumpPage(
        tester,
        isPremium: true,
        state: yearState([
          for (var i = 0; i < 3; i++)
            yearMemory('m$i', DateTime(2025, i + 1), title: 'Moment $i'),
        ]),
      );

      await tester.tap(find.byTooltip('Remove').first);
      await settle(tester);

      expect(find.text('Choose at least 3 memories.'), findsOneWidget);
      final export = tester.widget<ButtonStyleButton>(
        find.byKey(const ValueKey('year-thread-export-video')),
      );
      expect(export.onPressed, isNull);
    });

    testWidgets('explains when no year has enough memories', (tester) async {
      await pumpPage(
        tester,
        isPremium: true,
        state: yearState([yearMemory('a', DateTime(2025, 1))]),
      );

      expect(find.textContaining('needs a year with at least 3'), findsOne);
    });
  });

  group('wall card', () {
    List<Override> overrides(DateTime now, {MemoryState? state}) => [
      memoryRepositoryProvider.overrideWith(
        () => FakeYearRepository(state ?? sampleYear()),
      ),
      premiumEntitlementProvider.overrideWith(
        () => FakePremium(isPremium: false),
      ),
      yearThreadClockProvider.overrideWithValue(() => now),
    ];

    Future<void> pumpCard(WidgetTester tester, List<Override> list) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: list,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: YearThreadWallCard()),
          ),
        ),
      );
      await settle(tester);
    }

    const title = 'Your year in memories';

    testWidgets('shows in December for this year', (tester) async {
      await pumpCard(tester, overrides(DateTime(2025, 12, 3)));

      expect(find.text(title), findsOneWidget);
      expect(find.text('Turn 2025 into a short film.'), findsOneWidget);
    });

    testWidgets('shows in January for the year that ended', (tester) async {
      await pumpCard(tester, overrides(DateTime(2026, 1, 20)));

      expect(find.text('Turn 2025 into a short film.'), findsOneWidget);
    });

    testWidgets('stays hidden the rest of the year', (tester) async {
      for (final month in [2, 6, 11]) {
        await pumpCard(tester, overrides(DateTime(2025, month, 15)));
        expect(find.text(title), findsNothing, reason: 'month $month');
      }
    });

    testWidgets('stays hidden for a year with too few memories', (
      tester,
    ) async {
      await pumpCard(tester, overrides(DateTime(2024, 12, 3)));

      expect(find.text(title), findsNothing);
    });

    testWidgets('"Not now" hides it for that year', (tester) async {
      await pumpCard(tester, overrides(DateTime(2025, 12, 3)));

      await tester.tap(find.byTooltip('Not now'));
      await settle(tester);

      expect(find.text(title), findsNothing);
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getInt('year_thread_card_dismissed_year'), 2025);
    });

    testWidgets('appears on the wall in December', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final (now, visible) in [
        (DateTime(2025, 12, 10), true),
        (DateTime(2025, 10, 10), false),
      ]) {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...overrides(now),
              onThisDayClockProvider.overrideWithValue(() => now),
              onThisDayNotificationsProvider.overrideWithValue(
                FakeOnThisDayNotifications(),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const MemoryWallPage(),
            ),
          ),
        );
        await settle(tester);
        expect(
          find.text(title),
          visible ? findsOneWidget : findsNothing,
          reason: '$now',
        );
        // A fresh ProviderScope for the next date.
        await tester.pumpWidget(const SizedBox());
      }
    });
  });

  test('the card is kept out of the store screenshots', () {
    final source = File(
      'tool/store_screenshots/store_screenshots_test.dart',
    ).readAsStringSync();
    expect(source, contains('yearThreadWallCardYearProvider'));
  });
}
