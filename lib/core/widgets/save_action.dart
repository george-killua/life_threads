import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../localization/app_localizations_x.dart';

/// "Save" in a screen's top bar: active once something changed, a spinner
/// while saving.
class SaveAction extends StatelessWidget {
  const SaveAction({
    super.key,
    required this.enabled,
    required this.saving,
    required this.onSave,
    this.label,
    this.buttonKey = const ValueKey('top-bar-save'),
  });

  final bool enabled;
  final bool saving;
  final VoidCallback onSave;

  /// Instead of "Save", e.g. "Post".
  final String? label;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    if (saving) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: TextButton(
        key: buttonKey,
        onPressed: enabled ? onSave : null,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        child: Text(label ?? context.l10n.save),
      ),
    );
  }
}

/// Asks before leaving a screen with unsaved changes; true to leave.
Future<bool> confirmDiscardChanges(BuildContext context) async {
  final l10n = context.l10n;
  final discard = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.discardChangesTitle),
      content: Text(l10n.discardChangesBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.keepEditing),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.discardChanges),
        ),
      ],
    ),
  );
  return discard ?? false;
}
