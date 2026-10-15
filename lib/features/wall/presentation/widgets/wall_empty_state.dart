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
            Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 46),
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
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 22),
            // Full width, one under the other: the main action filled, the
            // others quieter.
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.l10n.saveMomentTitle),
                ),
                OutlinedButton.icon(
                  onPressed: onTakePhotos,
                  style: _secondaryStyle(
                    background: AppColors.gold.withValues(alpha: 0.14),
                    foreground: AppColors.amber,
                    border: AppColors.gold.withValues(alpha: 0.55),
                    bold: true,
                  ),
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: Text(context.l10n.takePhotosNow),
                ),
                OutlinedButton.icon(
                  onPressed: onQuickPhoto,
                  style: _secondaryStyle(
                    background: Colors.transparent,
                    foreground: AppColors.amber,
                    border: AppColors.line,
                  ),
                  icon: const Icon(Icons.add_photo_alternate_rounded),
                  label: Text(context.l10n.usePhoto),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Matches the filled button's height and shape, so the three line up.
ButtonStyle _secondaryStyle({
  required Color background,
  required Color foreground,
  required Color border,
  bool bold = false,
}) {
  return OutlinedButton.styleFrom(
    backgroundColor: background,
    foregroundColor: foreground,
    side: BorderSide(color: border),
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
    textStyle: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700),
  );
}
