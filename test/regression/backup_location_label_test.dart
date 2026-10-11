import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/data/backup_service.dart';
import 'backup_support.dart';

void main() {
  test(
    'round-trip keeps locationLabel of a memory without coordinates',
    () async {
      installFakeDocs();
      const svc = BackupService();
      final result = await svc.exportBackup(
        stateWith([event(label: 'Grandma\'s house')]),
      );
      final data = await svc.prepareImportBytes(
        await File(result.path).readAsBytes(),
      );
      expect(data.events.single['locationLabel'], "Grandma's house");
    },
  );
}
