import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/stories/data/music_catalog.dart';
import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:life_threads/features/stories/presentation/pages/create_story_page.dart';
import 'package:life_threads/features/stories/presentation/widgets/story_film_preview.dart';
import 'package:life_threads/features/stories/presentation/widgets/story_memory_strip.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/fake_music_preview.dart';
import 'support/on_this_day_fakes.dart';

/// The story screens on small phones with large text, in every language:
/// nothing overflows, and the parts of each screen don't paint over each
/// other (the memory strip once covered the settings under it).
void main() {
  final memories = [
    for (var i = 0; i < 6; i++)
      memory('m$i', DateTime(2020 + i, 5, 1)).copyWith(
        title: 'A rather long memory title number $i that wraps',
        description:
            'A long story about memory $i, with enough words to fill '
            'two lines of the caption field and more.',
      ),
  ];

  const sizes = [Size(320, 568), Size(375, 667)];
  const locales = AppLocalizations.supportedLocales;

  Future<void> pump(
    WidgetTester tester,
    Size size,
    Locale locale,
    double textScale,
  ) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: RouteNames.createStory,
      initialExtra: 'm0',
      routes: [
        GoRoute(
          path: RouteNames.createStory,
          builder: (context, state) =>
              CreateStoryPage(initialMemoryId: state.extra as String?),
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
            () => FakePremium(isPremium: false),
          ),
          musicPreviewProvider.overrideWithValue(FakeMusicPreview()),
        ],
        child: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: MaterialApp.router(
            routerConfig: router,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
          ),
        ),
      ),
    );
    await _frames(tester);
  }

  Rect rectOf(WidgetTester tester, Finder finder) =>
      tester.getRect(finder.first);

  void expectApart(Rect a, Rect b, String what) {
    final overlap = a.intersect(b);
    expect(
      overlap.width <= 0.5 || overlap.height <= 0.5,
      isTrue,
      reason: '$what overlap by $overlap',
    );
  }

  for (final size in sizes) {
    for (final locale in locales) {
      for (final scale in [1.0, 1.3]) {
        final name =
            '${size.width.toInt()}x${size.height.toInt()} '
            '${locale.languageCode} text ${scale}x';

        testWidgets('story editor fits: $name', (tester) async {
          await pump(tester, size, locale, scale);
          expect(tester.takeException(), isNull);
          final preview = rectOf(tester, find.byType(StoryFilmPreview));
          final strip = rectOf(tester, find.byType(StoryMemoryStrip));
          final page = rectOf(
            tester,
            find.byKey(const ValueKey('story-settings')),
          );
          final save = rectOf(tester, find.byKey(const ValueKey('story-save')));
          expectApart(preview, strip, 'preview and strip');
          expectApart(page, save, 'page and buttons');
          // The strip's photos stay above the settings under them.
          final mode = rectOf(
            tester,
            find.byKey(const ValueKey('story-mode-picture')),
          );
          for (final element
              in find
                  .descendant(
                    of: find.byType(StoryMemoryStrip),
                    matching: find.byType(Image),
                  )
                  .evaluate()) {
            final box = element.renderObject! as RenderBox;
            final photo = box.localToGlobal(Offset.zero) & box.size;
            expect(
              photo.bottom <= mode.top + 0.5,
              isTrue,
              reason: 'photo $photo reaches into the settings at $mode',
            );
          }

          // Scrolled to the end, the preview is small and pinned, and the
          // settings below it stay clear of it.
          final position = tester
              .state<ScrollableState>(
                find
                    .descendant(
                      of: find.byKey(const ValueKey('story-settings')),
                      matching: find.byType(Scrollable),
                    )
                    .first,
              )
              .position;
          position.jumpTo(position.maxScrollExtent);
          await _frames(tester, 3);
          expect(tester.takeException(), isNull);
          final small = rectOf(tester, find.byType(StoryFilmPreview));
          expect(small.height, lessThan(preview.height));
          final row = rectOf(
            tester,
            find.byKey(const ValueKey('story-animation-row')),
          );
          if (row.top >= page.top && row.bottom <= page.bottom) {
            expectApart(small, row, 'small preview and animation row');
          }
        });

        testWidgets('animation screen fits: $name', (tester) async {
          await pump(tester, size, locale, scale);
          await _showSetting(tester, 'story-animation-row');
          await _frames(tester, 3);
          await tester.tap(find.byKey(const ValueKey('story-animation-row')));
          await _frames(tester);
          expect(tester.takeException(), isNull);
          // Scroll through every tile.
          for (var i = 0; i < 8; i++) {
            await tester.drag(
              find.byType(CustomScrollView),
              const Offset(0, -300),
            );
            await _frames(tester, 3);
            expect(tester.takeException(), isNull, reason: 'after scroll $i');
          }
        });

        testWidgets('music screen fits: $name', (tester) async {
          await pump(tester, size, locale, scale);
          // Small phones scroll the editor's settings to reach Music.
          await tester.tap(find.byKey(const ValueKey('story-video-switch')));
          await _frames(tester, 3);
          await _showSetting(tester, 'story-music-row');
          await _frames(tester, 3);
          await tester.tap(find.byKey(const ValueKey('story-music-row')));
          await _frames(tester);
          final track = bundledMusicTracks.first;
          final song = find.byKey(ValueKey('story-music-${track.id}'));
          await tester.scrollUntilVisible(
            song,
            60,
            scrollable: find
                .descendant(
                  of: find.byKey(const ValueKey('story-music-songs')),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          await tester.ensureVisible(song);
          await _frames(tester, 3);
          await tester.tap(song);
          await _frames(tester);
          expect(tester.takeException(), isNull);
          final preview = rectOf(tester, find.byType(StoryFilmPreview));
          final slider = rectOf(
            tester,
            find.byKey(const ValueKey('story-length-slider')),
          );
          // What shows of the trimmer: the top part scrolls on small phones.
          final top = rectOf(tester, find.byType(SingleChildScrollView));
          final trimmer = rectOf(
            tester,
            find.byKey(const ValueKey('music-trimmer')),
          ).intersect(top);
          final songs = rectOf(
            tester,
            find.byKey(const ValueKey('story-music-songs')),
          );
          expectApart(preview, slider, 'preview and length');
          expectApart(preview, trimmer, 'preview and trimmer');
          expectApart(trimmer, songs, 'trimmer and songs');
          // The song list still has room to show songs.
          expect(songs.height, greaterThan(80), reason: 'songs $songs');
        });
      }
    }
  }
}

/// Scrolls the editor's settings (small phones) until the row [key] shows.
Future<void> _showSetting(WidgetTester tester, String key) async {
  final row = find.byKey(ValueKey(key));
  final position = tester
      .state<ScrollableState>(
        find
            .descendant(
              of: find.byKey(const ValueKey('story-settings')),
              matching: find.byType(Scrollable),
            )
            .first,
      )
      .position;
  while (row.evaluate().isEmpty && position.pixels < position.maxScrollExtent) {
    position.jumpTo(position.pixels + 40);
    await tester.pump();
  }
  await tester.ensureVisible(row);
  await tester.pump();
  // The pinned preview may still cover it: scroll on until it can be tapped.
  while (row.hitTestable().evaluate().isEmpty &&
      position.pixels < position.maxScrollExtent) {
    position.jumpTo(position.pixels + 30);
    await tester.pump();
  }
}

/// Pages with a running film never settle.
Future<void> _frames(WidgetTester tester, [int count = 8]) async {
  for (var i = 0; i < count; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
