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

import '../../memories/data/memory_repository.dart';
import '../domain/backup_models.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return const BackupService();
});

class BackupService {
  const BackupService();

  static const backupManifestName = 'lifethreads-backup.json';
  static const encryptedManifestName = 'lifethreads-encrypted.json';
  static const encryptedPayloadName = 'lifethreads-payload.bin';
  static const formatVersion = 1;
  static const encryptedArchiveVersion = 1;
  static const _kdfIterations = 120000;

  Future<BackupExportResult> exportBackup(
    MemoryState state, {
    String? password,
  }) async {
    final archive = Archive();
    final localToArchivePath = <String, String>{};

    for (final photo in state.photos) {
      await _addPhotoFile(
        archive: archive,
        localToArchivePath: localToArchivePath,
        localPath: photo.localPath,
        archiveName: _photoArchiveName(photo.id, photo.localPath),
      );
    }

    for (final event in state.events) {
      final coverPath = event.coverPhotoPath;
      if (coverPath == null || localToArchivePath.containsKey(coverPath)) {
        continue;
      }
      await _addPhotoFile(
        archive: archive,
        localToArchivePath: localToArchivePath,
        localPath: coverPath,
        archiveName: _photoArchiveName('cover_${event.id}', coverPath),
      );
    }

    archive.addFile(
      ArchiveFile.string(
        backupManifestName,
        jsonEncode({
          'app': 'LifeThreads',
          'formatVersion': formatVersion,
          'createdAt': DateTime.now().toIso8601String(),
          'metadata': {
            'memoryCount': state.events.length,
            'photoCount': state.photos.length,
            'personCount': state.people.length,
            'wallItemCount': state.wallItems.length,
            'connectionCount': state.connections.length,
          },
          'wallLayout': {
            'kind': 'freeform',
            'positionsIncluded': true,
            'notesIncluded': true,
            'connectionsIncluded': true,
          },
          'events': [
            for (final event in state.events)
              {
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
              },
          ],
          'photos': [
            for (final photo in state.photos)
              if (localToArchivePath[photo.localPath] != null)
                {
                  'id': photo.id,
                  'eventId': photo.eventId,
                  'localPath': localToArchivePath[photo.localPath],
                  'originalAssetId': photo.originalAssetId,
                  'capturedAt': photo.capturedAt.millisecondsSinceEpoch,
                  'latitude': photo.latitude,
                  'longitude': photo.longitude,
                  'width': photo.width,
                  'height': photo.height,
                },
          ],
          'people': [
            for (final person in state.people)
              {
                'id': person.id,
                'eventId': person.eventId,
                'name': person.name,
                'relationship': person.relationship,
                'phone': person.phone,
                'email': person.email,
              },
          ],
          'connections': [
            for (final connection in state.connections)
              {
                'id': connection.id,
                'fromEventId': connection.fromEventId,
                'toEventId': connection.toEventId,
                'label': connection.label,
              },
          ],
          'wallItems': [
            for (final item in state.wallItems)
              {
                'id': item.id,
                'type': item.type.name,
                'content': item.content,
                'createdAt': item.createdAt.millisecondsSinceEpoch,
                'wallX': item.wallPosition.dx,
                'wallY': item.wallPosition.dy,
                'colorValue': item.color.toARGB32(),
              },
          ],
        }),
      ),
    );

    final backupsDir = await _backupsDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '')
        .replaceAll('.', '-');
    final plainBytes = ZipEncoder().encodeBytes(archive);
    final exportPassword = password?.trim() ?? '';
    final isEncrypted = exportPassword.isNotEmpty;
    final exportBytes = isEncrypted
        ? await _encryptArchive(plainBytes, exportPassword)
        : plainBytes;
    final file = File(
      p.join(
        backupsDir.path,
        isEncrypted
            ? 'lifethreads_encrypted_$timestamp.zip'
            : 'lifethreads_$timestamp.zip',
      ),
    );
    await file.writeAsBytes(exportBytes, flush: true);

    return BackupExportResult(
      path: file.path,
      memoryCount: state.events.length,
      photoCount: state.photos
          .where((photo) => localToArchivePath.containsKey(photo.localPath))
          .length,
      wallItemCount: state.wallItems.length,
      isEncrypted: isEncrypted,
    );
  }

  Future<BackupImportData?> pickAndPrepareImport({String? password}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.single;
    final bytes = picked.bytes ?? await File(picked.path!).readAsBytes();
    final archive = await _decodeArchive(bytes, password: password);
    final files = {
      for (final file in archive)
        if (file.isFile) file.name: file,
    };
    final manifestFile = files[backupManifestName];
    if (manifestFile == null) {
      throw const BackupValidationException('Backup manifest is missing.');
    }

    final manifestBytes = manifestFile.readBytes();
    if (manifestBytes == null) {
      throw const BackupValidationException('Backup manifest is unreadable.');
    }

    final decoded = jsonDecode(utf8.decode(manifestBytes));
    if (decoded is! Map) {
      throw const BackupValidationException('Backup manifest is invalid.');
    }
    final payload = decoded.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    final referencedPhotoPaths = validateBackupPayload(
      payload,
      files.keys.toSet(),
    );
    final restoredPhotoPaths = await _restorePhotoFiles(
      referencedPhotoPaths,
      files,
    );

    return BackupImportData(
      events: _mapList(payload['events']),
      photos: _mapList(payload['photos']),
      people: _optionalMapList(payload['people']),
      connections: _mapList(payload['connections']),
      wallItems: _mapList(payload['wallItems']),
      photoPaths: restoredPhotoPaths,
    );
  }

  static Set<String> validateBackupPayload(
    Map<String, Object?> payload,
    Set<String> archiveFileNames,
  ) {
    if (payload['app'] != 'LifeThreads') {
      throw const BackupValidationException(
        'This is not a LifeThreads backup.',
      );
    }
    if (payload['formatVersion'] != formatVersion) {
      throw const BackupValidationException('Unsupported backup version.');
    }

    final events = _mapList(payload['events']);
    final photos = _mapList(payload['photos']);
    final people = _optionalMapList(payload['people']);
    final connections = _mapList(payload['connections']);
    final wallItems = _mapList(payload['wallItems']);

    final eventIds = <String>{};
    for (final event in events) {
      final id = _requiredString(event, 'id');
      _requiredString(event, 'title');
      eventIds.add(id);
    }

    final sourceIds = {...eventIds};
    for (final item in wallItems) {
      sourceIds.add(_requiredString(item, 'id'));
      _requiredString(item, 'type');
    }

    for (final connection in connections) {
      final fromId = _requiredString(connection, 'fromEventId');
      final toId = _requiredString(connection, 'toEventId');
      if (!sourceIds.contains(fromId) || !sourceIds.contains(toId)) {
        throw const BackupValidationException(
          'Backup has a connection to a missing wall item.',
        );
      }
    }

    final referencedPhotoPaths = <String>{};
    for (final event in events) {
      final coverPhotoPath = event['coverPhotoPath'];
      if (coverPhotoPath is String && coverPhotoPath.isNotEmpty) {
        _validateArchivePath(coverPhotoPath, archiveFileNames);
        referencedPhotoPaths.add(coverPhotoPath);
      }
    }

    for (final photo in photos) {
      final eventId = _requiredString(photo, 'eventId');
      if (!eventIds.contains(eventId)) {
        throw BackupValidationException(
          'Photo references missing memory $eventId.',
        );
      }
      final localPath = _requiredString(photo, 'localPath');
      _validateArchivePath(localPath, archiveFileNames);
      referencedPhotoPaths.add(localPath);
    }

    for (final person in people) {
      final eventId = _requiredString(person, 'eventId');
      if (!eventIds.contains(eventId)) {
        throw BackupValidationException(
          'Person references missing memory $eventId.',
        );
      }
      _requiredString(person, 'name');
      _requiredString(person, 'relationship');
    }

    return referencedPhotoPaths;
  }

  Future<List<int>> _encryptArchive(
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
            'encryptedArchiveVersion': encryptedArchiveVersion,
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

  Future<Archive> _decodeArchive(List<int> bytes, {String? password}) async {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final files = {
      for (final file in archive)
        if (file.isFile) file.name: file,
    };
    if (!files.containsKey(encryptedManifestName)) return archive;

    final importPassword = password?.trim() ?? '';
    if (importPassword.isEmpty) {
      throw const BackupValidationException(
        'This archive is encrypted. Enter its password to import it.',
      );
    }

    final manifestBytes = files[encryptedManifestName]?.readBytes();
    final payloadBytes = files[encryptedPayloadName]?.readBytes();
    if (manifestBytes == null || payloadBytes == null) {
      throw const BackupValidationException('Encrypted archive is incomplete.');
    }

    final decoded = jsonDecode(utf8.decode(manifestBytes));
    if (decoded is! Map) {
      throw const BackupValidationException(
        'Encrypted archive manifest is invalid.',
      );
    }
    final manifest = decoded.map((key, value) => MapEntry('$key', value));
    if (manifest['app'] != 'LifeThreads' ||
        manifest['encryptedArchiveVersion'] != encryptedArchiveVersion) {
      throw const BackupValidationException(
        'Unsupported encrypted archive version.',
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
        'Archive password is incorrect or the archive is damaged.',
      );
    }
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
    final photosDir = await _memoryPhotosDirectory();
    const uuid = Uuid();
    final restored = <String, String>{};

    for (final archivePath in referencedPhotoPaths) {
      final archiveFile = files[archivePath];
      final bytes = archiveFile?.readBytes();
      if (bytes == null) {
        throw BackupValidationException('Photo file is missing: $archivePath.');
      }

      final extension = p.extension(archivePath).isEmpty
          ? '.jpg'
          : p.extension(archivePath);
      final file = File(
        p.join(photosDir.path, 'restore_${uuid.v4()}$extension'),
      );
      await file.writeAsBytes(bytes, flush: true);
      restored[archivePath] = file.path;
    }

    return restored;
  }

  Future<Directory> _backupsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupsDir = Directory(p.join(directory.path, 'backups'));
    if (!await backupsDir.exists()) await backupsDir.create(recursive: true);
    return backupsDir;
  }

  Future<Directory> _memoryPhotosDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(directory.path, 'memory_photos'));
    if (!await photosDir.exists()) await photosDir.create(recursive: true);
    return photosDir;
  }

  String _photoArchiveName(String id, String localPath) {
    final extension = p.extension(localPath).isEmpty
        ? '.jpg'
        : p.extension(localPath);
    return 'photos/$id$extension';
  }

  static List<Map<String, Object?>> _mapList(Object? value) {
    if (value is! List) {
      throw const BackupValidationException('Backup data is incomplete.');
    }
    return [
      for (final item in value)
        if (item is Map)
          item.map((key, value) => MapEntry(key.toString(), value))
        else
          throw const BackupValidationException('Backup list item is invalid.'),
    ];
  }

  static List<Map<String, Object?>> _optionalMapList(Object? value) {
    if (value == null) return const [];
    return _mapList(value);
  }

  static String _requiredString(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is String && value.isNotEmpty) return value;
    throw BackupValidationException('Backup field "$key" is missing.');
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
        'Backup photo path is invalid: $archivePath.',
      );
    }
  }
}
