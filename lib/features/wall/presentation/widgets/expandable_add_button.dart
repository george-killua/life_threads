import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

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

  @override
  State<ExpandableAddButton> createState() => _ExpandableAddButtonState();
}

class _ExpandableAddButtonState extends State<ExpandableAddButton> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 190),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _isOpen
              ? Column(
                  key: const ValueKey('actions'),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _ActionChipButton(
                      icon: Icons.auto_stories_rounded,
                      label: 'Memory',
                      subtitle: 'Full guided story',
                      onTap: () => _run(widget.onAddEvent),
                    ),
                    _ActionChipButton(
                      icon: Icons.add_photo_alternate_rounded,
                      label: 'Quick photo memory',
                      subtitle: 'Pick photo and hang it',
                      onTap: () => _run(widget.onAddQuickPhoto),
                    ),
                    _ActionChipButton(
                      icon: Icons.sticky_note_2_rounded,
                      label: 'Text note',
                      subtitle: 'Small thought on wall',
                      onTap: () => _run(widget.onAddText),
                    ),
                    _ActionChipButton(
                      icon: Icons.push_pin_rounded,
                      label: 'Nail / rope anchor',
                      subtitle: 'Manual rope point',
                      onTap: () => _run(widget.onAddNail),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('closed')),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.28),
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
          child: FloatingActionButton.extended(
            heroTag: 'wall-add-menu',
            onPressed: () => setState(() => _isOpen = !_isOpen),
            icon: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 180),
              child: const Icon(Icons.add_rounded),
            ),
            label: Text(_isOpen ? 'Close' : 'Add'),
          ),
        ),
      ],
    );
  }

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
