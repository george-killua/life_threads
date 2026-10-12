import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../wall/presentation/widgets/wall_background.dart';

/// The page frame of the family screens: the wall background, a back
/// button, a title and a scrolling body, like Settings.
class FamilyPageScaffold extends StatelessWidget {
  const FamilyPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.actions = const [],
    this.onBack,
  });

  final String title;
  final List<Widget> children;
  final List<Widget> actions;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          // Ink of list tiles and buttons draws on the wall, not under it.
          child: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        onPressed:
                            onBack ?? () => Navigator.of(context).maybePop(),
                        icon: const BackButtonIcon(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      ...actions,
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A rounded panel like the Settings cards.
class FamilyPanel extends StatelessWidget {
  const FamilyPanel({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.child,
    this.actions = const [],
    this.badge,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String? body;
  final Widget? child;
  final List<Widget> actions;
  final String? badge;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? Colors.redAccent : AppColors.gold;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.9),
            AppColors.panel.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accent, size: 25),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                if (badge != null) FamilyBadge(label: badge!, color: accent),
              ],
            ),
            if (body != null && body!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                body!,
                style: const TextStyle(
                  color: AppColors.muted,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (child != null) ...[const SizedBox(height: 12), child!],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(spacing: 10, runSpacing: 10, children: actions),
            ],
          ],
        ),
      ),
    );
  }
}

class FamilyBadge extends StatelessWidget {
  const FamilyBadge({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.gold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

/// A filled button in the Settings style.
class FamilyAction extends StatelessWidget {
  const FamilyAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
    this.secondary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool danger;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    if (secondary) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    final color = danger ? Colors.redAccent : AppColors.gold;
    return FilledButton.icon(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: danger ? AppColors.text : AppColors.paperInk,
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

/// A bullet line with an icon, for explanations.
class FamilyPoint extends StatelessWidget {
  const FamilyPoint({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.45, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Used and total storage of a family wall.
class FamilyUsageBar extends StatelessWidget {
  const FamilyUsageBar({
    super.key,
    required this.usedBytes,
    required this.quotaBytes,
    required this.label,
  });

  final int usedBytes;
  final int quotaBytes;
  final String label;

  @override
  Widget build(BuildContext context) {
    final fraction = quotaBytes <= 0
        ? 0.0
        : (usedBytes / quotaBytes).clamp(0.0, 1.0);
    final nearlyFull = fraction >= 0.9;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 9,
            backgroundColor: AppColors.line,
            color: nearlyFull ? Colors.redAccent : AppColors.gold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
