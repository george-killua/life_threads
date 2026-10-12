import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../../core/storage/app_storage_paths.dart';
import '../../backup/domain/backup_models.dart';
import '../../onboarding/onboarding_preferences.dart';
import '../../wall/domain/wall_item.dart';
import '../domain/memory_category.dart';
import '../domain/memory_connection.dart';
import '../domain/memory_event.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_photo.dart';
import '../domain/memory_person.dart' as person_model;
import '../domain/memory_type.dart';
import 'memory_seed_data.dart';

final memoryRepositoryProvider =
    AsyncNotifierProvider<MemoryRepository, MemoryState>(MemoryRepository.new);

class MemoryState {
  const MemoryState({
    required this.events,
    required this.connections,
    required this.photos,
    required this.people,
    required this.wallItems,
  });

  final List<MemoryEvent> events;
  final List<MemoryConnection> connections;
  final List<MemoryPhoto> photos;
  final List<person_model.MemoryPerson> people;
  final List<WallItem> wallItems;

  MemoryEvent? findEvent(String id) {
    for (final event in events) {
      if (event.id == id) return event;
    }
    return null;
  }

  List<MemoryPhoto> photosForEvent(String id) {
    return photos.where((photo) => photo.eventId == id).toList();
  }

  List<person_model.MemoryPerson> peopleForEvent(String id) {
    return people.where((person) => person.eventId == id).toList();
  }

  List<WallItem> attachedTextNotes(String id) {
    final noteIds = connections
        .where(
          (connection) =>
              connection.fromEventId == id || connection.toEventId == id,
        )
        .map(
          (connection) => connection.fromEventId == id
              ? connection.toEventId
              : connection.fromEventId,
        )
        .toSet();

    final notes =
        wallItems
            .where(
              (item) =>
                  item.type == WallItemType.text && noteIds.contains(item.id),
            )
            .toList()
          ..sort(
            (first, second) => first.createdAt.compareTo(second.createdAt),
          );
    return notes;
  }

  List<MemoryEvent> connectedEvents(String id) {
    final connectedIds = connections
        .where(
          (connection) =>
              connection.fromEventId == id || connection.toEventId == id,
        )
        .map(
          (connection) => connection.fromEventId == id
              ? connection.toEventId
              : connection.fromEventId,
        )
        .toSet();

    return events.where((event) => connectedIds.contains(event.id)).toList();
  }

  bool hasConnection(String firstId, String secondId) {
    return connections.any(
      (connection) =>
          (connection.fromEventId == firstId &&
              connection.toEventId == secondId) ||
          (connection.fromEventId == secondId &&
              connection.toEventId == firstId),
    );
  }

  MemoryConnection? connectionBetween(String firstId, String secondId) {
    for (final connection in connections) {
      final matches =
          (connection.fromEventId == firstId &&
              connection.toEventId == secondId) ||
          (connection.fromEventId == secondId &&
              connection.toEventId == firstId);
      if (matches) return connection;
    }
    return null;
  }

  bool get hasDemoWall {
    return events.any((event) => MemorySeedData.isDemoEventId(event.id));
  }

  bool get isDemoOnly {
    return events.isNotEmpty &&
        wallItems.isEmpty &&
        events.every((event) => MemorySeedData.isDemoEventId(event.id));
  }
}

class NewMemoryDraft {
  const NewMemoryDraft({
    required this.title,
    required this.description,
    required this.category,
    required this.memoryType,
    required this.feeling,
    required this.occurredAt,
    required this.locationLabel,
    this.latitude,
    this.longitude,
    this.coverPhotoPath,
    this.connectedEventId,
    this.connectionReason,
    this.wallPosition,
    this.photos = const [],
    this.people = const [],
  });

  final String title;
  final String description;
  final MemoryCategory category;
  final MemoryType memoryType;
  final MemoryFeeling feeling;
  final DateTime occurredAt;
  final String locationLabel;
  final double? latitude;
  final double? longitude;
  final String? coverPhotoPath;
  final String? connectedEventId;
  final String? connectionReason;
  final Offset? wallPosition;
  final List<MemoryPhotoDraft> photos;
  final List<MemoryPersonDraft> people;
}

class MemoryPhotoDraft {
  const MemoryPhotoDraft({
    required this.localPath,
    required this.capturedAt,
    required this.width,
    required this.height,
    this.originalAssetId,
    this.latitude,
    this.longitude,
  });

  final String localPath;
  final String? originalAssetId;
  final DateTime capturedAt;
  final double? latitude;
  final double? longitude;
  final int width;
  final int height;
}

class MemoryPersonDraft {
  const MemoryPersonDraft({
    required this.name,
    required this.relationship,
    this.phone,
    this.email,
  });

  final String name;
  final String relationship;
  final String? phone;
  final String? email;
}

class MemoryRepository extends AsyncNotifier<MemoryState> {
  final _uuid = const Uuid();

  db.AppDatabase get _database => ref.read(appDatabaseProvider);

  @override
  Future<MemoryState> build() async {
    await _seedIfEmpty();
    await _replaceLegacyDemoWall();
    await _syncDemoAssetCovers();
    return _loadState();
  }

  Future<void> addMemory(NewMemoryDraft draft) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = await _loadState();
      final documentsPath = await AppStoragePaths.documentsPath();
      final index = current.events.length;
      final id = _uuid.v4();
      final event = MemoryEvent(
        id: id,
        title: draft.title,
        description: draft.description,
        category: draft.category,
        memoryType: draft.memoryType,
        feeling: draft.feeling,
        occurredAt: draft.occurredAt,
        createdAt: DateTime.now(),
        coverColor: _colors[index % _colors.length],
        wallPosition:
            draft.wallPosition ??
            Offset(150 + (index % 3) * 260, 180 + (index ~/ 3) * 210),
        rotation: index.isEven ? -0.035 : 0.04,
        locationLabel: draft.locationLabel,
        latitude: draft.latitude,
        longitude: draft.longitude,
        coverPhotoPath: draft.coverPhotoPath,
      );

      await _database.transaction(() async {
        await _database
            .into(_database.memoryEvents)
            .insert(_eventToCompanion(event, documentsPath: documentsPath));

        for (final photo in draft.photos) {
          await _database
              .into(_database.memoryPhotos)
              .insert(
                db.MemoryPhotosCompanion.insert(
                  id: _uuid.v4(),
                  eventId: id,
                  localPath: AppStoragePaths.persistPhotoPath(
                    photo.localPath,
                    documentsPath,
                  ),
                  originalAssetId: Value(photo.originalAssetId),
                  capturedAt: photo.capturedAt.millisecondsSinceEpoch,
                  latitude: Value(photo.latitude),
                  longitude: Value(photo.longitude),
                  width: photo.width,
                  height: photo.height,
                ),
              );
        }

        for (final person in draft.people) {
          await _database
              .into(_database.memoryPeople)
              .insert(_personDraftToCompanion(person, id));
        }

        final connectedEventId = draft.connectedEventId;
        if (connectedEventId != null && connectedEventId.isNotEmpty) {
          await _database
              .into(_database.memoryConnections)
              .insert(
                db.MemoryConnectionsCompanion.insert(
                  id: _uuid.v4(),
                  fromEventId: connectedEventId,
                  toEventId: id,
                  label: _cleanConnectionLabel(draft.connectionReason),
                ),
              );
        }
      });

      return _loadState();
    });
  }

  Future<void> updateMemory({
    required String id,
    required String title,
    required String description,
    required MemoryCategory category,
    required MemoryType memoryType,
    required MemoryFeeling feeling,
    required DateTime occurredAt,
    required String locationLabel,
    double? latitude,
    double? longitude,
    String? coverPhotoPath,
    List<MemoryPhotoDraft>? photos,
    List<MemoryPersonDraft>? people,
  }) async {
    final documentsPath = await AppStoragePaths.documentsPath();
    final replacedFiles = <String>{};
    await _database.transaction(() async {
      replacedFiles.addAll(
        await _storedPhotoPathsFor([id], includePhotos: photos != null),
      );
      await (_database.update(
        _database.memoryEvents,
      )..where((row) => row.id.equals(id))).write(
        db.MemoryEventsCompanion(
          title: Value(title),
          description: Value(description),
          category: Value(category.name),
          memoryType: Value(memoryType.name),
          feeling: Value(feeling.name),
          occurredAt: Value(occurredAt.millisecondsSinceEpoch),
          locationLabel: Value(locationLabel),
          latitude: Value(latitude),
          longitude: Value(longitude),
          coverPhotoPath: Value(
            AppStoragePaths.persistOptionalPhotoPath(
              coverPhotoPath,
              documentsPath,
            ),
          ),
        ),
      );

      if (photos != null) {
        await (_database.delete(
          _database.memoryPhotos,
        )..where((row) => row.eventId.equals(id))).go();

        for (final photo in photos) {
          await _database
              .into(_database.memoryPhotos)
              .insert(
                db.MemoryPhotosCompanion.insert(
                  id: _uuid.v4(),
                  eventId: id,
                  localPath: AppStoragePaths.persistPhotoPath(
                    photo.localPath,
                    documentsPath,
                  ),
                  originalAssetId: Value(photo.originalAssetId),
                  capturedAt: photo.capturedAt.millisecondsSinceEpoch,
                  latitude: Value(photo.latitude),
                  longitude: Value(photo.longitude),
                  width: photo.width,
                  height: photo.height,
                ),
              );
        }
      }

      if (people != null) {
        await (_database.delete(
          _database.memoryPeople,
        )..where((row) => row.eventId.equals(id))).go();

        for (final person in people) {
          await _database
              .into(_database.memoryPeople)
              .insert(_personDraftToCompanion(person, id));
        }
      }
    });
    await _deleteUnreferencedPhotoFiles(replacedFiles);
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> deleteMemory(String id) async {
    final removedFiles = <String>{};
    await _database.transaction(() async {
      removedFiles.addAll(await _storedPhotoPathsFor([id]));
      await (_database.delete(
        _database.memoryPhotos,
      )..where((row) => row.eventId.equals(id))).go();
      await (_database.delete(
        _database.memoryPeople,
      )..where((row) => row.eventId.equals(id))).go();
      await (_database.delete(_database.memoryConnections)..where(
            (row) => row.fromEventId.equals(id) | row.toEventId.equals(id),
          ))
          .go();
      await (_database.delete(
        _database.memoryEvents,
      )..where((row) => row.id.equals(id))).go();
    });
    await _deleteUnreferencedPhotoFiles(removedFiles);
    state = await AsyncValue.guard(_loadState);
  }

  /// Stored (DB-form) paths of the photo files and covers owned by [eventIds].
  Future<Set<String>> _storedPhotoPathsFor(
    List<String> eventIds, {
    bool includePhotos = true,
  }) async {
    final paths = <String>{};
    if (includePhotos) {
      final photos = await (_database.select(
        _database.memoryPhotos,
      )..where((row) => row.eventId.isIn(eventIds))).get();
      paths.addAll(photos.map((row) => row.localPath));
    }
    final events = await (_database.select(
      _database.memoryEvents,
    )..where((row) => row.id.isIn(eventIds))).get();
    for (final event in events) {
      final cover = event.coverPhotoPath;
      if (cover != null && cover.isNotEmpty) paths.add(cover);
    }
    return paths;
  }

  /// Deletes app-owned photo files that no memory references any more.
  /// Only files inside the app's memory_photos folder are ever touched.
  Future<void> _deleteUnreferencedPhotoFiles(Set<String> storedPaths) async {
    if (storedPaths.isEmpty) return;
    try {
      final documentsPath = await AppStoragePaths.documentsPath();
      final photosDir = p.normalize(
        p.join(documentsPath, AppStoragePaths.memoryPhotosDirectoryName),
      );

      final referenced = <String>{};
      for (final row in await _database.select(_database.memoryPhotos).get()) {
        referenced.add(
          AppStoragePaths.resolvePhotoPath(row.localPath, documentsPath),
        );
      }
      for (final row in await _database.select(_database.memoryEvents).get()) {
        final cover = AppStoragePaths.resolveOptionalPhotoPath(
          row.coverPhotoPath,
          documentsPath,
        );
        if (cover != null) referenced.add(cover);
      }

      for (final stored in storedPaths) {
        final resolved = p.normalize(
          AppStoragePaths.resolvePhotoPath(stored, documentsPath),
        );
        if (referenced.contains(resolved)) continue;
        if (!p.isWithin(photosDir, resolved)) continue;
        final file = File(resolved);
        if (await file.exists()) await file.delete();
      }
    } catch (_) {
      // Cleanup is best effort; the memory change itself already committed.
    }
  }

  Future<void> clearDemoWall() async {
    await _database.transaction(_deleteDemoRows);
    await ref.read(onboardingPreferencesProvider).disableDemoWall();
    state = await AsyncValue.guard(_loadState);
  }

  /// Deletes every demo memory (current and pre-0.1.9 demo wall) with its
  /// photos, people and threads.
  Future<void> _deleteDemoRows() async {
    final demoIds = {
      ...MemorySeedData.eventIds,
      ...MemorySeedData.legacyEventIds,
    };
    await (_database.delete(
      _database.memoryPhotos,
    )..where((row) => row.eventId.isIn(demoIds))).go();
    await (_database.delete(
      _database.memoryPeople,
    )..where((row) => row.eventId.isIn(demoIds))).go();
    await (_database.delete(_database.memoryConnections)..where(
          (row) => row.fromEventId.isIn(demoIds) | row.toEventId.isIn(demoIds),
        ))
        .go();
    await (_database.delete(
      _database.memoryEvents,
    )..where((row) => row.id.isIn(demoIds))).go();
  }

  Future<void> clearAllData() async {
    await _database.transaction(() async {
      await _database.delete(_database.memoryConnections).go();
      await _database.delete(_database.memoryPhotos).go();
      await _database.delete(_database.memoryPeople).go();
      await _database.delete(_database.wallItems).go();
      await _database.delete(_database.memoryEvents).go();
    });

    final photosDir = await AppStoragePaths.memoryPhotosDirectory();
    if (await photosDir.exists()) {
      await photosDir.delete(recursive: true);
    }

    // "All local data" includes the profile name, and the sync key older
    // versions kept for the removed Cloud Sync.
    final preferences = ref.read(onboardingPreferencesProvider);
    await preferences.disableDemoWall();
    await preferences.setDisplayName('');
    await (await SharedPreferences.getInstance()).remove(
      'lifethreads.cloud_sync_key',
    );
    ref.invalidate(userDisplayNameProvider);
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> setMemoryConnection({
    required String memoryId,
    required String otherMemoryId,
    required bool isConnected,
    String? label,
  }) async {
    await setConnection(
      fromId: memoryId,
      toId: otherMemoryId,
      isConnected: isConnected,
      label: label,
    );
  }

  Future<void> setConnection({
    required String fromId,
    required String toId,
    required bool isConnected,
    String? label,
  }) async {
    if (fromId == toId) return;

    // Check-and-write runs in one transaction; drift serialises transactions,
    // so fast repeated toggles can't both insert the same pair.
    await _database.transaction(() async {
      final matches =
          await (_database.select(_database.memoryConnections)..where(
                (row) =>
                    (row.fromEventId.equals(fromId) &
                        row.toEventId.equals(toId)) |
                    (row.fromEventId.equals(toId) &
                        row.toEventId.equals(fromId)),
              ))
              .get();
      final existing = matches.isEmpty ? null : matches.first;

      // Heal duplicate pairs left behind by older builds.
      for (final duplicate in matches.skip(1)) {
        await (_database.delete(
          _database.memoryConnections,
        )..where((row) => row.id.equals(duplicate.id))).go();
      }

      if (isConnected && existing == null) {
        await _database
            .into(_database.memoryConnections)
            .insert(
              db.MemoryConnectionsCompanion.insert(
                id: _uuid.v4(),
                fromEventId: fromId,
                toEventId: toId,
                label: _cleanConnectionLabel(label),
              ),
            );
      } else if (isConnected && existing != null && label != null) {
        await (_database.update(
          _database.memoryConnections,
        )..where((row) => row.id.equals(existing.id))).write(
          db.MemoryConnectionsCompanion(
            label: Value(_cleanConnectionLabel(label)),
          ),
        );
      } else if (!isConnected && existing != null) {
        await (_database.delete(
          _database.memoryConnections,
        )..where((row) => row.id.equals(existing.id))).go();
      }
    });

    state = await AsyncValue.guard(_loadState);
  }

  Future<void> updateConnectionLabel(String connectionId, String label) async {
    await (_database.update(
      _database.memoryConnections,
    )..where((row) => row.id.equals(connectionId))).write(
      db.MemoryConnectionsCompanion(label: Value(_cleanConnectionLabel(label))),
    );
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> addTextNote({
    required String text,
    required Offset position,
  }) async {
    final now = DateTime.now();
    await _database
        .into(_database.wallItems)
        .insert(
          db.WallItemsCompanion.insert(
            id: _uuid.v4(),
            type: WallItemType.text.name,
            content: text.trim(),
            createdAt: now.millisecondsSinceEpoch,
            wallX: position.dx,
            wallY: position.dy,
            colorValue: AppColors.cardDark.toARGB32(),
          ),
        );
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> addNail({required Offset position}) async {
    final now = DateTime.now();
    await _database
        .into(_database.wallItems)
        .insert(
          db.WallItemsCompanion.insert(
            id: _uuid.v4(),
            type: WallItemType.nail.name,
            content: 'Rope anchor',
            createdAt: now.millisecondsSinceEpoch,
            wallX: position.dx,
            wallY: position.dy,
            colorValue: AppColors.gold.toARGB32(),
          ),
        );
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> updateTextNote({
    required String id,
    required String text,
  }) async {
    await (_database.update(_database.wallItems)
          ..where((row) => row.id.equals(id)))
        .write(db.WallItemsCompanion(content: Value(text.trim())));
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> attachTextNoteToMemory({
    required String textNoteId,
    required String? memoryId,
    required Offset position,
  }) async {
    await _database.transaction(() async {
      final note =
          await (_database.select(_database.wallItems)..where(
                (row) =>
                    row.id.equals(textNoteId) &
                    row.type.equals(WallItemType.text.name),
              ))
              .getSingleOrNull();
      if (note == null) return;

      final targetMemory = memoryId == null
          ? null
          : await (_database.select(
              _database.memoryEvents,
            )..where((row) => row.id.equals(memoryId))).getSingleOrNull();
      if (memoryId != null && targetMemory == null) return;

      await (_database.delete(_database.memoryConnections)..where(
            (row) =>
                row.fromEventId.equals(textNoteId) |
                row.toEventId.equals(textNoteId),
          ))
          .go();

      await (_database.update(
        _database.wallItems,
      )..where((row) => row.id.equals(textNoteId))).write(
        db.WallItemsCompanion(
          wallX: Value(position.dx),
          wallY: Value(position.dy),
        ),
      );

      if (memoryId != null) {
        await _database
            .into(_database.memoryConnections)
            .insert(
              db.MemoryConnectionsCompanion.insert(
                id: _uuid.v4(),
                fromEventId: textNoteId,
                toEventId: memoryId,
                label: '',
              ),
            );
      }
    });
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> deleteWallItem(String id) async {
    await _database.transaction(() async {
      await (_database.delete(_database.memoryConnections)..where(
            (row) => row.fromEventId.equals(id) | row.toEventId.equals(id),
          ))
          .go();
      await (_database.delete(
        _database.wallItems,
      )..where((row) => row.id.equals(id))).go();
    });
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> moveMemory(String id, Offset position) async {
    // `value` keeps the previous data while another write is loading, so a
    // drag that ends during addMemory is still applied and persisted.
    final current = state.value;
    if (current != null) {
      final updatedEvents = [
        for (final event in current.events)
          if (event.id == id) event.copyWith(wallPosition: position) else event,
      ];
      state = AsyncData(
        MemoryState(
          events: updatedEvents,
          connections: current.connections,
          photos: current.photos,
          people: current.people,
          wallItems: current.wallItems,
        ),
      );
    }

    await (_database.update(
      _database.memoryEvents,
    )..where((row) => row.id.equals(id))).write(
      db.MemoryEventsCompanion(
        wallX: Value(position.dx),
        wallY: Value(position.dy),
      ),
    );
  }

  Future<void> moveWallItem(String id, Offset position) async {
    final current = state.value;
    if (current != null) {
      final updatedItems = [
        for (final item in current.wallItems)
          if (item.id == id) item.copyWith(wallPosition: position) else item,
      ];
      state = AsyncData(
        MemoryState(
          events: current.events,
          connections: current.connections,
          photos: current.photos,
          people: current.people,
          wallItems: updatedItems,
        ),
      );
    }

    await (_database.update(
      _database.wallItems,
    )..where((row) => row.id.equals(id))).write(
      db.WallItemsCompanion(
        wallX: Value(position.dx),
        wallY: Value(position.dy),
      ),
    );
  }

  Future<BackupImportResult> importBackup(BackupImportData backup) async {
    final documentsPath = await AppStoragePaths.documentsPath();
    final idMap = <String, String>{};
    var eventCount = 0;
    var photoCount = 0;
    var personCount = 0;
    var wallItemCount = 0;
    var connectionCount = 0;
    final importedPairs = <String>{};

    try {
      await _database.transaction(() async {
        // Restoring onto an empty wall keeps the saved arrangement; importing
        // next to existing memories nudges the imports so they don't overlap.
        final wallIsEmpty =
            (await _database.select(_database.memoryEvents).get()).isEmpty &&
            (await _database.select(_database.wallItems).get()).isEmpty;

        for (final event in backup.events) {
          final sourceId = _stringValue(event, 'id');
          final newId = _uuid.v4();
          final offset = wallIsEmpty ? 0.0 : 52.0 + eventCount * 8.0;
          final coverPhotoPath = _nullableString(event, 'coverPhotoPath');
          idMap[sourceId] = newId;

          await _database
              .into(_database.memoryEvents)
              .insert(
                db.MemoryEventsCompanion.insert(
                  id: newId,
                  title: _stringValue(
                    event,
                    'title',
                    fallback: 'Restored memory',
                  ),
                  description: _stringValue(event, 'description'),
                  category: Value(
                    _stringValue(event, 'category', fallback: 'personal'),
                  ),
                  memoryType: Value(
                    _stringValue(event, 'memoryType', fallback: 'moment'),
                  ),
                  feeling: Value(
                    _stringValue(event, 'feeling', fallback: 'warm'),
                  ),
                  occurredAt: _intValue(
                    event,
                    'occurredAt',
                    fallback: DateTime.now().millisecondsSinceEpoch,
                  ),
                  createdAt: _intValue(
                    event,
                    'createdAt',
                    fallback: DateTime.now().millisecondsSinceEpoch,
                  ),
                  coverColorValue: _intValue(
                    event,
                    'coverColorValue',
                    fallback: AppColors.gold.toARGB32(),
                  ),
                  wallX: _doubleValue(event, 'wallX', fallback: 180) + offset,
                  wallY: _doubleValue(event, 'wallY', fallback: 220) + offset,
                  rotation: _doubleValue(event, 'rotation'),
                  locationLabel: _stringValue(
                    event,
                    'locationLabel',
                    fallback: '',
                  ),
                  latitude: Value(_nullableDouble(event, 'latitude')),
                  longitude: Value(_nullableDouble(event, 'longitude')),
                  coverPhotoPath: Value(
                    coverPhotoPath == null
                        ? null
                        : AppStoragePaths.persistOptionalPhotoPath(
                            backup.photoPaths[coverPhotoPath],
                            documentsPath,
                          ),
                  ),
                ),
              );
          eventCount++;
        }

        for (final item in backup.wallItems) {
          final sourceId = _stringValue(item, 'id');
          final newId = _uuid.v4();
          final offset = wallIsEmpty ? 0.0 : 52.0 + wallItemCount * 6.0;
          idMap[sourceId] = newId;

          await _database
              .into(_database.wallItems)
              .insert(
                db.WallItemsCompanion.insert(
                  id: newId,
                  type: _stringValue(
                    item,
                    'type',
                    fallback: WallItemType.text.name,
                  ),
                  content: _stringValue(item, 'content'),
                  createdAt: _intValue(
                    item,
                    'createdAt',
                    fallback: DateTime.now().millisecondsSinceEpoch,
                  ),
                  wallX: _doubleValue(item, 'wallX', fallback: 220) + offset,
                  wallY: _doubleValue(item, 'wallY', fallback: 260) + offset,
                  colorValue: _intValue(
                    item,
                    'colorValue',
                    fallback: AppColors.cardDark.toARGB32(),
                  ),
                ),
              );
          wallItemCount++;
        }

        for (final photo in backup.photos) {
          final eventId = idMap[_stringValue(photo, 'eventId')];
          final archivePath = _stringValue(photo, 'localPath');
          final localPath = backup.photoPaths[archivePath];
          if (eventId == null || localPath == null) continue;

          await _database
              .into(_database.memoryPhotos)
              .insert(
                db.MemoryPhotosCompanion.insert(
                  id: _uuid.v4(),
                  eventId: eventId,
                  localPath: AppStoragePaths.persistPhotoPath(
                    localPath,
                    documentsPath,
                  ),
                  originalAssetId: Value(
                    _nullableString(photo, 'originalAssetId'),
                  ),
                  capturedAt: _intValue(
                    photo,
                    'capturedAt',
                    fallback: DateTime.now().millisecondsSinceEpoch,
                  ),
                  latitude: Value(_nullableDouble(photo, 'latitude')),
                  longitude: Value(_nullableDouble(photo, 'longitude')),
                  width: _intValue(photo, 'width'),
                  height: _intValue(photo, 'height'),
                ),
              );
          photoCount++;
        }

        for (final person in backup.people) {
          final eventId = idMap[_stringValue(person, 'eventId')];
          if (eventId == null) continue;

          await _database
              .into(_database.memoryPeople)
              .insert(
                db.MemoryPeopleCompanion.insert(
                  id: _uuid.v4(),
                  eventId: eventId,
                  name: _stringValue(person, 'name', fallback: 'Someone'),
                  relationship: _stringValue(
                    person,
                    'relationship',
                    fallback: 'person',
                  ),
                  phone: Value(_nullableString(person, 'phone')),
                  email: Value(_nullableString(person, 'email')),
                ),
              );
          personCount++;
        }

        for (final connection in backup.connections) {
          final fromId = idMap[_stringValue(connection, 'fromEventId')];
          final toId = idMap[_stringValue(connection, 'toEventId')];
          if (fromId == null || toId == null || fromId == toId) continue;
          final pairKey = ([fromId, toId]..sort()).join('|');
          if (!importedPairs.add(pairKey)) continue;

          await _database
              .into(_database.memoryConnections)
              .insert(
                db.MemoryConnectionsCompanion.insert(
                  id: _uuid.v4(),
                  fromEventId: fromId,
                  toEventId: toId,
                  label: _cleanConnectionLabel(
                    _nullableString(connection, 'label'),
                  ),
                ),
              );
          connectionCount++;
        }
      });
    } catch (_) {
      // The archive's photos were already written to disk; nothing references
      // them after the rolled-back import.
      for (final path in backup.photoPaths.values) {
        try {
          final file = File(path);
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
      rethrow;
    }

    state = await AsyncValue.guard(_loadState);
    return BackupImportResult(
      memoryCount: eventCount,
      photoCount: photoCount,
      personCount: personCount,
      wallItemCount: wallItemCount,
      connectionCount: connectionCount,
    );
  }

  Future<MemoryState> _loadState() async {
    final documentsPath = await AppStoragePaths.documentsPath();
    final eventRows = await _database.select(_database.memoryEvents).get();
    final connectionRows = await _database
        .select(_database.memoryConnections)
        .get();
    final photoRows = await _database.select(_database.memoryPhotos).get();
    final peopleRows = await _database.select(_database.memoryPeople).get();
    final wallItemRows = await _database.select(_database.wallItems).get();

    return MemoryState(
      events: eventRows
          .map((row) => _eventFromRow(row, documentsPath))
          .toList(),
      connections: connectionRows.map(_connectionFromRow).toList(),
      photos: photoRows
          .map((row) => _photoFromRow(row, documentsPath))
          .toList(),
      people: peopleRows.map(_personFromRow).toList(),
      wallItems: wallItemRows.map(_wallItemFromRow).toList(),
    );
  }

  Future<void> _seedIfEmpty() async {
    final existing = await _database.select(_database.memoryEvents).get();
    if (existing.isNotEmpty) return;
    final shouldUseDemoWall = await ref
        .read(onboardingPreferencesProvider)
        .shouldUseDemoWall();
    if (!shouldUseDemoWall) return;

    await _database.transaction(_insertDemoRows);
    // The demo wall is seeded once. Deleting the demo memories later must not
    // bring them back on the next launch.
    await ref.read(onboardingPreferencesProvider).disableDemoWall();
  }

  /// Installs that still show the pre-0.1.9 demo wall (nothing of their own
  /// added) get the current one, the wall from the store screenshots.
  Future<void> _replaceLegacyDemoWall() async {
    final events = await _database.select(_database.memoryEvents).get();
    if (events.isEmpty ||
        !events.every(
          (row) => MemorySeedData.legacyEventIds.contains(row.id),
        )) {
      return;
    }
    final wallItems = await _database.select(_database.wallItems).get();
    if (wallItems.isNotEmpty) return;
    await _database.transaction(() async {
      await _deleteDemoRows();
      await _insertDemoRows();
    });
  }

  Future<void> _insertDemoRows() async {
    final l10n = MemorySeedData.localizationsForLocale(
      WidgetsBinding.instance.platformDispatcher.locale,
    );
    for (final event in MemorySeedData.localizedEvents(l10n)) {
      await _database
          .into(_database.memoryEvents)
          .insert(_eventToCompanion(event));
    }
    for (final connection in MemorySeedData.localizedConnections(l10n)) {
      await _database
          .into(_database.memoryConnections)
          .insert(
            db.MemoryConnectionsCompanion.insert(
              id: connection.id,
              fromEventId: connection.fromEventId,
              toEventId: connection.toEventId,
              label: connection.label,
            ),
          );
    }
    for (final person in MemorySeedData.localizedPeople(l10n)) {
      await _database
          .into(_database.memoryPeople)
          .insert(
            db.MemoryPeopleCompanion.insert(
              id: person.id,
              eventId: person.eventId,
              name: person.name,
              relationship: person.relationship,
            ),
          );
    }
  }

  Future<void> _syncDemoAssetCovers() async {
    for (final event in MemorySeedData.events) {
      await (_database.update(_database.memoryEvents)
            ..where((row) => row.id.equals(event.id))
            ..where(
              (row) =>
                  row.coverPhotoPath.isNull() | row.coverPhotoPath.equals(''),
            ))
          .write(
            db.MemoryEventsCompanion(
              coverPhotoPath: Value(event.coverPhotoPath),
            ),
          );
    }
  }

  db.MemoryEventsCompanion _eventToCompanion(
    MemoryEvent event, {
    String? documentsPath,
  }) {
    final coverPhotoPath = documentsPath == null
        ? event.coverPhotoPath
        : AppStoragePaths.persistOptionalPhotoPath(
            event.coverPhotoPath,
            documentsPath,
          );

    return db.MemoryEventsCompanion.insert(
      id: event.id,
      title: event.title,
      description: event.description,
      category: Value(event.category.name),
      memoryType: Value(event.memoryType.name),
      feeling: Value(event.feeling.name),
      occurredAt: event.occurredAt.millisecondsSinceEpoch,
      createdAt: event.createdAt.millisecondsSinceEpoch,
      coverColorValue: event.coverColor.toARGB32(),
      wallX: event.wallPosition.dx,
      wallY: event.wallPosition.dy,
      rotation: event.rotation,
      locationLabel: event.locationLabel,
      latitude: Value(event.latitude),
      longitude: Value(event.longitude),
      coverPhotoPath: Value(coverPhotoPath),
    );
  }

  db.MemoryPeopleCompanion _personDraftToCompanion(
    MemoryPersonDraft person,
    String eventId,
  ) {
    return db.MemoryPeopleCompanion.insert(
      id: _uuid.v4(),
      eventId: eventId,
      name: person.name.trim(),
      relationship: person.relationship.trim(),
      phone: Value(_cleanOptional(person.phone)),
      email: Value(_cleanOptional(person.email)),
    );
  }

  MemoryEvent _eventFromRow(db.MemoryEvent row, String documentsPath) {
    return MemoryEvent(
      id: row.id,
      title: row.title,
      description: row.description,
      category: MemoryCategory.fromName(row.category),
      memoryType: MemoryType.fromName(row.memoryType),
      feeling: MemoryFeeling.fromName(row.feeling),
      occurredAt: DateTime.fromMillisecondsSinceEpoch(row.occurredAt),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      coverColor: Color(row.coverColorValue),
      wallPosition: Offset(row.wallX, row.wallY),
      rotation: row.rotation,
      locationLabel: row.locationLabel,
      latitude: row.latitude,
      longitude: row.longitude,
      coverPhotoPath: AppStoragePaths.resolveOptionalPhotoPath(
        row.coverPhotoPath,
        documentsPath,
      ),
    );
  }

  MemoryConnection _connectionFromRow(db.MemoryConnection row) {
    return MemoryConnection(
      id: row.id,
      fromEventId: row.fromEventId,
      toEventId: row.toEventId,
      label: row.label,
    );
  }

  MemoryPhoto _photoFromRow(db.MemoryPhoto row, String documentsPath) {
    return MemoryPhoto(
      id: row.id,
      eventId: row.eventId,
      localPath: AppStoragePaths.resolvePhotoPath(row.localPath, documentsPath),
      originalAssetId: row.originalAssetId,
      capturedAt: DateTime.fromMillisecondsSinceEpoch(row.capturedAt),
      latitude: row.latitude,
      longitude: row.longitude,
      width: row.width,
      height: row.height,
    );
  }

  person_model.MemoryPerson _personFromRow(db.MemoryPeopleData row) {
    return person_model.MemoryPerson(
      id: row.id,
      eventId: row.eventId,
      name: row.name,
      relationship: row.relationship,
      phone: row.phone,
      email: row.email,
    );
  }

  WallItem _wallItemFromRow(db.WallItem row) {
    return WallItem(
      id: row.id,
      type: WallItemType.fromName(row.type),
      content: row.content,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      wallPosition: Offset(row.wallX, row.wallY),
      color: Color(row.colorValue),
    );
  }

  static const _colors = [
    AppColors.gold,
    AppColors.blue,
    AppColors.rose,
    AppColors.sage,
    Color(0xFFBDA0C9),
  ];

  String _cleanConnectionLabel(String? label) {
    final clean = label?.trim();
    // Empty means "no reason"; the UI shows a translated fallback.
    return clean ?? '';
  }

  String? _cleanOptional(String? value) {
    final clean = value?.trim();
    return clean == null || clean.isEmpty ? null : clean;
  }

  String _stringValue(
    Map<String, Object?> map,
    String key, {
    String fallback = '',
  }) {
    final value = map[key];
    if (value is String) return value;
    return fallback;
  }

  String? _nullableString(Map<String, Object?> map, String key) {
    final value = map[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  int _intValue(Map<String, Object?> map, String key, {int fallback = 0}) {
    final value = map[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  double _doubleValue(
    Map<String, Object?> map,
    String key, {
    double fallback = 0,
  }) {
    final value = map[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  double? _nullableDouble(Map<String, Object?> map, String key) {
    final value = map[key];
    final parsed = value is num
        ? value.toDouble()
        : value is String
        ? double.tryParse(value)
        : null;
    // "NaN"/"Infinity" parse fine but break maps and layout downstream.
    return parsed != null && parsed.isFinite ? parsed : null;
  }
}
