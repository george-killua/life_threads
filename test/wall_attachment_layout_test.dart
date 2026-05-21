import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_colors.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/wall/domain/wall_attachment_layout.dart';
import 'package:life_threads/features/wall/domain/wall_item.dart';

void main() {
  test('attached text note follows memory using stored offset', () {
    final memory = _memory('m1', const Offset(200, 300));
    final note = _note('n1', const Offset(100, -40));
    final connection = _connection(note.id, memory.id);

    final displayItems = WallAttachmentLayout.displayWallItems(
      wallItems: [note],
      visibleEvents: [memory],
      allEvents: [memory],
      connections: [connection],
    );

    expect(displayItems.single.wallPosition, const Offset(300, 260));
  });

  test('dragging attached text note uses pending absolute position', () {
    final memory = _memory('m1', const Offset(200, 300));
    final note = _note('n1', const Offset(100, -40));
    final pendingPosition = const Offset(430, 240);

    final displayItems = WallAttachmentLayout.displayWallItems(
      wallItems: [note],
      visibleEvents: [memory],
      allEvents: [memory],
      connections: [_connection(note.id, memory.id)],
      draggingWallItemId: note.id,
      pendingDragPosition: pendingPosition,
    );

    expect(displayItems.single.wallPosition, pendingPosition);
  });

  test('next attachment offset stacks notes around the memory', () {
    final memory = _memory('m1', const Offset(200, 300));
    final first = _note('n1', const Offset(112, -46));
    final second = _note('n2', const Offset(80, 80));

    final offset = WallAttachmentLayout.nextAttachmentOffset(
      wallItems: [first, second],
      events: [memory],
      connections: [_connection(first.id, memory.id)],
      event: memory,
      item: second,
    );

    expect(offset, const Offset(112, 2));
  });
}

MemoryEvent _memory(String id, Offset position) {
  return MemoryEvent(
    id: id,
    title: 'Memory $id',
    description: 'Story',
    category: MemoryCategory.personal,
    memoryType: MemoryType.moment,
    feeling: MemoryFeeling.warm,
    occurredAt: DateTime(2026),
    createdAt: DateTime(2026),
    coverColor: AppColors.gold,
    wallPosition: position,
    rotation: 0,
    locationLabel: 'Linz',
  );
}

WallItem _note(String id, Offset position) {
  return WallItem(
    id: id,
    type: WallItemType.text,
    content: 'Note',
    createdAt: DateTime(2026),
    wallPosition: position,
    color: AppColors.cardDark,
  );
}

MemoryConnection _connection(String from, String to) {
  return MemoryConnection(
    id: '$from-$to',
    fromEventId: from,
    toEventId: to,
    label: 'sticky note',
  );
}
