import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../tour/app_tour.dart';
import '../../../tour/coach.dart';

/// The wall's main action: a round "+" that opens the "Add to your wall"
/// sheet (memory, quick photo, text note, nail).
class ExpandableAddButton extends StatelessWidget {
  const ExpandableAddButton({
    super.key,
    required this.onAddEvent,
    required this.onAddQuickPhoto,
    required this.onAddText,
    required this.onAddNail,
  });

  final VoidCallback onAddEvent;
  final VoidCallback onAddQuickPhoto;
  final VoidCallback onAddText;
  final VoidCallback onAddNail;

  /// The "+" is a little larger than the camera button beside it.
  static const double size = 64;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: l10n.add,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.28),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.36),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: CoachTarget(
          id: TourTargets.add,
          child: FilledButton(
            key: const ValueKey('wall-add-button'),
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              fixedSize: const Size.square(size),
              minimumSize: const Size.square(size),
              padding: EdgeInsets.zero,
            ),
            onPressed: () => _open(context),
            child: const Icon(Icons.add_rounded, size: 32),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final l10n = context.l10n;
    final action = await showModalBottomSheet<VoidCallback>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _AddSheet(
        items: [
          (
            icon: Icons.auto_stories_rounded,
            label: l10n.expandableMemory,
            subtitle: l10n.expandableMemorySubtitle,
            action: onAddEvent,
          ),
          (
            icon: Icons.add_photo_alternate_rounded,
            label: l10n.expandableQuickPhoto,
            subtitle: l10n.expandableQuickPhotoSubtitle,
            action: onAddQuickPhoto,
          ),
          (
            icon: Icons.sticky_note_2_rounded,
            label: l10n.expandableTextNote,
            subtitle: l10n.expandableTextNoteSubtitle,
            action: onAddText,
          ),
          (
            icon: Icons.push_pin_rounded,
            label: l10n.expandableNail,
            subtitle: l10n.expandableNailSubtitle,
            action: onAddNail,
          ),
        ],
      ),
    );
    action?.call();
  }
}

typedef _AddItem = ({
  IconData icon,
  String label,
  String subtitle,
  VoidCallback action,
});

/// "Add to your wall": one full-width row per thing to add. Pops with the
/// chosen action.
class _AddSheet extends StatelessWidget {
  const _AddSheet({required this.items});

  final List<_AddItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                context.l10n.addToWallTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 14),
            for (final (index, item) in items.indexed)
              // The first row (Memory) is where the guided tour points.
              _maybeTourTarget(
                index == 0,
                _AddRow(
                  icon: item.icon,
                  label: item.label,
                  subtitle: item.subtitle,
                  onTap: () => Navigator.of(context).pop(item.action),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _maybeTourTarget(bool target, Widget row) =>
    target ? CoachTarget(id: TourTargets.addMemory, child: row) : row;

class _AddRow extends StatelessWidget {
  const _AddRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: AppColors.gold.withValues(alpha: 0.18)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.panelWarm,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.14),
                  ),
                  child: Icon(icon, color: AppColors.amber, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
