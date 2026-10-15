import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/database/app_database.dart' as db;
import 'package:life_threads/core/database/database_provider.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/data/place_names.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Directory docs;

class _FakePlaces implements PlaceNameLookup {
  _FakePlaces(this.names);
  final Map<double, String> names;
  final asked = <double>[];

  @override
  Future<String?> nameFor(double latitude, double longitude, Locale locale) {
    asked.add(latitude);
    return Future.value(names[latitude]);
  }
}

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

/// Writes bare memories straight into the database, as an older version
/// would have left them, before the repository first loads.
Future<void> _insertEvents(Iterable<String> ids) async {
  final container = ProviderContainer();
  final database = container.read(appDatabaseProvider);
  for (final id in ids) {
    await database
        .into(database.memoryEvents)
        .insert(
          db.MemoryEventsCompanion.insert(
            id: id,
            title: id,
            description: '',
            occurredAt: 0,
            createdAt: 0,
            coverColorValue: 0,
            wallX: 0,
            wallY: 0,
            rotation: 0,
            locationLabel: '',
          ),
        );
  }
  container.dispose();
}

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

  test('the demo wall is the one from the store screenshots', () async {
    SharedPreferences.setMockInitialValues({'demo_wall_enabled': true});
    final container = _container();
    addTearDown(container.dispose);
    final seeded = await container.read(memoryRepositoryProvider.future);

    expect(seeded.isDemoOnly, isTrue);
    expect(seeded.events, hasLength(9));
    expect(seeded.connections, hasLength(7));
    expect(seeded.people, hasLength(7));
    for (final event in seeded.events) {
      expect(event.coverPhotoPath, startsWith('assets/demo_moments/'));
      expect(File(event.coverPhotoPath!).existsSync(), isTrue);
    }
  });

  test('an install still showing the old demo wall gets the new one', () async {
    SharedPreferences.setMockInitialValues({});
    await _insertEvents(MemorySeedData.legacyEventIds);
    final container = _container();
    addTearDown(container.dispose);

    final state = await container.read(memoryRepositoryProvider.future);
    expect(
      state.events.map((event) => event.id).toSet(),
      MemorySeedData.eventIds,
    );

    await container.read(memoryRepositoryProvider.notifier).clearDemoWall();
    expect(container.read(memoryRepositoryProvider).value!.events, isEmpty);
  });

  test('the old demo wall stays when the user added a memory', () async {
    SharedPreferences.setMockInitialValues({});
    await _insertEvents([MemorySeedData.legacyEventIds.first, 'mine']);
    final container = _container();
    addTearDown(container.dispose);

    final state = await container.read(memoryRepositoryProvider.future);
    expect(state.events.map((event) => event.id).toSet(), {
      MemorySeedData.legacyEventIds.first,
      'mine',
    });
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

  test('importing a backup twice does not duplicate memories', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    const backup = BackupImportData(
      events: [
        {'id': 'e1', 'title': 'Split', 'occurredAt': 1000, 'createdAt': 2000},
        {'id': 'e2', 'title': 'Summit', 'occurredAt': 3000, 'createdAt': 4000},
      ],
      photos: [],
      people: [],
      connections: [
        {'fromEventId': 'e1', 'toEventId': 'e2', 'label': 'Same summer'},
      ],
      wallItems: [
        {'id': 'n1', 'type': 'text', 'content': 'Hello', 'createdAt': 5000},
      ],
      photoPaths: {},
    );
    final repository = container.read(memoryRepositoryProvider.notifier);

    final first = await repository.importBackup(backup);
    final second = await repository.importBackup(backup);

    final state = container.read(memoryRepositoryProvider).value!;
    expect(first.memoryCount, 2);
    expect(second.memoryCount, 0);
    expect(second.connectionCount, 0);
    expect(
      state.events.map((e) => e.title),
      unorderedEquals(['Split', 'Summit']),
    );
    expect(state.connections, hasLength(1));
    expect(state.wallItems, hasLength(1));
  });

  test('restoring a backup of this wall skips memories still on it', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    final repository = container.read(memoryRepositoryProvider.notifier);
    await repository.importBackup(
      const BackupImportData(
        events: [
          {'id': 'e1', 'title': 'Split', 'occurredAt': 1000, 'createdAt': 2000},
        ],
        photos: [],
        people: [],
        connections: [],
        wallItems: [],
        photoPaths: {},
      ),
    );
    final existingId = container
        .read(memoryRepositoryProvider)
        .value!
        .events
        .single
        .id;

    // A backup made from this wall carries the wall's own ids.
    final result = await repository.importBackup(
      BackupImportData(
        events: [
          {'id': existingId, 'title': 'Split (renamed)', 'occurredAt': 1000},
          {'id': 'other', 'title': 'New one', 'occurredAt': 9000},
        ],
        photos: const [],
        people: const [],
        connections: const [],
        wallItems: const [],
        photoPaths: const {},
      ),
    );

    final titles = container
        .read(memoryRepositoryProvider)
        .value!
        .events
        .map((e) => e.title);
    expect(result.memoryCount, 1);
    expect(titles, unorderedEquals(['Split', 'New one']));
  });

  test('places saved as coordinates get their names later', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    final repository = container.read(memoryRepositoryProvider.notifier);
    await container.read(memoryRepositoryProvider.future);
    await repository.clearDemoWall();
    NewMemoryDraft located(String title, double lat, String label) =>
        NewMemoryDraft(
          title: title,
          description: '',
          category: MemoryCategory.travel,
          memoryType: MemoryType.moment,
          feeling: MemoryFeeling.warm,
          occurredAt: DateTime(2025, 7, 1),
          locationLabel: label,
          latitude: lat,
          longitude: 16.44032,
        );
    await repository.addMemory(located('Split', 43.5081, '43.50810, 16.44032'));
    await repository.addMemory(located('Named', 44.0, 'Grandma\'s house'));
    await repository.addMemory(located('Offline', 45.0, '45.00000, 16.44032'));

    final places = _FakePlaces({43.5081: 'Split, Croatia'});
    await repository.nameCoordinatePlaces(places, const Locale('en'));

    String place(String title) => container
        .read(memoryRepositoryProvider)
        .requireValue
        .events
        .firstWhere((e) => e.title == title)
        .locationLabel;
    expect(place('Split'), 'Split, Croatia');
    // A name the user gave is never replaced.
    expect(place('Named'), "Grandma's house");
    expect(places.asked, isNot(contains(44.0)));
    // No name found (offline): the coordinates stay for the next try.
    expect(place('Offline'), '45.00000, 16.44032');

    // Saved in the database, not only in memory.
    container.dispose();
    final reloaded = ProviderContainer();
    final events = (await reloaded.read(
      memoryRepositoryProvider.future,
    )).events;
    expect(
      events.firstWhere((e) => e.title == 'Split').locationLabel,
      'Split, Croatia',
    );
    reloaded.dispose();
  });

  test('the demo wall speaks the app language, also after a change', () async {
    SharedPreferences.setMockInitialValues({
      'demo_wall_enabled': true,
      'selected_locale_code': 'de',
    });
    final de = lookupAppLocalizations(const Locale('de'));
    final en = lookupAppLocalizations(const Locale('en'));
    final container = _container();
    addTearDown(container.dispose);
    final repository = container.read(memoryRepositoryProvider.notifier);
    final seeded = await container.read(memoryRepositoryProvider.future);
    expect(seeded.findEvent('demo-newborn')!.title, de.demoNewbornTitle);

    // The user renames one demo memory, then switches to English.
    final dance = seeded.findEvent('demo-first-dance')!;
    await repository.updateMemory(
      id: dance.id,
      title: 'Unser Tanz',
      description: dance.description,
      category: dance.category,
      memoryType: dance.memoryType,
      feeling: dance.feeling,
      occurredAt: dance.occurredAt,
      locationLabel: dance.locationLabel,
    );
    await repository.localizeDemoWall(const Locale('en'));

    final state = container.read(memoryRepositoryProvider).requireValue;
    expect(state.findEvent('demo-newborn')!.title, en.demoNewbornTitle);
    expect(state.findEvent('demo-first-dance')!.title, 'Unser Tanz');
    expect(
      state.findEvent('demo-first-dance')!.description,
      en.demoFirstDanceStory,
    );
    expect(
      state.connections.map((c) => c.label),
      contains(en.demoThreadFirstDanceToFirstHome),
    );
    expect(
      state.people.map((p) => p.relationship),
      contains(en.demoRelationGrandpa),
    );
  });

  test('a removed memory comes back whole with Undo', () async {
    SharedPreferences.setMockInitialValues({});
    final photosDir = Directory('${docs.path}/memory_photos')..createSync();
    final file = File('${photosDir.path}/p.jpg')..writeAsBytesSync([1, 2, 3]);
    final container = _container();
    addTearDown(container.dispose);
    await container.read(memoryRepositoryProvider.future);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await repo.addMemory(_draft('Other', photos: const []));
    final otherId = container
        .read(memoryRepositoryProvider)
        .value!
        .events
        .single
        .id;
    await repo.addMemory(
      NewMemoryDraft(
        title: 'With photo',
        description: '',
        category: MemoryCategory.personal,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime(2025, 1, 1),
        locationLabel: '',
        photos: [_photo(file.path)],
        coverPhotoPath: file.path,
        connectedEventId: otherId,
        people: const [MemoryPersonDraft(name: 'Kate', relationship: 'Sister')],
      ),
    );
    MemoryState current() => container.read(memoryRepositoryProvider).value!;
    final id = current().events.firstWhere((e) => e.title == 'With photo').id;

    final removed = await repo.removeMemory(id);
    expect(current().findEvent(id), isNull);
    expect(current().connections, isEmpty);
    // Still on disk while it can be undone.
    expect(file.existsSync(), isTrue);

    await repo.restore(removed);
    expect(current().findEvent(id)?.title, 'With photo');
    expect(current().photosForEvent(id), hasLength(1));
    expect(current().peopleForEvent(id).single.name, 'Kate');
    expect(current().connections, hasLength(1));

    // Not undone: the photo file goes once the undo window has passed.
    await repo.forget(await repo.removeMemory(id));
    expect(file.existsSync(), isFalse);
  });

  test('walls: create, move a memory, hide it, delete the wall', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await container.read(memoryRepositoryProvider.future);
    MemoryState current() => container.read(memoryRepositoryProvider).value!;

    final travel = await repo.createWall('Travel 2025');
    expect(current().walls.single.name, 'Travel 2025');
    await repo.addMemory(_draft('At home'));
    await repo.addMemory(
      NewMemoryDraft(
        title: 'Split',
        description: '',
        category: MemoryCategory.travel,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime(2025, 7, 1),
        locationLabel: '',
        wallId: travel,
      ),
    );
    String id(String title) =>
        current().events.firstWhere((e) => e.title == title).id;

    expect(current().onWall(null).events.map((e) => e.title), ['At home']);
    expect(current().onWall(travel).events.map((e) => e.title), ['Split']);

    await repo.moveMemoryToWall(id('At home'), travel);
    expect(current().onWall(null).events, isEmpty);
    expect(current().onWall(travel).events, hasLength(2));

    // Hidden: off the wall and out of search etc., unless asked for.
    await repo.setHidden(id('Split'), hidden: true);
    expect(current().onWall(travel).events.map((e) => e.title), ['At home']);
    expect(current().onWall(travel, includeHidden: true).events, hasLength(2));
    expect(current().visibleEvents.map((e) => e.title), ['At home']);

    // Deleting the wall moves everything back to My wall.
    await repo.deleteWall(travel);
    expect(current().walls, isEmpty);
    expect(current().onWall(null, includeHidden: true).events, hasLength(2));
  });

  test('a backup keeps walls and hidden memories', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _container();
    addTearDown(container.dispose);
    final repo = container.read(memoryRepositoryProvider.notifier);
    await container.read(memoryRepositoryProvider.future);

    final result = await repo.importBackup(
      const BackupImportData(
        walls: [
          {'id': 'w1', 'name': 'Our kids', 'createdAt': 1},
        ],
        events: [
          {
            'id': 'e1',
            'title': 'First steps',
            'occurredAt': 1000,
            'createdAt': 1000,
            'wallId': 'w1',
            'hidden': true,
          },
        ],
        photos: [],
        people: [],
        connections: [],
        wallItems: [],
        photoPaths: {},
      ),
    );
    expect(result.memoryCount, 1);
    final state = container.read(memoryRepositoryProvider).value!;
    expect(state.walls.single.name, 'Our kids');
    final event = state.events.single;
    expect(event.wallId, state.walls.single.id);
    expect(event.hidden, isTrue);
  });
}
