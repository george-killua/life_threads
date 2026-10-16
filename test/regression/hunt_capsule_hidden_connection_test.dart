// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// sharing a visible memory must not send a hidden connected memory's title,
// place and date along.
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_service.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';

import 'hunt_support.dart' show event;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory docs;
  setUp(() async {
    docs = await Directory.systemTemp.createTemp('seam_capsule_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
  });

  test('shared capsule does not reveal a hidden connected memory', () async {
    final visible = event(id: 'a');
    final secret = event(
      id: 'b',
      label: 'Secret clinic',
    ).copyWith(title: 'SECRET hidden memory', hidden: true);
    final state = MemoryState(
      events: [visible, secret],
      connections: const [
        MemoryConnection(id: 'c', fromEventId: 'a', toEventId: 'b', label: ''),
      ],
      photos: const [],
      people: const [],
      wallItems: const [],
    );
    final export = await const MemoryCapsuleService().exportCapsule(
      state: state,
      memoryId: 'a',
    );
    final zip = ZipDecoder().decodeBytes(File(export.path).readAsBytesSync());
    final manifest = String.fromCharCodes(
      zip.findFile(MemoryCapsuleService.manifestName)!.content as List<int>,
    );
    expect(manifest, isNot(contains('SECRET hidden memory')));
  });
}
