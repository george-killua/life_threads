import 'package:flutter/material.dart';

import '../../memories/domain/memory_connection.dart';
import '../../memories/domain/memory_event.dart';
import 'wall_item.dart';

class WallAttachmentLayout {
  const WallAttachmentLayout._();

  static const canvasSize = Size(1280, 1180);

  static List<WallItem> displayWallItems({
    required List<WallItem> wallItems,
    required List<MemoryEvent> visibleEvents,
    required List<MemoryEvent> allEvents,
    required List<MemoryConnection> connections,
    String? draggingWallItemId,
    Offset? pendingDragPosition,
  }) {
    final visibleEventById = {
      for (final event in visibleEvents) event.id: event,
    };
    final attachmentCounts = <String, int>{};
    final displayItems = <WallItem>[];

    for (final item in wallItems) {
      final attachedMemoryId = attachedMemoryIdFor(
        item: item,
        events: allEvents,
        connections: connections,
      );
      final isDraggingItem =
          draggingWallItemId == item.id && pendingDragPosition != null;

      if (item.type != WallItemType.text || attachedMemoryId == null) {
        displayItems.add(
          isDraggingItem
              ? item.copyWith(wallPosition: pendingDragPosition)
              : item,
        );
        continue;
      }

      final event = visibleEventById[attachedMemoryId];
      if (event == null) continue;

      if (isDraggingItem) {
        displayItems.add(item.copyWith(wallPosition: pendingDragPosition));
        continue;
      }

      final index = attachmentCounts.update(
        attachedMemoryId,
        (value) => value + 1,
        ifAbsent: () => 0,
      );
      displayItems.add(
        item.copyWith(
          wallPosition: attachedTextPosition(
            item: item,
            event: event,
            index: index,
          ),
        ),
      );
    }

    return displayItems;
  }

  static Offset attachedTextPosition({
    required WallItem item,
    required MemoryEvent event,
    required int index,
  }) {
    final position = event.wallPosition + attachmentOffset(item, event, index);
    return Offset(
      _clampDouble(position.dx, 36, canvasSize.width - 235),
      _clampDouble(position.dy, 88, canvasSize.height - 180),
    );
  }

  static Offset attachmentOffset(WallItem item, MemoryEvent event, int index) {
    final stored = item.wallPosition;
    if (_looksLikeNoteOffset(stored)) return stored;

    final oldAbsoluteOffset = stored - event.wallPosition;
    if (_looksLikeNoteOffset(oldAbsoluteOffset)) return oldAbsoluteOffset;

    return defaultAttachmentOffset(index);
  }

  static Offset absoluteTextPosition({
    required WallItem item,
    required List<WallItem> wallItems,
    required List<MemoryEvent> events,
    required List<MemoryConnection> connections,
  }) {
    final attachedMemoryId = attachedMemoryIdFor(
      item: item,
      events: events,
      connections: connections,
    );
    final attachedMemory = _eventById(events, attachedMemoryId);
    if (attachedMemory == null) return item.wallPosition;

    final index = wallItems
        .where(
          (other) =>
              other.type == WallItemType.text &&
              attachedMemoryIdFor(
                    item: other,
                    events: events,
                    connections: connections,
                  ) ==
                  attachedMemoryId,
        )
        .toList()
        .indexWhere((other) => other.id == item.id);

    return attachedTextPosition(
      item: item,
      event: attachedMemory,
      index: index < 0 ? 0 : index,
    );
  }

  static Offset nextAttachmentOffset({
    required List<WallItem> wallItems,
    required List<MemoryEvent> events,
    required List<MemoryConnection> connections,
    required MemoryEvent event,
    required WallItem item,
  }) {
    final currentAttachedId = attachedMemoryIdFor(
      item: item,
      events: events,
      connections: connections,
    );
    if (currentAttachedId == event.id) {
      return clampAttachmentOffset(item.wallPosition);
    }

    final existingCount = wallItems
        .where(
          (other) =>
              other.id != item.id &&
              other.type == WallItemType.text &&
              attachedMemoryIdFor(
                    item: other,
                    events: events,
                    connections: connections,
                  ) ==
                  event.id,
        )
        .length;
    return defaultAttachmentOffset(existingCount);
  }

  static Offset defaultAttachmentOffset(int index) =>
      Offset(112, -46 + index * 48);

  static Offset clampAttachmentOffset(Offset offset) {
    return Offset(
      _clampDouble(offset.dx, -190, 270),
      _clampDouble(offset.dy, -150, 190),
    );
  }

  static String? attachedMemoryIdFor({
    required WallItem item,
    required Iterable<MemoryEvent> events,
    required Iterable<MemoryConnection> connections,
  }) {
    if (item.type != WallItemType.text) return null;
    final eventIds = {for (final event in events) event.id};

    for (final connection in connections) {
      if (connection.fromEventId == item.id &&
          eventIds.contains(connection.toEventId)) {
        return connection.toEventId;
      }
      if (connection.toEventId == item.id &&
          eventIds.contains(connection.fromEventId)) {
        return connection.fromEventId;
      }
    }
    return null;
  }

  static MemoryEvent? _eventById(Iterable<MemoryEvent> events, String? id) {
    if (id == null) return null;
    for (final event in events) {
      if (event.id == id) return event;
    }
    return null;
  }

  static bool _looksLikeNoteOffset(Offset offset) {
    return offset.dx.abs() <= 360 && offset.dy.abs() <= 280;
  }

  static double _clampDouble(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }
}
