// End-to-end tests for the protocol (LT-TP-100) parts a simulator cannot do
// for real: buying and restoring Premium (no store account) and family walls
// (no Google or Apple sign-in). The rest of the protocol runs as Maestro
// flows in .maestro/flows. Both run from tool/e2e/run_e2e.sh.
//
// The real app runs with a stand-in store and family server
// (support/harness.dart). The tests share the app's data in order, like one
// person testing from first start on.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:life_threads/app/app.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';

import 'support/harness.dart';

Finder key(String value) => find.byKey(ValueKey(value));

/// Scrolls the screen's main list until [finder] is on screen.
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await waitFor(tester, find.byType(Scrollable));
  for (var i = 0; i < 25 && finder.hitTestable().evaluate().isEmpty; i++) {
    if (finder.evaluate().isNotEmpty) {
      await scrollToCenter(tester, finder.first);
      if (finder.hitTestable().evaluate().isNotEmpty) break;
    }
    await tester.drag(
      find.byType(Scrollable).hitTestable().first,
      const Offset(0, -300),
    );
    await settle(tester, 300);
  }
}

Future<void> openSettings(WidgetTester tester) async {
  await tapOn(tester, find.byTooltip('More'));
  await tapText(tester, 'Settings');
  await waitFor(tester, find.text('Your name'));
}

Future<void> openPremiumPage(WidgetTester tester) async {
  await openSettings(tester);
  await scrollTo(tester, find.text('Open Premium'));
  await tapText(tester, 'Open Premium');
  await waitFor(tester, find.textContaining('LifeThreads Premium'));
}

Future<void> openFamilyWalls(WidgetTester tester) async {
  await openSettings(tester);
  await scrollTo(tester, find.text('Open family walls'));
  await tapText(tester, 'Open family walls', settleMillis: 1200);
  await waitGone(tester, find.text('Open family walls'));
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(resetAppData);

  tearDownAll(() {
    binding.reportData = {'protocol': e2eResults, 'platform': platformName};
    // ignore: avoid_print
    print(
      'E2E_RESULTS $platformName '
      '${e2eResults.entries.map((e) => '${e.key}=${e.value}').join(' ')}',
    );
  });

  protocolTest('INS-02', 'Onboarding (setup for the tests below)', (
    tester,
  ) async {
    await launchApp(tester);
    await completeOnboarding(tester);
    await waitFor(tester, find.text('Start with one thing from today'));
  });

  protocolTest('PRM-02', 'Subscribe with the store', (tester) async {
    await launchApp(tester);
    await openPremiumPage(tester);
    await scrollTo(tester, key('premium-subscribe'));
    expect(find.textContaining('€4.99'), findsWidgets);
    expect(find.textContaining('renews automatically'), findsWidgets);
    await tapOn(tester, key('premium-subscribe'), settleMillis: 1500);
    await waitFor(tester, find.text('Premium Active'));
  });

  protocolTest('PRM-03', 'Restore the subscription', (tester) async {
    await launchApp(tester);
    // As after reinstalling: the store still has the purchase, the app not.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LifeThreadsApp)),
    );
    await runReal(
      tester,
      container.read(premiumEntitlementProvider.notifier).revokeStoreUnlock(),
    );
    await openPremiumPage(tester);
    await scrollTo(tester, key('premium-restore'));
    expect(find.text('Premium Active'), findsNothing);
    await tapOn(tester, key('premium-restore'), settleMillis: 1500);
    await waitFor(tester, find.text('Premium Active'));
  });

  protocolTest('FAM-01', 'Sign in and create a family wall', (tester) async {
    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapOn(tester, key('family-sign-in-button'));
    await tapOn(tester, key('family-sign-in-google'));
    await tapOn(tester, key('family-create-button'));
    // The family rules: accepting needs the box ticked first.
    await waitFor(tester, find.textContaining('Zero tolerance'));
    await tapOn(tester, key('family-terms-agree'));
    await tapOn(tester, key('family-terms-accept'));
    await enterInto(tester, key('family-name-field'), 'The Kassihs');
    await enterInto(tester, key('family-display-name-field'), 'Lina');
    await tapOn(
      tester,
      find.text('Create family wall').last,
      settleMillis: 1500,
    );
    await waitFor(tester, find.text('The wall is waiting'));
    expect(find.text('The Kassihs'), findsWidgets);
    expect(e2eFamily.calls, contains('createFamily:The Kassihs'));
  });

  protocolTest('FAM-03', 'Share a memory on the family wall', (tester) async {
    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapText(tester, 'The Kassihs');
    // The empty wall's button and the + button are both "Add memory".
    await tapText(tester, 'Add memory');
    await enterInto(tester, key('family-memory-title'), 'Picnic by the lake');
    await enterInto(tester, key('family-memory-story'), 'Everyone came.');
    await tapOn(tester, key('family-memory-save'), settleMillis: 1500);
    await waitFor(tester, find.text('Picnic by the lake'));
    expect(e2eFamily.calls, contains('addMemory:Picnic by the lake'));
  });

  protocolTest('FAM-02', 'Invite, and join another family', (tester) async {
    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapText(tester, 'The Kassihs');
    await tapOn(tester, key('family-settings'));
    await tapOn(tester, key('family-invite'));
    await waitFor(tester, find.text('Invite link ready'));
    await tapOn(tester, key('family-invite-share'));
    expect(
      e2eShared.last.text,
      contains('https://gkcoding.dev/lifethreads/join/'),
    );
    await closeApp(tester);

    // Another family invites Lina.
    final cousins = e2eFamily.addFamily(
      name: 'Cousins',
      ownerId: 'aunt',
      members: {'aunt': 'Aunt Mira'},
    );
    e2eFamily.seedMemory(
      cousins.id,
      id: 'mira-birthday',
      authorId: 'aunt',
      title: "Mira's birthday",
    );
    final link = e2eFamily.addInvite(cousins.id);

    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapOn(tester, key('family-join-button'));
    await enterInto(tester, key('family-invite-link-field'), '$link');
    await tapText(tester, 'Continue');
    await waitFor(tester, find.text('Join this family wall?'));
    await enterInto(tester, key('family-join-name-field'), 'Lina');
    await tapText(tester, 'Join', settleMillis: 1500);
    await waitFor(tester, find.text("Mira's birthday"));
    expect(e2eFamily.calls, contains('acceptInvite'));
  });

  protocolTest('FAM-04', 'Report, block, leave', (tester) async {
    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapText(tester, 'Cousins');
    await tapText(tester, "Mira's birthday");
    await tapOn(tester, key('family-memory-menu'));
    await tapText(tester, 'Report');
    await waitFor(tester, find.text('Report memory'));
    await tapOn(tester, key('family-report-harassment'));
    await enterInto(tester, key('family-report-details'), 'Test report');
    await tapOn(tester, key('family-report-block'));
    await tapOn(tester, key('family-report-send'), settleMillis: 1500);
    await waitFor(tester, find.textContaining('within 24 hours'));
    expect(e2eFamily.reports.last['reason'], FamilyReportReason.harassment);
    expect(e2eFamily.blocked, contains('aunt'));
    await tapText(tester, 'Done');
    await closeApp(tester);

    // Leave the Cousins wall and delete Lina's posts there.
    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapText(tester, 'Cousins');
    await tapOn(tester, key('family-settings'));
    await scrollTo(tester, key('family-leave'));
    await tapOn(tester, key('family-leave'));
    await tapOn(tester, key('family-delete-content'));
    await tapOn(
      tester,
      key('family-content-choice-confirm'),
      settleMillis: 1500,
    );
    await waitGone(tester, find.text('Cousins'));
    expect(e2eFamily.calls, contains('leaveFamily:true'));
  });

  protocolTest('FAM-05', 'Delete the account', (tester) async {
    await launchApp(tester);
    await openFamilyWalls(tester);
    await tapOn(tester, key('family-account-button'));
    await tapOn(tester, key('family-delete-account'));
    await waitFor(tester, find.text('Delete your account?'));
    expect(find.textContaining('My wall is not affected'), findsOneWidget);
    await tapOn(tester, key('family-delete-understood'));
    await tapOn(
      tester,
      key('family-delete-account-confirm'),
      settleMillis: 1500,
    );
    await waitFor(tester, find.text('Sign in to use family walls'));
    expect(e2eFamily.calls, contains('deleteAccount'));
  });
}
