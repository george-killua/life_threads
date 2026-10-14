import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../domain/family_models.dart';
import '../family_providers.dart';

/// A pill naming the wall on screen ("My wall" or a family wall) that opens
/// the wall switcher.
class WallSwitcherButton extends ConsumerWidget {
  const WallSwitcherButton({super.key, this.currentFamilyId, this.label});

  /// The family wall on screen; null on "My wall".
  final String? currentFamilyId;

  /// Overrides the shown name (e.g. while the family loads).
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final families = ref.watch(familiesProvider).asData?.value ?? const [];
    final current = families.where((f) => f.id == currentFamilyId).firstOrNull;
    final text =
        label ?? (currentFamilyId == null ? l10n.myWall : current?.name ?? '');
    return Semantics(
      button: true,
      label: l10n.switchWall,
      child: GestureDetector(
        key: const ValueKey('wall-switcher'),
        onTap: () => showWallSwitcher(context, currentFamilyId),
        child: Container(
          height: 36,
          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.panelWarm.withValues(alpha: 0.9),
                AppColors.wallInk.withValues(alpha: 0.82),
              ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.32)),
          ),
          // Bounded (e.g. in a Row): the name shrinks; unbounded (in a
          // scrolling pill row): it takes up to 160 points.
          child: LayoutBuilder(
            builder: (context, constraints) {
              final name = ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.card,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              );
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    currentFamilyId == null
                        ? Icons.person_rounded
                        : Icons.diversity_1_rounded,
                    size: 17,
                    color: AppColors.amber,
                  ),
                  const SizedBox(width: 7),
                  if (constraints.hasBoundedWidth)
                    Flexible(child: name)
                  else
                    name,
                  const Icon(
                    Icons.unfold_more_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Lists "My wall" and the family walls; opens the chosen one.
Future<void> showWallSwitcher(
  BuildContext context,
  String? currentFamilyId,
) async {
  final choice = await showModalBottomSheet<_WallChoice>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _WallSwitcherSheet(currentFamilyId: currentFamilyId),
  );
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case _MyWall():
      if (currentFamilyId != null) context.go(RouteNames.wall);
    case _FamilyWall(:final familyId):
      if (familyId == currentFamilyId) return;
      final location = RouteNames.familyWallFor(familyId);
      if (currentFamilyId == null) {
        await context.push(location);
      } else {
        context.pushReplacement(location);
      }
    case _ManageWalls():
      await context.push(RouteNames.familyWalls);
  }
}

sealed class _WallChoice {
  const _WallChoice();
}

class _MyWall extends _WallChoice {
  const _MyWall();
}

class _FamilyWall extends _WallChoice {
  const _FamilyWall(this.familyId);

  final String familyId;
}

class _ManageWalls extends _WallChoice {
  const _ManageWalls();
}

class _WallSwitcherSheet extends ConsumerWidget {
  const _WallSwitcherSheet({required this.currentFamilyId});

  final String? currentFamilyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final families = ref.watch(familiesProvider).asData?.value ?? const [];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                l10n.switchWall,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _ChoiceTile(
              icon: Icons.person_rounded,
              title: l10n.myWall,
              subtitle: l10n.myWallSubtitle,
              selected: currentFamilyId == null,
              onTap: () => Navigator.of(context).pop(const _MyWall()),
            ),
            for (final family in families)
              _ChoiceTile(
                icon: Icons.diversity_1_rounded,
                title: family.name,
                subtitle: family.role == FamilyRole.owner
                    ? l10n.familyRoleOwner
                    : l10n.familyRoleMember,
                selected: currentFamilyId == family.id,
                onTap: () => Navigator.of(context).pop(_FamilyWall(family.id)),
              ),
            Divider(color: AppColors.line),
            _ChoiceTile(
              icon: Icons.tune_rounded,
              title: l10n.familyWallsManage,
              selected: false,
              onTap: () => Navigator.of(context).pop(const _ManageWalls()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      selectedColor: AppColors.amber,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Icon(icon, color: AppColors.gold),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: selected
          ? Icon(Icons.check_rounded, color: AppColors.amber)
          : null,
    );
  }
}
