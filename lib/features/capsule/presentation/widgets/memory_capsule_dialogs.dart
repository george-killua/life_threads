import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
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
        final l10n = context.l10n;
        final isExport = purpose == MemoryCapsulePasswordPurpose.export;
        final isSecureShare = isExport && requirePassword;
        final isRequiredImport = !isExport && requirePassword;
        return AlertDialog(
          title: Text(
            isSecureShare
                ? l10n.shareEncryptedCapsuleTitle
                : isRequiredImport
                ? l10n.openSharedCapsuleTitle
                : isExport
                ? l10n.exportMemoryCapsuleTitle
                : l10n.importCapsuleDialogTitle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSecureShare
                      ? l10n.secureSharePasswordBody
                      : isRequiredImport
                      ? l10n.sharedCapsulePasswordBody
                      : isExport
                      ? l10n.capsuleExportBody
                      : l10n.capsuleImportBody,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: isSecureShare
                        ? l10n.capsulePasswordLabel
                        : isRequiredImport
                        ? l10n.sharedCapsulePasswordLabel
                        : isExport
                        ? l10n.capsulePasswordOptional
                        : l10n.capsulePasswordLabel,
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
                  Text(
                    l10n.capsulePasswordWarning,
                    style: const TextStyle(
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
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              onPressed: () {
                if (requirePassword && controller.text.trim().isEmpty) {
                  setState(() {
                    errorText = l10n.passwordRequiredCloudSharing;
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
                    ? l10n.createSecureShare
                    : isRequiredImport
                    ? l10n.previewMemory
                    : isExport
                    ? l10n.exportAction
                    : l10n.chooseCapsule,
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
  final l10n = context.l10n;
  try {
    final shareResult = await SharePlus.instance.share(
      ShareParams(
        title: l10n.sendCapsuleTitle,
        subject: l10n.sendCapsuleSubject,
        text: result.isEncrypted
            ? l10n.sendEncryptedCapsuleText
            : l10n.sendCapsuleText,
        files: [XFile(result.path, mimeType: 'application/zip')],
      ),
    );
    if (!context.mounted) return;
    final label = switch (shareResult.status) {
      ShareResultStatus.success => l10n.capsuleReadyToSend,
      ShareResultStatus.dismissed => l10n.capsuleSavedLater,
      ShareResultStatus.unavailable => l10n.capsuleSharingUnavailable,
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
        content: Text(l10n.capsuleShareFailed('$error')),
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
      title: Text(context.l10n.importThisMemory),
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
                ? context.l10n.noStoryTextIncluded
                : preview.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, height: 1.35),
          ),
          const SizedBox(height: 14),
          if (preview.locationLabel.trim().isNotEmpty)
            _CapsulePreviewRow(
              icon: Icons.place_rounded,
              label: context.l10n.placeLabel,
              value: preview.locationLabel,
            ),
          _CapsulePreviewRow(
            icon: Icons.image_rounded,
            label: context.l10n.photosLabel,
            value: '${preview.photoCount}',
          ),
          _CapsulePreviewRow(
            icon: Icons.sticky_note_2_rounded,
            label: context.l10n.notesLabel,
            value: '${preview.noteCount}',
          ),
          _CapsulePreviewRow(
            icon: Icons.hub_rounded,
            label: context.l10n.connectionsLabel,
            value: '${preview.connectionCount}',
          ),
          _CapsulePreviewRow(
            icon: Icons.people_alt_rounded,
            label: context.l10n.peopleLabel,
            value: '${preview.peopleCount}',
          ),
          if (preview.isEncrypted) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.capsulePasswordProtected,
              style: const TextStyle(
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
          child: Text(context.l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.add_to_photos_rounded),
          label: Text(context.l10n.addToWall),
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
