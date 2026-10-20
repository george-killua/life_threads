import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/router/app_router.dart';
import '../../app/router/route_names.dart';
import '../../core/localization/app_localizations_x.dart';
import '../../core/widgets/app_toast.dart';
import '../../l10n/generated/app_localizations.dart';
import '../media/data/picked_memory_photo.dart';
import '../memories/data/memory_repository.dart';
import '../memories/data/memory_seed_data.dart';
import '../wall/data/current_wall.dart';
import 'coach.dart';

/// The guided "Show me how" tour: it walks through every part of the app on
/// the real screens, with the demo memories and their pictures. At the end
/// (also when skipped) it asks whether to remove the demo memories.
const appTour = 'lifethreads';

bool get appTourRunning => Coach.instance.tour == appTour;

/// What the tour points at (see [CoachTarget]).
abstract final class TourTargets {
  static const card = 'tour-card';
  static const connect = 'tour-connect';
  static const add = 'tour-add';
  static const addMemory = 'tour-add-memory';
  static const addTitle = 'tour-add-title';
  static const saveNow = 'tour-save-now';
  static const camera = 'tour-camera';
  static const view = 'tour-view';
  static const viewModes = 'tour-view-modes';
  static const viewDone = 'tour-view-done';
  static const search = 'tour-search';
  static const more = 'tour-more';
  static const moreStory = 'tour-more-story';
  static const moreYear = 'tour-more-year';
  static const moreLookBack = 'tour-more-look-back';
  static const moreNewWall = 'tour-more-new-wall';
  static const moreFamily = 'tour-more-family';
  static const moreSettings = 'tour-more-settings';
  static const storyPickContinue = 'tour-story-continue';
  static const storyAnimation = 'tour-story-animation';
  static const storyStyleTile = 'tour-story-style-tile';
  static const storyStyleDone = 'tour-story-style-done';
  static const storyMusic = 'tour-story-music';
  static const storyMusicTrimmer = 'tour-story-music-trimmer';
  static const storyMusicDone = 'tour-story-music-done';
  static const storyShare = 'tour-story-share';
}

/// The demo memory the tour opens.
const tourCardMemoryId = 'demo-first-dance';

/// The demo picture the tour's new memory starts with.
const _tourPhotoAsset = 'assets/demo_moments/beach_sunset.jpg';

/// Starts the tour on My wall, with the demo memories put up for it.
///
/// Uses the app's provider container, not a page's, because the page it
/// starts from (onboarding, the tutorial sheet) closes during the tour.
Future<void> startAppTour(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final repository = container.read(memoryRepositoryProvider.notifier);
  await container.read(currentWallProvider.notifier).select(null);
  await repository.addDemoMemories();
  _home();
  final root = AppRouter.rootNavigatorKey.currentContext;
  if (root == null || !root.mounted) return;
  final l10n = root.l10n;
  Coach.instance.start(
    appTour,
    appTourSteps(l10n),
    onEnd: () => WidgetsBinding.instance.addPostFrameCallback(
      (_) => _afterTour(container),
    ),
  );
}

/// Back to the wall by closing the screens on top, like pressing back:
/// screens waiting for the one they opened to close (the wall does) hear it.
void _home() {
  // An open menu (the ⋯ menu the tour points into) closes first.
  AppRouter.rootNavigatorKey.currentState?.popUntil(
    (route) => route is! PopupRoute,
  );
  final router = AppRouter.router;
  while (router.canPop()) {
    router.pop();
  }
  if (router.routerDelegate.currentConfiguration.uri.path != RouteNames.wall) {
    router.go(RouteNames.wall);
  }
}

/// The tour's steps, in the app's language.
List<CoachStep> appTourSteps(AppLocalizations l10n) {
  const home = _home;

  return [
    CoachStep(title: l10n.tourWelcomeTitle, body: l10n.tourWelcomeBody),
    CoachStep(
      target: TourTargets.card,
      title: l10n.tourCardTitle,
      body: l10n.tourCardBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.connect,
      title: l10n.tourConnectTitle,
      body: l10n.tourConnectBody,
      tapToContinue: true,
    ),
    CoachStep(title: l10n.tourConnectionsTitle, body: l10n.tourConnectionsBody),
    CoachStep(
      target: TourTargets.add,
      title: l10n.tourAddTitle,
      body: l10n.tourAddBody,
      tapToContinue: true,
      onEnter: home,
    ),
    CoachStep(
      target: TourTargets.addMemory,
      title: l10n.tourAddMemoryTitle,
      body: l10n.tourAddMemoryBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.addTitle,
      title: l10n.tourAddTextTitle,
      body: l10n.tourAddTextBody,
    ),
    CoachStep(
      target: TourTargets.saveNow,
      title: l10n.tourSaveTitle,
      body: l10n.tourSaveBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.camera,
      title: l10n.tourCameraTitle,
      body: l10n.tourCameraBody,
      onEnter: home,
    ),
    CoachStep(
      target: TourTargets.view,
      title: l10n.tourViewTitle,
      body: l10n.tourViewBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.viewModes,
      title: l10n.tourViewModesTitle,
      body: l10n.tourViewModesBody,
    ),
    CoachStep(
      target: TourTargets.viewDone,
      title: l10n.tourViewDoneTitle,
      body: l10n.tourViewDoneBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.search,
      title: l10n.tourSearchTitle,
      body: l10n.tourSearchBody,
    ),
    CoachStep(
      target: TourTargets.more,
      title: l10n.tourMoreTitle,
      body: l10n.tourMoreBody,
      tapToContinue: true,
      onEnter: home,
    ),
    CoachStep(
      target: TourTargets.moreStory,
      title: l10n.tourStoryTitle,
      body: l10n.tourStoryBody,
      tapToContinue: true,
    ),
    // Making a story, hands-on: the example memories are picked already.
    CoachStep(
      target: TourTargets.storyPickContinue,
      title: l10n.tourStoryPickTitle,
      body: l10n.tourStoryPickBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.storyAnimation,
      title: l10n.tourStoryAnimationTitle,
      body: l10n.tourStoryAnimationBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.storyStyleTile,
      title: l10n.tourStoryStyleTitle,
      body: l10n.tourStoryStyleBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.storyStyleDone,
      title: l10n.tourStoryMusicDoneTitle,
      body: l10n.tourStoryMusicDoneBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.storyMusic,
      title: l10n.tourStoryMusicTitle,
      body: l10n.tourStoryMusicBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.storyMusicTrimmer,
      title: l10n.tourStoryTrimTitle,
      body: l10n.tourStoryTrimBody,
    ),
    CoachStep(
      target: TourTargets.storyMusicDone,
      title: l10n.tourStoryMusicDoneTitle,
      body: l10n.tourStoryMusicDoneBody,
      tapToContinue: true,
    ),
    CoachStep(
      target: TourTargets.storyShare,
      title: l10n.tourStoryShareTitle,
      body: l10n.tourStoryShareBody,
    ),
    // The rest of the menu, each entry ringed where it is.
    CoachStep(
      target: TourTargets.more,
      title: l10n.tourMoreAgainTitle,
      body: l10n.tourMoreAgainBody,
      tapToContinue: true,
      onEnter: home,
    ),
    CoachStep(
      target: TourTargets.moreYear,
      title: l10n.tourYearTitle,
      body: l10n.tourYearBody,
    ),
    CoachStep(
      target: TourTargets.moreLookBack,
      title: l10n.tourLookBackTitle,
      body: l10n.tourLookBackBody,
    ),
    CoachStep(
      target: TourTargets.moreNewWall,
      title: l10n.tourWallsTitle,
      body: l10n.tourWallsBody,
    ),
    CoachStep(
      target: TourTargets.moreFamily,
      title: l10n.tourFamilyTitle,
      body: l10n.tourFamilyBody,
    ),
    CoachStep(
      target: TourTargets.moreSettings,
      title: l10n.tourSettingsTitle,
      body: l10n.tourSettingsBody,
    ),
    CoachStep(
      title: l10n.tourFinishTitle,
      body: l10n.tourFinishBody,
      onEnter: home,
    ),
  ];
}

/// The photos the tour's "Add memory" step starts with: one demo picture,
/// copied to a file like a photo from the library.
Future<List<PickedMemoryPhoto>> tourPhotos(AppLocalizations l10n) async {
  final data = await rootBundle.load(_tourPhotoAsset);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/lifethreads_tour_photo.jpg');
  await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
  final now = DateTime.now();
  return [
    PickedMemoryPhoto(
      localPath: file.path,
      capturedAt: DateTime(now.year, now.month, now.day, 18),
      width: 1200,
      height: 900,
      hasCapturedDate: true,
      hasDimensions: true,
      title: l10n.tourDemoPhotoTitle,
    ),
  ];
}

/// Memories saved during the tour (with the demo picture): removed with the
/// demo memories.
abstract final class TourMemories {
  static const _key = 'tour_memory_ids';

  static Future<void> remember(Iterable<String> ids) async {
    if (ids.isEmpty) return;
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList(_key) ?? const [];
    await preferences.setStringList(_key, {...saved, ...ids}.toList());
  }

  static Future<List<String>> all() async =>
      (await SharedPreferences.getInstance()).getStringList(_key) ?? const [];

  static Future<void> clear() async =>
      (await SharedPreferences.getInstance()).remove(_key);
}

/// After the tour: back on the wall, and if demo memories (or memories
/// saved during the tour) are there, ask whether to remove them.
Future<void> _afterTour(ProviderContainer ref) async {
  try {
    await _askToRemoveDemo(ref);
  } on StateError {
    // The app closed meanwhile (its providers are gone).
  }
}

Future<void> _askToRemoveDemo(ProviderContainer ref) async {
  _home();
  await Future<void>.delayed(const Duration(milliseconds: 350));
  final context = AppRouter.rootNavigatorKey.currentContext;
  if (context == null || !context.mounted) return;
  final state = ref.read(memoryRepositoryProvider).asData?.value;
  final tourIds = await TourMemories.all();
  final events = state?.events ?? const [];
  final hasDemo =
      events.any((event) => MemorySeedData.isDemoEventId(event.id)) ||
      events.any((event) => tourIds.contains(event.id));
  if (!hasDemo || !context.mounted) {
    await TourMemories.clear();
    return;
  }
  final l10n = context.l10n;
  final remove = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(l10n.tourRemoveDemoTitle),
      content: Text(l10n.tourRemoveDemoBody),
      actions: [
        TextButton(
          key: const ValueKey('tour-keep-demo'),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.tourRemoveDemoKeep),
        ),
        FilledButton(
          key: const ValueKey('tour-remove-demo'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.tourRemoveDemoRemove),
        ),
      ],
    ),
  );
  if (remove != true) return;
  final repository = ref.read(memoryRepositoryProvider.notifier);
  for (final id in tourIds) {
    if (events.any((event) => event.id == id)) {
      await repository.deleteMemory(id);
    }
  }
  await repository.clearDemoWall();
  await TourMemories.clear();
  if (context.mounted) {
    ScaffoldMessenger.maybeOf(
      context,
    )?.showToast(l10n.tourRemovedToast, kind: ToastKind.success);
  }
}
