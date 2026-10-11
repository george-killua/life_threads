import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/map/presentation/widgets/memory_map_preview.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';

MemoryEvent ev(double lat, double lng) => MemoryEvent(
  id: 'm1',
  title: 'T',
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2024),
  createdAt: DateTime(2024),
  coverColor: const Color(0xFFD2A24A),
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: '',
  latitude: lat,
  longitude: lng,
);

void main() {
  for (final c in [(95.0, 10.0), (double.nan, double.nan)]) {
    testWidgets('map preview tolerates imported coords ${c.$1},${c.$2}', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MemoryMapPreview(event: ev(c.$1, c.$2))),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
