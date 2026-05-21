import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

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
        final isExport = purpose == ArchivePasswordPurpose.export;
        return AlertDialog(
          title: Text(isExport ? 'Export Premium Archive' : 'Import Archive'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExport
                      ? 'Add a password to encrypt the archive. Leave empty for a normal local zip.'
                      : 'If this archive is encrypted, enter its password. Leave empty for older or unprotected backups.',
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: isExport
                        ? 'Archive password (optional)'
                        : 'Archive password',
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
                    'Keep the password somewhere safe. It cannot be recovered if you lose it.',
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
              onPressed: () => Navigator.of(context).pop(controller.text),
              icon: Icon(
                isExport
                    ? Icons.enhanced_encryption_rounded
                    : Icons.restore_rounded,
              ),
              label: Text(isExport ? 'Export' : 'Choose Archive'),
            ),
          ],
        );
      },
    ),
  );

  controller.dispose();
  return result;
}
