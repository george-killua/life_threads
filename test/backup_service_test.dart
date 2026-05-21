import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/data/backup_service.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';

void main() {
  group('BackupService validation', () {
    test('accepts a valid LifeThreads backup payload', () {
      final paths = BackupService.validateBackupPayload(
        {
          'app': 'LifeThreads',
          'formatVersion': 1,
          'events': [
            {
              'id': 'memory-1',
              'title': 'First memory',
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
          'connections': [],
          'wallItems': [],
        },
        {'lifethreads-backup.json', 'photos/cover.jpg', 'photos/photo-1.jpg'},
      );

      expect(paths, {'photos/cover.jpg', 'photos/photo-1.jpg'});
    });

    test('rejects missing referenced photo files', () {
      expect(
        () => BackupService.validateBackupPayload(
          {
            'app': 'LifeThreads',
            'formatVersion': 1,
            'events': [
              {'id': 'memory-1', 'title': 'First memory'},
            ],
            'photos': [
              {
                'id': 'photo-1',
                'eventId': 'memory-1',
                'localPath': 'photos/missing.jpg',
              },
            ],
            'connections': [],
            'wallItems': [],
          },
          {'lifethreads-backup.json'},
        ),
        throwsA(isA<BackupValidationException>()),
      );
    });
  });
}
