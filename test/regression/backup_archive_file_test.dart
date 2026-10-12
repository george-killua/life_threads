import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/data/backup_service.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_photo.dart';
import 'package:path/path.dart' as p;

import 'backup_support.dart';

MemoryState _stateWithPhotos(Directory docs) {
  final random = Random(7);
  final photos = [
    for (var i = 0; i < 3; i++)
      File(p.join(docs.path, 'memory_photos', 'photo_$i.jpg'))
        ..createSync(recursive: true)
        // Random bytes stand in for JPEG data and do not compress.
        ..writeAsBytesSync(List.generate(300000, (_) => random.nextInt(256))),
  ];
  return MemoryState(
    events: [event(id: 'e1').copyWith(coverPhotoPath: photos.first.path)],
    connections: const [],
    photos: [
      for (final (i, file) in photos.indexed)
        MemoryPhoto(
          id: 'p$i',
          eventId: 'e1',
          localPath: file.path,
          capturedAt: DateTime(2025),
          width: 1,
          height: 1,
        ),
    ],
    people: const [],
    wallItems: const [],
  );
}

void main() {
  late Directory docs;
  const service = BackupService();

  setUp(() => docs = installFakeDocs());
  tearDown(() => docs.deleteSync(recursive: true));

  test('encrypted export round-trips every photo byte for byte', () async {
    final state = _stateWithPhotos(docs);
    final result = await service.exportBackup(state, password: 'secret');
    expect(result.isEncrypted, isTrue);
    expect(result.photoCount, 3);

    final data = await service.prepareImportFile(
      result.path,
      password: 'secret',
    );
    expect(data.photos, hasLength(3));
    for (final photo in data.photos) {
      final original = state.photos.firstWhere((o) => o.id == photo['id']);
      final restored = data.photoPaths[photo['localPath']]!;
      expect(
        File(restored).readAsBytesSync(),
        File(original.localPath).readAsBytesSync(),
      );
    }
  });

  test('a wrong password is rejected', () async {
    final result = await service.exportBackup(
      _stateWithPhotos(docs),
      password: 'secret',
    );
    await expectLater(
      service.prepareImportFile(result.path, password: 'wrong'),
      throwsA(isA<BackupValidationException>()),
    );
  });

  test(
    'exports go to the temporary folder, not the backed-up documents',
    () async {
      final result = await service.exportBackup(_stateWithPhotos(docs));
      expect(p.isWithin(p.join(docs.path, 'tmp'), result.path), isTrue);
      expect(Directory(p.join(docs.path, 'backups')).existsSync(), isFalse);
    },
  );

  test('cleanup removes shared exports and legacy document backups', () async {
    final legacy = File(p.join(docs.path, 'backups', 'old.zip'))
      ..createSync(recursive: true);
    final result = await service.exportBackup(_stateWithPhotos(docs));

    await service.deleteExportedArchives();

    expect(File(result.path).existsSync(), isFalse);
    expect(legacy.existsSync(), isFalse);
  });

  test(
    'archives encrypted in one piece by older versions still import',
    () async {
      final plain = await service.exportBackup(_stateWithPhotos(docs));
      final plainBytes = File(plain.path).readAsBytesSync();

      // The pre-streaming writer: AES-GCM over the whole zip in memory.
      final salt = List.generate(32, (i) => i);
      final nonce = List.generate(12, (i) => i);
      final key = await Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 120000,
        bits: 256,
      ).deriveKey(secretKey: SecretKey(utf8.encode('old')), nonce: salt);
      final box = await AesGcm.with256bits().encrypt(
        plainBytes,
        secretKey: key,
        nonce: nonce,
      );
      final legacy = ZipEncoder().encodeBytes(
        Archive()
          ..addFile(
            ArchiveFile.string(
              BackupService.encryptedManifestName,
              jsonEncode({
                'app': 'LifeThreads',
                'encryptedArchiveVersion': 1,
                'salt': base64Encode(salt),
                'nonce': base64Encode(nonce),
                'mac': base64Encode(box.mac.bytes),
              }),
            ),
          )
          ..addFile(
            ArchiveFile.bytes(
              BackupService.encryptedPayloadName,
              box.cipherText,
            ),
          ),
      );

      final data = await service.prepareImportBytes(legacy, password: 'old');
      expect(data.photos, hasLength(3));
    },
  );
}
