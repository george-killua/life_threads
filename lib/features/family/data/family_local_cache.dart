import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../memories/domain/memory_category.dart';
import '../../memories/domain/memory_feeling.dart';
import '../domain/family_models.dart';

/// The JSON inside an encrypted memory record: every [FamilyMemory] field
/// except the server's metadata (id, family, author, version, timestamps),
/// which come from the item itself so they cannot be forged by the author.
abstract final class FamilyMemoryRecord {
  static const formatVersion = 1;

  static Map<String, Object?> encode({
    required String title,
    required String description,
    required MemoryCategory category,
    required MemoryFeeling feeling,
    required DateTime occurredAt,
    required String locationLabel,
    required double? latitude,
    required double? longitude,
    required String? coverPhotoId,
    required List<String> photoIds,
    required double wallX,
    required double wallY,
    required double rotation,
  }) => {
    'v': formatVersion,
    'title': title,
    'description': description,
    'category': category.name,
    'feeling': feeling.name,
    'occurredAt': occurredAt.toUtc().toIso8601String(),
    'locationLabel': locationLabel,
    'latitude': ?latitude,
    'longitude': ?longitude,
    'coverPhotoId': ?coverPhotoId,
    'photoIds': photoIds,
    'wallX': wallX,
    'wallY': wallY,
    'rotation': rotation,
  };

  static Map<String, Object?> fromMemory(FamilyMemory memory) => encode(
    title: memory.title,
    description: memory.description,
    category: memory.category,
    feeling: memory.feeling,
    occurredAt: memory.occurredAt,
    locationLabel: memory.locationLabel,
    latitude: memory.latitude,
    longitude: memory.longitude,
    coverPhotoId: memory.coverPhotoId,
    photoIds: memory.photoIds,
    wallX: memory.wallX,
    wallY: memory.wallY,
    rotation: memory.rotation,
  );

  /// Builds a memory from a decrypted record plus server metadata. Unknown
  /// or missing fields fall back to safe defaults (a newer app version may
  /// add fields).
  static FamilyMemory decode(
    Map<String, Object?> record, {
    required String id,
    required String familyId,
    required String authorId,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    double number(Object? value, double fallback) =>
        value is num && value.isFinite ? value.toDouble() : fallback;
    double? optionalNumber(Object? value) =>
        value is num && value.isFinite ? value.toDouble() : null;
    String string(Object? value) => value is String ? value : '';
    // Ids come from other members' records and become file names: only
    // plain ids are accepted (no "../").
    final photoIds = record['photoIds'] is List
        ? (record['photoIds'] as List)
              .whereType<String>()
              .where(isSafeFamilyId)
              .toList()
        : <String>[];
    final cover = record['coverPhotoId'];
    return FamilyMemory(
      id: id,
      familyId: familyId,
      authorId: authorId,
      version: version,
      title: string(record['title']),
      description: string(record['description']),
      category: MemoryCategory.fromName(string(record['category'])),
      feeling: MemoryFeeling.fromName(string(record['feeling'])),
      occurredAt: DateTime.tryParse(string(record['occurredAt'])) ?? createdAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      locationLabel: string(record['locationLabel']),
      latitude: optionalNumber(record['latitude']),
      longitude: optionalNumber(record['longitude']),
      coverPhotoId: cover is String && photoIds.contains(cover) ? cover : null,
      photoIds: photoIds,
      wallX: number(record['wallX'], 0),
      wallY: number(record['wallY'], 0),
      rotation: number(record['rotation'], 0),
    );
  }

  /// The cache form: the record plus the metadata.
  static Map<String, Object?> toCacheJson(FamilyMemory memory) => {
    ...fromMemory(memory),
    'id': memory.id,
    'familyId': memory.familyId,
    'authorId': memory.authorId,
    'version': memory.version,
    'createdAt': memory.createdAt.toUtc().toIso8601String(),
    'updatedAt': memory.updatedAt.toUtc().toIso8601String(),
  };

  static FamilyMemory? fromCacheJson(Object? json) {
    if (json is! Map) return null;
    final map = json.cast<String, Object?>();
    final id = map['id'];
    final familyId = map['familyId'];
    final authorId = map['authorId'];
    final version = map['version'];
    final createdAt = DateTime.tryParse('${map['createdAt']}');
    final updatedAt = DateTime.tryParse('${map['updatedAt']}');
    if (id is! String ||
        familyId is! String ||
        authorId is! String ||
        version is! int ||
        createdAt == null ||
        updatedAt == null) {
      return null;
    }
    return decode(
      map,
      id: id,
      familyId: familyId,
      authorId: authorId,
      version: version,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// What the device remembers about one family between syncs.

/// Ids of families, memories and photos: letters, digits, '-' and '_'.
bool isSafeFamilyId(String id) => _safeFamilyId.hasMatch(id);
final _safeFamilyId = RegExp(r'^[A-Za-z0-9_-]{1,128}$');

class FamilySyncState {
  const FamilySyncState({
    this.cursor = '0',
    this.membersVersion,
    this.members = const [],
  });

  final String cursor;
  final int? membersVersion;
  final List<FamilyMember> members;

  FamilySyncState copyWith({
    String? cursor,
    int? membersVersion,
    List<FamilyMember>? members,
  }) => FamilySyncState(
    cursor: cursor ?? this.cursor,
    membersVersion: membersVersion ?? this.membersVersion,
    members: members ?? this.members,
  );

  Map<String, Object?> toJson() => {
    'cursor': cursor,
    'membersVersion': membersVersion,
    'members': [
      for (final m in members)
        {
          'accountId': m.accountId,
          'role': m.role.name,
          'displayName': m.displayName,
          'isBlockedByMe': m.isBlockedByMe,
        },
    ],
  };

  static FamilySyncState fromJson(Object? json) {
    if (json is! Map) return const FamilySyncState();
    final members = <FamilyMember>[];
    if (json['members'] is List) {
      for (final m in json['members'] as List) {
        if (m is Map && m['accountId'] is String) {
          members.add(
            FamilyMember(
              accountId: m['accountId'] as String,
              role: m['role'] == 'owner' ? FamilyRole.owner : FamilyRole.member,
              displayName: m['displayName'] is String
                  ? m['displayName'] as String
                  : '',
              isBlockedByMe: m['isBlockedByMe'] == true,
            ),
          );
        }
      }
    }
    return FamilySyncState(
      cursor: json['cursor'] is String ? json['cursor'] as String : '0',
      membersVersion: json['membersVersion'] is int
          ? json['membersVersion'] as int
          : null,
      members: members,
    );
  }
}

/// The local family cache: small JSON files under one directory (decrypted
/// records, cursors, the families list) plus decrypted photo files.
///
/// Kept apart from the personal memories database on purpose: it is a
/// disposable copy of server data (a sync from cursor 0 rebuilds it), a
/// wall holds at most a few thousand small records, and deleting the
/// account or leaving a family is a directory delete with no migration of
/// the personal database involved.
class FamilyLocalCache {
  FamilyLocalCache(this._rootFuture);

  final Future<Directory> _rootFuture;

  final Map<String, Map<String, FamilyMemory>> _memories = {};
  final Map<String, FamilySyncState> _states = {};
  List<Family>? _families;
  Map<String, Object?>? _account;
  Set<String>? _blocked;
  Future<void> _writes = Future.value();

  Future<Directory> get root => _rootFuture;

  Future<String> _familyDir(String familyId) async =>
      p.join((await root).path, 'families', _checkedId(familyId));

  Future<Directory> photosDir(String familyId) async =>
      Directory(p.join(await _familyDir(familyId), 'photos'));

  Future<File> photoFile(String familyId, String photoId) async => File(
    p.join((await photosDir(familyId)).path, '${_checkedId(photoId)}.jpg'),
  );

  /// Server and member supplied ids name files and folders here; anything
  /// that isn't a plain id could reach outside the cache.
  static String _checkedId(String id) {
    if (!isSafeFamilyId(id)) {
      throw ArgumentError.value(id, 'id', 'not a plain family id');
    }
    return id;
  }

  Future<Object?> _readJson(String path) async {
    final file = File(path);
    try {
      if (!await file.exists()) return null;
      return jsonDecode(await file.readAsString());
    } on FormatException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  /// Writes are queued so they land in order, each atomically (temp file +
  /// rename).
  Future<void> _writeJson(String path, Object? value) {
    final encoded = jsonEncode(value);
    final next = _writes.then((_) async {
      final file = File(path);
      await file.parent.create(recursive: true);
      final temp = File('$path.tmp');
      await temp.writeAsString(encoded, flush: true);
      await temp.rename(path);
    });
    _writes = next.catchError((_) {});
    return next;
  }

  // Account -----------------------------------------------------------------

  Future<Map<String, Object?>?> account() async {
    if (_account != null) return _account;
    final json = await _readJson(p.join((await root).path, 'account.json'));
    _account = json is Map ? json.cast<String, Object?>() : null;
    return _account;
  }

  Future<void> saveAccount(Map<String, Object?> json) async {
    _account = json;
    await _writeJson(p.join((await root).path, 'account.json'), json);
  }

  // Families ----------------------------------------------------------------

  Future<List<Family>> families() async {
    if (_families != null) return _families!;
    final json = await _readJson(p.join((await root).path, 'families.json'));
    final families = <Family>[];
    if (json is List) {
      for (final f in json) {
        if (f is Map && f['id'] is String) {
          families.add(
            Family(
              id: f['id'] as String,
              name: f['name'] is String ? f['name'] as String : '',
              ownerId: f['ownerId'] is String ? f['ownerId'] as String : '',
              role: f['role'] == 'owner' ? FamilyRole.owner : FamilyRole.member,
              memberCount: f['memberCount'] is int
                  ? f['memberCount'] as int
                  : 0,
              usedBytes: f['usedBytes'] is int ? f['usedBytes'] as int : 0,
              quotaBytes: f['quotaBytes'] is int ? f['quotaBytes'] as int : 0,
              keyId: f['keyId'] is String ? f['keyId'] as String : null,
              keyEpoch: f['keyEpoch'] is int ? f['keyEpoch'] as int : 0,
              rotationRequired: f['rotationRequired'] == true,
            ),
          );
        }
      }
    }
    return _families = families;
  }

  Future<void> saveFamilies(List<Family> families) async {
    _families = List.unmodifiable(families);
    await _writeJson(p.join((await root).path, 'families.json'), [
      for (final f in families)
        {
          'id': f.id,
          'name': f.name,
          'ownerId': f.ownerId,
          'role': f.role.name,
          'memberCount': f.memberCount,
          'usedBytes': f.usedBytes,
          'quotaBytes': f.quotaBytes,
          'keyId': f.keyId,
          'keyEpoch': f.keyEpoch,
          'rotationRequired': f.rotationRequired,
        },
    ]);
  }

  // Blocks ------------------------------------------------------------------

  Future<Set<String>> blocked() async {
    if (_blocked != null) return _blocked!;
    final json = await _readJson(p.join((await root).path, 'blocks.json'));
    return _blocked = json is List ? json.whereType<String>().toSet() : {};
  }

  Future<void> saveBlocked(Set<String> ids) async {
    _blocked = Set.of(ids);
    await _writeJson(
      p.join((await root).path, 'blocks.json'),
      ids.toList()..sort(),
    );
  }

  // Per family ----------------------------------------------------------------

  Future<FamilySyncState> state(String familyId) async {
    final cached = _states[familyId];
    if (cached != null) return cached;
    final json = await _readJson(
      p.join(await _familyDir(familyId), 'state.json'),
    );
    return _states[familyId] = FamilySyncState.fromJson(json);
  }

  Future<void> saveState(String familyId, FamilySyncState state) async {
    _states[familyId] = state;
    await _writeJson(
      p.join(await _familyDir(familyId), 'state.json'),
      state.toJson(),
    );
  }

  Future<Map<String, FamilyMemory>> memories(String familyId) async {
    final cached = _memories[familyId];
    if (cached != null) return cached;
    final json = await _readJson(
      p.join(await _familyDir(familyId), 'memories.json'),
    );
    final memories = <String, FamilyMemory>{};
    if (json is List) {
      for (final entry in json) {
        final memory = FamilyMemoryRecord.fromCacheJson(entry);
        if (memory != null) memories[memory.id] = memory;
      }
    }
    return _memories[familyId] = memories;
  }

  Future<void> saveMemories(
    String familyId,
    Map<String, FamilyMemory> memories,
  ) async {
    _memories[familyId] = memories;
    await _writeJson(p.join(await _familyDir(familyId), 'memories.json'), [
      for (final m in memories.values) FamilyMemoryRecord.toCacheJson(m),
    ]);
  }

  /// Forgets one family: records, cursor and decrypted photos.
  Future<void> deleteFamily(String familyId) async {
    _memories.remove(familyId);
    _states.remove(familyId);
    await _writes;
    final dir = Directory(await _familyDir(familyId));
    try {
      await dir.delete(recursive: true);
    } on PathNotFoundException {
      // Already gone.
    }
  }

  /// Forgets everything (sign out, account deletion).
  Future<void> clear() async {
    _memories.clear();
    _states.clear();
    _families = null;
    _account = null;
    _blocked = null;
    await _writes;
    final dir = await root;
    try {
      await dir.delete(recursive: true);
    } on PathNotFoundException {
      // Already gone (cleared twice at once, e.g. sign-out and a 401).
    }
  }
}
