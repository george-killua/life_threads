import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Directory docs;

ProviderContainer _container() {
  final container = ProviderContainer();
  container.listen(memoryRepositoryProvider, (_, _) {});
  return container;
}

NewMemoryDraft _draft(
  String title, {
  List<MemoryPhotoDraft> photos = const [],
  String? coverPhotoPath,
}) => NewMemoryDraft(
  title: title,
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2025, 1, 1),
  locationLabel: '',
  photos: photos,
  coverPhotoPath: coverPhotoPath,
);

MemoryPhotoDraft _photo(String path) => MemoryPhotoDraft(
  localPath: path,
  capturedAt: DateTime(2025),
  width: 1,
  height: 1,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('repo_docs_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
  });

  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  test('fast connect toggles never leave a duplicate pair behind', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await repo.addMemory(_draft('A'));
    await repo.addMemory(_draft('B'));
    final events = container.read(memoryRepositoryProvider).value!.events;
    final a = events[0].id;
    final b = events[1].id;

    await Future.wait([
      repo.setConnection(fromId: a, toId: b, isConnected: true),
      repo.setConnection(fromId: a, toId: b, isConnected: false),
      repo.setConnection(fromId: a, toId: b, isConnected: true),
    ]);
    expect(container.read(memoryRepositoryProvider).value!.connections, [
      isA<Object>(),
    ]);

    await repo.setConnection(fromId: b, toId: a, isConnected: false);
    expect(
      container.read(memoryRepositoryProvider).value!.connections,
      isEmpty,
    );
  });

  test('a memory cannot be connected to itself', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await repo.addMemory(_draft('A'));
    final id = container.read(memoryRepositoryProvider).value!.events.single.id;

    await repo.setConnection(fromId: id, toId: id, isConnected: true);
    expect(
      container.read(memoryRepositoryProvider).value!.connections,
      isEmpty,
    );
  });

  test('deleting a memory removes its photo files', () async {
    SharedPreferences.setMockInitialValues({});
    final photosDir = Directory('${docs.path}/memory_photos')..createSync();
    final file = File('${photosDir.path}/p.jpg')..writeAsBytesSync([1, 2, 3]);
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await repo.addMemory(
      _draft(
        'With photo',
        photos: [_photo(file.path)],
        coverPhotoPath: file.path,
      ),
    );
    final id = container.read(memoryRepositoryProvider).value!.events.single.id;

    await repo.deleteMemory(id);

    expect(file.existsSync(), isFalse);
  });

  test('deleting a memory keeps files another memory still uses', () async {
    SharedPreferences.setMockInitialValues({});
    final photosDir = Directory('${docs.path}/memory_photos')..createSync();
    final file = File('${photosDir.path}/shared.jpg')..writeAsBytesSync([1]);
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await repo.addMemory(_draft('A', photos: [_photo(file.path)]));
    await repo.addMemory(_draft('B', photos: [_photo(file.path)]));
    final first = container.read(memoryRepositoryProvider).value!.events.first;

    await repo.deleteMemory(first.id);

    expect(file.existsSync(), isTrue);
  });

  test('deleted demo memories do not come back on the next launch', () async {
    SharedPreferences.setMockInitialValues({'demo_wall_enabled': true});
    var container = _container();
    final seeded = await container.read(memoryRepositoryProvider.future);
    expect(seeded.events.length, MemorySeedData.eventIds.length);
    final repo = container.read(memoryRepositoryProvider.notifier);
    for (final id in MemorySeedData.eventIds) {
      await repo.deleteMemory(id);
    }
    container.dispose();

    container = _container();
    addTearDown(container.dispose);
    final relaunched = await container.read(memoryRepositoryProvider.future);
    expect(relaunched.events, isEmpty);
  });

  test('clearing all data also removes the name and cloud sync key', () async {
    SharedPreferences.setMockInitialValues({
      'user_display_name': 'Sam',
      'lifethreads.cloud_sync_key': 'lt_${'a' * 32}_${'b' * 32}',
    });
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);

    await container.read(memoryRepositoryProvider.notifier).clearAllData();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('user_display_name'), isNull);
    expect(preferences.getString('lifethreads.cloud_sync_key'), isNull);
  });

  test('restoring onto an empty wall keeps saved positions', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);

    await container
        .read(memoryRepositoryProvider.notifier)
        .importBackup(
          const BackupImportData(
            events: [
              {'id': 'e1', 'title': 'Saved', 'wallX': 300.0, 'wallY': 400.0},
            ],
            photos: [],
            people: [],
            connections: [],
            wallItems: [],
            photoPaths: {},
          ),
        );

    final event = container.read(memoryRepositoryProvider).value!.events.single;
    expect(event.wallPosition, const Offset(300, 400));
  });

  test('imported NaN coordinates are dropped', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);

    await container
        .read(memoryRepositoryProvider.notifier)
        .importBackup(
          const BackupImportData(
            events: [
              {
                'id': 'e1',
                'title': 'Corrupt',
                'latitude': 'NaN',
                'longitude': 'Infinity',
              },
            ],
            photos: [],
            people: [],
            connections: [],
            wallItems: [],
            photoPaths: {},
          ),
        );

    final event = container.read(memoryRepositoryProvider).value!.events.single;
    expect(event.latitude, isNull);
    expect(event.longitude, isNull);
    expect(event.hasGeoPoint, isFalse);
  });
}
