import 'package:flutter/material.dart';

import '../../memories/domain/memory_connection.dart';
import '../../memories/domain/memory_event.dart';
import 'wall_item.dart';

class WallAttachmentLayout {
  const WallAttachmentLayout._();

  /// Large freeform board — cards can be placed well beyond the first viewport.
  /// Kept for display snapshots / previews; the live wall is effectively unbounded.
  static const canvasSize = Size(3600, 3200);

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
