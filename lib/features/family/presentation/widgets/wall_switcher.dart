import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../premium/domain/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../../wall/data/current_wall.dart';
import '../../domain/family_models.dart';
import '../family_providers.dart';

/// A pill naming the wall on screen ("My wall", one of one's own named
/// walls, or a family wall) that opens the wall switcher.
class WallSwitcherButton extends ConsumerWidget {
  const WallSwitcherButton({super.key, this.currentFamilyId, this.label});

  /// The family wall on screen; null on "My wall".
  final String? currentFamilyId;

  /// Overrides the shown name (e.g. while the family loads).
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Empty until family walls were used here: no family service calls.
    final families = ref.watch(switchableFamiliesProvider);
    final current = families.where((f) => f.id == currentFamilyId).firstOrNull;
    final walls =
        ref.watch(memoryRepositoryProvider).asData?.value.walls ?? const [];
    final ownWall = walls
        .where((w) => w.id == ref.watch(currentWallProvider))
        .firstOrNull;
    final text =
        label ??
        (currentFamilyId == null
            ? ownWall?.name ?? l10n.myWall
            : current?.name ?? '');
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
                  style: TextStyle(
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
                  Icon(
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

/// Lists "My wall", one's own named walls and the family walls; opens the
/// chosen one, or makes a new wall (Premium).
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
  final container = ProviderScope.containerOf(context, listen: false);
  final currentWall = container.read(currentWallProvider.notifier);
  switch (choice) {
    case _MyWall():
      await currentWall.select(null);
      if (currentFamilyId != null && context.mounted) {
        context.go(RouteNames.wall);
      }
    case _OwnWall(:final wallId):
      await currentWall.select(wallId);
      if (currentFamilyId != null && context.mounted) {
        context.go(RouteNames.wall);
      }
    case _NewWall():
      await createNewWall(context);
      if (currentFamilyId != null && context.mounted) {
        context.go(RouteNames.wall);
      }
    case _WallOptions(:final wallId):
      await _showWallOptions(context, wallId);
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

class _OwnWall extends _WallChoice {
  const _OwnWall(this.wallId);

  final String wallId;
}

class _NewWall extends _WallChoice {
  const _NewWall();
}

class _WallOptions extends _WallChoice {
  const _WallOptions(this.wallId);

  final String wallId;
}

/// Asks for a name and makes a new wall of one's own (Premium), then shows
/// it.
Future<void> createNewWall(BuildContext context) async {
  if (!await requirePremium(context, PremiumFeature.walls)) return;
  if (!context.mounted) return;
  final name = await _askWallName(context, title: context.l10n.newWall);
  if (name == null || !context.mounted) return;
  final container = ProviderScope.containerOf(context, listen: false);
  final id = await container
      .read(memoryRepositoryProvider.notifier)
      .createWall(name);
  await container.read(currentWallProvider.notifier).select(id);
}

Future<void> _showWallOptions(BuildContext context, String wallId) async {
  final l10n = context.l10n;
  final container = ProviderScope.containerOf(context, listen: false);
  final wall = container
      .read(memoryRepositoryProvider)
      .asData
      ?.value
      .walls
      .where((w) => w.id == wallId)
      .firstOrNull;
  if (wall == null) return;
  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: Text(l10n.renameWall),
            onTap: () => Navigator.of(sheetContext).pop('rename'),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded, color: AppColors.error),
            title: Text(
              l10n.deleteWall,
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () => Navigator.of(sheetContext).pop('delete'),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;
  final repository = container.read(memoryRepositoryProvider.notifier);
  if (action == 'rename') {
    final name = await _askWallName(
      context,
      title: l10n.renameWall,
      initial: wall.name,
    );
    if (name != null) await repository.renameWall(wallId, name);
    return;
  }
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteWallQuestion(wall.name)),
      content: Text(l10n.deleteWallBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  if (container.read(currentWallProvider) == wallId) {
    await container.read(currentWallProvider.notifier).select(null);
  }
  await repository.deleteWall(wallId);
}

Future<String?> _askWallName(
  BuildContext context, {
  required String title,
  String initial = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _WallNameDialog(title: title, initial: initial),
  );
}

/// Owns its text controller, so it is disposed only once the dialog has
/// fully gone (not during its closing animation, which crashed).
class _WallNameDialog extends StatefulWidget {
  const _WallNameDialog({required this.title, required this.initial});

  final String title;
  final String initial;

  @override
  State<_WallNameDialog> createState() => _WallNameDialogState();
}

class _WallNameDialogState extends State<_WallNameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 40,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: l10n.wallNameLabel,
          hintText: l10n.newWallHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.initial.isEmpty ? l10n.createWall : l10n.save),
        ),
      ],
    );
  }
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
    // Empty until family walls were used here: no family service calls.
    final families = ref.watch(switchableFamiliesProvider);
    final walls =
        ref.watch(memoryRepositoryProvider).asData?.value.walls ?? const [];
    final currentWall = ref.watch(currentWallProvider);
    final onOwnWall = currentFamilyId == null;
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
              selected:
                  onOwnWall &&
                  (currentWall == null ||
                      !walls.any((w) => w.id == currentWall)),
              onTap: () => Navigator.of(context).pop(const _MyWall()),
            ),
            for (final wall in walls)
              _ChoiceTile(
                icon: Icons.dashboard_rounded,
                title: wall.name,
                subtitle: l10n.personalWallSubtitle,
                selected: onOwnWall && currentWall == wall.id,
                onTap: () => Navigator.of(context).pop(_OwnWall(wall.id)),
                onOptions: () =>
                    Navigator.of(context).pop(_WallOptions(wall.id)),
              ),
            _ChoiceTile(
              icon: Icons.add_rounded,
              title: l10n.newWall,
              selected: false,
              onTap: () => Navigator.of(context).pop(const _NewWall()),
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
            if (families.isNotEmpty) ...[
              Divider(color: AppColors.line),
              _ChoiceTile(
                icon: Icons.tune_rounded,
                title: l10n.familyWallsManage,
                selected: false,
                onTap: () => Navigator.of(context).pop(const _ManageWalls()),
              ),
            ],
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
    this.onOptions,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  /// Rename or delete (one's own walls).
  final VoidCallback? onOptions;

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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected) Icon(Icons.check_rounded, color: AppColors.amber),
          if (onOptions != null)
            IconButton(
              tooltip: context.l10n.wallOptions,
              onPressed: onOptions,
              icon: const Icon(Icons.more_horiz_rounded),
            ),
        ],
      ),
    );
  }
}
