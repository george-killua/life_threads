// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// CreateStoryPage (setup as in test/create_story_page_test.dart).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_feature.dart';
import 'package:life_threads/features/stories/data/music_catalog.dart';
import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:life_threads/features/stories/data/story_exporter.dart';
import 'package:life_threads/features/stories/presentation/pages/create_story_page.dart';
import 'package:life_threads/features/stories/presentation/templates/story_templates.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import '../support/fake_music_preview.dart';
import '../support/on_this_day_fakes.dart';

class _NoExporter implements StoryExporter {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      Future<File>.error(StateError('not expected'));
}

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  late FakeMusicPreview preview;

  Future<void> pumpPage(
    WidgetTester tester, {
    required List<dynamic> memories,
    required bool isPremium,
    String? initialMemoryId,
  }) async {
    preview = FakeMusicPreview();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: RouteNames.createStory,
      initialExtra: initialMemoryId,
      routes: [
        GoRoute(
          path: RouteNames.createStory,
          builder: (context, state) =>
              CreateStoryPage(initialMemoryId: state.extra as String?),
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
            () => FakeMemoryRepository(memories.cast()),
          ),
          premiumEntitlementProvider.overrideWith(
            () => FakePremium(isPremium: isPremium),
          ),
          storyExporterProvider.overrideWithValue(_NoExporter()),
          musicPreviewProvider.overrideWithValue(preview),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('S1-01 story started from a hidden memory reaches the editor', (
    tester,
  ) async {
    final memories = [
      memory('a', DateTime(2021, 1, 1)),
      memory('h', DateTime(2022, 1, 1)).copyWith(hidden: true),
    ];
    // Wall long-press menu on a hidden card (shown via View sheet) →
    // Create story, extra: 'h'.
    await pumpPage(
      tester,
      memories: memories,
      isPremium: false,
      initialMemoryId: 'h',
    );
    // The hidden memory it was started from is the story: the editor opens.
    await tester.pumpAndSettle();
    expect(find.byType(StoryPage), findsWidgets);
    expect(find.text(l10n.storyPickCount(1, 6)), findsNothing);
  });

  testWidgets('S1-03 the song preview stops when the paywall opens', (
    tester,
  ) async {
    await pumpPage(
      tester,
      memories: [memory('m1', DateTime(2021, 1, 1))],
      isPremium: false,
      initialMemoryId: 'm1',
    );
    await tester.tap(find.byKey(const ValueKey('story-video-switch')));
    await tester.pump();
    final track = bundledMusicTracks.first;
    await tester.ensureVisible(find.textContaining(track.title));
    await tester.pump();
    await tester.tap(find.textContaining(track.title));
    await tester.pump();
    expect(preview.calls, ['play:${track.id}']);

    await tester.tap(find.byKey(const ValueKey('story-save')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('UPGRADE storyVideo'), findsOneWidget);
    expect(
      preview.calls.last,
      'stop',
      reason: 'song still looping behind the paywall: ${preview.calls}',
    );
  });
}
