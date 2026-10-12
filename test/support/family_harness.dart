import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/family/data/family_service.dart';
import 'package:life_threads/features/family/presentation/family_providers.dart';
import 'package:life_threads/features/family/presentation/family_routes.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_feature.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_family_service.dart';
import 'on_this_day_fakes.dart';

/// Share sheet calls captured by the harness.
final sharedParams = <ShareParams>[];

/// Pumps the family screens on a router with stand-ins for "My wall" and
/// the Premium page.
Future<GoRouter> pumpFamilyScreens(
  WidgetTester tester,
  FakeFamilyService? service, {
  String initialLocation = RouteNames.familyWalls,
  bool isPremium = true,
  Locale locale = const Locale('en'),
  Map<String, Object> preferences = const {},
  GlobalKey<NavigatorState>? navigatorKey,
  Widget Function(Widget child)? wrap,
}) async {
  SharedPreferences.setMockInitialValues(preferences);
  sharedParams.clear();
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Text('HOME')),
      ),
      GoRoute(
        path: RouteNames.wall,
        builder: (context, state) => const Scaffold(body: Text('MY WALL')),
      ),
      GoRoute(
        path: RouteNames.upgrade,
        builder: (context, state) => Scaffold(
          body: Text('UPGRADE ${(state.extra as PremiumFeature?)?.name}'),
        ),
      ),
      ...familyRoutes,
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Without a service the real, still unimplemented provider is used.
        if (service != null) familyServiceProvider.overrideWithValue(service),
        premiumEntitlementProvider.overrideWith(
          () => FakePremium(isPremium: isPremium),
        ),
        familyShareSheetProvider.overrideWithValue((params) async {
          sharedParams.add(params);
          return const ShareResult('done', ShareResultStatus.success);
        }),
      ],
      child: MaterialApp.router(
        theme: AppTheme.dark,
        locale: locale,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: wrap == null ? null : (context, child) => wrap(child!),
      ),
    ),
  );
  await settle(tester);
  return router;
}

/// Pumps frames; the family wall's cards sway forever, so pumpAndSettle
/// cannot be used there.
Future<void> settle(WidgetTester tester, {int frames = 12}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}
