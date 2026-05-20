import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class MemoryEvents extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text().withDefault(const Constant('personal'))();
  TextColumn get memoryType => text().withDefault(const Constant('moment'))();
  TextColumn get feeling => text().withDefault(const Constant('warm'))();
  IntColumn get occurredAt => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get coverColorValue => integer()();
  RealColumn get wallX => real()();
  RealColumn get wallY => real()();
  RealColumn get rotation => real()();
  TextColumn get locationLabel => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get coverPhotoPath => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MemoryPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text()();
  TextColumn get localPath => text()();
  TextColumn get originalAssetId => text().nullable()();
  IntColumn get capturedAt => integer()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MemoryConnections extends Table {
  TextColumn get id => text()();
  TextColumn get fromEventId => text()();
  TextColumn get toEventId => text()();
  TextColumn get label => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WallItems extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
  RealColumn get wallX => real()();
  RealColumn get wallY => real()();
  IntColumn get colorValue => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [MemoryEvents, MemoryPhotos, MemoryConnections, WallItems],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(memoryEvents, memoryEvents.category);
      }
      if (from < 3) {
        await migrator.createTable(wallItems);
      }
      if (from < 4) {
        await migrator.addColumn(memoryEvents, memoryEvents.memoryType);
        await migrator.addColumn(memoryEvents, memoryEvents.feeling);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'life_threads.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
