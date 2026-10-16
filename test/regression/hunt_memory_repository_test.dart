// Regression tests from the 2026-10-16 whole-codebase bug hunt: memory repository.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/database/database_provider.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Directory docs;

ProviderContainer _container() {
  final c = ProviderContainer();
  c.listen(memoryRepositoryProvider, (_, _) {});
  return c;
}

NewMemoryDraft _draft(String title, {String? wallId}) => NewMemoryDraft(
  title: title,
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2025, 1, 1),
  locationLabel: '',
  wallId: wallId,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    docs = await Directory.systemTemp.createTemp('m1_docs_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
  });
  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  test('M1-01 moving a note keeps the list of personal walls', () async {
    SharedPreferences.setMockInitialValues({});
    final c = _container();
    addTearDown(c.dispose);
    final repo = c.read(memoryRepositoryProvider.notifier);
    await c.read(memoryRepositoryProvider.future);
    final travel = await repo.createWall('Travel');
    await repo.addTextNote(text: 'hi', position: Offset.zero, wallId: travel);
    final noteId = c.read(memoryRepositoryProvider).value!.wallItems.single.id;

    await repo.moveWallItem(noteId, const Offset(50, 50));

    expect(
      c.read(memoryRepositoryProvider).value!.walls,
      hasLength(1),
      reason: 'walls vanish from state after dragging a note',
    );
  });

  test('M1-02 a removed demo cover stays removed after relaunch', () async {
    SharedPreferences.setMockInitialValues({'demo_wall_enabled': true});
    var c = _container();
    final seeded = await c.read(memoryRepositoryProvider.future);
    final demo = seeded.events.firstWhere(
      (e) => e.coverPhotoPath != null && e.coverPhotoPath!.isNotEmpty,
    );
    await c
        .read(memoryRepositoryProvider.notifier)
        .updateMemory(
          id: demo.id,
          title: demo.title,
          description: demo.description,
          category: demo.category,
          memoryType: demo.memoryType,
          feeling: demo.feeling,
          occurredAt: demo.occurredAt,
          locationLabel: demo.locationLabel,
          coverPhotoPath: null,
        );
    expect(
      c
          .read(memoryRepositoryProvider)
          .value!
          .findEvent(demo.id)!
          .coverPhotoPath,
      isNull,
    );
    c.dispose();

    c = _container();
    addTearDown(c.dispose);
    final relaunched = await c.read(memoryRepositoryProvider.future);
    expect(
      relaunched.findEvent(demo.id)!.coverPhotoPath,
      isNull,
      reason: 'cover the user removed came back',
    );
  });

  test(
    'M1-03 re-importing a backup leaves no unreferenced photo copies',
    () async {
      SharedPreferences.setMockInitialValues({});
      final c = _container();
      addTearDown(c.dispose);
      await c.read(memoryRepositoryProvider.future);
      final repo = c.read(memoryRepositoryProvider.notifier);
      final dir = Directory('${docs.path}/memory_photos')..createSync();
      BackupImportData backup(String copyName) {
        final f = File('${dir.path}/$copyName')..writeAsBytesSync([1, 2, 3]);
        return BackupImportData(
          events: const [
            {
              'id': 'e1',
              'title': 'Split',
              'occurredAt': 1000,
              'createdAt': 2000,
              'coverPhotoPath': 'photos/a.jpg',
            },
          ],
          photos: const [
            {
              'eventId': 'e1',
              'localPath': 'photos/a.jpg',
              'capturedAt': 1,
              'width': 1,
              'height': 1,
            },
          ],
          people: const [],
          connections: const [],
          wallItems: const [],
          photoPaths: {'photos/a.jpg': f.path},
        );
      }

      await repo.importBackup(backup('restore_1.jpg'));
      final second = await repo.importBackup(backup('restore_2.jpg'));
      expect(second.memoryCount, 0);
      expect(
        File('${dir.path}/restore_2.jpg').existsSync(),
        isFalse,
        reason:
            'copy for a skipped memory stays on disk, referenced by nothing',
      );
    },
  );

  test('M1-04 undo of a removed memory after its wall was deleted', () async {
    SharedPreferences.setMockInitialValues({});
    final c = _container();
    addTearDown(c.dispose);
    final repo = c.read(memoryRepositoryProvider.notifier);
    await c.read(memoryRepositoryProvider.future);
    final travel = await repo.createWall('Travel');
    await repo.addMemory(_draft('Split', wallId: travel));
    final id = c.read(memoryRepositoryProvider).value!.events.single.id;
    final removed = await repo.removeMemory(id);
    await repo.deleteWall(travel);
    await repo.restore(removed);
    final s = c.read(memoryRepositoryProvider).value!;
    expect(
      s.onWall(null).events.map((e) => e.id),
      contains(id),
      reason: 'restored memory points at a deleted wall and is on no wall',
    );
  });

  test('P1-04 regression: a drag during addMemory is persisted', () async {
    SharedPreferences.setMockInitialValues({});
    final c = _container();
    addTearDown(c.dispose);
    final repo = c.read(memoryRepositoryProvider.notifier);
    await c.read(memoryRepositoryProvider.future);
    await repo.addMemory(_draft('A'));
    final id = c.read(memoryRepositoryProvider).value!.events.single.id;
    final adding = repo.addMemory(_draft('B'));
    final moving = repo.moveMemory(id, const Offset(999, 777));
    await Future.wait([adding, moving]);
    final a = c.read(memoryRepositoryProvider).value!.findEvent(id)!;
    expect(a.wallPosition, const Offset(999, 777));
    final row =
        await (c
                .read(appDatabaseProvider)
                .select(c.read(appDatabaseProvider).memoryEvents)
              ..where((r) => r.id.equals(id)))
            .getSingle();
    expect(row.wallX, 999);
    expect(MemorySeedData.eventIds, isNotEmpty);
  });
}
