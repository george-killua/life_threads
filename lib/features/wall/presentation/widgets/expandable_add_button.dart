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
  // The menu opens in its own popup route above the button, so it doesn't
  // take width from the memory card beside the button. An OverlayPortal or a
  // LayerLink here made iOS report every accessibility frame on the wall at
  // a third of its size (VoiceOver, UI tests); a route doesn't.
  final _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _buttonKey,
      child: _AddButton(
        open: false,
        turns: const AlwaysStoppedAnimation(0),
        heroTag: 'wall-add-menu',
        buttonKey: const ValueKey('wall-add-button'),
        onPressed: _open,
      ),
    );
  }

  Future<void> _open() async {
    final navigator = Navigator.of(context);
    final button = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = navigator.overlay?.context.findRenderObject() as RenderBox?;
    if (button == null || overlay == null) return;
    final anchor =
        button.localToGlobal(Offset.zero, ancestor: overlay) & button.size;
    final l10n = context.l10n;
    final action = await navigator.push(
      _AddMenuRoute(
        anchor: anchor,
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        items: [
          (
            icon: Icons.auto_stories_rounded,
            label: l10n.expandableMemory,
            subtitle: l10n.expandableMemorySubtitle,
            action: widget.onAddEvent,
          ),
          (
            icon: Icons.add_photo_alternate_rounded,
            label: l10n.expandableQuickPhoto,
            subtitle: l10n.expandableQuickPhotoSubtitle,
            action: widget.onAddQuickPhoto,
          ),
          (
            icon: Icons.sticky_note_2_rounded,
            label: l10n.expandableTextNote,
            subtitle: l10n.expandableTextNoteSubtitle,
            action: widget.onAddText,
          ),
          (
            icon: Icons.push_pin_rounded,
            label: l10n.expandableNail,
            subtitle: l10n.expandableNailSubtitle,
            action: widget.onAddNail,
          ),
        ],
      ),
    );
    action?.call();
  }
}

typedef _AddMenuItem = ({
  IconData icon,
  String label,
  String subtitle,
  VoidCallback action,
});

/// The add button; the menu route draws a copy of it over it, turned into
/// "Close".
class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.open,
    required this.turns,
    required this.onPressed,
    this.heroTag,
    this.buttonKey,
  });

  final bool open;
  final Animation<double> turns;
  final VoidCallback onPressed;
  final Object? heroTag;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact =
        MediaQuery.sizeOf(context).width <
        ExpandableAddButton.compactBelowWidth;
    final icon = RotationTransition(
      turns: turns,
      child: const Icon(Icons.add_rounded),
    );
    return DecoratedBox(
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
              key: buttonKey,
              heroTag: heroTag,
              tooltip: open ? l10n.close : l10n.add,
              onPressed: onPressed,
              child: icon,
            )
          : FloatingActionButton.extended(
              key: buttonKey,
              heroTag: heroTag,
              onPressed: onPressed,
              icon: icon,
              label: Text(open ? l10n.close : l10n.add),
            ),
    );
  }
}

/// The open menu: its bottom end corner sits 10 pt above the button's top
/// end corner, with a Close button where the add button is. Pops with the
/// chosen action, or null.
class _AddMenuRoute extends PopupRoute<VoidCallback> {
  _AddMenuRoute({
    required this.anchor,
    required this.items,
    required this.barrierLabel,
  });

  final Rect anchor;
  final List<_AddMenuItem> items;

  @override
  final String barrierLabel;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 190);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final size = MediaQuery.sizeOf(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return Stack(
      children: [
        Positioned(
          left: rtl ? anchor.left : null,
          right: rtl ? null : size.width - anchor.right,
          bottom: size.height - anchor.top + 10,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 40),
            child: FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween(begin: 0.96, end: 1.0).animate(curved),
                alignment: rtl ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final item in items)
                      _ActionChipButton(
                        icon: item.icon,
                        label: item.label,
                        subtitle: item.subtitle,
                        onTap: () => Navigator.of(context).pop(item.action),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fromRect(
          rect: anchor,
          child: _AddButton(
            open: true,
            turns: Tween(begin: 0.0, end: 0.125).animate(curved),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
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
