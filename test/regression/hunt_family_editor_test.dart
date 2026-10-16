// Regressions from the 2026-10-16 hunt: family memory editor.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/family/presentation/pages/family_memory_editor_page.dart';
import 'package:life_threads/features/media/data/photo_library_service.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';

import '../support/fake_family_service.dart';
import '../support/family_harness.dart';

Finder key(String value) => find.byKey(ValueKey(value));

FakeFamilyService familyWith() {
  final service = FakeFamilyService(account: FakeFamilyService.account());
  service.addFamily(
    id: 'f1',
    name: 'Sunday Table',
    ownerId: 'me',
    members: {'me': 'George', 'ana': 'Ana'},
  );
  service.seedMemory('f1', id: 'mine', authorId: 'me', title: 'Garden');
  return service;
}

/// Personal memories with nothing in them; deletes dropped photo copies the
/// way the real repository does (no memory uses them here).
class _NoPersonalMemories extends MemoryRepository {
  @override
  Future<MemoryState> build() async => const MemoryState(
    events: [],
    connections: [],
    photos: [],
    people: [],
    wallItems: [],
  );

  @override
  Future<void> deleteUnusedPhotoCopies(Iterable<String> paths) async {
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    }
  }
}

/// Camera that "captures" a real file in a temp folder (the app's copy).
class _FakeCamera extends PhotoLibraryService {
  _FakeCamera(this.file);
  final File file;
  @override
  Future<PickedMemoryPhoto?> capturePhotoToAppStorage() async =>
      PickedMemoryPhoto(
        localPath: file.path,
        capturedAt: DateTime(2026, 9, 1),
        width: 10,
        height: 10,
        hasCapturedDate: false,
        hasDimensions: true,
      );
}

Future<void> systemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await settle(tester);
}

void main() {
  testWidgets('F3-01 edit: changing only the date, then back, asks first', (
    tester,
  ) async {
    final router = await pumpFamilyScreens(
      tester,
      familyWith(),
      initialLocation: RouteNames.familyWallFor('f1'),
    );
    router.push(RouteNames.familyEditMemoryFor('f1', 'mine'));
    await settle(tester);
    await tapAndSettle(tester, find.textContaining('Date:'));
    await tapAndSettle(tester, find.text('15').first);
    await tapAndSettle(tester, find.text('OK'));
    expect(find.textContaining('Sep 15, 2026'), findsOneWidget);
    await systemBack(tester);
    expect(
      find.byType(FamilyMemoryEditorPage),
      findsOneWidget,
      reason: 'back left the editor without asking; the edit is lost',
    );
    expect(
      find.text('Discard changes?'),
      findsOneWidget,
      reason: 'the changed date is thrown away without asking',
    );
  });

  testWidgets('control: a typed title, then back, does ask (method works)', (
    tester,
  ) async {
    final router = await pumpFamilyScreens(
      tester,
      familyWith(),
      initialLocation: RouteNames.familyWallFor('f1'),
    );
    router.push(RouteNames.familyAddMemoryFor('f1'));
    await settle(tester);
    await tester.enterText(key('family-memory-title'), 'Picnic');
    await tester.pump();
    await systemBack(tester);
    expect(find.text('Discard changes?'), findsOneWidget);
  });

  testWidgets('F3-01b new memory: only a place typed, then back, asks first', (
    tester,
  ) async {
    final router = await pumpFamilyScreens(
      tester,
      familyWith(),
      initialLocation: RouteNames.familyWallFor('f1'),
    );
    router.push(RouteNames.familyAddMemoryFor('f1'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Place'),
      'Lake Wörthersee',
    );
    await tester.pump();
    await systemBack(tester);
    expect(
      find.byType(FamilyMemoryEditorPage),
      findsOneWidget,
      reason: 'back left the editor without asking; the edit is lost',
    );
    expect(find.text('Discard changes?'), findsOneWidget);
  });

  testWidgets(
    'F3-02 edit link to a memory that is gone does not spin forever',
    (tester) async {
      await pumpFamilyScreens(
        tester,
        familyWith(),
        initialLocation: RouteNames.familyEditMemoryFor('f1', 'deleted-one'),
      );
      await settle(tester, frames: 40);
      expect(find.byType(FamilyMemoryEditorPage), findsOneWidget);
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'memories loaded; the editor should say the memory is gone',
      );
    },
  );

  testWidgets('F3-03 a removed photo leaves its copy in app storage', (
    tester,
  ) async {
    final dir = Directory.systemTemp.createTempSync('f3_photo');
    final file = File('${dir.path}/copy.jpg')..writeAsBytesSync([1, 2, 3]);
    final camera = _FakeCamera(file);
    await pumpFamilyScreens(
      tester,
      familyWith(),
      initialLocation: RouteNames.familyAddMemoryFor('f1'),
      wrap: (child) => ProviderScope(
        overrides: [
          photoLibraryServiceProvider.overrideWithValue(camera),
          memoryRepositoryProvider.overrideWith(_NoPersonalMemories.new),
        ],
        child: child,
      ),
    );
    await tapAndSettle(tester, find.text('Take photo'));
    expect(find.byTooltip('Remove photo'), findsOneWidget);
    await tapAndSettle(tester, find.byTooltip('Remove photo'));
    expect(find.text('No photos yet'), findsOneWidget);
    await settle(tester);
    expect(
      file.existsSync(),
      isFalse,
      reason: 'removed photo copy is never deleted (orphaned in memory_photos)',
    );
  });

  testWidgets('F3-03b a posted photo leaves its plaintext copy behind', (
    tester,
  ) async {
    final dir = Directory.systemTemp.createTempSync('f3_photo');
    final file = File('${dir.path}/copy.jpg')..writeAsBytesSync([1, 2, 3]);
    final camera = _FakeCamera(file);
    final service = familyWith();
    await pumpFamilyScreens(
      tester,
      service,
      initialLocation: RouteNames.familyAddMemoryFor('f1'),
      wrap: (child) => ProviderScope(
        overrides: [
          photoLibraryServiceProvider.overrideWithValue(camera),
          memoryRepositoryProvider.overrideWith(_NoPersonalMemories.new),
        ],
        child: child,
      ),
    );
    await tapAndSettle(tester, find.text('Take photo'));
    await tapAndSettle(tester, key('family-memory-save'));
    expect(service.calls.where((c) => c.startsWith('addMemory')), hasLength(1));
    await settle(tester);
    expect(
      file.existsSync(),
      isFalse,
      reason: 'the uploaded photo stays as an unreferenced local copy',
    );
  });
}
