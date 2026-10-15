// On this day on the wall card, the memory detail page and in Settings.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/presentation/pages/memory_detail_page.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_settings.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_feature.dart';
import 'package:life_threads/features/settings/presentation/pages/settings_page.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/on_this_day_fakes.dart';

final today = DateTime(2026, 10, 12, 10);

List<Override> overrides({
  required bool isPremium,
  FakeOnThisDayNotifications? notifications,
  DateTime? now,
}) => [
  memoryRepositoryProvider.overrideWith(
    () => FakeMemoryRepository([
      memory('older', DateTime(2019, 3, 4)),
      memory('anniversary', DateTime(2023, 10, 12)),
    ]),
  ),
  premiumEntitlementProvider.overrideWith(
    () => FakePremium(isPremium: isPremium),
  ),
  onThisDayClockProvider.overrideWithValue(() => now ?? today),
  onThisDayNotificationsProvider.overrideWithValue(
    notifications ?? FakeOnThisDayNotifications(),
  ),
];

Widget app(Widget home, List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('wall card', () {
    Future<void> pumpWall(WidgetTester tester, List<Override> list) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(app(const MemoryWallPage(), list));
      await settle(tester);
    }

    testWidgets('shows the On this day memory first, also without Premium', (
      tester,
    ) async {
      await pumpWall(tester, overrides(isPremium: false));

      expect(find.text('3 years ago today'), findsOneWidget);
      expect(find.text('Remember this'), findsNothing);
    });

    testWidgets('falls back to Remember this without a match', (tester) async {
      await pumpWall(
        tester,
        overrides(isPremium: false, now: DateTime(2026, 1, 1)),
      );

      expect(find.text('Remember this'), findsOneWidget);
      expect(find.textContaining('years ago today'), findsNothing);
    });
  });

  group('memory detail', () {
    Future<void> pumpDetail(
      WidgetTester tester, {
      required bool premium,
    }) async {
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        app(
          const MemoryDetailPage(memoryId: 'anniversary'),
          overrides(isPremium: premium),
        ),
      );
      await settle(tester);
    }

    testWidgets('opens as an On this day chapter with Premium', (tester) async {
      await pumpDetail(tester, premium: true);

      expect(find.text('On this day · 3 years ago'), findsOneWidget);
    });

    testWidgets('free users see the usual page', (tester) async {
      await pumpDetail(tester, premium: false);

      expect(find.text('Memory anniversary'), findsWidgets);
      expect(find.textContaining('On this day'), findsNothing);
    });
  });

  group('settings', () {
    Future<ProviderContainer> pumpSettings(
      WidgetTester tester,
      List<Override> list,
    ) async {
      PackageInfo.setMockInitialValues(
        appName: 'LifeThreads',
        packageName: 'dev.gkcoding.lifethreads',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );
      await tester.binding.setSurfaceSize(const Size(800, 4000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SettingsPage()),
          GoRoute(
            path: RouteNames.upgrade,
            builder: (context, state) =>
                Text('UPGRADE ${(state.extra as PremiumFeature?)?.name}'),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: list,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await settle(tester);
      return ProviderScope.containerOf(
        tester.element(find.byType(SettingsPage)),
      );
    }

    Finder reminderSwitch() => find.byType(Switch);

    testWidgets('free users are sent to Premium; no permission is asked', (
      tester,
    ) async {
      final notifications = FakeOnThisDayNotifications();
      final container = await pumpSettings(
        tester,
        overrides(isPremium: false, notifications: notifications),
      );

      await tester.tap(reminderSwitch());
      await settle(tester);

      expect(find.text('UPGRADE onThisDay'), findsOneWidget);
      expect(notifications.permissionRequests, 0);
      final settings = container.read(onThisDaySettingsProvider).value!;
      expect(settings.remindersEnabled, isFalse);
    });

    testWidgets('Premium users turn reminders on after granting permission', (
      tester,
    ) async {
      final notifications = FakeOnThisDayNotifications();
      final container = await pumpSettings(
        tester,
        overrides(isPremium: true, notifications: notifications),
      );
      // The time row shows once reminders are on.
      expect(find.text('At 9:00 AM'), findsNothing);

      await tester.tap(reminderSwitch());
      await settle(tester);

      expect(notifications.permissionRequests, 1);
      final settings = container.read(onThisDaySettingsProvider).value!;
      expect(settings.remindersEnabled, isTrue);
      expect(find.text('At 9:00 AM'), findsOneWidget);
    });

    testWidgets('a denied permission leaves reminders off', (tester) async {
      final notifications = FakeOnThisDayNotifications(grantPermission: false);
      final container = await pumpSettings(
        tester,
        overrides(isPremium: true, notifications: notifications),
      );

      await tester.tap(reminderSwitch());
      await settle(tester);

      expect(
        find.text(
          "Notifications are off for LifeThreads. Allow them in your phone's settings.",
        ),
        findsOneWidget,
      );
      final settings = container.read(onThisDaySettingsProvider).value!;
      expect(settings.remindersEnabled, isFalse);
    });
  });
}
