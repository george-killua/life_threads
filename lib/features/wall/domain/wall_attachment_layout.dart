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
    return [
      for (final item in wallItems)
        if (draggingWallItemId == item.id && pendingDragPosition != null)
          item.copyWith(wallPosition: pendingDragPosition)
        else
          item,
    ];
  }
}
