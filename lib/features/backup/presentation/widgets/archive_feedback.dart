import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../domain/backup_models.dart';

Future<void> shareExportedArchive(
  BuildContext context,
  BackupExportResult result,
) async {
  final l10n = context.l10n;
  try {
    final shareResult = await SharePlus.instance.share(
      ShareParams(
        title: l10n.sendArchiveTitle,
        subject: l10n.sendArchiveSubject,
        text: result.isEncrypted
            ? l10n.sendEncryptedArchiveText
            : l10n.sendArchiveText,
        files: [XFile(result.path, mimeType: 'application/zip')],
      ),
    );
    if (!context.mounted) return;
    final label = switch (shareResult.status) {
      ShareResultStatus.success => l10n.archiveReadyToSend,
      ShareResultStatus.dismissed => l10n.archiveSavedLater,
      ShareResultStatus.unavailable => l10n.archiveSharingUnavailable,
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(l10n.savedToPath(label, result.path)),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        content: Text(l10n.archiveShareFailed('$error')),
      ),
    );
  }
}

Future<void> showArchiveImportSummary(
  BuildContext context,
  BackupImportResult result,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.archiveImportedTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SummaryRow(
            icon: Icons.photo_library_rounded,
            label: context.l10n.memoriesLabel,
            value: result.memoryCount,
          ),
          _SummaryRow(
            icon: Icons.image_rounded,
            label: context.l10n.photosLabel,
            value: result.photoCount,
          ),
          _SummaryRow(
            icon: Icons.people_alt_rounded,
            label: context.l10n.peopleLabel,
            value: result.personCount,
          ),
          _SummaryRow(
            icon: Icons.sticky_note_2_rounded,
            label: context.l10n.wallNotesNailsLabel,
            value: result.wallItemCount,
          ),
          _SummaryRow(
            icon: Icons.cable_rounded,
            label: context.l10n.connectionsLabel,
            value: result.connectionCount,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.archiveImportSummary,
            style: const TextStyle(color: AppColors.muted, height: 1.35),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.done),
        ),
      ],
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
