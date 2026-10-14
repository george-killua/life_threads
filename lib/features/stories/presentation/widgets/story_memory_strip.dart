import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/domain/memory_event.dart';
import '../templates/story_visuals.dart';

/// The memories in the story being edited, in story order: hold and drag to
/// reorder, × to remove (the last one stays), + to add another.
class StoryMemoryStrip extends StatelessWidget {
  const StoryMemoryStrip({
    super.key,
    required this.memories,
    required this.canAdd,
    required this.onReorder,
    required this.onRemove,
    required this.onAdd,
  });

  final List<MemoryEvent> memories;
  final bool canAdd;

  /// [to] is counted after removing the item at [from].
  final void Function(int from, int to) onReorder;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canRemove = memories.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                l10n.storyMemoriesInStory,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  memories.length > 1 ? l10n.storyMemoriesReorderHint : '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 78,
          child: ReorderableListView.builder(
            key: const ValueKey('story-memory-strip'),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            buildDefaultDragHandles: false,
            itemCount: memories.length,
            onReorderItem: onReorder,
            proxyDecorator: (child, _, _) =>
                Material(color: Colors.transparent, child: child),
            footer: canAdd
                ? _AddTile(label: l10n.storyAddMemory, onTap: onAdd)
                : null,
            itemBuilder: (context, index) {
              final memory = memories[index];
              return ReorderableDelayedDragStartListener(
                key: ValueKey('story-strip-${memory.id}'),
                index: index,
                child: _MemoryThumb(
                  memory: memory,
                  order: index + 1,
                  onRemove: canRemove ? () => onRemove(memory.id) : null,
                  removeLabel: l10n.storyRemoveMemory(memory.title),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MemoryThumb extends StatelessWidget {
  const _MemoryThumb({
    required this.memory,
    required this.order,
    required this.onRemove,
    required this.removeLabel,
  });

  final MemoryEvent memory;
  final int order;
  final VoidCallback? onRemove;
  final String removeLabel;

  @override
  Widget build(BuildContext context) {
    final path = memory.coverPhotoPath;
    final ImageProvider? image = path == null || path.isEmpty
        ? null
        : ResizeImage(
            path.startsWith('assets/')
                ? AssetImage(path)
                : FileImage(File(path)) as ImageProvider,
            width: 168,
          );
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10, top: 6),
      child: SizedBox.square(
        dimension: 68,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Semantics(
                label: '$order. ${memory.title}',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.5),
                    child: image == null
                        ? StoryPhotoPlaceholder(color: memory.coverColor)
                        : Image(image: image, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$order',
                  style: TextStyle(
                    color: AppColors.wallInk,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            if (onRemove != null)
              PositionedDirectional(
                end: -8,
                top: -8,
                child: Semantics(
                  button: true,
                  label: removeLabel,
                  excludeSemantics: true,
                  child: InkResponse(
                    key: ValueKey('story-strip-remove-${memory.id}'),
                    onTap: onRemove,
                    radius: 18,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.wallInk,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox.square(
        dimension: 68,
        child: Material(
          color: AppColors.panel.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            key: const ValueKey('story-strip-add'),
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: AppColors.gold),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
