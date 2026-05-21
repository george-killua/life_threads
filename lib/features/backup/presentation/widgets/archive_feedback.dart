import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/backup_models.dart';

Future<void> shareExportedArchive(
  BuildContext context,
  BackupExportResult result,
) async {
  try {
    final shareResult = await SharePlus.instance.share(
      ShareParams(
        title: 'Send LifeThreads archive',
        subject: 'LifeThreads memory archive',
        text: result.isEncrypted
            ? 'LifeThreads encrypted archive. Use the password you chose to import it on another device.'
            : 'LifeThreads archive. Import it in LifeThreads to open your memory wall on another device.',
        files: [XFile(result.path, mimeType: 'application/zip')],
      ),
    );
    if (!context.mounted) return;
    final label = switch (shareResult.status) {
      ShareResultStatus.success => 'Archive ready to send.',
      ShareResultStatus.dismissed => 'Archive saved. You can share it later.',
      ShareResultStatus.unavailable =>
        'Archive saved, but sharing is unavailable.',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('$label Saved to ${result.path}'),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        content: Text('Archive saved, but sharing failed: $error'),
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
      title: const Text('Archive imported'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SummaryRow(
            icon: Icons.photo_library_rounded,
            label: 'Memories',
            value: result.memoryCount,
          ),
          _SummaryRow(
            icon: Icons.image_rounded,
            label: 'Photos',
            value: result.photoCount,
          ),
          _SummaryRow(
            icon: Icons.people_alt_rounded,
            label: 'People',
            value: result.personCount,
          ),
          _SummaryRow(
            icon: Icons.sticky_note_2_rounded,
            label: 'Wall notes / nails',
            value: result.wallItemCount,
          ),
          _SummaryRow(
            icon: Icons.cable_rounded,
            label: 'Connections',
            value: result.connectionCount,
          ),
          const SizedBox(height: 10),
          const Text(
            'Your current wall was kept. Imported memories were added safely.',
            style: TextStyle(color: AppColors.muted, height: 1.35),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
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
