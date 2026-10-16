import 'dart:math' as math;

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

  /// The lowest a card may start: the wall board is 80000 px tall.
  static const _lastRowY = 76000.0;

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

    // Long walls continue in the next pair of columns, so every card
    // stays on the board.
    final perColumn = ((_lastRowY - 165) ~/ 165) + 1;
    return [
      for (var index = 0; index < sorted.length; index++)
        sorted[index].copyWith(
          wallPosition:
              manualOverrides[sorted[index].id] ??
              Offset(
                150 + (index ~/ perColumn) * 820 + (index.isEven ? 0 : 360),
                165 + (index % perColumn) * 165,
              ),
        ),
    ];
  }

  static List<MemoryEvent> _categoryCluster(
    List<MemoryEvent> events,
    Map<String, Offset> manualOverrides,
  ) {
    final output = <MemoryEvent>[];
    final categories = MemoryCategory.values.length;
    final perColumn = ((_lastRowY - 160) ~/ 205) + 1;
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
                Offset(
                  // A very long category continues to the right of all
                  // the others.
                  105 + (groupIndex + (index ~/ perColumn) * categories) * 365,
                  160 + (index % perColumn) * 205,
                ),
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
    // Places sit three to a row; a row is as tall as its longest place, and
    // when the board's bottom is reached the next rows start further right.
    final perColumn = ((_lastRowY - 165) ~/ 180) + 1;
    var rowTop = 165.0;
    var blockLeft = 115.0;
    for (var rowStart = 0; rowStart < keys.length; rowStart += 3) {
      final rowKeys = keys.skip(rowStart).take(3).toList();
      final tallest = rowKeys
          .map((key) => groups[key]!.length.clamp(1, perColumn))
          .reduce(math.max);
      final rowHeight = math.max(420.0, (tallest - 1) * 180 + 240.0);
      if (rowTop > 165 && rowTop + rowHeight - 240 > _lastRowY) {
        rowTop = 165;
        blockLeft += 3 * 370 + 160;
      }
      for (var column = 0; column < rowKeys.length; column++) {
        final group = groups[rowKeys[column]]!
          ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
        for (var index = 0; index < group.length; index++) {
          final event = group[index];
          output.add(
            event.copyWith(
              wallPosition:
                  manualOverrides[event.id] ??
                  Offset(
                    // A single huge place wraps into extra columns.
                    blockLeft + column * 370 + (index ~/ perColumn) * 1270,
                    rowTop + (index % perColumn) * 180,
                  ),
            ),
          );
        }
      }
      rowTop += rowHeight;
    }
    return output;
  }

  static String _locationKey(MemoryEvent event) {
    if (!event.hasGeoPoint) return 'Unknown place';
    // Integer tenths avoid separate "-0.0" and "0.0" buckets around 0°.
    final lat = (event.latitude! * 10).round();
    final lng = (event.longitude! * 10).round();
    return '$lat,$lng';
  }
}
