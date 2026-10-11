// Wall display: corrupt photos are skipped and only https QR codes are used.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/features/display/data/wall_display_service.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';

MemoryEvent _event(String cover) => MemoryEvent(
  id: 'e1',
  title: 't',
  description: 'd',
  category: MemoryCategory.values.first,
  memoryType: MemoryType.values.first,
  feeling: MemoryFeeling.values.first,
  occurredAt: DateTime(2024),
  createdAt: DateTime(2024),
  coverColor: const Color(0xFF112233),
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: '',
  coverPhotoPath: cover,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Object> publishWith(Uint8List bytes, String name) async {
    final dir = await Directory.systemTemp.createTemp('p4_display');
    final file = File('${dir.path}/$name')..writeAsBytesSync(bytes);
    const service = WallDisplayService(allowedHosts: {'127.0.0.1'});
    try {
      await service.publishSnapshot(
        // Port 1: connection refused locally, never reaches the network.
        scanUri: Uri.parse('http://127.0.0.1:1/display/s/connect?token=x'),
        state: MemoryState(
          events: [_event(file.path)],
          connections: const [],
          photos: const [],
          people: const [],
          wallItems: const [],
        ),
      );
      return 'no error';
    } catch (e) {
      return e;
    }
  }

  final good = img.encodeJpg(img.Image(width: 800, height: 600));

  test(
    'truncated JPEG cover -> WallDisplayException (not a raw error)',
    () async {
      final truncated = Uint8List.fromList(good.sublist(0, good.length ~/ 3));
      final error = await publishWith(truncated, 'cut.jpg');
      expect(
        error,
        isA<WallDisplayException>(),
        reason: 'got ${error.runtimeType}: $error',
      );
    },
  );

  test('JPEG header + garbage cover -> WallDisplayException', () async {
    final junk = Uint8List.fromList([
      ...good.sublist(0, 200),
      ...List.filled(500, 0x7f),
    ]);
    final error = await publishWith(junk, 'junk.jpg');
    expect(
      error,
      isA<WallDisplayException>(),
      reason: 'got ${error.runtimeType}: $error',
    );
  });

  test(
    'plain-http display QR (token + full wall snapshot in cleartext) is rejected',
    () {
      expect(
        const WallDisplayService().isDisplayScanLink(
          Uri.parse('http://display.gkcoding.dev/display/s/connect?token=x'),
        ),
        isFalse,
      );
    },
  );
}
