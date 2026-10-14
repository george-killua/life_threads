import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_invite_sheet.dart';
import '../widgets/family_ui.dart';
import 'family_report_page.dart';

/// One family wall's settings: name, storage, my name, invites, members
/// and leaving or deleting it. What shows depends on the role: the owner
/// renames, removes members and deletes the wall; members leave.
class FamilySettingsPage extends ConsumerWidget {
  const FamilySettingsPage({super.key, required this.familyId});

  final String familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final familyState = ref.watch(familyProvider(familyId));
    final account = ref.watch(familyAccountProvider).asData?.value;
    final family = familyState.asData?.value;

    if (family == null) {
      return FamilyPageScaffold(
        title: l10n.familySettingsTitle,
        children: [
          if (familyState.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            FamilyPanel(
              icon: Icons.help_outline_rounded,
              title: l10n.familyErrorNotFound,
            ),
        ],
      );
    }

    final isOwner = family.role == FamilyRole.owner;
    final membersState = ref.watch(familyMembersProvider(familyId));
    final members = membersState.asData?.value ?? const <FamilyMember>[];
    final me = members.where((m) => m.accountId == account?.id).firstOrNull;

    return FamilyPageScaffold(
      title: family.name,
      children: [
        FamilyPanel(
          icon: Icons.diversity_1_rounded,
          title: l10n.familySettingsTitle,
          badge: isOwner ? l10n.familyRoleOwner : l10n.familyRoleMember,
          actions: [
            if (isOwner)
              FamilyAction(
                key: const ValueKey('family-rename'),
                label: l10n.familyRename,
                icon: Icons.edit_rounded,
                secondary: true,
                onTap: () => _rename(context, family),
              ),
            FamilyAction(
              key: const ValueKey('family-my-name'),
              label: l10n.familySetMyName,
              icon: Icons.badge_rounded,
              secondary: true,
              onTap: () => _setMyName(context, ref, me?.displayName ?? ''),
            ),
          ],
          child: FamilyUsageBar(
            usedBytes: family.usedBytes,
            quotaBytes: family.quotaBytes,
            label: l10n.familyStorageUsed(
              formatFamilyBytes(context, family.usedBytes),
              formatFamilyBytes(context, family.quotaBytes),
            ),
          ),
        ),
        FamilyPanel(
          icon: Icons.person_add_alt_1_rounded,
          title: l10n.familyInviteTitle,
          body: l10n.familyInviteBody,
          actions: [
            FamilyAction(
              key: const ValueKey('family-invite'),
              label: l10n.familyInviteAction,
              icon: Icons.ios_share_rounded,
              onTap: () => inviteToFamily(context, family),
            ),
          ],
        ),
        FamilyPanel(
          icon: Icons.groups_rounded,
          title: l10n.familyMembersTitle,
          body: l10n.familyMemberCount(family.memberCount),
          child: membersState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text(familyErrorMessage(l10n, error)),
            data: (members) => Column(
              children: [
                for (final member in members)
                  _MemberTile(
                    family: family,
                    member: member,
                    isMe: member.accountId == account?.id,
                    viewerIsOwner: isOwner,
                  ),
              ],
            ),
          ),
        ),
        if (isOwner)
          FamilyPanel(
            icon: Icons.delete_forever_rounded,
            title: l10n.familyDeleteTitle,
            body: l10n.familyDeleteBody,
            danger: true,
            actions: [
              FamilyAction(
                key: const ValueKey('family-delete'),
                label: l10n.familyDeleteAction,
                icon: Icons.delete_outline_rounded,
                danger: true,
                onTap: () => _delete(context, family),
              ),
            ],
          )
        else
          FamilyPanel(
            icon: Icons.logout_rounded,
            title: l10n.familyLeaveTitle,
            body: l10n.familyLeaveBody,
            danger: true,
            actions: [
              FamilyAction(
                key: const ValueKey('family-leave'),
                label: l10n.familyLeaveAction,
                icon: Icons.logout_rounded,
                danger: true,
                onTap: () => _leave(context, family),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _rename(BuildContext context, Family family) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    final name = await showFamilyTextDialog(
      context,
      title: l10n.familyRename,
      label: l10n.familyNameLabel,
      initialText: family.name,
      maxLength: 60,
    );
    if (name == null || name.isEmpty || !context.mounted) return;
    try {
      await service.renameFamily(family.id, name);
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }

  Future<void> _setMyName(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    final name = await showFamilyTextDialog(
      context,
      title: l10n.familySetMyName,
      label: l10n.familyMyNameLabel,
      helper: l10n.familyMyNameHelper,
      initialText: current,
      maxLength: 40,
    );
    if (name == null || name.isEmpty || !context.mounted) return;
    try {
      await service.setMyDisplayName(familyId, name);
      ref.invalidate(familyMembersProvider(familyId));
      if (context.mounted) showFamilyMessage(context, l10n.familyMyNameSaved);
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }

  Future<void> _delete(BuildContext context, Family family) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    final confirmed = await confirmFamilyAction(
      context,
      title: l10n.familyDeleteQuestion(family.name),
      body: l10n.familyDeleteConfirmBody,
      confirmLabel: l10n.familyDeleteAction,
      danger: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await runWithFamilyProgress(
        context,
        l10n.familyDeleting,
        () => service.deleteFamily(family.id),
      );
      AppLogger.event('family_deleted');
      if (context.mounted) context.go(RouteNames.familyWalls);
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }

  Future<void> _leave(BuildContext context, Family family) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    final deleteContent = await showDialog<bool>(
      context: context,
      builder: (_) => _ContentChoiceDialog(
        title: l10n.familyLeaveQuestion(family.name),
        body: l10n.familyLeaveConfirmBody,
        checkboxLabel: l10n.familyLeaveDeleteMine,
        confirmLabel: l10n.familyLeaveAction,
      ),
    );
    if (deleteContent == null || !context.mounted) return;
    try {
      await runWithFamilyProgress(
        context,
        l10n.familyLeaving,
        () => service.leaveFamily(family.id, deleteMyContent: deleteContent),
      );
      AppLogger.event('family_left');
      if (context.mounted) context.go(RouteNames.familyWalls);
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }
}

class _MemberTile extends ConsumerWidget {
  const _MemberTile({
    required this.family,
    required this.member,
    required this.isMe,
    required this.viewerIsOwner,
  });

  final Family family;
  final FamilyMember member;
  final bool isMe;
  final bool viewerIsOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = familyMemberName(l10n, member.displayName, isMe: isMe);
    final role = member.role == FamilyRole.owner
        ? l10n.familyRoleOwner
        : l10n.familyRoleMember;
    return ListTile(
      key: ValueKey('family-member-${member.accountId}'),
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.wallPlum,
        foregroundColor: AppColors.amber,
        child: Text(name.characters.firstOrNull?.toUpperCase() ?? '?'),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(
        member.isBlockedByMe ? '$role • ${l10n.familyBlocked}' : role,
      ),
      trailing: isMe
          ? null
          : PopupMenuButton<_MemberAction>(
              key: ValueKey('family-member-menu-${member.accountId}'),
              tooltip: l10n.familyMemberActions,
              onSelected: (action) => _onAction(context, ref, action, name),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: member.isBlockedByMe
                      ? _MemberAction.unblock
                      : _MemberAction.block,
                  child: Text(
                    member.isBlockedByMe
                        ? l10n.familyUnblock
                        : l10n.familyBlock,
                  ),
                ),
                PopupMenuItem(
                  value: _MemberAction.report,
                  child: Text(l10n.familyReport),
                ),
                if (viewerIsOwner && member.role != FamilyRole.owner)
                  PopupMenuItem(
                    value: _MemberAction.remove,
                    child: Text(
                      l10n.familyRemoveMember,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    _MemberAction action,
    String name,
  ) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    try {
      switch (action) {
        case _MemberAction.block:
          final confirmed = await confirmFamilyAction(
            context,
            title: l10n.familyBlockQuestion(name),
            body: l10n.familyBlockBody,
            confirmLabel: l10n.familyBlock,
          );
          if (!confirmed) return;
          await service.block(member.accountId);
        case _MemberAction.unblock:
          await service.unblock(member.accountId);
        case _MemberAction.report:
          await reportFamilyContent(
            context,
            familyId: family.id,
            target: FamilyReportTarget.member,
            targetId: member.accountId,
            authorId: member.isBlockedByMe ? null : member.accountId,
            authorName: name,
          );
        case _MemberAction.remove:
          final deleteContent = await showDialog<bool>(
            context: context,
            builder: (_) => _ContentChoiceDialog(
              title: l10n.familyRemoveQuestion(name),
              body: l10n.familyRemoveBody,
              checkboxLabel: l10n.familyRemoveDeleteContent,
              confirmLabel: l10n.familyRemoveMember,
            ),
          );
          if (deleteContent == null) return;
          await service.removeMember(
            family.id,
            member.accountId,
            deleteContent: deleteContent,
          );
          AppLogger.event('family_member_removed');
      }
      ref.invalidate(familyMembersProvider(family.id));
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }
}

enum _MemberAction { block, unblock, report, remove }

/// A danger confirmation with a "also delete content" checkbox; pops the
/// checkbox value, or null when cancelled.
class _ContentChoiceDialog extends StatefulWidget {
  const _ContentChoiceDialog({
    required this.title,
    required this.body,
    required this.checkboxLabel,
    required this.confirmLabel,
  });

  final String title;
  final String body;
  final String checkboxLabel;
  final String confirmLabel;

  @override
  State<_ContentChoiceDialog> createState() => _ContentChoiceDialogState();
}

class _ContentChoiceDialogState extends State<_ContentChoiceDialog> {
  var _deleteContent = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.body),
            const SizedBox(height: 8),
            CheckboxListTile(
              key: const ValueKey('family-delete-content'),
              value: _deleteContent,
              onChanged: (value) =>
                  setState(() => _deleteContent = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(widget.checkboxLabel),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('family-content-choice-confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.text,
          ),
          onPressed: () => Navigator.of(context).pop(_deleteContent),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// A one-field text dialog; pops the trimmed text or null.
Future<String?> showFamilyTextDialog(
  BuildContext context, {
  required String title,
  required String label,
  String initialText = '',
  String? helper,
  int maxLength = 60,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _FamilyTextDialog(
      title: title,
      label: label,
      initialText: initialText,
      helper: helper,
      maxLength: maxLength,
    ),
  );
}

class _FamilyTextDialog extends StatefulWidget {
  const _FamilyTextDialog({
    required this.title,
    required this.label,
    required this.initialText,
    required this.helper,
    required this.maxLength,
  });

  final String title;
  final String label;
  final String initialText;
  final String? helper;
  final int maxLength;

  @override
  State<_FamilyTextDialog> createState() => _FamilyTextDialogState();
}

class _FamilyTextDialogState extends State<_FamilyTextDialog> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        key: const ValueKey('family-text-field'),
        controller: _controller,
        autofocus: true,
        maxLength: widget.maxLength,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: widget.helper,
          helperMaxLines: 3,
        ),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}
