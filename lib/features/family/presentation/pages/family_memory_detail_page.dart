import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../memories/presentation/memory_l10n.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_photo.dart';
import '../widgets/family_ui.dart';
import 'family_report_page.dart';

/// What the viewer may do with a family memory, by the server's rules: only
/// the author edits; the author or the family owner deletes; everyone else
/// can report it and block its author.
class FamilyMemoryPermissions {
  const FamilyMemoryPermissions({
    required this.canEdit,
    required this.canDelete,
    required this.canReport,
    required this.canBlockAuthor,
  });

  factory FamilyMemoryPermissions.of({
    required FamilyMemory memory,
    required Family family,
    required String? myId,
  }) {
    final isAuthor = myId != null && memory.authorId == myId;
    final isOwner = family.role == FamilyRole.owner;
    return FamilyMemoryPermissions(
      canEdit: isAuthor,
      canDelete: isAuthor || isOwner,
      canReport: !isAuthor,
      canBlockAuthor: !isAuthor,
    );
  }

  final bool canEdit;
  final bool canDelete;
  final bool canReport;
  final bool canBlockAuthor;
}

enum _DetailAction { delete, report, block }

class FamilyMemoryDetailPage extends ConsumerWidget {
  const FamilyMemoryDetailPage({
    super.key,
    required this.familyId,
    required this.memoryId,
  });

  final String familyId;
  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final family = ref.watch(familyProvider(familyId)).asData?.value;
    final memoriesState = ref.watch(familyMemoriesProvider(familyId));
    final memory = memoriesState.asData?.value
        .where((m) => m.id == memoryId)
        .firstOrNull;
    final account = ref.watch(familyAccountProvider).asData?.value;
    final members =
        ref.watch(familyMembersProvider(familyId)).asData?.value ??
        const <FamilyMember>[];

    if (memory == null || family == null) {
      return FamilyPageScaffold(
        title: l10n.familyMemoryTitle,
        children: [
          if (memoriesState.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            FamilyPanel(
              icon: Icons.help_outline_rounded,
              title: l10n.familyMemoryGone,
            ),
        ],
      );
    }

    final permissions = FamilyMemoryPermissions.of(
      memory: memory,
      family: family,
      myId: account?.id,
    );
    final author = familyAuthorName(
      l10n,
      members,
      memory.authorId,
      myId: account?.id,
    );
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMMd(locale).format(memory.occurredAt);

    return FamilyPageScaffold(
      title: memory.title,
      actions: [
        if (permissions.canEdit)
          IconButton(
            key: const ValueKey('family-memory-edit'),
            tooltip: l10n.edit,
            onPressed: () => context.push(
              RouteNames.familyEditMemoryFor(familyId, memory.id),
            ),
            icon: const Icon(Icons.edit_rounded),
            color: AppColors.gold,
          ),
        if (permissions.canDelete ||
            permissions.canReport ||
            permissions.canBlockAuthor)
          PopupMenuButton<_DetailAction>(
            key: const ValueKey('family-memory-menu'),
            tooltip: l10n.familyMemoryActions,
            onSelected: (action) =>
                _onAction(context, ref, action, memory, family, author),
            itemBuilder: (context) => [
              if (permissions.canReport)
                PopupMenuItem(
                  value: _DetailAction.report,
                  child: Text(l10n.familyReport),
                ),
              if (permissions.canBlockAuthor)
                PopupMenuItem(
                  value: _DetailAction.block,
                  child: Text(l10n.familyBlockAuthor(author)),
                ),
              if (permissions.canDelete)
                PopupMenuItem(
                  value: _DetailAction.delete,
                  child: Text(
                    l10n.delete,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
      ],
      children: [
        if (memory.photoIds.isNotEmpty) ...[
          SizedBox(
            height: 300,
            child: PageView(
              controller: PageController(viewportFraction: 0.92),
              children: [
                for (final photoId in memory.photoIds)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: FamilyPhoto(familyId: familyId, photoId: photoId),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              key: const ValueKey('family-memory-author'),
              icon: Icons.person_rounded,
              label: l10n.familyAddedBy(author),
            ),
            _InfoChip(icon: Icons.event_rounded, label: date),
            if (memory.locationLabel.trim().isNotEmpty)
              _InfoChip(
                icon: Icons.place_rounded,
                label: memory.locationLabel.trim(),
              ),
            _InfoChip(
              icon: memory.feeling.icon,
              label: memory.feeling.localizedLabel(l10n),
              color: memory.feeling.color,
            ),
            _InfoChip(
              icon: Icons.label_rounded,
              label: memory.category.localizedLabel(l10n),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (memory.description.trim().isNotEmpty)
          FamilyPanel(
            icon: Icons.auto_stories_rounded,
            title: l10n.storyPanel,
            child: Text(
              memory.description,
              style: const TextStyle(
                height: 1.55,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    _DetailAction action,
    FamilyMemory memory,
    Family family,
    String author,
  ) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    try {
      switch (action) {
        case _DetailAction.report:
          await reportFamilyContent(
            context,
            familyId: familyId,
            target: FamilyReportTarget.memory,
            targetId: memory.id,
            authorId: memory.authorId,
            authorName: author,
          );
        case _DetailAction.block:
          final confirmed = await confirmFamilyAction(
            context,
            title: l10n.familyBlockQuestion(author),
            body: l10n.familyBlockBody,
            confirmLabel: l10n.familyBlock,
          );
          if (!confirmed) return;
          await service.block(memory.authorId);
          ref.invalidate(familyMembersProvider(familyId));
          AppLogger.event('family_member_blocked');
          if (context.mounted) context.pop();
        case _DetailAction.delete:
          final account = ref.read(familyAccountProvider).asData?.value;
          final asModerator = memory.authorId != account?.id;
          final confirmed = await confirmFamilyAction(
            context,
            title: l10n.familyDeleteMemoryQuestion,
            body: asModerator
                ? l10n.familyDeleteMemoryAsOwnerBody(author)
                : l10n.familyDeleteMemoryBody,
            confirmLabel: l10n.delete,
            danger: true,
          );
          if (!confirmed || !context.mounted) return;
          await runWithFamilyProgress(
            context,
            l10n.familyDeletingMemory,
            () => service.deleteMemory(memory),
          );
          AppLogger.event('family_memory_deleted');
          if (context.mounted) context.pop();
      }
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.panelWarm.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.amber),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
