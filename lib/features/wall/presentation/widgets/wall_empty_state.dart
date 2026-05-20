import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class WallEmptyState extends StatelessWidget {
  const WallEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.panelWarm.withValues(alpha: 0.92),
              AppColors.panel.withValues(alpha: 0.88),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.32),
              blurRadius: 38,
              offset: const Offset(0, 18),
            ),
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.08),
              blurRadius: 44,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.gold,
              size: 46,
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your memory room',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add a first memory, then connect it to the next one. The wall becomes richer as your moments grow.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add first memory'),
            ),
          ],
        ),
      ),
    );
  }
}
