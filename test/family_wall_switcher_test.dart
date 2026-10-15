import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/family/data/family_service.dart';
import 'package:life_threads/features/family/presentation/family_routes.dart';
import 'package:life_threads/features/family/presentation/pages/family_wall_page.dart';
import 'package:life_threads/features/family/presentation/pages/family_walls_page.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/settings/presentation/pages/settings_page.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/features/year_thread/data/year_thread_providers.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_family_service.dart';
import 'support/family_harness.dart';
import 'support/on_this_day_fakes.dart';

/// Counts reads of the family service: the personal wall must not start it
/// before family walls were used on this device.
var serviceReads = 0;

Future<void> pumpApp(
  WidgetTester tester, {
  required FakeFamilyService service,
  required bool familyWallsUsed,
  String initialLocation = RouteNames.wall,
}) async {
  SharedPreferences.setMockInitialValues({
    if (familyWallsUsed) 'family_walls_active': true,
  });
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/package_info'),
        (call) async => {
          'appName': 'LifeThreads',
          'packageName': 'dev.gkcoding.lifethreads',
          'version': '1.0.0',
          'buildNumber': '1',
        },
      );
  serviceReads = 0;
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RouteNames.wall,
        builder: (context, state) => const MemoryWallPage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      ...familyRoutes,
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        familyServiceProvider.overrideWith((ref) {
          serviceReads++;
          return service;
        }),
        memoryRepositoryProvider.overrideWith(
          () => FakeMemoryRepository([memory('a', DateTime(2024, 5, 1))]),
        ),
        premiumEntitlementProvider.overrideWith(
          () => FakePremium(isPremium: true),
        ),
        onThisDayMatchesProvider.overrideWithValue(const []),
        yearThreadWallCardYearProvider.overrideWithValue(null),
      ],
      child: MaterialApp.router(
        theme: AppTheme.dark,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await settle(tester);
}

void main() {
  FakeFamilyService withFamilies() {
    final service = FakeFamilyService(account: FakeFamilyService.account());
    service.addFamily(id: 'f1', name: 'Sunday Table');
    service.addFamily(
      id: 'f2',
      name: 'Cousins',
      ownerId: 'olga',
      members: {'me': ''},
    );
    return service;
  }

  testWidgets('no switcher and no family service until family walls are used', (
    tester,
  ) async {
    await pumpApp(tester, service: withFamilies(), familyWallsUsed: false);
    expect(find.byType(MemoryWallPage), findsOneWidget);
    expect(find.byKey(const ValueKey('wall-switcher')), findsNothing);
    await tapAndSettle(tester, find.byKey(const ValueKey('wall-view-button')));
    expect(find.byKey(const ValueKey('wall-switcher')), findsNothing);
    expect(serviceReads, 0);
  });

  testWidgets('switches from My wall to a family wall and back', (
    tester,
  ) async {
    await pumpApp(tester, service: withFamilies(), familyWallsUsed: true);
    final switcher = find.byKey(const ValueKey('wall-switcher'));
    expect(switcher, findsOneWidget);
    expect(
      find.descendant(of: switcher, matching: find.text('My wall')),
      findsOneWidget,
    );

    await tapAndSettle(tester, switcher);
    expect(find.text('Switch wall'), findsOneWidget);
    expect(find.text('Sunday Table'), findsOneWidget);
    expect(find.text('Cousins'), findsOneWidget);
    expect(find.text('Manage family walls'), findsOneWidget);

    await tapAndSettle(tester, find.text('Cousins'));
    expect(find.byType(FamilyWallPage), findsOneWidget);
    expect(
      find.descendant(of: switcher, matching: find.text('Cousins')),
      findsOneWidget,
    );

    // Family wall to family wall, then home.
    await tapAndSettle(tester, switcher);
    await tapAndSettle(tester, find.text('Sunday Table'));
    expect(
      find.descendant(of: switcher, matching: find.text('Sunday Table')),
      findsOneWidget,
    );
    await tapAndSettle(tester, switcher);
    await tapAndSettle(tester, find.text('My wall').last);
    expect(find.byType(MemoryWallPage), findsOneWidget);
    expect(find.byType(FamilyWallPage), findsNothing);
  });

  testWidgets('the wall\'s More menu opens the family walls', (tester) async {
    await pumpApp(
      tester,
      service: withFamilies(),
      familyWallsUsed: false,
      initialLocation: RouteNames.wall,
    );
    expect(serviceReads, 0);
    await tapAndSettle(tester, find.byKey(const ValueKey('wall-more-button')));
    await tapAndSettle(tester, find.text('Family walls').last);
    expect(find.byType(FamilyWallsPage), findsOneWidget);
    expect(find.text('Sunday Table'), findsOneWidget);
    expect(find.text('Cousins'), findsOneWidget);
  });
}
