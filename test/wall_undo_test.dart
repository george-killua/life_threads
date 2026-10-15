// Deleting from the wall: gone at once, with "Undo" on a toast.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regression/wall_drag_test.dart' show FakeRepo;

class _UndoRepo extends FakeRepo {
  final calls = <String>[];

  @override
  Future<RemovedFromWall> removeMemory(String id) async {
    calls.add('remove $id');
    final current = state.requireValue;
    state = AsyncData(
      MemoryState(
        events: current.events.where((e) => e.id != id).toList(),
        connections: current.connections,
        photos: current.photos,
        people: current.people,
        wallItems: current.wallItems,
      ),
    );
    return const RemovedFromWall.empty();
  }

  @override
  Future<void> restore(RemovedFromWall removed) async => calls.add('restore');

  @override
  Future<void> forget(RemovedFromWall removed) async => calls.add('forget');
}

void main() {
  testWidgets('a deleted memory shows "Memory deleted." with Undo', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = _UndoRepo();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [memoryRepositoryProvider.overrideWith(() => repo)],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MemoryWallPage(),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    await tester.longPress(find.text('Card A').first);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.tap(find.text('Delete'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(repo.calls, ['remove A']);
    expect(find.text('Memory deleted.'), findsOneWidget);
    // Screen readers announce the message (not just the buttons).
    final handle = tester.ensureSemantics();
    expect(find.bySemanticsLabel(RegExp('Memory deleted')), findsWidgets);
    handle.dispose();
    await tester.tap(find.text('Undo'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(repo.calls, ['remove A', 'restore']);
  });
}
