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
import 'package:life_threads/features/stories/data/story_exporter.dart';
import 'package:life_threads/features/stories/domain/music_track.dart';
import 'package:life_threads/features/stories/domain/story_film.dart';
import 'package:life_threads/features/stories/domain/story_template.dart';
import 'package:life_threads/features/stories/presentation/pages/create_story_page.dart';
import 'package:life_threads/features/stories/presentation/templates/story_templates.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/on_this_day_fakes.dart';

class _FakeExporter implements StoryExporter {
  final calls = <String>[];

  @override
  Future<File> exportImage(BuildContext context, Widget page) async {
    calls.add('image:${(page as StoryPage).template.name}');
    return File('${Directory.systemTemp.path}/fake_story.png');
  }

  @override
  Future<File> exportVideo(
    BuildContext context,
    StoryFilm film, {
    MusicTrack? music,
    void Function(double progress)? onProgress,
    StoryExportCancel? cancel,
  }) async {
    calls.add('video:${music?.id}');
    onProgress?.call(1);
    return File('${Directory.systemTemp.path}/fake_story.mp4');
  }

  @override
  Future<bool> share(BuildContext context, File file, {String? text}) async {
    calls.add('share:${file.path.split('.').last}');
    return true;
  }

  @override
  Future<void> saveToGallery(File file) async {
    calls.add('save:${file.path.split('.').last}');
  }
}

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  final memories = [
    for (var i = 0; i < 7; i++)
      memory(
        'm$i',
        DateTime(2020 + i, 5, 1),
      ).copyWith(description: 'Story of memory $i'),
  ];

  Future<_FakeExporter> pumpPage(
    WidgetTester tester, {
    required bool isPremium,
    String? initialMemoryId,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final exporter = _FakeExporter();
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
            () => FakeMemoryRepository(memories),
          ),
          premiumEntitlementProvider.overrideWith(
            () => FakePremium(isPremium: isPremium),
          ),
          storyExporterProvider.overrideWithValue(exporter),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return exporter;
  }

  group('StorySelection', () {
    test('holds at most six memories and keeps the pick order', () {
      var selection = const StorySelection();
      for (var i = 0; i < 8; i++) {
        selection = selection.toggle('m$i');
      }
      expect(selection.ids, ['m0', 'm1', 'm2', 'm3', 'm4', 'm5']);
      expect(selection.isFull, isTrue);
      selection = selection.toggle('m2');
      expect(selection.ids, ['m0', 'm1', 'm3', 'm4', 'm5']);
      expect(selection.toggle('m6').ids.last, 'm6');
    });

    test('resolves only memories that still exist', () {
      final selection = const StorySelection(['m3', 'gone', 'm1']);
      expect(selection.resolve(memories).map((m) => m.id), ['m3', 'm1']);
    });
  });

  testWidgets('the picker stops at six memories', (tester) async {
    await pumpPage(tester, isPremium: false);

    expect(find.text(l10n.storyPickCount(0, 6)), findsOneWidget);
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.text('Memory m$i'));
      await tester.pump();
    }
    expect(find.text(l10n.storyPickCount(6, 6)), findsOneWidget);

    await tester.tap(find.text('Memory m6'));
    await tester.pump();
    expect(find.text(l10n.storyPickCount(6, 6)), findsOneWidget);
    expect(find.text(l10n.storyPickLimit(6)), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('story-continue')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.storyEditorTitle), findsOneWidget);
    expect(find.byType(StoryPage), findsWidgets);
  });

  testWidgets('started from a memory, the editor opens with its story', (
    tester,
  ) async {
    await pumpPage(tester, isPremium: false, initialMemoryId: 'm2');

    expect(find.text(l10n.storyEditorTitle), findsOneWidget);
    final caption = tester.widget<TextField>(
      find.byKey(const ValueKey('story-caption')),
    );
    expect(caption.controller!.text, 'Story of memory 2');
  });

  testWidgets('the preview is free, sharing opens Premium', (tester) async {
    final exporter = await pumpPage(
      tester,
      isPremium: false,
      initialMemoryId: 'm1',
    );
    expect(find.byType(StoryPage), findsWidgets);
    expect(find.text(l10n.storyPreviewFree), findsOneWidget);

    await tester.tap(find.text(l10n.storyShare));
    await tester.pumpAndSettle();

    expect(find.text('UPGRADE storyImage'), findsOneWidget);
    expect(exporter.calls, isEmpty);
  });

  testWidgets('a video story asks for the video feature', (tester) async {
    final exporter = await pumpPage(
      tester,
      isPremium: false,
      initialMemoryId: 'm1',
    );
    await tester.tap(find.byKey(const ValueKey('story-video-switch')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('story-save')));
    // The film preview loops, so no pumpAndSettle.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('UPGRADE storyVideo'), findsOneWidget);
    expect(exporter.calls, isEmpty);
  });

  testWidgets('with Premium, Share exports and opens the share sheet', (
    tester,
  ) async {
    final exporter = await pumpPage(
      tester,
      isPremium: true,
      initialMemoryId: 'm1',
    );
    expect(find.text(l10n.storyPreviewFree), findsNothing);

    await tester.tap(find.text(l10n.storyShare));
    await tester.pumpAndSettle();

    expect(exporter.calls, ['image:single', 'share:png']);
  });

  testWidgets('with Premium, a video with music is exported and saved', (
    tester,
  ) async {
    final exporter = await pumpPage(
      tester,
      isPremium: true,
      initialMemoryId: 'm1',
    );
    await tester.tap(find.byKey(const ValueKey('story-video-switch')));
    await tester.pump();
    expect(find.text(l10n.storyMusicNoneHint), findsOneWidget);
    await tester.tap(find.textContaining(bundledMusicTracks.first.title));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('story-save')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(exporter.calls, [
      'video:${bundledMusicTracks.first.id}',
      'save:mp4',
    ]);
    expect(find.text(l10n.storySaved), findsOneWidget);
  });
}
