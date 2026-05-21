import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/wall/domain/wall_layout.dart';

void main() {
  group('WallLayoutEngine', () {
    test('timeline layout orders memories by date', () {
      final older = _event(
        id: 'older',
        date: DateTime(2020),
        category: MemoryCategory.travel,
      );
      final newer = _event(
        id: 'newer',
        date: DateTime(2024),
        category: MemoryCategory.personal,
      );

      final result = WallLayoutEngine.apply(
        events: [newer, older],
        mode: WallLayoutMode.timeline,
      );

      expect(result.map((event) => event.id), ['older', 'newer']);
      expect(
        result.first.wallPosition.dy,
        lessThan(result.last.wallPosition.dy),
      );
    });

    test('manual overrides win over computed layouts', () {
      final event = _event(
        id: 'memory',
        date: DateTime(2024),
        category: MemoryCategory.family,
      );
      const override = Offset(777, 888);

      final result = WallLayoutEngine.apply(
        events: [event],
        mode: WallLayoutMode.categoryCluster,
        manualOverrides: {'memory': override},
      );

      expect(result.single.wallPosition, override);
    });
  });
}

MemoryEvent _event({
  required String id,
  required DateTime date,
  required MemoryCategory category,
}) {
  return MemoryEvent(
    id: id,
    title: id,
    description: 'Story',
    category: category,
    memoryType: MemoryType.moment,
    feeling: MemoryFeeling.warm,
    occurredAt: date,
    createdAt: date,
    coverColor: Colors.amber,
    wallPosition: const Offset(10, 20),
    rotation: 0,
    locationLabel: 'Linz, Austria',
  );
}
