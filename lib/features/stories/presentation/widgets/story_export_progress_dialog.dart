import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../data/story_exporter.dart';

typedef StoryVideoExport =
    Future<File> Function(
      BuildContext context,
      void Function(double progress) onProgress,
      StoryExportCancel cancel,
    );

/// Runs [export] (given [context]) behind a progress dialog with a Cancel
/// button. Returns the file, or null when the user cancelled; other errors
/// are rethrown.
Future<File?> runStoryVideoExport(
  BuildContext context,
  StoryVideoExport export,
) async {
  final progress = ValueNotifier<double>(0);
  final cancel = StoryExportCancel();
  final future = export(context, (value) => progress.value = value, cancel);
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        child: StoryExportProgressDialog(
          progress: progress,
          onCancel: cancel.cancel,
        ),
      ),
    ),
  );
  try {
    return await future;
  } on StoryExportCancelled {
    return null;
  } finally {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    progress.dispose();
  }
}

class StoryExportProgressDialog extends StatefulWidget {
  const StoryExportProgressDialog({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  final ValueListenable<double> progress;
  final VoidCallback onCancel;

  @override
  State<StoryExportProgressDialog> createState() =>
      _StoryExportProgressDialogState();
}

class _StoryExportProgressDialogState extends State<StoryExportProgressDialog> {
  var _cancelling = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.storyRenderingTitle),
      content: ValueListenableBuilder<double>(
        valueListenable: widget.progress,
        builder: (context, value, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.storyRenderingBody,
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: value <= 0 ? null : value,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.storyRenderingPercent((value * 100).floor()),
              style: TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancelling
              ? null
              : () {
                  setState(() => _cancelling = true);
                  widget.onCancel();
                },
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
