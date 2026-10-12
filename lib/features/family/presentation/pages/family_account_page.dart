import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_ui.dart';

/// The family wall account: who is signed in, sign out, delete account.
class FamilyAccountPage extends ConsumerWidget {
  const FamilyAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final account = ref.watch(familyAccountProvider).asData?.value;
    final families = ref.watch(familiesProvider).asData?.value ?? const [];
    final ownedCount = account == null
        ? 0
        : families.where((f) => f.ownerId == account.id).length;

    return FamilyPageScaffold(
      title: l10n.familyAccountTitle,
      children: [
        if (account == null)
          FamilyPanel(
            icon: Icons.person_outline_rounded,
            title: l10n.familySignedOutTitle,
            body: l10n.familySignedOutBody,
            actions: [
              FamilyAction(
                label: l10n.familySignIn,
                icon: Icons.login_rounded,
                onTap: () => ensureFamilyAccount(context),
              ),
            ],
          )
        else ...[
          FamilyPanel(
            icon: Icons.verified_user_rounded,
            title: l10n.familySignedInTitle,
            body: l10n.familySignedInBody,
            actions: [
              FamilyAction(
                key: const ValueKey('family-sign-out'),
                label: l10n.familySignOut,
                icon: Icons.logout_rounded,
                onTap: () => _signOut(context, ref),
              ),
            ],
            child: GestureDetector(
              onLongPress: () =>
                  Clipboard.setData(ClipboardData(text: account.id)),
              child: Text(
                l10n.familyAccountId(account.id),
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          FamilyPanel(
            icon: Icons.delete_forever_rounded,
            title: l10n.familyDeleteAccountTitle,
            body: l10n.familyDeleteAccountBody,
            danger: true,
            actions: [
              FamilyAction(
                key: const ValueKey('family-delete-account'),
                label: l10n.familyDeleteAccount,
                icon: Icons.delete_outline_rounded,
                danger: true,
                onTap: () => _deleteAccount(context, ref, ownedCount),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    final confirmed = await confirmFamilyAction(
      context,
      title: l10n.familySignOutQuestion,
      body: l10n.familySignOutBody,
      confirmLabel: l10n.familySignOut,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await runWithFamilyProgress(context, l10n.familySigningOut, () async {
        await service.signOut();
        await ref.read(familyWallsActiveProvider.notifier).setActive(false);
      });
      AppLogger.event('family_signed_out');
      if (context.mounted) Navigator.of(context).maybePop();
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }

  Future<void> _deleteAccount(
    BuildContext context,
    WidgetRef ref,
    int ownedCount,
  ) async {
    final l10n = context.l10n;
    final service = familyServiceFor(context);
    if (service == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _DeleteAccountDialog(ownedCount: ownedCount),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await runWithFamilyProgress(
        context,
        l10n.familyDeletingAccount,
        () async {
          await service.deleteAccount();
          await ref.read(familyWallsActiveProvider.notifier).setActive(false);
        },
      );
      AppLogger.event('family_account_deleted');
      if (!context.mounted) return;
      showFamilyMessage(context, l10n.familyAccountDeleted);
      Navigator.of(context).maybePop();
    } catch (error) {
      if (context.mounted) showFamilyError(context, error);
    }
  }
}

/// Spells out what deleting the account removes, and needs a tick before
/// the delete button works.
class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.ownedCount});

  final int ownedCount;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  var _understood = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.familyDeleteAccountQuestion),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyPoint(
              icon: Icons.family_restroom_rounded,
              text: l10n.familyDeleteAccountOwned(widget.ownedCount),
            ),
            FamilyPoint(
              icon: Icons.photo_library_rounded,
              text: l10n.familyDeleteAccountPosts,
            ),
            FamilyPoint(
              icon: Icons.key_off_rounded,
              text: l10n.familyDeleteAccountKeys,
            ),
            FamilyPoint(
              icon: Icons.phone_iphone_rounded,
              text: l10n.familyDeleteAccountMyWall,
            ),
            FamilyPoint(
              icon: Icons.workspace_premium_rounded,
              text: l10n.familyDeleteAccountSubscription,
            ),
            CheckboxListTile(
              key: const ValueKey('family-delete-understood'),
              value: _understood,
              onChanged: (value) =>
                  setState(() => _understood = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.familyDeleteAccountUnderstood,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('family-delete-account-confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: AppColors.text,
          ),
          onPressed: _understood ? () => Navigator.of(context).pop(true) : null,
          child: Text(l10n.familyDeleteAccount),
        ),
      ],
    );
  }
}
