import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../localization/app_localizations_x.dart';

/// What a toast is about; sets its icon, colour and how long it stays.
enum ToastKind { info, success, error }

/// A button on a toast, e.g. "Delete" or "Undo".
class ToastAction {
  const ToastAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}

/// Shows themed toasts: a floating card with an icon, the message, an
/// optional action and a close button. Built on [SnackBar], so queueing,
/// swipe to dismiss and screen reader announcements keep working.
extension AppToastContextX on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, {
    ToastKind kind = ToastKind.info,
    ToastAction? action,
    Duration? duration,
  }) {
    return ScaffoldMessenger.of(
      this,
    ).showToast(message, kind: kind, action: action, duration: duration);
  }
}

/// For callers that kept the messenger across an async gap.
extension AppToastMessengerX on ScaffoldMessengerState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, {
    ToastKind kind = ToastKind.info,
    ToastAction? action,
    Duration? duration,
  }) {
    return showSnackBar(
      appToast(message, kind: kind, action: action, duration: duration),
    );
  }
}

/// The [SnackBar] behind a toast.
SnackBar appToast(
  String message, {
  ToastKind kind = ToastKind.info,
  ToastAction? action,
  Duration? duration,
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    padding: EdgeInsets.zero,
    // The card has its own close button; the theme's would be a second.
    showCloseIcon: false,
    margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
    duration: duration ?? _durationFor(kind, hasAction: action != null),
    content: _ToastCard(message: message, kind: kind, action: action),
  );
}

Duration _durationFor(ToastKind kind, {required bool hasAction}) {
  if (hasAction) return const Duration(seconds: 9);
  return switch (kind) {
    ToastKind.error => const Duration(seconds: 7),
    ToastKind.info || ToastKind.success => const Duration(seconds: 4),
  };
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.message, required this.kind, this.action});

  final String message;
  final ToastKind kind;
  final ToastAction? action;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (kind) {
      ToastKind.success => (AppColors.sage, Icons.check_rounded),
      ToastKind.info => (AppColors.gold, Icons.auto_awesome_rounded),
      ToastKind.error => (AppColors.error, Icons.priority_high_rounded),
    };

    void close(SnackBarClosedReason reason) =>
        ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar(reason: reason);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.98),
            AppColors.panel.withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.38)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
          BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 22),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 4, 8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.16),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 14.5,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (action != null)
              TextButton(
                onPressed: () {
                  close(SnackBarClosedReason.action);
                  action!.onPressed();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.amber,
                  textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: Text(action!.label),
              ),
            IconButton(
              onPressed: () => close(SnackBarClosedReason.dismiss),
              tooltip: context.l10n.close,
              icon: const Icon(Icons.close_rounded, size: 19),
              color: AppColors.muted,
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
