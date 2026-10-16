// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// family flows.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/family/presentation/pages/family_wall_page.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';

import '../support/fake_family_service.dart';
import '../support/family_harness.dart';

Finder key(String value) => find.byKey(ValueKey(value));

/// setMyDisplayName fails (e.g. connection drops right after createFamily).
class _NameFails extends FakeFamilyService {
  _NameFails() : super(account: FakeFamilyService.account());
  @override
  Future<void> setMyDisplayName(String familyId, String displayName) async {
    calls.add('setMyDisplayName:$displayName');
    throw const SocketException('connection lost');
  }
}

FakeFamilyService _wallWithMyMemory({List<String> photoIds = const []}) {
  final service = FakeFamilyService(account: FakeFamilyService.account());
  service.addFamily(
    id: 'f1',
    name: 'Sunday Table',
    ownerId: 'me',
    members: {'me': 'George'},
  );
  service.seedMemory(
    'f1',
    id: 'mine',
    authorId: 'me',
    title: 'Garden',
    photoIds: photoIds,
  );
  return service;
}

MemoryCard _card(WidgetTester tester, String id) =>
    tester.widget<MemoryCard>(key('family-card-$id'));

void main() {
  testWidgets('F2-01 create: a created family is reported as a failure', (
    tester,
  ) async {
    final service = _NameFails();
    await pumpFamilyScreens(tester, service);
    await tapAndSettle(tester, key('family-create-button'));
    await tester.enterText(key('family-name-field'), 'The Kassihs');
    await tester.enterText(key('family-display-name-field'), 'George');
    await tester.pump();
    await tapAndSettle(tester, find.text('Create family wall').last);

    final created = service.calls
        .where((c) => c.startsWith('createFamily'))
        .length;
    expect(created, 1);
    expect(service.families.length, 1, reason: 'family exists on the server');
    // Expected: the new wall opens (name can be set later).
    // Actual: an offline error toast, no navigation, setActive(true) skipped.
    expect(
      find.byType(FamilyWallPage),
      findsOneWidget,
      reason: 'family was created but the flow reported an error',
    );
  });

  testWidgets('F2-02 own moved card ignores later synced position', (
    tester,
  ) async {
    final service = _wallWithMyMemory();
    await pumpFamilyScreens(
      tester,
      service,
      initialLocation: RouteNames.familyWallFor('f1'),
    );
    final card = _card(tester, 'mine');
    card.onDragStart();
    _card(tester, 'mine').onDragUpdate(const Offset(100, 0));
    _card(tester, 'mine').onDragEnd();
    await settle(tester);
    expect(service.calls, contains('moveMemory:mine'));

    // Later the same author moves the card on another device; sync brings it.
    final stored = service.families['f1']!.memories.single;
    await service.moveMemory(stored, 500, 500);
    await tapAndSettle(tester, key('family-refresh'));

    final shown = _card(tester, 'mine').event.wallPosition;
    // Board origin is (-20000,-20000), so (500,500) is shown at (20500,20500).
    expect(
      shown,
      const Offset(20500, 20500),
      reason: '_pendingMoves never cleared; stale local position wins',
    );
  });

  testWidgets('F2-03 cover photo error is stuck after refresh', (tester) async {
    final service = _wallWithMyMemory(photoIds: ['p1']);
    await pumpFamilyScreens(
      tester,
      service,
      initialLocation: RouteNames.familyWallFor('f1'),
    );
    expect(_card(tester, 'mine').event.coverPhotoPath, isNull);

    // Back online: the photo can be fetched now; the user taps refresh.
    service.setPhotoFile('p1', File('/tmp/p1.jpg'));
    await tapAndSettle(tester, key('family-refresh'));
    expect(
      _card(tester, 'mine').event.coverPhotoPath,
      '/tmp/p1.jpg',
      reason: 'familyPhotoProvider error cached; refresh does not retry',
    );
  });
}
