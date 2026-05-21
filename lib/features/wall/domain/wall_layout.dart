import 'package:flutter/material.dart';

import '../../memories/domain/memory_category.dart';
import '../../memories/domain/memory_event.dart';

enum WallLayoutMode {
  freeform('Freeform wall', Icons.open_with_rounded),
  timeline('Timeline wall', Icons.timeline_rounded),
  categoryCluster('Cluster by category', Icons.category_rounded),
  locationCluster('Cluster by location', Icons.place_rounded);

  const WallLayoutMode(this.label, this.icon);

  final String label;
  final IconData icon;
}

class WallLayoutEngine {
  const WallLayoutEngine._();

  static List<MemoryEvent> apply({
    required List<MemoryEvent> events,
    required WallLayoutMode mode,
    Map<String, Offset> manualOverrides = const {},
  }) {
    return switch (mode) {
      WallLayoutMode.freeform => _freeform(events, manualOverrides),
      WallLayoutMode.timeline => _timeline(events, manualOverrides),
      WallLayoutMode.categoryCluster => _categoryCluster(
        events,
        manualOverrides,
      ),
      WallLayoutMode.locationCluster => _locationCluster(
        events,
        manualOverrides,
      ),
    };
  }

  static List<MemoryEvent> _freeform(
    List<MemoryEvent> events,
    Map<String, Offset> manualOverrides,
  ) {
    return [
      for (final event in events)
        event.copyWith(
          wallPosition: manualOverrides[event.id] ?? event.wallPosition,
        ),
    ];
  }

  static List<MemoryEvent> _timeline(
    List<MemoryEvent> events,
    Map<String, Offset> manualOverrides,
  ) {
    final sorted = [...events]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    return [
      for (var index = 0; index < sorted.length; index++)
        sorted[index].copyWith(
          wallPosition:
              manualOverrides[sorted[index].id] ??
              Offset(150 + (index.isEven ? 0 : 360), 165 + index * 165),
        ),
    ];
  }

  static List<MemoryEvent> _categoryCluster(
    List<MemoryEvent> events,
    Map<String, Offset> manualOverrides,
  ) {
    final output = <MemoryEvent>[];
    for (final category in MemoryCategory.values) {
      final group = events.where((event) => event.category == category).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      final groupIndex = MemoryCategory.values.indexOf(category);
      for (var index = 0; index < group.length; index++) {
        final event = group[index];
        output.add(
          event.copyWith(
            wallPosition:
                manualOverrides[event.id] ??
                Offset(105 + groupIndex * 365, 160 + index * 205),
          ),
        );
      }
    }
    return output;
  }

  static List<MemoryEvent> _locationCluster(
    List<MemoryEvent> events,
    Map<String, Offset> manualOverrides,
  ) {
    final groups = <String, List<MemoryEvent>>{};
    for (final event in events) {
      groups.putIfAbsent(_locationKey(event), () => []).add(event);
    }

    final keys = groups.keys.toList()..sort();
    final output = <MemoryEvent>[];
    for (var groupIndex = 0; groupIndex < keys.length; groupIndex++) {
      final group = groups[keys[groupIndex]]!
        ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
      for (var index = 0; index < group.length; index++) {
        final event = group[index];
        output.add(
          event.copyWith(
            wallPosition:
                manualOverrides[event.id] ??
                Offset(
                  115 + (groupIndex % 3) * 370,
                  165 + (groupIndex ~/ 3) * 420 + index * 180,
                ),
          ),
        );
      }
    }
    return output;
  }

  static String _locationKey(MemoryEvent event) {
    if (event.latitude != null && event.longitude != null) {
      return '${event.latitude!.toStringAsFixed(1)},${event.longitude!.toStringAsFixed(1)}';
    }
    final location = event.locationLabel.trim();
    if (location.isEmpty) return 'Unknown place';
    return location.split(',').first.trim().toLowerCase();
  }
}
