// Regression tests from the 2026-10-16 whole-codebase bug hunt: memory capsule
// export/import.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_service.dart';

import 'hunt_support.dart' show event, stateWith;

late Directory docs;

/// Rewrites the declared uncompressed size of every entry to [size].
Uint8List _lieAboutSizes(List<int> zip, int size) {
  final b = Uint8List.fromList(zip);
  final v = ByteData.sublistView(b);
  for (var i = 0; i + 4 < b.length; i++) {
    final sig = v.getUint32(i, Endian.little);
    if (sig == 0x04034b50) v.setUint32(i + 22, size, Endian.little);
    if (sig == 0x02014b50) v.setUint32(i + 24, size, Endian.little);
  }
  return b;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    docs = await Directory.systemTemp.createTemp('c1_capsule_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
  });
  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  Future<Map<String, Object?>> roundTrip(
    String label,
    double? lat,
    double? lng,
  ) async {
    const service = MemoryCapsuleService();
    final export = await service.exportCapsule(
      state: stateWith([event(label: label, lat: lat, lng: lng)]),
      memoryId: 'e1',
    );
    final draft = await service.prepareImportFromBytes(
      File(export.path).readAsBytesSync(),
    );
    return draft.backup.events.single;
  }

  test(
    'C1-03a capsule keeps the place name of a memory without coordinates',
    () async {
      final e = await roundTrip("Grandma's house", null, null);
      expect(e['locationLabel'], "Grandma's house");
    },
  );

  test('C1-03b capsule does not invent a coordinate text label', () async {
    final e = await roundTrip('', 48.8566, 2.3522);
    expect(e['locationLabel'], '');
  });

  test(
    'regression P3-09: entry lying about its size cannot inflate past it',
    () async {
      final inner = Archive()
        ..addFile(
          ArchiveFile.string(
            MemoryCapsuleService.manifestName,
            jsonEncode({'app': 'LifeThreads'}),
          ),
        )
        ..addFile(ArchiveFile.bytes('photos/bomb.jpg', Uint8List(200 << 20)));
      final bomb = _lieAboutSizes(ZipEncoder().encodeBytes(inner), 1000);
      expect(bomb.length, lessThan(25 << 20));
      await expectLater(
        const MemoryCapsuleService().prepareImportFromBytes(bomb),
        throwsA(anything),
      );
      final dir = Directory('${docs.path}/memory_photos');
      expect(dir.existsSync() ? dir.listSync() : const [], isEmpty);
    },
  );

  test(
    'regression: whitespace password rejected; wrong password rejected',
    () async {
      const service = MemoryCapsuleService();
      await expectLater(
        service.exportCapsule(
          state: stateWith([event()]),
          memoryId: 'e1',
          password: '  ',
        ),
        throwsA(isA<BackupValidationException>()),
      );
      final enc = await service.exportCapsule(
        state: stateWith([event()]),
        memoryId: 'e1',
        password: 'pw',
      );
      await expectLater(
        service.prepareImportFromBytes(
          File(enc.path).readAsBytesSync(),
          password: 'nope',
        ),
        throwsA(isA<BackupValidationException>()),
      );
    },
  );
}
