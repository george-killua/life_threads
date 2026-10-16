import 'dart:async';

import 'package:app_links_platform_interface/app_links_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/family/presentation/family_flows.dart';
import 'package:life_threads/features/family/presentation/pages/family_sign_in_page.dart';
import 'package:life_threads/features/family/presentation/pages/family_terms_page.dart';
import 'package:life_threads/features/family/presentation/pages/family_wall_page.dart';
import 'package:life_threads/features/family/presentation/widgets/family_invite_link_listener.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_family_service.dart';
import 'support/family_harness.dart';

class _FakeLinks extends AppLinksPlatform with MockPlatformInterfaceMixin {
  final controller = StreamController<Uri>.broadcast();
  @override
  Future<Uri?> getInitialLink() async => null;
  @override
  Stream<Uri> get uriLinkStream => controller.stream;
}

Finder key(String value) => find.byKey(ValueKey(value));

Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
  await tester.ensureVisible(finder);
  await tester.enterText(finder, text);
  await tester.pump();
}

/// A family "Sunday Table" owned by [ownerId], with "me" and "ana" in it.
FakeFamilyService familyWith({
  String ownerId = 'me',
  bool termsAccepted = true,
}) {
  final service = FakeFamilyService(
    account: FakeFamilyService.account(termsAccepted: termsAccepted),
  );
  service.addFamily(
    id: 'f1',
    name: 'Sunday Table',
    ownerId: ownerId,
    members: {'me': 'George', 'ana': 'Ana', if (ownerId != 'me') ownerId: ''},
    usedBytes: 300 * 1024 * 1024,
    quotaBytes: 2 * 1024 * 1024 * 1024,
  );
  service.seedMemory(
    'f1',
    id: 'mine',
    authorId: 'me',
    title: 'Grandma\'s garden',
    description: 'Tomatoes everywhere.',
    locationLabel: 'Graz',
  );
  service.seedMemory(
    'f1',
    id: 'anas',
    authorId: 'ana',
    title: 'First swim',
    wallX: 260,
  );
  return service;
}

void main() {
  group('sign-in gate', () {
    testWidgets('signed out: explains the account, signs in with Google', (
      tester,
    ) async {
      final service = FakeFamilyService();
      await pumpFamilyScreens(tester, service);

      expect(find.text('Sign in to use family walls'), findsOneWidget);

      await tapAndSettle(tester, key('family-sign-in-button'));
      expect(find.byType(FamilySignInPage), findsOneWidget);
      expect(find.textContaining('My wall needs no account'), findsOneWidget);
      // Android: Google only.
      expect(key('family-sign-in-apple'), findsNothing);

      await tapAndSettle(tester, key('family-sign-in-google'));
      expect(service.calls, contains('signInWithGoogle'));
      expect(find.byType(FamilySignInPage), findsNothing);
      expect(find.textContaining('No family walls yet'), findsOneWidget);
      expect(key('family-create-button'), findsOneWidget);
    });

    testWidgets('iOS offers Sign in with Apple next to Google', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        final service = FakeFamilyService();
        await pumpFamilyScreens(tester, service);
        await tapAndSettle(tester, key('family-sign-in-button'));
        expect(key('family-sign-in-apple'), findsOneWidget);
        expect(key('family-sign-in-google'), findsOneWidget);
        await tapAndSettle(tester, key('family-sign-in-apple'));
        expect(service.calls, contains('signInWithApple'));
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('a cancelled sign-in stays quiet; an error is shown', (
      tester,
    ) async {
      final service = FakeFamilyService()
        ..signInError = const FamilyException('sign_in_canceled');
      await pumpFamilyScreens(tester, service);
      await tapAndSettle(tester, key('family-sign-in-button'));
      await tapAndSettle(tester, key('family-sign-in-google'));
      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(FamilySignInPage), findsOneWidget);

      service.signInError = const FamilyException('network');
      await tapAndSettle(tester, key('family-sign-in-google'));
      expect(find.textContaining('offline'), findsOneWidget);
    });

    testWidgets('family screens without a family service say so', (
      tester,
    ) async {
      // A service that fails to start must not break the screen.
      await pumpFamilyScreens(tester, null);
      expect(find.text('Not available yet'), findsOneWidget);
      await tapAndSettle(tester, find.byTooltip('Back'));
      expect(tester.takeException(), isNull);
    });
  });

  group('create family', () {
    testWidgets('without Premium opens the Premium page and creates nothing', (
      tester,
    ) async {
      final service = FakeFamilyService(account: FakeFamilyService.account());
      await pumpFamilyScreens(tester, service, isPremium: false);
      await tapAndSettle(tester, key('family-create-button'));
      expect(find.text('UPGRADE familyWall'), findsOneWidget);
      expect(service.calls.where((c) => c.startsWith('createFamily')), isEmpty);
    });

    testWidgets('terms, subscription link, name, then the new wall', (
      tester,
    ) async {
      final service = FakeFamilyService(
        account: FakeFamilyService.account(
          termsAccepted: false,
          hasActiveSubscription: false,
        ),
      );
      await pumpFamilyScreens(tester, service);
      await tapAndSettle(tester, key('family-create-button'));

      // Terms gate: accept only after ticking the box.
      expect(find.byType(FamilyTermsPage), findsOneWidget);
      expect(find.textContaining('Zero tolerance'), findsOneWidget);
      expect(find.textContaining('within 24 hours'), findsOneWidget);
      final accept = tester.widget<FilledButton>(key('family-terms-accept'));
      expect(accept.onPressed, isNull);
      await tapAndSettle(tester, key('family-terms-agree'));
      await tapAndSettle(tester, key('family-terms-accept'));
      expect(service.calls, contains('acceptTerms:2026-10'));
      expect(service.calls, contains('linkSubscription'));

      await enterText(tester, key('family-name-field'), 'The Kassihs');
      await enterText(tester, key('family-display-name-field'), 'George');
      await tapAndSettle(tester, find.text('Create family wall').last);

      expect(service.calls, contains('createFamily:The Kassihs'));
      expect(service.calls, contains('setMyDisplayName:George'));
      expect(find.byType(FamilyWallPage), findsOneWidget);
      expect(find.text('The Kassihs'), findsOneWidget);
      expect(find.text('The wall is waiting'), findsOneWidget);
    });

    testWidgets('no verified subscription: explains and creates nothing', (
      tester,
    ) async {
      final service = FakeFamilyService(
        account: FakeFamilyService.account(hasActiveSubscription: false),
        subscriptionOnLink: false,
      );
      await pumpFamilyScreens(tester, service);
      await tapAndSettle(tester, key('family-create-button'));
      expect(find.textContaining('active Premium subscription'), findsOne);
      expect(service.calls.where((c) => c.startsWith('createFamily')), isEmpty);
    });
  });

  group('terms gate', () {
    testWidgets('posting needs the rules accepted first', (tester) async {
      final service = familyWith(termsAccepted: false);
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyWallFor('f1'),
      );
      await tapAndSettle(tester, key('family-add-memory'));
      expect(find.byType(FamilyTermsPage), findsOneWidget);
      await tapAndSettle(tester, find.byTooltip('Back').last);
      expect(find.byType(FamilyWallPage), findsOneWidget);
      expect(service.calls.where((c) => c.startsWith('acceptTerms')), isEmpty);
    });
  });

  group('invites', () {
    testWidgets('invite link goes to the share sheet', (tester) async {
      final service = familyWith();
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familySettingsFor('f1'),
      );
      await tapAndSettle(tester, key('family-invite'));
      expect(find.text('Invite link ready'), findsOneWidget);
      expect(
        find.text('Works once and expires after 7 days at the latest.'),
        findsOneWidget,
      );
      await tapAndSettle(tester, key('family-invite-share'));
      expect(sharedParams, hasLength(1));
      expect(
        sharedParams.single.text,
        contains('https://gkcoding.dev/lifethreads/join/'),
      );
      expect(sharedParams.single.text, contains('Sunday Table'));
    });

    testWidgets('an invite of an owner without subscription is refused', (
      tester,
    ) async {
      final service = familyWith();
      service.families['f1']!.ownerSubscriptionActive = false;
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familySettingsFor('f1'),
      );
      await tapAndSettle(tester, key('family-invite'));
      expect(find.text('Invite link ready'), findsNothing);
      expect(find.textContaining('active Premium subscription'), findsOne);
    });
  });

  group('join', () {
    late FakeFamilyService service;
    late FakeFamily other;

    setUp(() {
      // Joining needs no Premium of one's own.
      service = FakeFamilyService();
      other = service.addFamily(
        id: 'f2',
        name: 'Cousins',
        ownerId: 'olga',
        members: {'olga': 'Olga'},
      );
    });

    Future<void> joinWith(WidgetTester tester, Uri link) async {
      await tapAndSettle(tester, key('family-join-button'));
      await enterText(tester, key('family-invite-link-field'), '$link');
      await tapAndSettle(tester, find.text('Continue'));
    }

    testWidgets('paste link, sign in, confirm, open the wall', (tester) async {
      await pumpFamilyScreens(tester, service, isPremium: false);
      // Signed out: the join option sits behind sign-in.
      await tapAndSettle(tester, key('family-sign-in-button'));
      await tapAndSettle(tester, key('family-sign-in-google'));

      await joinWith(tester, service.addInvite(other.id));
      expect(find.text('Join this family wall?'), findsOneWidget);
      await enterText(tester, key('family-join-name-field'), 'George');
      await tapAndSettle(tester, find.text('Join'));

      expect(service.calls, contains('acceptInvite'));
      expect(service.calls, contains('setMyDisplayName:George'));
      expect(find.byType(FamilyWallPage), findsOneWidget);
      expect(find.text('Cousins'), findsWidgets);
    });

    for (final (name, setup, message) in [
      (
        'expired',
        (FakeFamilyService s, FakeFamily f) =>
            s.addInvite(f.id, validFor: const Duration(days: -1)),
        'This invite has expired',
      ),
      (
        'used',
        (FakeFamilyService s, FakeFamily f) {
          final link = s.addInvite(f.id);
          s.invites[link.pathSegments.last]!.used = true;
          return link;
        },
        'already used',
      ),
      (
        'revoked',
        (FakeFamilyService s, FakeFamily f) {
          final link = s.addInvite(f.id);
          s.invites[link.pathSegments.last]!.revoked = true;
          return link;
        },
        'withdrawn',
      ),
      (
        'full',
        (FakeFamilyService s, FakeFamily f) => s.addInvite(
          s.addFamily(name: 'Big', ownerId: 'x', maxMembers: 1).id,
        ),
        'member limit',
      ),
      (
        'not an invite',
        (FakeFamilyService s, FakeFamily f) =>
            Uri.parse('https://example.com/whatever'),
        'not a valid LifeThreads invite link',
      ),
    ]) {
      testWidgets('join error: $name', (tester) async {
        final signedIn = FakeFamilyService(
          account: FakeFamilyService.account(),
        );
        final family = signedIn.addFamily(
          id: 'f2',
          name: 'Cousins',
          ownerId: 'olga',
        );
        final link = setup(signedIn, family);
        await pumpFamilyScreens(tester, signedIn);
        await joinWith(tester, link);
        if (find.text('Join').evaluate().isNotEmpty) {
          await tapAndSettle(tester, find.text('Join'));
        }
        expect(find.textContaining(message), findsOneWidget);
        expect(find.byType(FamilyWallPage), findsNothing);
      });
    }

    testWidgets('a link to a family already joined restores it', (
      tester,
    ) async {
      final signedIn = FakeFamilyService(account: FakeFamilyService.account());
      final family = signedIn.addFamily(
        id: 'f2',
        name: 'Cousins',
        ownerId: 'olga',
        members: {'me': 'George'},
      );
      await pumpFamilyScreens(tester, signedIn);
      await joinWith(tester, signedIn.addInvite(family.id));
      await tapAndSettle(tester, find.text('Join'));
      expect(find.byType(FamilyWallPage), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('You joined Cousins.'), findsOneWidget);
    });

    testWidgets('an opened invite link asks to join, then opens the wall', (
      tester,
    ) async {
      final links = _FakeLinks();
      AppLinksPlatform.instance = links;
      final navigatorKey = GlobalKey<NavigatorState>();
      final signedIn = FakeFamilyService(account: FakeFamilyService.account());
      final family = signedIn.addFamily(
        id: 'f2',
        name: 'Cousins',
        ownerId: 'olga',
      );
      await pumpFamilyScreens(
        tester,
        signedIn,
        navigatorKey: navigatorKey,
        wrap: (child) =>
            FamilyInviteLinkListener(navigatorKey: navigatorKey, child: child),
      );
      // Not an invite: ignored.
      links.controller.add(
        Uri.parse('https://gkcoding.dev/lifethreads/share/x'),
      );
      await settle(tester);
      expect(find.text('Join this family wall?'), findsNothing);

      links.controller.add(signedIn.addInvite(family.id));
      await settle(tester);
      expect(find.text('Join this family wall?'), findsOneWidget);
      await tapAndSettle(tester, find.text('Join'));
      expect(find.byType(FamilyWallPage), findsOneWidget);
    });
  });

  group('permissions per role', () {
    Future<void> openMemory(
      WidgetTester tester,
      FakeFamilyService service,
      String memoryId,
    ) async {
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyMemoryFor('f1', memoryId),
      );
    }

    Future<List<String>> menuItems(WidgetTester tester) async {
      await tapAndSettle(tester, key('family-memory-menu'));
      final items = tester
          .widgetList<PopupMenuItem<Object?>>(
            find.byWidgetPredicate((w) => w is PopupMenuItem),
          )
          .map((item) => ((item.child as Text).data ?? ''))
          .toList();
      await tester.tapAt(const Offset(5, 5));
      await settle(tester);
      return items;
    }

    testWidgets('member, own memory: edit and delete, no report', (
      tester,
    ) async {
      await openMemory(tester, familyWith(ownerId: 'olga'), 'mine');
      expect(key('family-memory-edit'), findsOneWidget);
      expect(find.text('Added by George (you)'), findsOneWidget);
      expect(await menuItems(tester), ['Delete']);
    });

    testWidgets('member, someone else\'s memory: report and block only', (
      tester,
    ) async {
      await openMemory(tester, familyWith(ownerId: 'olga'), 'anas');
      expect(key('family-memory-edit'), findsNothing);
      expect(await menuItems(tester), ['Report', 'Block Ana']);
    });

    testWidgets('owner, someone else\'s memory: report, block and delete', (
      tester,
    ) async {
      final service = familyWith();
      await openMemory(tester, service, 'anas');
      expect(key('family-memory-edit'), findsNothing);
      expect(await menuItems(tester), ['Report', 'Block Ana', 'Delete']);

      await tapAndSettle(tester, key('family-memory-menu'));
      await tapAndSettle(tester, find.text('Delete'));
      expect(find.textContaining('As the owner you can remove'), findsOne);
      await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Delete'));
      expect(service.calls, contains('deleteMemory:anas'));
    });

    testWidgets('owner sees remove and delete wall; member sees leave', (
      tester,
    ) async {
      final owner = familyWith();
      await pumpFamilyScreens(
        tester,
        owner,
        initialLocation: RouteNames.familySettingsFor('f1'),
      );
      expect(key('family-rename'), findsOneWidget);
      expect(key('family-delete'), findsOneWidget);
      expect(key('family-leave'), findsNothing);
      expect(find.textContaining('300 MB of 2 GB used'), findsOneWidget);
      await tapAndSettle(tester, key('family-member-menu-ana'));
      expect(find.text('Remove from wall'), findsOneWidget);
      await tapAndSettle(tester, find.text('Remove from wall'));
      await tapAndSettle(tester, key('family-delete-content'));
      await tapAndSettle(tester, key('family-content-choice-confirm'));
      expect(owner.calls, contains('removeMember:ana:true'));
    });

    testWidgets('member: no rename or remove; leaving can delete own posts', (
      tester,
    ) async {
      final member = familyWith(ownerId: 'olga');
      await pumpFamilyScreens(
        tester,
        member,
        initialLocation: RouteNames.familySettingsFor('f1'),
      );
      expect(key('family-rename'), findsNothing);
      expect(key('family-delete'), findsNothing);
      await tapAndSettle(tester, key('family-member-menu-ana'));
      expect(find.text('Remove from wall'), findsNothing);
      expect(find.text('Block'), findsOneWidget);
      await tester.tapAt(const Offset(5, 5));
      await settle(tester);

      await tapAndSettle(tester, key('family-leave'));
      await tapAndSettle(tester, key('family-delete-content'));
      await tapAndSettle(tester, key('family-content-choice-confirm'));
      expect(member.calls, contains('leaveFamily:true'));
      expect(find.textContaining('No family walls yet'), findsOneWidget);
      // Back still leads home (the list was the only page left before).
      await tapAndSettle(tester, find.byTooltip('Back'));
      expect(find.text('MY WALL'), findsOneWidget);
    });

    testWidgets('family wall: author name on cards; blocked authors hidden', (
      tester,
    ) async {
      final service = familyWith(ownerId: 'olga');
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyWallFor('f1'),
      );
      expect(find.byType(MemoryCard), findsNWidgets(2));
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('George (you)'), findsOneWidget);

      service.blocked.add('ana');
      await tapAndSettle(tester, key('family-refresh'));
      expect(find.byType(MemoryCard), findsOneWidget);
      expect(find.text('First swim'), findsNothing);
    });
  });

  group('report', () {
    testWidgets('reason, details, optional block, 24-hour confirmation', (
      tester,
    ) async {
      final service = familyWith(ownerId: 'olga');
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyMemoryFor('f1', 'anas'),
      );
      await tapAndSettle(tester, key('family-memory-menu'));
      await tapAndSettle(tester, find.text('Report'));
      expect(find.text('Report memory'), findsOneWidget);
      // The decrypted title and story go to GK Coding as evidence.
      expect(key('family-report-evidence'), findsOneWidget);
      expect(find.textContaining('Its photos are never sent'), findsOneWidget);
      for (final reason in FamilyReportReason.values) {
        expect(key('family-report-${reason.name}'), findsOneWidget);
      }
      final send = tester.widget<ButtonStyleButton>(key('family-report-send'));
      expect(send.onPressed, isNull);

      await tapAndSettle(tester, key('family-report-harassment'));
      await enterText(tester, key('family-report-details'), 'Mean caption');
      await tapAndSettle(tester, key('family-report-block'));
      await tapAndSettle(tester, key('family-report-send'));

      expect(find.textContaining('within 24 hours'), findsWidgets);
      expect(service.reports.single['reason'], FamilyReportReason.harassment);
      expect(service.reports.single['details'], 'Mean caption');
      expect(service.reports.single['targetId'], 'anas');
      expect(service.blocked, contains('ana'));
      await tapAndSettle(tester, find.text('Done'));
      expect(find.text('Report memory'), findsNothing);
    });
  });

  group('account', () {
    testWidgets('delete account spells out the consequences and confirms', (
      tester,
    ) async {
      final service = familyWith();
      await pumpFamilyScreens(
        tester,
        service,
        preferences: {'family_walls_active': true},
      );
      await tapAndSettle(tester, key('family-account-button'));
      await tapAndSettle(tester, key('family-delete-account'));

      expect(find.text('Delete your account?'), findsOneWidget);
      expect(
        find.textContaining('you own is deleted for all its members'),
        findsOneWidget,
      );
      expect(find.textContaining('My wall is not affected'), findsOneWidget);
      final confirm = key('family-delete-account-confirm');
      expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
      await tapAndSettle(tester, key('family-delete-understood'));
      await tapAndSettle(tester, confirm);

      expect(service.calls, contains('deleteAccount'));
      expect(service.currentAccount, isNull);
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getBool('family_walls_active'), isFalse);
      expect(find.text('Sign in to use family walls'), findsOneWidget);
    });

    testWidgets('cancelling account deletion deletes nothing', (tester) async {
      final service = familyWith();
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyAccount,
      );
      await tapAndSettle(tester, key('family-delete-account'));
      await tapAndSettle(tester, find.text('Cancel'));
      expect(service.calls, isNot(contains('deleteAccount')));
    });
  });

  group('editing', () {
    testWidgets('version conflict: refresh and save over the new version', (
      tester,
    ) async {
      final service = familyWith(ownerId: 'olga');
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyEditMemoryFor('f1', 'mine'),
      );
      await enterText(tester, key('family-memory-title'), 'Grandma\'s roses');
      service.bumpVersion('f1', 'mine', title: 'Changed elsewhere');
      await tapAndSettle(tester, key('family-memory-save'));

      expect(find.text('Changed by someone else'), findsOneWidget);
      await tapAndSettle(tester, find.text('Refresh and save'));
      expect(service.calls, contains('updateMemory:1:Grandma\'s roses'));
      expect(service.calls, contains('updateMemory:2:Grandma\'s roses'));
      expect(
        service.families['f1']!.memories
            .firstWhere((m) => m.id == 'mine')
            .title,
        'Grandma\'s roses',
      );
    });

    testWidgets('new terms on the server: accept them, then it posts', (
      tester,
    ) async {
      final service = familyWith();
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyAddMemoryFor('f1'),
      );
      // The app still thinks the terms are accepted; the server does not.
      service.nextAddError = const FamilyException('terms_not_accepted');
      await enterText(tester, key('family-memory-title'), 'Picnic');
      await tapAndSettle(tester, key('family-memory-save'));
      expect(find.byType(FamilyTermsPage), findsOneWidget);
      await tapAndSettle(tester, key('family-terms-agree'));
      await tapAndSettle(tester, key('family-terms-accept'));
      expect(service.calls, contains('acceptTerms:2026-10'));
      expect(service.calls.where((c) => c == 'addMemory:Picnic'), hasLength(2));
      expect(find.byType(FamilyTermsPage), findsNothing);
    });

    testWidgets('a full wall explains the quota', (tester) async {
      final service = familyWith();
      service.nextUpdateError = const FamilyException('quota_exceeded');
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyEditMemoryFor('f1', 'mine'),
      );
      await tapAndSettle(tester, key('family-memory-save'));
      expect(find.text('The wall is full'), findsOneWidget);
      expect(find.text('300 MB of 2 GB used'), findsOneWidget);
    });

    testWidgets('a new memory goes to the wall', (tester) async {
      final service = familyWith();
      await pumpFamilyScreens(
        tester,
        service,
        initialLocation: RouteNames.familyWallFor('f1'),
      );
      await tapAndSettle(tester, key('family-add-memory'));
      await enterText(tester, key('family-memory-title'), 'Picnic');
      await enterText(tester, key('family-memory-story'), 'By the lake.');
      await tapAndSettle(tester, key('family-memory-save'));
      expect(service.calls, contains('addMemory:Picnic'));
      expect(find.byType(FamilyWallPage), findsOneWidget);
      expect(find.text('Picnic'), findsOneWidget);
    });
  });

  test('every known error code has its own message in every language', () {
    const codes = [
      'subscription_required',
      'invite_expired',
      'invite_used',
      'invite_revoked',
      'invite_invalid',
      'invite_key_invalid',
      'already_member',
      'family_full',
      'quota_exceeded',
      'version_conflict',
      'terms_required',
      'terms_not_accepted',
      'too_large',
      'not_author',
      'network_error',
      'signed_out',
      'sign_in_unavailable',
      'family_key_missing',
      'no_purchase_found',
      'name_too_long',
      'photo_unreadable',
    ];
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      for (final code in codes) {
        expect(
          familyErrorMessage(l10n, FamilyException(code)),
          isNot(l10n.familyErrorGeneric),
          reason: code,
        );
      }
    }
    expect(
      isFamilyCancellation(const FamilyException('sign_in_canceled')),
      isTrue,
    );
  });
}
