// Plays the real app on a simulator through the scenes of the store copy, in
// real time, for a screen recording that an ad is cut from (no captions; the
// ad adds them). Run with tool/ad_video/record.sh, which records the screen.
//
// Same demo memories as the store screenshots, Premium on, a family wall from
// the fake family service. Prints AD_START / AD_SCENE <name> / AD_END with the
// time, so the recording can be trimmed and cut per scene.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:life_threads/app/router/app_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/family/data/family_service.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:life_threads/features/year_thread/data/year_thread_providers.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/support/fake_family_service.dart';
import '../test/support/fake_music_preview.dart';
import '../tool/store_screenshots/fixtures.dart';

const _lang = String.fromEnvironment('AD_LANG', defaultValue: 'en');
const _familyId = 'ad-family-wall';

class _DemoMemories extends MemoryRepository {
  @override
  Future<MemoryState> build() async => storeMemoryState(_lang);
}

class _Premium extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async =>
      const PremiumEntitlement(isPremium: true, isMockUnlocked: false);
}

/// A demo photo from the app's assets, as a file (the family wall and the
/// add screen read files).
Future<File> _photoFile(Directory dir, String name) async {
  final data = await rootBundle.load('$momentsPrefix$name');
  return File('${dir.path}/$name')..writeAsBytesSync(data.buffer.asUint8List());
}

Future<FakeFamilyService> _family(Directory dir) async {
  final service = FakeFamilyService(account: FakeFamilyService.account());
  service.addFamily(
    id: _familyId,
    name: 'Our family',
    ownerId: 'me',
    members: {'me': 'Me', 'mom': 'Mom', 'lina': 'Lina'},
  );
  const authors = ['me', 'mom', 'lina'];
  final events = storeMemoryState(_lang).events.take(6).toList();
  for (final (i, event) in events.indexed) {
    final cover = event.coverPhotoPath;
    final photos = <String>[];
    if (cover != null) {
      service.setPhotoFile(
        'photo-$i',
        await _photoFile(dir, cover.split('/').last),
      );
      photos.add('photo-$i');
    }
    service.seedMemory(
      _familyId,
      id: 'family-memory-$i',
      authorId: authors[i % 3],
      title: event.title,
      description: event.description,
      photoIds: photos,
      wallX: 150.0 + (i % 2) * 210,
      wallY: 180.0 + (i ~/ 2) * 250,
      feeling: event.feeling,
      category: event.category,
    );
  }
  return service;
}

void _mark(String label) {
  // ignore: avoid_print
  print('AD_MARK $label ${DateTime.now().millisecondsSinceEpoch}');
}

/// Lets the app run in real time (animations, the wind, the film).
Future<void> _hold(WidgetTester tester, int millis) async {
  final end = DateTime.now().add(Duration(milliseconds: millis));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }
}

Future<void> _go(WidgetTester tester, String location, {Object? extra}) async {
  AppRouter.router.go(location, extra: extra);
  await _hold(tester, 900);
}

/// A slow drag, like a finger.
Future<void> _swipe(
  WidgetTester tester,
  Offset from,
  Offset by, {
  int millis = 1400,
}) async {
  final gesture = await tester.startGesture(from);
  const steps = 40;
  for (var i = 0; i < steps; i++) {
    await gesture.moveBy(by / steps.toDouble());
    await _hold(tester, millis ~/ steps);
  }
  await gesture.up();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('ad video', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'user_display_name': '',
      'backup_last_saved_at': DateTime.now().millisecondsSinceEpoch,
    });
    final dir = await Directory.systemTemp.createTemp('ad_video_');
    final family = await _family(dir);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryRepositoryProvider.overrideWith(_DemoMemories.new),
          premiumEntitlementProvider.overrideWith(_Premium.new),
          familyServiceProvider.overrideWithValue(family),
          musicPreviewProvider.overrideWithValue(FakeMusicPreview()),
          onThisDayMatchesProvider.overrideWithValue(const []),
          yearThreadWallCardYearProvider.overrideWithValue(null),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          locale: const Locale(_lang),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: AppRouter.router,
        ),
      ),
    );
    AppRouter.router.go(RouteNames.wall);
    await _hold(tester, 3000); // photos load, cards settle
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    final centre = Offset(size.width / 2, size.height / 2);
    final events = storeMemoryState(_lang).events;

    _mark('AD_START');

    // 1. The wall: cards swaying on their threads (no pan: a drag that
    // starts on a card would move the card).
    _mark('wall');
    await _hold(tester, 7000);

    // 2. A memory: its photos, story and the memories it is threaded to.
    _mark('memory');
    await _go(tester, '/memories/store-first-dance');
    await _hold(tester, 2500);
    await _swipe(tester, centre, Offset(0, -size.height * 0.6), millis: 2200);
    await _hold(tester, 2000);

    // 3. A story with music: the film template plays.
    _mark('story');
    await _go(tester, RouteNames.createStory, extra: 'store-beach-sunset');
    await _hold(tester, 1200);
    final video = find.byKey(const ValueKey('story-video-switch'));
    await tester.ensureVisible(video);
    await tester.tap(video);
    await _hold(tester, 400);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000));
    await _hold(tester, 7000);

    // (No Thread of the Year scene: its title card names a year, which
    // would date the ad.)

    // 4. The family wall.
    _mark('family');
    await _go(tester, RouteNames.familyWallFor(_familyId));
    await _hold(tester, 4500);

    // 5. Adding a memory with three photos.
    _mark('add');
    AppRouter.router.go(
      RouteNames.addMemory,
      extra: [
        for (final name in [
          'beach_sunset.jpg',
          'newborn.jpg',
          'first_dance.jpg',
        ])
          PickedMemoryPhoto(
            localPath: (await _photoFile(dir, name)).path,
            capturedAt: DateTime(2025, 7, 26, 19, 40),
            width: 1200,
            height: 896,
            hasCapturedDate: true,
            hasDimensions: true,
            title: events[2].title,
          ),
      ],
    );
    await _hold(tester, 4500);

    // Back to the wall to close.
    _mark('wall-end');
    await _go(tester, RouteNames.wall);
    await _hold(tester, 3500);
    _mark('AD_END');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
