import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../data/wall_theme_controller.dart';
import '../../domain/wall_theme.dart';
import 'wall_theme_preview.dart';

/// The theme choice in Settings: Auto, the year-round themes and the
/// seasonal themes of the moment, each with a live preview.
class WallThemePicker extends ConsumerWidget {
  const WallThemePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isPremium =
        ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    final autoOn =
        isPremium && (ref.watch(wallThemeAutoProvider).asData?.value ?? false);
    final effective = ref.watch(effectiveWallThemeProvider);
    final now = ref.watch(wallClockProvider).asData?.value ?? DateTime.now();
    final seasonal = WallThemePreset.seasonalAt(now);
    final upcoming = WallThemePreset.upcomingAt(now);

    Widget option(WallThemePreset theme) => _ThemeOption(
      theme: theme,
      selected: !autoOn && effective.id == theme.id,
      locked: theme.isPremium && !isPremium,
      badge: theme.season == null
          ? null
          : l10n.themeSeasonalUntil(theme.season!.endAfter(now)),
      onTap: () => _showPreview(context, ref, theme),
    );

    // Not available yet: shown so people can look forward to them.
    Widget comingOption(WallThemePreset theme) {
      final opensOn = theme.season!.startAfter(now);
      return _ThemeOption(
        theme: theme,
        selected: false,
        locked: true,
        lockIcon: Icons.schedule_rounded,
        badge: l10n.themeAvailableFrom(opensOn),
        onTap: () => _showPreview(context, ref, theme, opensOn: opensOn),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AutoOption(
          selected: autoOn,
          locked: !isPremium,
          now: now,
          onTap: () => _selectAuto(context, ref),
        ),
        _SectionHeader(title: l10n.themeYearRoundTitle),
        for (final theme in WallThemePreset.all) option(theme),
        if (seasonal.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.themeSeasonalTitle,
            body: l10n.themeSeasonalBody,
          ),
          for (final theme in seasonal) option(theme),
        ],
        if (upcoming.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.themeComingTitle,
            body: l10n.themeComingBody,
          ),
          for (final theme in upcoming) comingOption(theme),
        ],
      ],
    );
  }

  Future<void> _selectAuto(BuildContext context, WidgetRef ref) async {
    final isPremium =
        ref.read(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    if (!isPremium) {
      await context.push(RouteNames.upgrade);
      return;
    }
    await ref.read(wallThemeAutoProvider.notifier).setEnabled(true);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.themeAutoSelected)));
  }

  Future<void> _showPreview(
    BuildContext context,
    WidgetRef ref,
    WallThemePreset theme, {
    DateTime? opensOn,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => _ThemePreviewSheet(
        theme: theme,
        opensOn: opensOn,
        onUse: () async {
          Navigator.of(sheetContext).pop();
          await _selectTheme(context, ref, theme);
        },
        onUnlock: () {
          Navigator.of(sheetContext).pop();
          context.push(RouteNames.upgrade);
        },
      ),
    );
  }

  Future<void> _selectTheme(
    BuildContext context,
    WidgetRef ref,
    WallThemePreset theme,
  ) async {
    await ref.read(wallThemeProvider.notifier).selectTheme(theme);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.themeSelected(wallThemeLabel(context, theme)),
        ),
      ),
    );
  }
}

/// The theme in use, for Settings; opens the Themes screen.
class WallThemeSummary extends ConsumerWidget {
  const WallThemeSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isPremium =
        ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    final autoOn =
        isPremium && (ref.watch(wallThemeAutoProvider).asData?.value ?? false);
    final theme = ref.watch(effectiveWallThemeProvider);
    final now = ref.watch(wallClockProvider).asData?.value ?? DateTime.now();
    final inSeason = WallThemePreset.seasonalAt(now).length;

    return _OptionFrame(
      selected: true,
      locked: false,
      accent: theme.accent,
      onTap: () => context.push(RouteNames.themes),
      leading: WallThemePreview(theme: theme, radius: 0),
      title: autoOn ? l10n.themeAutoTitle : wallThemeLabel(context, theme),
      description: l10n.themeBrowse(inSeason),
      trailing: Icons.chevron_right_rounded,
    );
  }
}

class _ThemePreviewSheet extends ConsumerWidget {
  const _ThemePreviewSheet({
    required this.theme,
    required this.onUse,
    required this.onUnlock,
    this.opensOn,
  });

  final WallThemePreset theme;
  final VoidCallback onUse;
  final VoidCallback onUnlock;

  /// Set for a seasonal theme whose season has not started yet.
  final DateTime? opensOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isPremium =
        ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    final autoOn = ref.watch(wallThemeAutoProvider).asData?.value ?? false;
    final inUse =
        !autoOn && ref.watch(effectiveWallThemeProvider).id == theme.id;
    final locked = theme.isPremium && !isPremium;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: WallThemePreview(theme: theme, radius: 22),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(theme.icon, color: theme.accent, size: 22),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    wallThemeLabel(context, theme),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              wallThemeDescription(context, theme),
              style: TextStyle(
                color: AppColors.muted,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            if (opensOn != null)
              FilledButton.icon(
                onPressed: null,
                icon: const Icon(Icons.schedule_rounded),
                label: Text(l10n.themeAvailableFrom(opensOn!)),
              )
            else if (locked)
              FilledButton.icon(
                onPressed: onUnlock,
                icon: const Icon(Icons.lock_open_rounded),
                label: Text(l10n.themeUnlockButton),
              )
            else
              FilledButton(
                onPressed: inUse ? null : onUse,
                child: Text(inUse ? l10n.themeInUse : l10n.themeUseButton),
              ),
          ],
        ),
      ),
    );
  }
}

class _AutoOption extends StatelessWidget {
  const _AutoOption({
    required this.selected,
    required this.locked,
    required this.now,
    required this.onTap,
  });

  final bool selected;
  final bool locked;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final current = WallThemePreset.autoAt(now);
    return _OptionFrame(
      selected: selected,
      locked: locked,
      accent: current.accent,
      onTap: onTap,
      // The theme Auto shows right now, marked with a clock.
      leading: Stack(
        fit: StackFit.expand,
        children: [
          WallThemePreview(theme: current, radius: 0),
          Positioned(
            right: 5,
            bottom: 5,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule_rounded,
                size: 14,
                color: current.accent,
              ),
            ),
          ),
        ],
      ),
      title: context.l10n.themeAutoTitle,
      description: context.l10n.themeAutoDescription,
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.theme,
    required this.selected,
    required this.locked,
    required this.onTap,
    this.badge,
    this.lockIcon = Icons.lock_rounded,
  });

  final WallThemePreset theme;
  final bool selected;
  final bool locked;
  final IconData lockIcon;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _OptionFrame(
      selected: selected,
      locked: locked,
      accent: theme.accent,
      onTap: onTap,
      leading: WallThemePreview(theme: theme, radius: 0),
      title: wallThemeLabel(context, theme),
      description: wallThemeDescription(context, theme),
      badge: badge,
      lockIcon: lockIcon,
    );
  }
}

class _OptionFrame extends StatelessWidget {
  const _OptionFrame({
    required this.selected,
    required this.locked,
    required this.accent,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.description,
    this.badge,
    this.lockIcon = Icons.lock_rounded,
    this.trailing,
  });

  final bool selected;
  final bool locked;
  final Color accent;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String description;
  final String? badge;
  final IconData lockIcon;

  /// Replaces the selection check, e.g. with a chevron for navigation.
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    final line = Theme.of(context).colorScheme.outline;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      // Its own button, so it is not merged into a surrounding card.
      child: Semantics(
        container: true,
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: selected
                  ? accent.withValues(alpha: 0.16)
                  : Colors.black.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? accent.withValues(alpha: 0.7) : line,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(width: 84, height: 58, child: leading),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (trailing != null)
                            Icon(trailing, color: accent, size: 22)
                          else if (locked)
                            Icon(lockIcon, color: accent, size: 17)
                          else if (selected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: accent,
                              size: 18,
                            ),
                        ],
                      ),
                      if (badge != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          badge!,
                          style: TextStyle(
                            color: accent,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.muted,
                          height: 1.3,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.body});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          if (body != null) ...[
            const SizedBox(height: 3),
            Text(
              body!,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12.5,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String wallThemeLabel(BuildContext context, WallThemePreset theme) {
  final l10n = context.l10n;
  return switch (theme.id) {
    WallThemeId.warmMemoryRoom => l10n.themeWarmMemoryRoom,
    WallThemeId.midnightArchive => l10n.themeMidnightArchive,
    WallThemeId.softPaperWall => l10n.themeSoftPaperWall,
    WallThemeId.travelCorkboard => l10n.themeTravelCorkboard,
    WallThemeId.autumnHarvest => l10n.themeAutumnHarvest,
    WallThemeId.winterLights => l10n.themeWinterLights,
    WallThemeId.springBlossom => l10n.themeSpringBlossom,
    WallThemeId.summerEvening => l10n.themeSummerEvening,
    WallThemeId.seaside => l10n.themeSeaside,
    WallThemeId.snowyCabin => l10n.themeSnowyCabin,
    WallThemeId.springMeadow => l10n.themeSpringMeadow,
    WallThemeId.mistyForest => l10n.themeMistyForest,
  };
}

String wallThemeDescription(BuildContext context, WallThemePreset theme) {
  final l10n = context.l10n;
  return switch (theme.id) {
    WallThemeId.warmMemoryRoom => l10n.themeWarmMemoryRoomDescription,
    WallThemeId.midnightArchive => l10n.themeMidnightArchiveDescription,
    WallThemeId.softPaperWall => l10n.themeSoftPaperWallDescription,
    WallThemeId.travelCorkboard => l10n.themeTravelCorkboardDescription,
    WallThemeId.autumnHarvest => l10n.themeAutumnHarvestDescription,
    WallThemeId.winterLights => l10n.themeWinterLightsDescription,
    WallThemeId.springBlossom => l10n.themeSpringBlossomDescription,
    WallThemeId.summerEvening => l10n.themeSummerEveningDescription,
    WallThemeId.seaside => l10n.themeSeasideDescription,
    WallThemeId.snowyCabin => l10n.themeSnowyCabinDescription,
    WallThemeId.springMeadow => l10n.themeSpringMeadowDescription,
    WallThemeId.mistyForest => l10n.themeMistyForestDescription,
  };
}
