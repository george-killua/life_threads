import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/data/backup_service.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';

import 'backup_support.dart';

void main() {
  test('export rejects a password made only of spaces', () async {
    installFakeDocs();
    const service = BackupService();

    await expectLater(
      service.exportBackup(stateWith([event()]), password: '   '),
      throwsA(isA<BackupValidationException>()),
    );
  });

  test('export without a password still writes a plain archive', () async {
    installFakeDocs();
    const service = BackupService();

    final result = await service.exportBackup(stateWith([event()]));

    expect(result.isEncrypted, isFalse);
  });
}
