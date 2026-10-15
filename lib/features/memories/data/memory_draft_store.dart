import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/storage/app_storage_paths.dart';
import '../../media/data/picked_memory_photo.dart';
import '../domain/memory_category.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_type.dart';
import 'memory_repository.dart';

final memoryDraftStoreProvider = Provider<MemoryDraftStore>(
  (ref) => MemoryDraftStore(),
);

/// A memory that was being added and not saved yet: kept so "Add memory"
/// can continue where one left off, also after the app was closed.
class MemoryDraft {
  const MemoryDraft({
    required this.savedAt,
    this.title = '',
    this.description = '',
    this.photos = const [],
    this.people = const [],
    this.step = 0,
    this.category = MemoryCategory.personal,
    this.memoryType = MemoryType.moment,
    this.feeling = MemoryFeeling.warm,
    this.occurredAt,
    this.dateFromPhotos = false,
    this.latitude,
    this.longitude,
    this.connectedEventId,
    this.connectionReason = '',
  });

  final DateTime savedAt;
  final String title;
  final String description;
  final List<PickedMemoryPhoto> photos;
  final List<MemoryPersonDraft> people;
  final int step;
  final MemoryCategory category;
  final MemoryType memoryType;
  final MemoryFeeling feeling;
  final DateTime? occurredAt;
  final bool dateFromPhotos;
  final double? latitude;
  final double? longitude;
  final String? connectedEventId;
  final String connectionReason;

  /// Worth keeping: something the user wrote or picked.
  bool get hasContent =>
      title.trim().isNotEmpty ||
      description.trim().isNotEmpty ||
      photos.isNotEmpty ||
      people.isNotEmpty;

  Map<String, Object?> toJson(String? documentsPath) => {
    'savedAt': savedAt.toIso8601String(),
    'title': title,
    'description': description,
    'photos': [
      for (final photo in photos)
        {
          'path': documentsPath == null
              ? photo.localPath
              : AppStoragePaths.persistPhotoPath(
                  photo.localPath,
                  documentsPath,
                ),
          'assetId': photo.originalAssetId,
          'capturedAt': photo.capturedAt.toIso8601String(),
          'width': photo.width,
          'height': photo.height,
          'hasCapturedDate': photo.hasCapturedDate,
          'hasDimensions': photo.hasDimensions,
          'latitude': photo.latitude,
          'longitude': photo.longitude,
          'title': photo.title,
        },
    ],
    'people': [
      for (final person in people)
        {
          'name': person.name,
          'relationship': person.relationship,
          'phone': person.phone,
          'email': person.email,
        },
    ],
    'step': step,
    'category': category.name,
    'memoryType': memoryType.name,
    'feeling': feeling.name,
    'occurredAt': occurredAt?.toIso8601String(),
    'dateFromPhotos': dateFromPhotos,
    'latitude': latitude,
    'longitude': longitude,
    'connectedEventId': connectedEventId,
    'connectionReason': connectionReason,
  };

  static MemoryDraft fromJson(
    Map<String, Object?> json,
    String? documentsPath,
  ) {
    T byName<T extends Enum>(List<T> values, Object? name, T fallback) =>
        values.where((value) => value.name == name).firstOrNull ?? fallback;
    DateTime? date(Object? value) =>
        value is String ? DateTime.tryParse(value) : null;
    double? number(Object? value) => value is num ? value.toDouble() : null;

    return MemoryDraft(
      savedAt: date(json['savedAt']) ?? DateTime.now(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photos: [
        for (final raw in json['photos'] as List? ?? const [])
          if (raw is Map)
            PickedMemoryPhoto(
              localPath: documentsPath == null
                  ? raw['path'] as String
                  : AppStoragePaths.resolvePhotoPath(
                      raw['path'] as String,
                      documentsPath,
                    ),
              originalAssetId: raw['assetId'] as String?,
              capturedAt: date(raw['capturedAt']) ?? DateTime.now(),
              width: raw['width'] as int? ?? 0,
              height: raw['height'] as int? ?? 0,
              hasCapturedDate: raw['hasCapturedDate'] as bool? ?? false,
              hasDimensions: raw['hasDimensions'] as bool? ?? false,
              latitude: number(raw['latitude']),
              longitude: number(raw['longitude']),
              title: raw['title'] as String?,
            ),
      ],
      people: [
        for (final raw in json['people'] as List? ?? const [])
          if (raw is Map)
            MemoryPersonDraft(
              name: raw['name'] as String? ?? '',
              relationship: raw['relationship'] as String? ?? '',
              phone: raw['phone'] as String?,
              email: raw['email'] as String?,
            ),
      ],
      step: json['step'] as int? ?? 0,
      category: byName(
        MemoryCategory.values,
        json['category'],
        MemoryCategory.personal,
      ),
      memoryType: byName(
        MemoryType.values,
        json['memoryType'],
        MemoryType.moment,
      ),
      feeling: byName(
        MemoryFeeling.values,
        json['feeling'],
        MemoryFeeling.warm,
      ),
      occurredAt: date(json['occurredAt']),
      dateFromPhotos: json['dateFromPhotos'] as bool? ?? false,
      latitude: number(json['latitude']),
      longitude: number(json['longitude']),
      connectedEventId: json['connectedEventId'] as String?,
      connectionReason: json['connectionReason'] as String? ?? '',
    );
  }
}

/// Keeps one [MemoryDraft] in the app's preferences. Photo paths are kept
/// relative to the documents folder, which moves between app updates on
/// iOS. The photos themselves are already copies in the app's storage.
class MemoryDraftStore {
  MemoryDraftStore({Future<String> Function()? documentsPath})
    : _documentsPath = documentsPath ?? AppStoragePaths.documentsPath;

  static const _key = 'add_memory_draft_v1';

  final Future<String> Function() _documentsPath;

  Future<MemoryDraft?> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(_key);
      if (raw == null) return null;
      final draft = MemoryDraft.fromJson(
        jsonDecode(raw) as Map<String, Object?>,
        await _documentsPathOrNull(),
      );
      // A photo can be gone (e.g. storage cleared); keep the rest.
      final photos = [
        for (final photo in draft.photos)
          if (await File(photo.localPath).exists()) photo,
      ];
      final kept = photos.length == draft.photos.length
          ? draft
          : draft.copyWithPhotos(photos);
      return kept.hasContent ? kept : null;
    } catch (error, stackTrace) {
      AppLogger.recordCrash(error, stackTrace);
      return null;
    }
  }

  Future<void> save(MemoryDraft draft) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!draft.hasContent) {
        await preferences.remove(_key);
        return;
      }
      await preferences.setString(
        _key,
        jsonEncode(draft.toJson(await _documentsPathOrNull())),
      );
    } catch (error, stackTrace) {
      AppLogger.recordCrash(error, stackTrace);
    }
  }

  /// Forgets the draft. With [deletePhotosOf] that draft's photo copies go
  /// too (the user started over); not after saving, when the memory uses
  /// them.
  Future<void> clear({MemoryDraft? deletePhotosOf}) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(_key);
      for (final photo in deletePhotosOf?.photos ?? const []) {
        final file = File(photo.localPath);
        if (await file.exists()) await file.delete();
      }
    } catch (error, stackTrace) {
      AppLogger.recordCrash(error, stackTrace);
    }
  }

  Future<String?> _documentsPathOrNull() async {
    try {
      return await _documentsPath();
    } catch (_) {
      return null;
    }
  }
}

extension on MemoryDraft {
  MemoryDraft copyWithPhotos(List<PickedMemoryPhoto> photos) => MemoryDraft(
    savedAt: savedAt,
    title: title,
    description: description,
    photos: photos,
    people: people,
    step: step,
    category: category,
    memoryType: memoryType,
    feeling: feeling,
    occurredAt: occurredAt,
    dateFromPhotos: dateFromPhotos,
    latitude: latitude,
    longitude: longitude,
    connectedEventId: connectedEventId,
    connectionReason: connectionReason,
  );
}
