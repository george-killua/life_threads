import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../backup/domain/backup_models.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_connection.dart';
import '../../memories/domain/memory_event.dart';
import '../../memories/domain/memory_photo.dart';
import '../../memories/domain/memory_person.dart';
import '../../wall/domain/wall_item.dart';
import '../domain/memory_capsule_models.dart';

final memoryCapsuleServiceProvider = Provider<MemoryCapsuleService>((ref) {
  return const MemoryCapsuleService();
});

class MemoryCapsuleService {
  const MemoryCapsuleService();

  static const manifestName = 'lifethreads-capsule.json';
  static const encryptedManifestName = 'lifethreads-capsule-encrypted.json';
  static const encryptedPayloadName = 'lifethreads-capsule-payload.bin';
  static const capsuleVersion = 1;
  static const encryptedCapsuleVersion = 1;
  static const _kdfIterations = 120000;

  Future<MemoryCapsuleExportResult> exportCapsule({
    required MemoryState state,
    required String memoryId,
    String? password,
  }) async {
    final event = state.findEvent(memoryId);
    if (event == null) {
      throw const BackupValidationException('Memory was not found.');
    }

    final archive = Archive();
    final localToArchivePath = <String, String>{};
    final photos = state.photosForEvent(memoryId);
    final people = state.peopleForEvent(memoryId);
    final notes = state.attachedTextNotes(memoryId);
    final includedIds = {event.id, for (final note in notes) note.id};
    final includedConnections = state.connections
        .where(
          (connection) =>
              includedIds.contains(connection.fromEventId) &&
              includedIds.contains(connection.toEventId),
        )
        .toList();
    final relatedMemories = state
        .connectedEvents(memoryId)
        .map((memory) => _relatedMemoryToJson(memory, state, memoryId))
        .toList();

    for (final photo in photos) {
      await _addPhotoFile(
        archive: archive,
        localToArchivePath: localToArchivePath,
        localPath: photo.localPath,
        archiveName: _photoArchiveName(photo.id, photo.localPath),
      );
    }

    final coverPath = event.coverPhotoPath;
    if (coverPath != null && !localToArchivePath.containsKey(coverPath)) {
      await _addPhotoFile(
        archive: archive,
        localToArchivePath: localToArchivePath,
        localPath: coverPath,
        archiveName: _photoArchiveName('cover_${event.id}', coverPath),
      );
    }

    archive.addFile(
      ArchiveFile.string(
        manifestName,
        jsonEncode({
          'app': 'LifeThreads',
          'type': 'memoryCapsule',
          'capsuleVersion': capsuleVersion,
          'createdAt': DateTime.now().toIso8601String(),
          'people': [for (final person in people) _personToJson(person)],
          'relatedMemories': relatedMemories,
          'metadata': {
            'photoCount': photos.length,
            'personCount': people.length,
            'noteCount': notes.length,
            'connectionCount': includedConnections.length,
            'relatedMemoryCount': relatedMemories.length,
          },
          'events': [_eventToJson(event, localToArchivePath)],
          'photos': [
            for (final photo in photos)
              if (localToArchivePath[photo.localPath] != null)
                _photoToJson(photo, localToArchivePath),
          ],
          'wallItems': [for (final note in notes) _wallItemToJson(note)],
          'connections': [
            for (final connection in includedConnections)
              _connectionToJson(connection),
          ],
        }),
      ),
    );

    final capsulesDir = await _capsulesDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '')
        .replaceAll('.', '-');
    final exportPassword = password?.trim() ?? '';
    final isEncrypted = exportPassword.isNotEmpty;
    final plainBytes = ZipEncoder().encodeBytes(archive);
    final exportBytes = isEncrypted
        ? await _encryptCapsule(plainBytes, exportPassword)
        : plainBytes;
    final file = File(
      p.join(
        capsulesDir.path,
        'lifethreads_capsule_${_slug(event.title)}_$timestamp.zip',
      ),
    );
    await file.writeAsBytes(exportBytes, flush: true);

    return MemoryCapsuleExportResult(
      path: file.path,
      title: event.title,
      photoCount: photos.length,
      noteCount: notes.length,
      connectionCount: includedConnections.length,
      isEncrypted: isEncrypted,
    );
  }

  Future<MemoryCapsuleImportDraft?> pickAndPrepareImport({
    String? password,
  }) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.single;
    final bytes = picked.bytes ?? await File(picked.path!).readAsBytes();
    return prepareImportFromBytes(bytes, password: password);
  }

  Future<MemoryCapsuleImportDraft> prepareImportFromBytes(
    List<int> bytes, {
    String? password,
  }) async {
    final isEncrypted = _isEncryptedCapsule(bytes);
    final archive = await _decodeCapsule(bytes, password: password);
    final files = {
      for (final file in archive)
        if (file.isFile) file.name: file,
    };
    final manifestFile = files[manifestName];
    if (manifestFile == null) {
      throw const BackupValidationException(
        'Memory capsule manifest is missing.',
      );
    }

    final manifestBytes = manifestFile.readBytes();
    if (manifestBytes == null) {
      throw const BackupValidationException('Memory capsule is unreadable.');
    }
    final decoded = jsonDecode(utf8.decode(manifestBytes));
    if (decoded is! Map) {
      throw const BackupValidationException('Memory capsule is invalid.');
    }
    final payload = decoded.map((key, value) => MapEntry('$key', value));
    final referencedPhotoPaths = validateCapsulePayload(
      payload,
      files.keys.toSet(),
    );
    final restoredPhotoPaths = await _restorePhotoFiles(
      referencedPhotoPaths,
      files,
    );
    final events = _mapList(payload['events']);
    final photos = _mapList(payload['photos']);
    final people = _mapList(payload['people']);
    final connections = _mapList(payload['connections']);
    final wallItems = _mapList(payload['wallItems']);

    return MemoryCapsuleImportDraft(
      preview: _previewFromPayload(
        payload,
        isEncrypted: isEncrypted,
        noteCount: wallItems.length,
        photoCount: photos.length,
        connectionCount: connections.length,
      ),
      backup: BackupImportData(
        events: events,
        photos: photos,
        people: people,
        connections: connections,
        wallItems: wallItems,
        photoPaths: restoredPhotoPaths,
      ),
    );
  }

  Future<void> discardImport(MemoryCapsuleImportDraft draft) async {
    for (final path in draft.backup.photoPaths.values) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  static Set<String> validateCapsulePayload(
    Map<String, Object?> payload,
    Set<String> archiveFileNames,
  ) {
    if (payload['app'] != 'LifeThreads' || payload['type'] != 'memoryCapsule') {
      throw const BackupValidationException(
        'This is not a LifeThreads memory capsule.',
      );
    }
    if (payload['capsuleVersion'] != capsuleVersion) {
      throw const BackupValidationException(
        'Unsupported memory capsule version.',
      );
    }

    final events = _mapList(payload['events']);
    if (events.length != 1) {
      throw const BackupValidationException(
        'A memory capsule must contain exactly one memory.',
      );
    }
    final eventId = _requiredString(events.first, 'id');
    _requiredString(events.first, 'title');

    final wallItems = _mapList(payload['wallItems']);
    final sourceIds = {eventId};
    for (final item in wallItems) {
      sourceIds.add(_requiredString(item, 'id'));
      _requiredString(item, 'type');
    }

    final connections = _mapList(payload['connections']);
    for (final connection in connections) {
      final fromId = _requiredString(connection, 'fromEventId');
      final toId = _requiredString(connection, 'toEventId');
      if (!sourceIds.contains(fromId) || !sourceIds.contains(toId)) {
        throw const BackupValidationException(
          'Memory capsule has a connection to missing content.',
        );
      }
    }

    final referencedPhotoPaths = <String>{};
    final coverPhotoPath = events.first['coverPhotoPath'];
    if (coverPhotoPath is String && coverPhotoPath.isNotEmpty) {
      _validateArchivePath(coverPhotoPath, archiveFileNames);
      referencedPhotoPaths.add(coverPhotoPath);
    }

    for (final photo in _mapList(payload['photos'])) {
      final photoEventId = _requiredString(photo, 'eventId');
      if (photoEventId != eventId) {
        throw const BackupValidationException(
          'Memory capsule photo references another memory.',
        );
      }
      final localPath = _requiredString(photo, 'localPath');
      _validateArchivePath(localPath, archiveFileNames);
      referencedPhotoPaths.add(localPath);
    }

    for (final person in _mapList(payload['people'])) {
      final personEventId = _requiredString(person, 'eventId');
      if (personEventId != eventId) {
        throw const BackupValidationException(
          'Memory capsule person references another memory.',
        );
      }
      _requiredString(person, 'name');
      _requiredString(person, 'relationship');
    }

    return referencedPhotoPaths;
  }

  bool _isEncryptedCapsule(List<int> bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes, verify: true);
      return archive.any(
        (file) => file.isFile && file.name == encryptedManifestName,
      );
    } catch (_) {
      return false;
    }
  }

  Future<List<int>> _encryptCapsule(
    List<int> plainBytes,
    String password,
  ) async {
    final random = Random.secure();
    final salt = _secureBytes(random, 32);
    final nonce = _secureBytes(random, 12);
    final algorithm = AesGcm.with256bits();
    final secretKey = await _deriveKey(password, salt);
    final box = await algorithm.encrypt(
      plainBytes,
      secretKey: secretKey,
      nonce: nonce,
    );

    final wrapper = Archive()
      ..addFile(
        ArchiveFile.string(
          encryptedManifestName,
          jsonEncode({
            'app': 'LifeThreads',
            'type': 'memoryCapsule',
            'encryptedCapsuleVersion': encryptedCapsuleVersion,
            'algorithm': 'AES-256-GCM',
            'kdf': 'PBKDF2-HMAC-SHA256',
            'iterations': _kdfIterations,
            'salt': base64Encode(salt),
            'nonce': base64Encode(nonce),
            'mac': base64Encode(box.mac.bytes),
            'createdAt': DateTime.now().toIso8601String(),
          }),
        ),
      )
      ..addFile(ArchiveFile.bytes(encryptedPayloadName, box.cipherText));

    return ZipEncoder().encodeBytes(wrapper);
  }

  Future<Archive> _decodeCapsule(List<int> bytes, {String? password}) async {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final files = {
      for (final file in archive)
        if (file.isFile) file.name: file,
    };
    if (!files.containsKey(encryptedManifestName)) return archive;

    final importPassword = password?.trim() ?? '';
    if (importPassword.isEmpty) {
      throw const BackupValidationException(
        'This memory capsule is encrypted. Enter its password to import it.',
      );
    }

    final manifestBytes = files[encryptedManifestName]?.readBytes();
    final payloadBytes = files[encryptedPayloadName]?.readBytes();
    if (manifestBytes == null || payloadBytes == null) {
      throw const BackupValidationException(
        'Encrypted memory capsule is incomplete.',
      );
    }

    final decoded = jsonDecode(utf8.decode(manifestBytes));
    if (decoded is! Map) {
      throw const BackupValidationException(
        'Encrypted memory capsule manifest is invalid.',
      );
    }
    final manifest = decoded.map((key, value) => MapEntry('$key', value));
    if (manifest['app'] != 'LifeThreads' ||
        manifest['type'] != 'memoryCapsule' ||
        manifest['encryptedCapsuleVersion'] != encryptedCapsuleVersion) {
      throw const BackupValidationException(
        'Unsupported encrypted memory capsule version.',
      );
    }

    try {
      final salt = base64Decode(_requiredString(manifest, 'salt'));
      final nonce = base64Decode(_requiredString(manifest, 'nonce'));
      final mac = Mac(base64Decode(_requiredString(manifest, 'mac')));
      final secretKey = await _deriveKey(importPassword, salt);
      final plainBytes = await AesGcm.with256bits().decrypt(
        SecretBox(payloadBytes, nonce: nonce, mac: mac),
        secretKey: secretKey,
      );
      return ZipDecoder().decodeBytes(plainBytes, verify: true);
    } on BackupValidationException {
      rethrow;
    } catch (_) {
      throw const BackupValidationException(
        'Capsule password is incorrect or the capsule is damaged.',
      );
    }
  }

  Future<void> _addPhotoFile({
    required Archive archive,
    required Map<String, String> localToArchivePath,
    required String localPath,
    required String archiveName,
  }) async {
    final file = File(localPath);
    if (!await file.exists()) return;

    localToArchivePath[localPath] = archiveName;
    archive.addFile(ArchiveFile.bytes(archiveName, await file.readAsBytes()));
  }

  Future<Map<String, String>> _restorePhotoFiles(
    Set<String> referencedPhotoPaths,
    Map<String, ArchiveFile> files,
  ) async {
    if (referencedPhotoPaths.isEmpty) return const {};

    final photosDir = await _memoryPhotosDirectory();
    const uuid = Uuid();
    final restored = <String, String>{};

    for (final archivePath in referencedPhotoPaths) {
      final archiveFile = files[archivePath];
      final bytes = archiveFile?.readBytes();
      if (bytes == null) {
        throw BackupValidationException(
          'Capsule photo is missing: $archivePath.',
        );
      }

      final extension = p.extension(archivePath).isEmpty
          ? '.jpg'
          : p.extension(archivePath);
      final file = File(
        p.join(photosDir.path, 'capsule_${uuid.v4()}$extension'),
      );
      await file.writeAsBytes(bytes, flush: true);
      restored[archivePath] = file.path;
    }

    return restored;
  }

  Future<SecretKey> _deriveKey(String password, List<int> salt) {
    return Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _kdfIterations,
      bits: 256,
    ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);
  }

  List<int> _secureBytes(Random random, int length) {
    return List<int>.generate(length, (_) => random.nextInt(256));
  }

  Future<Directory> _capsulesDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final capsulesDir = Directory(p.join(directory.path, 'capsules'));
    if (!await capsulesDir.exists()) await capsulesDir.create(recursive: true);
    return capsulesDir;
  }

  Future<Directory> _memoryPhotosDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(directory.path, 'memory_photos'));
    if (!await photosDir.exists()) await photosDir.create(recursive: true);
    return photosDir;
  }

  Map<String, Object?> _eventToJson(
    MemoryEvent event,
    Map<String, String> localToArchivePath,
  ) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'category': event.category.name,
      'memoryType': event.memoryType.name,
      'feeling': event.feeling.name,
      'occurredAt': event.occurredAt.millisecondsSinceEpoch,
      'createdAt': event.createdAt.millisecondsSinceEpoch,
      'coverColorValue': event.coverColor.toARGB32(),
      'wallX': event.wallPosition.dx,
      'wallY': event.wallPosition.dy,
      'rotation': event.rotation,
      'locationLabel': event.locationLabel,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'coverPhotoPath': event.coverPhotoPath == null
          ? null
          : localToArchivePath[event.coverPhotoPath],
    };
  }

  Map<String, Object?> _photoToJson(
    MemoryPhoto photo,
    Map<String, String> localToArchivePath,
  ) {
    return {
      'id': photo.id,
      'eventId': photo.eventId,
      'localPath': localToArchivePath[photo.localPath],
      'originalAssetId': photo.originalAssetId,
      'capturedAt': photo.capturedAt.millisecondsSinceEpoch,
      'latitude': photo.latitude,
      'longitude': photo.longitude,
      'width': photo.width,
      'height': photo.height,
    };
  }

  Map<String, Object?> _personToJson(MemoryPerson person) {
    return {
      'id': person.id,
      'eventId': person.eventId,
      'name': person.name,
      'relationship': person.relationship,
      'phone': person.phone,
      'email': person.email,
    };
  }

  Map<String, Object?> _wallItemToJson(WallItem item) {
    return {
      'id': item.id,
      'type': item.type.name,
      'content': item.content,
      'createdAt': item.createdAt.millisecondsSinceEpoch,
      'wallX': item.wallPosition.dx,
      'wallY': item.wallPosition.dy,
      'colorValue': item.color.toARGB32(),
    };
  }

  Map<String, Object?> _connectionToJson(MemoryConnection connection) {
    return {
      'id': connection.id,
      'fromEventId': connection.fromEventId,
      'toEventId': connection.toEventId,
      'label': connection.label,
    };
  }

  Map<String, Object?> _relatedMemoryToJson(
    MemoryEvent memory,
    MemoryState state,
    String sourceId,
  ) {
    return {
      'id': memory.id,
      'title': memory.title,
      'locationLabel': memory.locationLabel,
      'occurredAt': memory.occurredAt.millisecondsSinceEpoch,
      'label': state.connectionBetween(sourceId, memory.id)?.label,
    };
  }

  MemoryCapsulePreview _previewFromPayload(
    Map<String, Object?> payload, {
    required bool isEncrypted,
    required int noteCount,
    required int photoCount,
    required int connectionCount,
  }) {
    final event = _mapList(payload['events']).first;
    return MemoryCapsulePreview(
      title: _requiredString(event, 'title'),
      description: _stringValue(event, 'description'),
      locationLabel: _stringValue(event, 'locationLabel', fallback: 'Unknown'),
      occurredAt: DateTime.fromMillisecondsSinceEpoch(
        _intValue(
          event,
          'occurredAt',
          fallback: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
      photoCount: photoCount,
      noteCount: noteCount,
      connectionCount: connectionCount,
      relatedMemoryCount: _mapList(payload['relatedMemories']).length,
      peopleCount: _mapList(payload['people']).length,
      isEncrypted: isEncrypted,
    );
  }

  String _photoArchiveName(String id, String localPath) {
    final extension = p.extension(localPath).isEmpty
        ? '.jpg'
        : p.extension(localPath);
    return 'photos/$id$extension';
  }

  String _slug(String value) {
    final clean = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return clean.isEmpty ? 'memory' : clean;
  }

  static List<Map<String, Object?>> _mapList(Object? value) {
    if (value == null) return const [];
    if (value is! List) {
      throw const BackupValidationException('Capsule data is incomplete.');
    }
    return [
      for (final item in value)
        if (item is Map)
          item.map((key, value) => MapEntry(key.toString(), value))
        else
          throw const BackupValidationException(
            'Capsule list item is invalid.',
          ),
    ];
  }

  static String _requiredString(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is String && value.isNotEmpty) return value;
    throw BackupValidationException('Capsule field "$key" is missing.');
  }

  static String _stringValue(
    Map<String, Object?> map,
    String key, {
    String fallback = '',
  }) {
    final value = map[key];
    if (value is String) return value;
    return fallback;
  }

  static int _intValue(
    Map<String, Object?> map,
    String key, {
    int fallback = 0,
  }) {
    final value = map[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static void _validateArchivePath(
    String archivePath,
    Set<String> archiveFileNames,
  ) {
    final isUnsafe =
        archivePath.startsWith('/') ||
        archivePath.contains('\\') ||
        archivePath.split('/').contains('..');
    if (isUnsafe || !archiveFileNames.contains(archivePath)) {
      throw BackupValidationException(
        'Capsule photo path is invalid: $archivePath.',
      );
    }
  }
}
