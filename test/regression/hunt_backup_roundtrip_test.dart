// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// backup export/restore round trip (real BackupService + repository).
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/data/backup_service.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

late Directory docs;

NewMemoryDraft _draft(
  String title, {
  List<MemoryPhotoDraft> photos = const [],
  String label = '',
}) => NewMemoryDraft(
  title: title,
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2025, 1, 1),
  locationLabel: label,
  photos: photos,
);

Future<(ProviderContainer, MemoryRepository)> _repo() async {
  SharedPreferences.setMockInitialValues({});
  final container = ProviderContainer();
  container.listen(memoryRepositoryProvider, (_, _) {});
  await container.read(memoryRepositoryProvider.future);
  return (container, container.read(memoryRepositoryProvider.notifier));
}

List<String> _restoreFiles() {
  final dir = Directory(p.join(docs.path, 'memory_photos'));
  if (!dir.existsSync()) return [];
  return dir
      .listSync()
      .map((f) => p.basename(f.path))
      .where((n) => n.startsWith('restore_'))
      .toList();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('c1_docs_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
  });
  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  test('C1-01 restoring a backup onto the same wall leaves no orphan photo '
      'files', () async {
    final (container, repo) = await _repo();
    addTearDown(container.dispose);
    final src = File(p.join(docs.path, 'src.jpg'))..writeAsBytesSync([1, 2, 3]);
    await repo.addMemory(
      _draft(
        'A',
        photos: [
          MemoryPhotoDraft(
            localPath: src.path,
            capturedAt: DateTime(2025),
            width: 1,
            height: 1,
          ),
        ],
      ),
    );
    final state = container.read(memoryRepositoryProvider).value!;
    final export = await const BackupService().exportBackup(state);
    final data = await const BackupService().prepareImportFile(export.path);
    final result = await repo.importBackup(data);
    expect(result.memoryCount, 0, reason: 'memory already on the wall');
    // Every restore_* file written by prepareImportFile should be referenced
    // or cleaned up; the skipped memory's photo is neither.
    final referenced = container
        .read(memoryRepositoryProvider)
        .value!
        .photos
        .map((ph) => p.basename(ph.localPath))
        .toSet();
    final orphans = _restoreFiles().where((n) => !referenced.contains(n));
    expect(orphans, isEmpty, reason: 'unreferenced restored photo files');
  });

  test('C1-02 restoring a deleted memory keeps its thread to a note that is '
      'still on the wall', () async {
    final (container, repo) = await _repo();
    addTearDown(container.dispose);
    await repo.addMemory(_draft('A'));
    await repo.addTextNote(text: 'Note', position: const Offset(10, 10));
    var state = container.read(memoryRepositoryProvider).value!;
    final a = state.events.single.id;
    final n = state.wallItems.single.id;
    await repo.setConnection(fromId: a, toId: n, isConnected: true);
    state = container.read(memoryRepositoryProvider).value!;
    expect(state.connections, hasLength(1));
    final export = await const BackupService().exportBackup(state);

    await repo.deleteMemory(a);
    final data = await const BackupService().prepareImportFile(export.path);
    final result = await repo.importBackup(data);
    state = container.read(memoryRepositoryProvider).value!;
    expect(result.memoryCount, 1);
    expect(
      state.connections,
      hasLength(1),
      reason: 'thread A–note should come back with A',
    );
  });

  test('regression P2-01/P2-02/crypto', () async {
    final (container, repo) = await _repo();
    addTearDown(container.dispose);
    await repo.addMemory(_draft('A', label: "Grandma's house"));
    final state = container.read(memoryRepositoryProvider).value!;
    await expectLater(
      const BackupService().exportBackup(state, password: '   '),
      throwsA(isA<BackupValidationException>()),
    );
    final enc = await const BackupService().exportBackup(state, password: 'pw');
    expect(enc.isEncrypted, isTrue);
    await expectLater(
      const BackupService().prepareImportFile(enc.path, password: 'wrong'),
      throwsA(isA<BackupValidationException>()),
    );
    final data = await const BackupService().prepareImportFile(
      enc.path,
      password: 'pw',
    );
    expect(data.events.single['locationLabel'], "Grandma's house");
  });
}
