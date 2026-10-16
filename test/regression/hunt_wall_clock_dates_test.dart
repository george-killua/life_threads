// Regression tests from the 2026-10-16 whole-codebase bug hunt: memory dates
// are stored as wall-clock times, so they read the same in any time zone
// (they showed a day early after travelling west), and the v7 migration
// converts the instants older versions stored.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/database/app_database.dart';
import 'package:life_threads/core/database/wall_clock_time.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a date is stored as its calendar day and clock time', () {
    final taken = DateTime(2023, 6, 17, 18, 30);
    final stored = encodeWallClock(taken);
    // The same number in every time zone: 17 June 2023, 18:30 "as UTC".
    expect(stored, DateTime.utc(2023, 6, 17, 18, 30).millisecondsSinceEpoch);
    expect(decodeWallClock(stored), taken);
    expect(decodeWallClock(stored).isUtc, isFalse);
  });

  test('a UTC instant is stored as the local time it shows', () {
    final instant = DateTime.utc(2023, 6, 17, 12);
    expect(decodeWallClock(encodeWallClock(instant)), instant.toLocal());
  });

  group('migration to v7', () {
    late Directory docs;

    setUp(() async {
      docs = await Directory.systemTemp.createTemp('wall_clock_');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (call) async => docs.path,
          );
    });

    tearDown(() async {
      if (await docs.exists()) await docs.delete(recursive: true);
    });

    test('converts the stored instants of existing memories', () async {
      final taken = DateTime(2023, 6, 17, 18, 30);
      var database = AppDatabase();
      await database
          .into(database.memoryEvents)
          .insert(
            MemoryEventsCompanion.insert(
              id: 'old',
              title: 'Before the update',
              description: '',
              // What versions up to 6 stored: the local instant.
              occurredAt: taken.millisecondsSinceEpoch,
              createdAt: taken.millisecondsSinceEpoch,
              coverColorValue: 0xFF112233,
              wallX: 0,
              wallY: 0,
              rotation: 0,
              locationLabel: '',
            ),
          );
      await database.customStatement('PRAGMA user_version = 6');
      await database.close();

      database = AppDatabase();
      final row = await (database.select(
        database.memoryEvents,
      )..where((r) => r.id.equals('old'))).getSingle();
      await database.close();

      expect(row.occurredAt, encodeWallClock(taken));
      expect(decodeWallClock(row.occurredAt), taken);
    });
  });
}
