import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import 'family_ui.dart';

/// Creates an invite link for [family] and offers it through the share
/// sheet or the clipboard.
Future<void> inviteToFamily(BuildContext context, Family family) async {
  final service = familyServiceFor(context);
  if (service == null) return;
  final l10n = context.l10n;
  try {
    final link = await runWithFamilyProgress(
      context,
      l10n.familyCreatingInvite,
      () => service.createInvite(family.id),
    );
    AppLogger.event('family_invite_created');
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FamilyInviteSheet(family: family, link: link),
    );
  } catch (error) {
    if (context.mounted) showFamilyError(context, error);
  }
}

class FamilyInviteSheet extends ConsumerWidget {
  const FamilyInviteSheet({
    super.key,
    required this.family,
    required this.link,
  });

  final Family family;
  final Uri link;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.familyInviteReady,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            FamilyPoint(
              icon: Icons.timer_outlined,
              text: l10n.familyInviteValidity,
            ),
            FamilyPoint(
              icon: Icons.key_rounded,
              text: l10n.familyInviteKeyWarning,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.wallInk.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                link.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              key: const ValueKey('family-invite-share'),
              onPressed: () => _share(context, ref),
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(l10n.familyInviteShare),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: const ValueKey('family-invite-copy'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: link.toString()));
                if (context.mounted) {
                  showFamilyMessage(context, l10n.familyInviteCopied);
                }
              },
              icon: const Icon(Icons.copy_rounded),
              label: Text(l10n.familyInviteCopy),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final box = context.findRenderObject() as RenderBox?;
    try {
      await ref.read(familyShareSheetProvider)(
        ShareParams(
          subject: l10n.familyInviteSubject(family.name),
          text: l10n.familyInviteText(family.name, link.toString()),
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        showFamilyMessage(context, l10n.familyInviteShareFailed);
      }
    }
  }
}
