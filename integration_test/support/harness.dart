// Shared setup for the end-to-end tests: the real LifeThreads app with
// stand-ins only where a simulator or emulator cannot do the real thing
// (the App Store / Play billing sheet, Google and Apple sign-in for family
// walls, and the system notification scheduler).
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/app.dart';
import 'package:life_threads/app/router/app_router.dart';
import 'package:life_threads/features/family/data/family_service.dart';
import 'package:life_threads/features/family/presentation/family_providers.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/premium/data/premium_billing_controller.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_purchase_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test/support/fake_family_service.dart';
import '../../test/support/on_this_day_fakes.dart';

/// One family server stand-in for the whole run, so a wall created in one
/// test is still there in the next.
final e2eFamily = FakeFamilyService();
final e2eNotifications = FakeOnThisDayNotifications();
final e2eShared = <ShareParams>[];

/// The store as App Store / Google Play would report it, without the system
/// purchase sheet. Subscribing and restoring grant Premium the same way a
/// verified store purchase does.
class E2EStoreBilling extends PremiumBillingController {
  @override
  PremiumPurchaseState build() => const PremiumPurchaseState(
    status: PremiumPurchaseStatus.ready,
    productId: 'lifethreads_premium_monthly',
    price: '€4.99',
    canBuy: true,
  );

  @override
  Future<void> loadProduct() async {}

  @override
  Future<void> buySubscription() async {
    state = state.copyWith(
      status: PremiumPurchaseStatus.loading,
      message: PremiumPurchaseMessage.openingCheckout,
    );
    await ref.read(premiumEntitlementProvider.notifier).grantStoreUnlock();
    state = state.copyWith(
      status: PremiumPurchaseStatus.purchased,
      message: PremiumPurchaseMessage.active,
    );
  }

  @override
  Future<void> restorePurchases({bool silent = false}) async {
    await ref.read(premiumEntitlementProvider.notifier).grantStoreUnlock();
    state = state.copyWith(
      status: PremiumPurchaseStatus.restored,
      message: silent ? null : PremiumPurchaseMessage.restored,
    );
  }
}

/// Wipes the app's data like a fresh install and pins the app language to
/// English (the protocol's labels); the language test switches it later.
Future<void> resetAppData() async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  await preferences.setString('selected_locale_code', 'en');
  final documents = await getApplicationDocumentsDirectory();
  for (final entry in documents.listSync()) {
    try {
      entry.deleteSync(recursive: true);
    } catch (_) {}
  }
}

/// Starts the app the way a user opens it.
Future<void> launchApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        premiumBillingProvider.overrideWith(E2EStoreBilling.new),
        familyServiceProvider.overrideWithValue(e2eFamily),
        onThisDayNotificationsProvider.overrideWithValue(e2eNotifications),
        familyShareSheetProvider.overrideWithValue((params) async {
          e2eShared.add(params);
          return const ShareResult('done', ShareResultStatus.success);
        }),
      ],
      child: const LifeThreadsApp(),
    ),
  );
  await settle(tester);
}

/// Leaves the app between tests: the next [launchApp] starts at the root,
/// like reopening the app.
Future<void> closeApp(WidgetTester tester) async {
  AppRouter.router.go('/');
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 300));
}

/// Pumps frames for a while. The wall animates continuously, so
/// `pumpAndSettle` would never return.
Future<void> settle(WidgetTester tester, [int millis = 1200]) async {
  final end = DateTime.now().add(Duration(milliseconds: millis));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Pumps until [finder] matches, or fails with what is on screen.
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
  String? reason,
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail(
    '${reason ?? 'Timed out waiting for $finder'}\n'
    'On screen: ${visibleTexts(tester).take(40).join(' | ')}',
  );
}

/// Pumps until [finder] no longer matches.
Future<void> waitGone(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isEmpty) return;
  }
  fail('Still on screen after $timeout: $finder');
}

/// Scrolls [finder] into view (if it sits in a scrollable) and taps it.
Future<void> tapOn(
  WidgetTester tester,
  Finder finder, {
  int settleMillis = 700,
}) async {
  await waitFor(tester, finder);
  final target = finder.first;
  await scrollToCenter(tester, target);
  await tester.tap(target, warnIfMissed: false);
  await settle(tester, settleMillis);
}

Future<void> tapText(
  WidgetTester tester,
  String text, {
  int settleMillis = 700,
}) => tapOn(tester, find.text(text), settleMillis: settleMillis);

Future<void> enterInto(WidgetTester tester, Finder field, String text) async {
  await waitFor(tester, field);
  await scrollToCenter(tester, field.first);
  await tester.enterText(field.first, text);
  await tester.pump(const Duration(milliseconds: 200));
  hideKeyboard();
  await settle(tester, 500);
}

/// Closes the on-screen keyboard, like tapping Done.
void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

/// Every text currently built, for failure messages.
List<String> visibleTexts(WidgetTester tester) => find
    .byType(Text)
    .evaluate()
    .map((element) => (element.widget as Text).data ?? '')
    .where((text) => text.trim().isNotEmpty)
    .toList();

/// The protocol ID and result of every test, printed at the end of the run.
final e2eResults = <String, String>{};

/// A test from the protocol (`docs/testing`), by its ID.
void protocolTest(
  String id,
  String title,
  Future<void> Function(WidgetTester tester) body, {
  Timeout timeout = const Timeout(Duration(minutes: 4)),
}) {
  testWidgets('$id $title', (tester) async {
    e2eResults[id] = 'FAIL';
    try {
      await body(tester);
      e2eResults[id] = 'PASS';
    } finally {
      await closeApp(tester);
    }
  }, timeout: timeout);
}

String get platformName => Platform.isIOS ? 'iOS' : 'Android';

/// Waits for a real future (file I/O, encoders) while frames keep coming.
Future<T> runReal<T>(WidgetTester tester, Future<T> future) async {
  T? value;
  Object? error;
  var done = false;
  unawaited(
    future.then(
      (result) {
        value = result;
        done = true;
      },
      onError: (Object e) {
        error = e;
        done = true;
      },
    ),
  );
  while (!done) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  if (error != null) throw error!;
  return value as T;
}

/// Prints texts, tooltips and widget keys on screen (for writing tests).
void dumpScreen(WidgetTester tester, String label) {
  final tooltips = find
      .byType(Tooltip)
      .evaluate()
      .map((e) => (e.widget as Tooltip).message ?? '')
      .where((m) => m.isNotEmpty);
  final keys = <String>{};
  for (final element
      in find.byWidgetPredicate((w) => w.key is ValueKey).evaluate()) {
    final value = (element.widget.key as ValueKey).value;
    if (value is String && value.length < 60) keys.add(value);
  }
  // ignore: avoid_print
  print('SCREEN[$label] texts: ${visibleTexts(tester).take(80).join(' | ')}');
  // ignore: avoid_print
  print('SCREEN[$label] tooltips: ${tooltips.join(' | ')}');
  // ignore: avoid_print
  print('SCREEN[$label] keys: ${keys.take(80).join(' | ')}');
}

/// Runs the first-start onboarding: name, then the demo wall or a blank one.
Future<void> completeOnboarding(
  WidgetTester tester, {
  String name = 'Lina',
  bool demo = false,
}) async {
  await waitFor(tester, find.text('Build your living wall.'));
  await tapText(tester, 'Next');
  await tapText(tester, 'Next');
  await enterInto(tester, find.byType(TextField), name);
  await tapText(tester, 'Next');
  await tapText(tester, 'Next');
  await tapText(
    tester,
    demo ? 'Preview demo wall' : 'Start fresh',
    settleMillis: 2500,
  );
}

/// Scrolls [target] to the middle of its scroll view, clear of bottom bars
/// and sheets' edges.
Future<void> scrollToCenter(WidgetTester tester, Finder target) async {
  try {
    final element = tester.element(target);
    if (Scrollable.maybeOf(element) == null) return;
    // No animation: awaiting one would wait for frames this test drives.
    unawaited(Scrollable.ensureVisible(element, alignment: 0.45));
    await settle(tester, 400);
  } catch (_) {}
}
