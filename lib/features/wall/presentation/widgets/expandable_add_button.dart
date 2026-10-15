import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';

class ExpandableAddButton extends StatefulWidget {
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

  /// Screens narrower than this get the icon-only button.
  static const double compactBelowWidth = 400;

  @override
  State<ExpandableAddButton> createState() => _ExpandableAddButtonState();
}

class _ExpandableAddButtonState extends State<ExpandableAddButton> {
  // The menu floats above the button in the overlay, so opening it doesn't
  // take width from the memory card beside the button.
  final _menu = OverlayPortalController()..show();
  final _link = LayerLink();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact =
        MediaQuery.sizeOf(context).width <
        ExpandableAddButton.compactBelowWidth;
    final icon = AnimatedRotation(
      turns: _isOpen ? 0.125 : 0,
      duration: const Duration(milliseconds: 180),
      child: const Icon(Icons.add_rounded),
    );

    return OverlayPortal(
      controller: _menu,
      overlayChildBuilder: _buildMenu,
      child: CompositedTransformTarget(
        link: _link,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.28),
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
          // On a small phone the label ("Hinzufügen") would squeeze the
          // memory card beside it, so the button shows only the icon.
          child: compact
              ? FloatingActionButton(
                  key: const ValueKey('wall-add-button'),
                  heroTag: 'wall-add-menu',
                  tooltip: _isOpen ? l10n.close : l10n.add,
                  onPressed: _toggle,
                  child: icon,
                )
              : FloatingActionButton.extended(
                  key: const ValueKey('wall-add-button'),
                  heroTag: 'wall-add-menu',
                  onPressed: _toggle,
                  icon: icon,
                  label: Text(_isOpen ? l10n.close : l10n.add),
                ),
        ),
      ),
    );
  }

  /// The menu's bottom end corner sits 10 pt above the button's top end
  /// corner.
  Widget _buildMenu(BuildContext context) {
    final l10n = context.l10n;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Align(
      alignment: Alignment.topLeft,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: rtl ? Alignment.topLeft : Alignment.topRight,
        followerAnchor: rtl ? Alignment.bottomLeft : Alignment.bottomRight,
        offset: const Offset(0, -10),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width - 40,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 190),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _isOpen
                ? Column(
                    key: const ValueKey('actions'),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ActionChipButton(
                        icon: Icons.auto_stories_rounded,
                        label: l10n.expandableMemory,
                        subtitle: l10n.expandableMemorySubtitle,
                        onTap: () => _run(widget.onAddEvent),
                      ),
                      _ActionChipButton(
                        icon: Icons.add_photo_alternate_rounded,
                        label: l10n.expandableQuickPhoto,
                        subtitle: l10n.expandableQuickPhotoSubtitle,
                        onTap: () => _run(widget.onAddQuickPhoto),
                      ),
                      _ActionChipButton(
                        icon: Icons.sticky_note_2_rounded,
                        label: l10n.expandableTextNote,
                        subtitle: l10n.expandableTextNoteSubtitle,
                        onTap: () => _run(widget.onAddText),
                      ),
                      _ActionChipButton(
                        icon: Icons.push_pin_rounded,
                        label: l10n.expandableNail,
                        subtitle: l10n.expandableNailSubtitle,
                        onTap: () => _run(widget.onAddNail),
                      ),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('closed')),
          ),
        ),
      ),
    );
  }

  void _toggle() => setState(() => _isOpen = !_isOpen);

  void _run(VoidCallback action) {
    setState(() => _isOpen = false);
    action();
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.panelWarm.withValues(alpha: 0.95),
                  AppColors.wallDeep.withValues(alpha: 0.94),
                ],
              ),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.32),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.amber, size: 18),
                const SizedBox(width: 9),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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
