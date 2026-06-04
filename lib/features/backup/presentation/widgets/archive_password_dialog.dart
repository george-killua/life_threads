import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';

enum ArchivePasswordPurpose { export, import }

Future<String?> showArchivePasswordDialog(
  BuildContext context, {
  required ArchivePasswordPurpose purpose,
}) async {
  final controller = TextEditingController();
  var obscure = true;

  final result = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final l10n = context.l10n;
        final isExport = purpose == ArchivePasswordPurpose.export;
        return AlertDialog(
          title: Text(
            isExport ? l10n.exportPremiumArchiveTitle : l10n.importArchiveTitle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExport ? l10n.archiveExportBody : l10n.archiveImportBody,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: isExport
                        ? l10n.archivePasswordOptional
                        : l10n.archivePasswordLabel,
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
                    l10n.archivePasswordWarning,
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
              onPressed: () => Navigator.of(context).pop(controller.text),
              icon: Icon(
                isExport
                    ? Icons.enhanced_encryption_rounded
                    : Icons.restore_rounded,
              ),
              label: Text(isExport ? l10n.exportAction : l10n.chooseArchive),
            ),
          ],
        );
      },
    ),
  );

  controller.dispose();
  return result;
}
