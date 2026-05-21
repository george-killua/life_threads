import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_service.dart';

void main() {
  group('MemoryCapsuleService validation', () {
    test('accepts a valid single-memory capsule payload', () {
      final paths = MemoryCapsuleService.validateCapsulePayload(
        {
          'app': 'LifeThreads',
          'type': 'memoryCapsule',
          'capsuleVersion': 1,
          'events': [
            {
              'id': 'memory-1',
              'title': 'Vienna arrival',
              'coverPhotoPath': 'photos/cover.jpg',
            },
          ],
          'photos': [
            {
              'id': 'photo-1',
              'eventId': 'memory-1',
              'localPath': 'photos/photo-1.jpg',
            },
          ],
          'wallItems': [
            {'id': 'note-1', 'type': 'text', 'content': 'First night'},
          ],
          'connections': [
            {
              'id': 'connection-1',
              'fromEventId': 'memory-1',
              'toEventId': 'note-1',
            },
          ],
          'people': [],
          'relatedMemories': [],
        },
        {'lifethreads-capsule.json', 'photos/cover.jpg', 'photos/photo-1.jpg'},
      );

      expect(paths, {'photos/cover.jpg', 'photos/photo-1.jpg'});
    });

    test('rejects capsules with more than one memory', () {
      expect(
        () => MemoryCapsuleService.validateCapsulePayload(
          {
            'app': 'LifeThreads',
            'type': 'memoryCapsule',
            'capsuleVersion': 1,
            'events': [
              {'id': 'memory-1', 'title': 'One'},
              {'id': 'memory-2', 'title': 'Two'},
            ],
            'photos': [],
            'wallItems': [],
            'connections': [],
            'people': [],
            'relatedMemories': [],
          },
          {'lifethreads-capsule.json'},
        ),
        throwsA(isA<BackupValidationException>()),
      );
    });

    test('prepares import draft from capsule bytes', () async {
      final archive = Archive()
        ..addFile(
          ArchiveFile.string(
            MemoryCapsuleService.manifestName,
            jsonEncode({
              'app': 'LifeThreads',
              'type': 'memoryCapsule',
              'capsuleVersion': 1,
              'events': [
                {'id': 'memory-1', 'title': 'Shared memory'},
              ],
              'photos': [],
              'people': [],
              'wallItems': [],
              'connections': [],
              'relatedMemories': [],
            }),
          ),
        );

      final draft = await const MemoryCapsuleService().prepareImportFromBytes(
        ZipEncoder().encodeBytes(archive),
      );

      expect(draft.preview.title, 'Shared memory');
      expect(draft.backup.events.single['id'], 'memory-1');
    });
  });
}
