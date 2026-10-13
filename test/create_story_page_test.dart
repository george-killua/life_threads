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
import 'package:life_threads/features/stories/domain/music_track.dart';
import 'package:life_threads/features/stories/domain/story_film.dart';
import 'package:life_threads/features/stories/domain/story_template.dart';
import 'package:life_threads/features/stories/presentation/pages/create_story_page.dart';
import 'package:life_threads/features/stories/presentation/templates/story_templates.dart';
import 'package:life_threads/features/stories/presentation/widgets/music_trimmer.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/fake_music_preview.dart';
import 'support/on_this_day_fakes.dart';

class _FakeExporter implements StoryExporter {
  final calls = <String>[];
  Duration? musicStart;

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
    Duration musicStart = Duration.zero,
    void Function(double progress)? onProgress,
    StoryExportCancel? cancel,
  }) async {
    calls.add('video:${music?.id}');
    this.musicStart = musicStart;
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

  late FakeMusicPreview preview;

  Future<_FakeExporter> pumpPage(
    WidgetTester tester, {
    required bool isPremium,
    String? initialMemoryId,
  }) async {
    preview = FakeMusicPreview();
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

    test('removes, but never the last memory, and reorders', () {
      const selection = StorySelection(['a', 'b', 'c']);
      expect(selection.remove('b').ids, ['a', 'c']);
      expect(const StorySelection(['a']).remove('a').ids, ['a']);
      expect(selection.move(0, 2).ids, ['b', 'c', 'a']);
      expect(selection.move(2, 0).ids, ['c', 'a', 'b']);
      expect(selection.move(5, 0).ids, selection.ids);
    });

    test('search matches every word in title, story, place or year', () {
      final event = memories[3];
      expect(storyMemoryMatches(event, ''), isTrue);
      expect(storyMemoryMatches(event, 'memory M3'), isTrue);
      expect(storyMemoryMatches(event, '${event.occurredAt.year}'), isTrue);
      expect(storyMemoryMatches(event, 'story 3'), isTrue);
      expect(storyMemoryMatches(event, 'memory m4'), isFalse);
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

  testWidgets('with many memories the picker can be searched', (tester) async {
    await pumpPage(tester, isPremium: false);

    await tester.enterText(find.byKey(const ValueKey('story-search')), 'm4');
    await tester.pump();
    expect(find.text('Memory m4'), findsOneWidget);
    expect(find.text('Memory m3'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('story-search')),
      'nothing like this',
    );
    await tester.pump();
    expect(
      find.text(l10n.storySearchEmpty('nothing like this')),
      findsOneWidget,
    );
  });

  testWidgets('the editor adds, reorders and removes memories', (tester) async {
    await pumpPage(tester, isPremium: false, initialMemoryId: 'm2');
    expect(find.byKey(const ValueKey('story-strip-m2')), findsOneWidget);
    // One memory: nothing to remove.
    expect(find.byKey(const ValueKey('story-strip-remove-m2')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('story-strip-add')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.storyAddMemoryTitle), findsOneWidget);
    // Six memories left: few enough to list without a search bar.
    expect(find.byKey(const ValueKey('story-search')), findsNothing);
    await tester.tap(find.text('Memory m5'));
    await tester.pumpAndSettle();

    List<String> stripIds() => [
      for (final element
          in find
              .byWidgetPredicate(
                (widget) =>
                    widget.key is ValueKey<String> &&
                    (widget.key! as ValueKey<String>).value.startsWith(
                      'story-strip-m',
                    ),
              )
              .evaluate())
        (element.widget.key! as ValueKey<String>).value.substring(12),
    ];
    expect(stripIds(), ['m2', 'm5']);

    tester
        .widget<ReorderableListView>(
          find.byKey(const ValueKey('story-memory-strip')),
        )
        .onReorderItem!(1, 0);
    await tester.pump();
    expect(stripIds(), ['m5', 'm2']);
    // The caption follows the first memory until it is edited.
    final caption = tester.widget<TextField>(
      find.byKey(const ValueKey('story-caption')),
    );
    expect(caption.controller!.text, 'Story of memory 5');

    await tester.tap(find.byKey(const ValueKey('story-strip-remove-m5')));
    await tester.pump();
    expect(stripIds(), ['m2']);
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
    // The song list is long; bring the hint below it into view.
    await tester.scrollUntilVisible(
      find.text(l10n.storyMusicNoneHint),
      200,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    expect(find.text(l10n.storyMusicNoneHint), findsOneWidget);
    await tester.ensureVisible(
      find.textContaining(bundledMusicTracks.first.title),
    );
    await tester.pump();
    await tester.tap(find.textContaining(bundledMusicTracks.first.title));
    await tester.pump();
    // Picking a song plays the part the film would use, from its loudest
    // part.
    final track = bundledMusicTracks.first;
    expect(preview.calls, ['play:${track.id}']);
    final film = preview.parts.single;
    expect(film.start, MusicTrimmer.suggestedStart(track, film.length!));

    // Dragging the window to the start picks the beginning of the song.
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('music-trimmer')),
      200,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await tester.pump();
    await tester.drag(
      find.byKey(const ValueKey('music-trimmer')),
      const Offset(-2000, 0),
    );
    await tester.pump();
    expect(preview.parts.last.start, Duration.zero);
    expect(find.text('0:00 – ${_clock(film.length!)}'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('story-save')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(exporter.calls, [
      'video:${bundledMusicTracks.first.id}',
      'save:mp4',
    ]);
    expect(exporter.musicStart, Duration.zero);
    expect(find.text(l10n.storySaved), findsOneWidget);
    // The preview stops when the export starts.
    expect(preview.calls.last, 'stop');
  });
}

String _clock(Duration value) =>
    '${value.inMinutes}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';
