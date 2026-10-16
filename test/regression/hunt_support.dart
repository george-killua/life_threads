// Shared helpers for the hunt_* regression tests (not a test file).
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProvider(this.root);
  final String root;
  @override
  Future<String?> getApplicationDocumentsPath() async => root;
}

Directory installFakeDocs() {
  final dir = Directory.systemTemp.createTempSync('p2_backup_');
  PathProviderPlatform.instance = FakePathProvider(dir.path);
  return dir;
}

MemoryEvent event({
  String id = 'e1',
  String label = '',
  double? lat,
  double? lng,
}) => MemoryEvent(
  id: id,
  title: 'Title $id',
  description: 'd',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2025, 1, 1),
  createdAt: DateTime(2025, 1, 1),
  coverColor: const Color(0xFF112233),
  wallPosition: const Offset(10, 20),
  rotation: 0.1,
  locationLabel: label,
  latitude: lat,
  longitude: lng,
);

MemoryState stateWith(List<MemoryEvent> events) => MemoryState(
  events: events,
  connections: const [],
  photos: const [],
  people: const [],
  wallItems: const [],
);
