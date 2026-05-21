import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/memory_capsule_models.dart';

enum MemoryCapsulePasswordPurpose { export, import }

Future<String?> showMemoryCapsulePasswordDialog(
  BuildContext context, {
  required MemoryCapsulePasswordPurpose purpose,
  bool requirePassword = false,
}) async {
  final controller = TextEditingController();
  var obscure = true;
  String? errorText;

  final result = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final isExport = purpose == MemoryCapsulePasswordPurpose.export;
        final isSecureShare = isExport && requirePassword;
        final isRequiredImport = !isExport && requirePassword;
        return AlertDialog(
          title: Text(
            isSecureShare
                ? 'Share Encrypted Capsule'
                : isRequiredImport
                ? 'Open Shared Capsule'
                : isExport
                ? 'Export Memory Capsule'
                : 'Import Capsule',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSecureShare
                      ? 'Create a password before uploading this capsule. Send the password separately to the person receiving it.'
                      : isRequiredImport
                      ? 'Enter the password you received for this shared memory.'
                      : isExport
                      ? 'Add a password if this memory should be protected before you send it. Leave empty for a normal capsule.'
                      : 'If this capsule has a password, enter it. Otherwise leave empty.',
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: isSecureShare
                        ? 'Capsule password'
                        : isRequiredImport
                        ? 'Shared capsule password'
                        : isExport
                        ? 'Capsule password (optional)'
                        : 'Capsule password',
                    errorText: errorText,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
                if (isExport) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'LifeThreads cannot recover this password later.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                if (requirePassword && controller.text.trim().isEmpty) {
                  setState(() {
                    errorText = 'Password is required for cloud sharing.';
                  });
                  return;
                }
                Navigator.of(context).pop(controller.text);
              },
              icon: Icon(
                isExport ? Icons.inventory_2_rounded : Icons.download_rounded,
              ),
              label: Text(
                isSecureShare
                    ? 'Create Secure Share'
                    : isRequiredImport
                    ? 'Preview Memory'
                    : isExport
                    ? 'Export'
                    : 'Choose Capsule',
              ),
            ),
          ],
        );
      },
    ),
  );

  controller.dispose();
  return result;
}

Future<void> shareMemoryCapsule(
  BuildContext context,
  MemoryCapsuleExportResult result,
) async {
  try {
    final shareResult = await SharePlus.instance.share(
      ShareParams(
        title: 'Share LifeThreads memory',
        subject: 'LifeThreads memory capsule',
        text: result.isEncrypted
            ? 'Hey, I shared a protected LifeThreads memory with you. Use the password I sent you to import it.'
            : 'Hey, I shared a LifeThreads memory with you. Import the capsule in LifeThreads to add it to your wall.',
        files: [XFile(result.path, mimeType: 'application/zip')],
      ),
    );
    if (!context.mounted) return;
    final label = switch (shareResult.status) {
      ShareResultStatus.success => 'Capsule ready to send.',
      ShareResultStatus.dismissed => 'Capsule saved. You can share it later.',
      ShareResultStatus.unavailable =>
        'Capsule saved, but sharing is unavailable.',
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
        content: Text('Capsule saved, but sharing failed: $error'),
      ),
    );
  }
}

Future<bool> showMemoryCapsuleImportPreview(
  BuildContext context,
  MemoryCapsuleImportDraft draft,
) async {
  final preview = draft.preview;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Import this memory?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            preview.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            preview.description.isEmpty
                ? 'No story text included.'
                : preview.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, height: 1.35),
          ),
          const SizedBox(height: 14),
          _CapsulePreviewRow(
            icon: Icons.place_rounded,
            label: 'Place',
            value: preview.locationLabel,
          ),
          _CapsulePreviewRow(
            icon: Icons.image_rounded,
            label: 'Photos',
            value: '${preview.photoCount}',
          ),
          _CapsulePreviewRow(
            icon: Icons.sticky_note_2_rounded,
            label: 'Notes',
            value: '${preview.noteCount}',
          ),
          _CapsulePreviewRow(
            icon: Icons.hub_rounded,
            label: 'Connections',
            value: '${preview.connectionCount}',
          ),
          _CapsulePreviewRow(
            icon: Icons.people_alt_rounded,
            label: 'People',
            value: '${preview.peopleCount}',
          ),
          if (preview.isEncrypted) ...[
            const SizedBox(height: 8),
            const Text(
              'This capsule was password-protected.',
              style: TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.add_to_photos_rounded),
          label: const Text('Add to Wall'),
        ),
      ],
    ),
  );

  return confirmed == true;
}

class _CapsulePreviewRow extends StatelessWidget {
  const _CapsulePreviewRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            value,
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
