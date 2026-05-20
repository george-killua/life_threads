import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../wall/domain/wall_item.dart';
import '../domain/memory_category.dart';
import '../domain/memory_connection.dart';
import '../domain/memory_event.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_photo.dart';
import '../domain/memory_type.dart';
import 'memory_seed_data.dart';

final memoryRepositoryProvider =
    AsyncNotifierProvider<MemoryRepository, MemoryState>(MemoryRepository.new);

class MemoryState {
  const MemoryState({
    required this.events,
    required this.connections,
    required this.photos,
    required this.wallItems,
  });

  final List<MemoryEvent> events;
  final List<MemoryConnection> connections;
  final List<MemoryPhoto> photos;
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
    this.photos = const [],
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
  final List<MemoryPhotoDraft> photos;
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

class MemoryRepository extends AsyncNotifier<MemoryState> {
  final _uuid = const Uuid();

  db.AppDatabase get _database => ref.read(appDatabaseProvider);

  @override
  Future<MemoryState> build() async {
    await _seedIfEmpty();
    return _loadState();
  }

  Future<void> addMemory(NewMemoryDraft draft) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final current = await _loadState();
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
        wallPosition: Offset(150 + (index % 3) * 260, 180 + (index ~/ 3) * 210),
        rotation: index.isEven ? -0.035 : 0.04,
        locationLabel: draft.locationLabel,
        latitude: draft.latitude,
        longitude: draft.longitude,
        coverPhotoPath: draft.coverPhotoPath,
      );

      await _database.transaction(() async {
        await _database
            .into(_database.memoryEvents)
            .insert(_eventToCompanion(event));

        for (final photo in draft.photos) {
          await _database
              .into(_database.memoryPhotos)
              .insert(
                db.MemoryPhotosCompanion.insert(
                  id: _uuid.v4(),
                  eventId: id,
                  localPath: photo.localPath,
                  originalAssetId: Value(photo.originalAssetId),
                  capturedAt: photo.capturedAt.millisecondsSinceEpoch,
                  latitude: Value(photo.latitude),
                  longitude: Value(photo.longitude),
                  width: photo.width,
                  height: photo.height,
                ),
              );
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
                  label: draft.connectionReason?.trim().isNotEmpty == true
                      ? draft.connectionReason!.trim()
                      : 'new thread',
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
    required DateTime occurredAt,
    required String locationLabel,
    double? latitude,
    double? longitude,
    String? coverPhotoPath,
  }) async {
    await (_database.update(
      _database.memoryEvents,
    )..where((row) => row.id.equals(id))).write(
      db.MemoryEventsCompanion(
        title: Value(title),
        description: Value(description),
        category: Value(category.name),
        occurredAt: Value(occurredAt.millisecondsSinceEpoch),
        locationLabel: Value(locationLabel),
        latitude: Value(latitude),
        longitude: Value(longitude),
        coverPhotoPath: Value(coverPhotoPath),
      ),
    );
    state = await AsyncValue.guard(_loadState);
  }

  Future<void> deleteMemory(String id) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.memoryPhotos,
      )..where((row) => row.eventId.equals(id))).go();
      await (_database.delete(_database.memoryConnections)..where(
            (row) => row.fromEventId.equals(id) | row.toEventId.equals(id),
          ))
          .go();
      await (_database.delete(
        _database.memoryEvents,
      )..where((row) => row.id.equals(id))).go();
    });
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
    final existing =
        await (_database.select(_database.memoryConnections)..where(
              (row) =>
                  (row.fromEventId.equals(fromId) &
                      row.toEventId.equals(toId)) |
                  (row.fromEventId.equals(toId) & row.toEventId.equals(fromId)),
            ))
            .getSingleOrNull();

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
    }

    if (isConnected && existing != null && label != null) {
      await updateConnectionLabel(existing.id, label);
      return;
    }

    if (!isConnected && existing != null) {
      await (_database.delete(
        _database.memoryConnections,
      )..where((row) => row.id.equals(existing.id))).go();
    }

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
    final current = state.asData?.value;
    if (current == null) return;

    final updatedEvents = [
      for (final event in current.events)
        if (event.id == id) event.copyWith(wallPosition: position) else event,
    ];
    state = AsyncData(
      MemoryState(
        events: updatedEvents,
        connections: current.connections,
        photos: current.photos,
        wallItems: current.wallItems,
      ),
    );

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
    final current = state.asData?.value;
    if (current == null) return;

    final updatedItems = [
      for (final item in current.wallItems)
        if (item.id == id) item.copyWith(wallPosition: position) else item,
    ];
    state = AsyncData(
      MemoryState(
        events: current.events,
        connections: current.connections,
        photos: current.photos,
        wallItems: updatedItems,
      ),
    );

    await (_database.update(
      _database.wallItems,
    )..where((row) => row.id.equals(id))).write(
      db.WallItemsCompanion(
        wallX: Value(position.dx),
        wallY: Value(position.dy),
      ),
    );
  }

  Future<MemoryState> _loadState() async {
    final eventRows = await _database.select(_database.memoryEvents).get();
    final connectionRows = await _database
        .select(_database.memoryConnections)
        .get();
    final photoRows = await _database.select(_database.memoryPhotos).get();
    final wallItemRows = await _database.select(_database.wallItems).get();

    return MemoryState(
      events: eventRows.map(_eventFromRow).toList(),
      connections: connectionRows.map(_connectionFromRow).toList(),
      photos: photoRows.map(_photoFromRow).toList(),
      wallItems: wallItemRows.map(_wallItemFromRow).toList(),
    );
  }

  Future<void> _seedIfEmpty() async {
    final existing = await _database.select(_database.memoryEvents).get();
    if (existing.isNotEmpty) return;

    await _database.transaction(() async {
      for (final event in MemorySeedData.events) {
        await _database
            .into(_database.memoryEvents)
            .insert(_eventToCompanion(event));
      }
      for (final connection in MemorySeedData.connections) {
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
    });
  }

  db.MemoryEventsCompanion _eventToCompanion(MemoryEvent event) {
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
      coverPhotoPath: Value(event.coverPhotoPath),
    );
  }

  MemoryEvent _eventFromRow(db.MemoryEvent row) {
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
      coverPhotoPath: row.coverPhotoPath,
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

  MemoryPhoto _photoFromRow(db.MemoryPhoto row) {
    return MemoryPhoto(
      id: row.id,
      eventId: row.eventId,
      localPath: row.localPath,
      originalAssetId: row.originalAssetId,
      capturedAt: DateTime.fromMillisecondsSinceEpoch(row.capturedAt),
      latitude: row.latitude,
      longitude: row.longitude,
      width: row.width,
      height: row.height,
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
    return clean == null || clean.isEmpty ? 'connected memory' : clean;
  }
}
