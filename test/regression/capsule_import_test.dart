import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends PathProviderPlatform with MockPlatformInterfaceMixin {
  _FakePaths(this.docs);
  final String docs;
  @override
  Future<String?> getApplicationDocumentsPath() async => docs;
}

void main() {
  test('rejected capsule must not leave orphaned photo files', () async {
    final docs = await Directory.systemTemp.createTemp('p3docs');
    PathProviderPlatform.instance = _FakePaths(docs.path);
    final archive = Archive()
      ..addFile(ArchiveFile.bytes('photos/p.jpg', [1, 2, 3, 4]))
      ..addFile(
        ArchiveFile.string(
          MemoryCapsuleService.manifestName,
          jsonEncode({
            'app': 'LifeThreads', 'type': 'memoryCapsule', 'capsuleVersion': 1,
            'events': [
              {'id': 'e', 'title': 'T'},
            ],
            'photos': [
              {'id': 'p', 'eventId': 'e', 'localPath': 'photos/p.jpg'},
            ],
            'relatedMemories':
                'not-a-list', // not checked by validateCapsulePayload
          }),
        ),
      );
    final bytes = ZipEncoder().encodeBytes(archive);
    await expectLater(
      const MemoryCapsuleService().prepareImportFromBytes(bytes),
      throwsA(isA<BackupValidationException>()),
    );
    final photosDir = Directory('${docs.path}/memory_photos');
    final leftovers = photosDir.existsSync() ? photosDir.listSync() : const [];
    expect(
      leftovers,
      isEmpty,
      reason: 'orphaned files after rejection: ${leftovers.map((f) => f.path)}',
    );
  });
}
