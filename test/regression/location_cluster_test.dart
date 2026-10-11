import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/wall/domain/wall_layout.dart';

MemoryEvent _e(String id, double lat, double lng) => MemoryEvent(
  id: id,
  title: id,
  description: '',
  category: MemoryCategory.travel,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2024),
  createdAt: DateTime(2024),
  coverColor: Colors.amber,
  wallPosition: Offset.zero,
  rotation: 0,
  latitude: lat,
  longitude: lng,
  locationLabel: "",
);

void main() {
  test('points ~1km apart in the same 0.1deg bucket share a cluster', () {
    // London (Greenwich): longitude -0.004 vs +0.004 both round to 0.0
    final out = WallLayoutEngine.apply(
      events: [_e('west', 51.48, -0.004), _e('east', 51.48, 0.004)],
      mode: WallLayoutMode.locationCluster,
    );
    // same cluster => same column x
    expect(out[0].wallPosition.dx, out[1].wallPosition.dx);
  });
}
