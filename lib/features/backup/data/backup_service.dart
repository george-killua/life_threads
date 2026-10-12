import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
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

  /// Version 2 encrypts in 1 MiB chunks; version 1 (one AES-GCM pass over
  /// the whole zip, held in memory) is still read.
  static const encryptedArchiveVersion = 2;
  static const _legacyEncryptedArchiveVersion = 1;
  static const _chunkSize = 1 << 20;
  static const _macLength = 16;
  static const _kdfIterations = 120000;

  /// Writes one zip with every memory, note, thread and photo. Photos are
  /// streamed from disk (and through the cipher when a password is set), so
  /// memory use stays flat however large the library is. The file goes to the
  /// temporary directory: it is handed to the share sheet and deleted with
  /// [deleteExportedArchives]; it is never kept inside the app's backed-up
  /// documents.
  Future<BackupExportResult> exportBackup(
    MemoryState state, {
    String? password,
  }) async {
    final exportPassword = _exportPassword(password);
    final isEncrypted = exportPassword.isNotEmpty;
    await deleteExportedArchives();
    final workDir = await _exportDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '')
        .replaceAll('.', '-');
    final archivePath = p.join(
      workDir.path,
      isEncrypted
          ? 'lifethreads_encrypted_$timestamp.zip'
          : 'lifethreads_$timestamp.zip',
    );
    final plainPath = isEncrypted
        ? p.join(workDir.path, 'plain_$timestamp.zip')
        : archivePath;

    final localToArchivePath = <String, String>{};
    final zip = ZipFileEncoder()
      ..create(plainPath, level: ZipFileEncoder.store);
    try {
      for (final photo in state.photos) {
        await _addPhotoFile(
          zip: zip,
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
          zip: zip,
          localToArchivePath: localToArchivePath,
          localPath: coverPath,
          archiveName: _photoArchiveName('cover_${event.id}', coverPath),
        );
      }

      zip.addArchiveFile(
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
    } finally {
      await zip.close();
    }

    if (isEncrypted) {
      try {
        await _encryptArchiveFile(
          plainPath: plainPath,
          archivePath: archivePath,
          password: exportPassword,
        );
      } finally {
        await _deleteIfExists(plainPath);
      }
    }

    return BackupExportResult(
      path: archivePath,
      memoryCount: state.events.length,
      photoCount: state.photos
          .where((photo) => localToArchivePath.containsKey(photo.localPath))
          .length,
      wallItemCount: state.wallItems.length,
      isEncrypted: isEncrypted,
    );
  }

  /// Removes exported archives once they have been shared, and the copies
  /// older versions kept in the app's documents (`backups/`), which were
  /// included in device backups and never cleaned up.
  Future<void> deleteExportedArchives() async {
    for (final directory in [
      await _exportDirectory(create: false),
      await _legacyBackupsDirectory(),
    ]) {
      if (await directory.exists()) await directory.delete(recursive: true);
    }
  }

  Future<BackupImportData?> pickAndPrepareImport({String? password}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
    );
    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.single;
    final path = picked.path;
    if (path != null) return prepareImportFile(path, password: password);
    return prepareImportBytes(await picked.readAsBytes(), password: password);
  }

  Future<BackupImportData> prepareImportBytes(
    List<int> bytes, {
    String? password,
  }) async {
    final workDir = await _importDirectory();
    final file = File(p.join(workDir.path, 'picked_${const Uuid().v4()}.zip'));
    await file.writeAsBytes(bytes, flush: true);
    try {
      return await prepareImportFile(file.path, password: password);
    } finally {
      await _deleteIfExists(file.path);
    }
  }

  /// Reads an archive from disk without loading it into memory: an encrypted
  /// payload is decrypted to a temporary zip, and photos are copied straight
  /// from the zip into the app's photo folder.
  Future<BackupImportData> prepareImportFile(
    String path, {
    String? password,
  }) async {
    final workDir = await _importDirectory();
    final temporaryFiles = <String>[];
    final inputs = <InputFileStream>[];
    try {
      final archive = await _openArchive(
        path,
        password: password,
        workDir: workDir,
        temporaryFiles: temporaryFiles,
        inputs: inputs,
      );
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
    } on FormatException {
      throw const BackupValidationException(
        'This file is not a valid archive.',
      );
    } finally {
      for (final input in inputs) {
        await input.close();
      }
      for (final file in temporaryFiles) {
        await _deleteIfExists(file);
      }
    }
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

  /// Encrypts [plainPath] into a zip holding the ciphertext and a manifest
  /// with the key derivation parameters. The payload is a series of AES-GCM
  /// chunks (ciphertext + MAC each), so neither side needs the whole archive
  /// in memory: the cipher package's streaming GCM keeps all input until the
  /// end.
  Future<void> _encryptArchiveFile({
    required String plainPath,
    required String archivePath,
    required String password,
  }) async {
    final random = Random.secure();
    final salt = _secureBytes(random, 32);
    final noncePrefix = _secureBytes(random, 8);
    final secretKey = await _deriveKey(password, salt);
    final payloadPath = '$plainPath.payload';
    try {
      final input = await File(plainPath).open();
      final output = await File(payloadPath).open(mode: FileMode.write);
      try {
        final length = await input.length();
        final chunks = max(1, (length + _chunkSize - 1) ~/ _chunkSize);
        final cipher = AesGcm.with256bits();
        for (var index = 0; index < chunks; index++) {
          final box = await cipher.encrypt(
            await input.read(_chunkSize),
            secretKey: secretKey,
            nonce: _chunkNonce(noncePrefix, index),
            aad: _chunkAad(isLast: index == chunks - 1),
          );
          await output.writeFrom(box.cipherText);
          await output.writeFrom(box.mac.bytes);
        }
      } finally {
        await input.close();
        await output.close();
      }

      final wrapper = ZipFileEncoder()..create(archivePath);
      try {
        await _addStoredFile(wrapper, payloadPath, encryptedPayloadName);
        wrapper.addArchiveFile(
          ArchiveFile.string(
            encryptedManifestName,
            jsonEncode({
              'app': 'LifeThreads',
              'encryptedArchiveVersion': encryptedArchiveVersion,
              'algorithm': 'AES-256-GCM, 1 MiB chunks',
              'kdf': 'PBKDF2-HMAC-SHA256',
              'iterations': _kdfIterations,
              'salt': base64Encode(salt),
              'noncePrefix': base64Encode(noncePrefix),
              'chunkSize': _chunkSize,
              'createdAt': DateTime.now().toIso8601String(),
            }),
          ),
        );
      } finally {
        await wrapper.close();
      }
    } finally {
      await _deleteIfExists(payloadPath);
    }
  }

  Future<void> _decryptChunks({
    required String payloadPath,
    required String plainPath,
    required SecretKey secretKey,
    required List<int> noncePrefix,
    required int chunkSize,
  }) async {
    final input = await File(payloadPath).open();
    final output = await File(plainPath).open(mode: FileMode.write);
    try {
      final length = await input.length();
      final cipher = AesGcm.with256bits();
      var position = 0;
      var index = 0;
      do {
        final stored = min(chunkSize + _macLength, length - position);
        if (stored < _macLength) {
          throw const BackupValidationException(
            'Encrypted archive is damaged.',
          );
        }
        final bytes = await input.read(stored);
        position += stored;
        final clear = await cipher.decrypt(
          SecretBox(
            bytes.sublist(0, stored - _macLength),
            nonce: _chunkNonce(noncePrefix, index),
            mac: Mac(bytes.sublist(stored - _macLength)),
          ),
          secretKey: secretKey,
          aad: _chunkAad(isLast: position == length),
        );
        await output.writeFrom(clear);
        index++;
      } while (position < length);
    } finally {
      await input.close();
      await output.close();
    }
  }

  /// 8 random bytes and the chunk number: unique per chunk and archive.
  List<int> _chunkNonce(List<int> prefix, int index) => [
    ...prefix,
    (index >> 24) & 0xff,
    (index >> 16) & 0xff,
    (index >> 8) & 0xff,
    index & 0xff,
  ];

  /// Marks the final chunk, so a payload cut at a chunk boundary is rejected.
  List<int> _chunkAad({required bool isLast}) => [isLast ? 1 : 0];

  Future<Archive> _openArchive(
    String path, {
    required String? password,
    required Directory workDir,
    required List<String> temporaryFiles,
    required List<InputFileStream> inputs,
  }) async {
    final input = InputFileStream(path);
    inputs.add(input);
    final archive = ZipDecoder().decodeStream(input, verify: true);
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
    final payloadFile = files[encryptedPayloadName];
    if (manifestBytes == null || payloadFile == null) {
      throw const BackupValidationException('Encrypted archive is incomplete.');
    }

    final decoded = jsonDecode(utf8.decode(manifestBytes));
    if (decoded is! Map) {
      throw const BackupValidationException(
        'Encrypted archive manifest is invalid.',
      );
    }
    final manifest = decoded.map((key, value) => MapEntry('$key', value));
    final version = manifest['encryptedArchiveVersion'];
    if (manifest['app'] != 'LifeThreads' ||
        (version != encryptedArchiveVersion &&
            version != _legacyEncryptedArchiveVersion)) {
      throw const BackupValidationException(
        'Unsupported encrypted archive version.',
      );
    }

    final id = const Uuid().v4();
    final payloadPath = p.join(workDir.path, 'payload_$id.bin');
    final plainPath = p.join(workDir.path, 'plain_$id.zip');
    temporaryFiles.addAll([payloadPath, plainPath]);
    final payloadOutput = OutputFileStream(payloadPath);
    payloadFile.writeContent(payloadOutput);
    await payloadOutput.close();

    try {
      final salt = base64Decode(_requiredString(manifest, 'salt'));
      final secretKey = await _deriveKey(importPassword, salt);
      if (version == _legacyEncryptedArchiveVersion) {
        final clear = await AesGcm.with256bits().decrypt(
          SecretBox(
            await File(payloadPath).readAsBytes(),
            nonce: base64Decode(_requiredString(manifest, 'nonce')),
            mac: Mac(base64Decode(_requiredString(manifest, 'mac'))),
          ),
          secretKey: secretKey,
        );
        await File(plainPath).writeAsBytes(clear, flush: true);
      } else {
        final chunkSize = manifest['chunkSize'];
        if (chunkSize is! int || chunkSize <= 0 || chunkSize > 64 << 20) {
          throw const BackupValidationException(
            'Encrypted archive manifest is invalid.',
          );
        }
        await _decryptChunks(
          payloadPath: payloadPath,
          plainPath: plainPath,
          secretKey: secretKey,
          noncePrefix: base64Decode(_requiredString(manifest, 'noncePrefix')),
          chunkSize: chunkSize,
        );
      }
      await _deleteIfExists(payloadPath);
    } on BackupValidationException {
      rethrow;
    } catch (_) {
      throw const BackupValidationException(
        'Archive password is incorrect or the archive is damaged.',
      );
    }

    final plainInput = InputFileStream(plainPath);
    inputs.add(plainInput);
    try {
      return ZipDecoder().decodeStream(plainInput, verify: true);
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
    required ZipFileEncoder zip,
    required Map<String, String> localToArchivePath,
    required String localPath,
    required String archiveName,
  }) async {
    final file = File(localPath);
    if (!await file.exists()) return;

    localToArchivePath[localPath] = archiveName;
    await _addStoredFile(zip, localPath, archiveName);
  }

  /// Adds a file without compression. Photos and ciphertext do not shrink,
  /// and the encoder buffers compressed entries in memory but streams stored
  /// ones from disk.
  Future<void> _addStoredFile(
    ZipFileEncoder zip,
    String path,
    String archiveName,
  ) async {
    final input = InputFileStream(path);
    try {
      zip.addArchiveFile(
        ArchiveFile.stream(archiveName, input)
          ..compression = CompressionType.none
          ..lastModTime =
              (await File(path).lastModified()).millisecondsSinceEpoch ~/ 1000,
      );
    } finally {
      await input.close();
    }
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
      if (archiveFile == null) {
        throw BackupValidationException('Photo file is missing: $archivePath.');
      }

      final extension = p.extension(archivePath).isEmpty
          ? '.jpg'
          : p.extension(archivePath);
      final file = File(
        p.join(photosDir.path, 'restore_${uuid.v4()}$extension'),
      );
      final output = OutputFileStream(file.path);
      archiveFile.writeContent(output);
      await output.close();
      restored[archivePath] = file.path;
    }

    return restored;
  }

  /// Exports live in the temporary directory, which neither iCloud nor
  /// Android backups include.
  Future<Directory> _exportDirectory({bool create = true}) async {
    final directory = await getTemporaryDirectory();
    final exportDir = Directory(p.join(directory.path, 'lifethreads_export'));
    if (create && !await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }

  Future<Directory> _importDirectory() async {
    final directory = await getTemporaryDirectory();
    final importDir = Directory(p.join(directory.path, 'lifethreads_import'));
    if (!await importDir.exists()) await importDir.create(recursive: true);
    return importDir;
  }

  Future<Directory> _legacyBackupsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return Directory(p.join(directory.path, 'backups'));
  }

  Future<void> _deleteIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
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

  /// Empty means "no password". A password made only of spaces is rejected
  /// rather than silently producing an unencrypted file.
  String _exportPassword(String? password) {
    final trimmed = password?.trim() ?? '';
    if (trimmed.isEmpty && (password?.isNotEmpty ?? false)) {
      throw const BackupValidationException(
        'A password cannot be only spaces.',
      );
    }
    return trimmed;
  }
}
