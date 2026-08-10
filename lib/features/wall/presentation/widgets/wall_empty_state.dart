import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';

class WallEmptyState extends StatelessWidget {
  const WallEmptyState({
    super.key,
    required this.onAdd,
    required this.onQuickPhoto,
    required this.onTakePhotos,
  });

  final VoidCallback onAdd;
  final VoidCallback onQuickPhoto;
  final VoidCallback? onTakePhotos;

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
            Text(
              context.l10n.startWithOneThing,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              context.l10n.emptyWallBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onTakePhotos,
              icon: const Icon(Icons.photo_camera_rounded),
              label: Text(context.l10n.takePhotosNow),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(context.l10n.saveMomentTitle),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onQuickPhoto,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: Text(context.l10n.usePhoto),
            ),
          ],
        ),
      ),
    );
  }
}
