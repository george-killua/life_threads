import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_feature.dart';
import 'package:life_threads/features/premium/presentation/premium_gate.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/on_this_day_fakes.dart';

Future<bool?> tryFeature(WidgetTester tester, {required bool isPremium}) async {
  bool? result;
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: TextButton(
            onPressed: () async {
              result = await requirePremium(context, PremiumFeature.storyImage);
            },
            child: const Text('TRY'),
          ),
        ),
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
        premiumEntitlementProvider.overrideWith(
          () => FakePremium(isPremium: isPremium),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.tap(find.text('TRY'));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  testWidgets('passes with Premium and stays on the page', (tester) async {
    expect(await tryFeature(tester, isPremium: true), isTrue);
    expect(find.text('TRY'), findsOneWidget);
    expect(find.textContaining('UPGRADE'), findsNothing);
  });

  testWidgets('opens the Premium page with the feature without Premium', (
    tester,
  ) async {
    expect(await tryFeature(tester, isPremium: false), isFalse);
    expect(find.text('UPGRADE storyImage'), findsOneWidget);
  });

  test('every Premium feature has a name in every language', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      for (final feature in PremiumFeature.values) {
        expect(feature.label(l10n), isNotEmpty);
      }
    }
  });
}
