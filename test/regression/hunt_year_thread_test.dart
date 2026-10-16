// Regression tests from the 2026-10-16 whole-codebase bug hunt: Thread of
// the Year.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/personal_wall.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:life_threads/features/stories/data/story_exporter.dart';
import 'package:life_threads/features/stories/domain/music_track.dart';
import 'package:life_threads/features/year_thread/data/year_thread_providers.dart';
import 'package:life_threads/features/year_thread/presentation/pages/year_thread_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_music_preview.dart';
import '../support/on_this_day_fakes.dart';
import '../support/year_thread_fixtures.dart';
import '../year_thread_page_test.dart'
    show FakeYearRepository, FakeExporter, settle;

const _track = MusicTrack(
  id: 'song',
  title: 'Song',
  artist: 'Artist',
  mood: MusicMood.warm,
  license: 'test',
  sourceUrl: '',
  assetPath: 'assets/music/song.mp3',
  length: Duration(minutes: 3),
);

/// 2025: two memories on My wall, two on the "Trips" wall.
MemoryState _splitYear() => MemoryState(
  events: [
    yearMemory('h1', DateTime(2025, 2, 1), title: 'Home 1'),
    yearMemory('h2', DateTime(2025, 4, 1), title: 'Home 2'),
    yearMemory(
      't1',
      DateTime(2025, 6, 1),
      title: 'Trip 1',
    ).copyWith(wallId: 'w1'),
    yearMemory(
      't2',
      DateTime(2025, 8, 1),
      title: 'Trip 2',
    ).copyWith(wallId: 'w1'),
  ],
  connections: const [],
  photos: const [],
  people: const [],
  wallItems: const [],
  walls: [PersonalWall(id: 'w1', name: 'Trips', createdAt: DateTime(2025))],
);

Future<(FakeExporter, FakeMusicPreview, ProviderContainer)> _pump(
  WidgetTester tester, {
  required MemoryState state,
  bool isPremium = false,
  List<MusicTrack> tracks = const [],
}) async {
  final exporter = FakeExporter();
  final music = FakeMusicPreview();
  await tester.binding.setSurfaceSize(const Size(800, 3200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const YearThreadPage(initialYear: 2025),
      ),
      GoRoute(
        path: RouteNames.addMemory,
        builder: (context, s) => Text(
          'ADD date=${s.uri.queryParameters['date']}'
          ' wall=${s.uri.queryParameters['wall']}',
        ),
      ),
    ],
  );
  final container = ProviderContainer(
    overrides: [
      memoryRepositoryProvider.overrideWith(() => FakeYearRepository(state)),
      premiumEntitlementProvider.overrideWith(
        () => FakePremium(isPremium: isPremium),
      ),
      storyExporterProvider.overrideWithValue(exporter),
      musicPreviewProvider.overrideWithValue(music),
      yearThreadMusicTracksProvider.overrideWithValue(tracks),
      yearThreadClockProvider.overrideWithValue(() => DateTime(2025, 12, 5)),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await settle(tester);
  return (exporter, music, container);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Y1-01 wall card only offers a year its wall can film', (
    tester,
  ) async {
    final (_, _, container) = await _pump(tester, state: _splitYear());
    // The wall card counts all walls together: 4 memories in 2025.
    container.listen(yearThreadWallCardYearProvider, (_, _) {});
    await container.read(yearThreadCardDismissalProvider.future);
    await settle(tester);
    // 2025 has 2 memories on My wall (on screen) and 2 on Trips: the card
    // on My wall doesn't offer a film that wall can't make.
    expect(container.read(yearThreadWallCardYearProvider), isNull);
  });

  testWidgets('Y1-02 empty-state "Add a memory" ignores the chosen wall', (
    tester,
  ) async {
    await _pump(tester, state: _splitYear());
    await tester.tap(find.text('Trips'));
    await settle(tester);
    expect(find.text('Your first Thread of the Year'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('year-thread-add-memory')));
    await settle(tester);
    // "Add a memory to 2025" passes wall=w1; the main button does not.
    expect(find.textContaining('ADD date='), findsOneWidget);
    expect(find.text('ADD date=null wall=w1'), findsOneWidget);
  });

  // A double tap on Export makes one film.
  testWidgets('Y1-03 a double tap on Export makes two films', (tester) async {
    final (exporter, _, _) = await _pump(
      tester,
      state: sampleYear(),
      isPremium: true,
    );
    final button = find.byKey(const ValueKey('year-thread-export-video'));
    // Two taps in the same frame: the button is still enabled for both.
    await tester.tap(button);
    await tester.tap(button);
    await settle(tester);
    expect(exporter.films, hasLength(1));
  });

  testWidgets('Y1-04 pausing the preview leaves the music playing', (
    tester,
  ) async {
    final (_, music, _) = await _pump(
      tester,
      state: sampleYear(),
      tracks: const [_track],
    );
    await tester.tap(find.text('No music'));
    await settle(tester);
    await tester.tap(find.text('Song · Artist').last);
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('year-thread-preview')));
    await settle(tester);
    music.calls.clear();
    await tester.tap(find.byTooltip('Pause'));
    await settle(tester);
    expect(find.byTooltip('Play'), findsOneWidget); // the film is paused
    expect(music.calls, contains('stop'), reason: 'song keeps playing');
  });
}
