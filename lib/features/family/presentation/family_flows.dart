import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations_x.dart';
import '../../../core/logging/app_logger.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../onboarding/onboarding_preferences.dart';
import '../../premium/domain/premium_feature.dart';
import '../../premium/presentation/premium_gate.dart';
import '../data/family_service.dart';
import '../domain/family_models.dart';
import 'family_providers.dart';
import 'pages/family_sign_in_page.dart';
import 'pages/family_terms_page.dart';

/// Where the family wall rules live on the web.
final familyTermsUri = Uri.parse('https://gkcoding.dev/lifethreads/terms');

/// Error codes that mean the user backed out (e.g. closed the Apple or
/// Google sheet): nothing to report.
const _cancelCodes = {
  'cancelled',
  'canceled',
  'sign_in_canceled',
  'sign_in_cancelled',
};

bool isFamilyCancellation(Object error) =>
    error is FamilyException && _cancelCodes.contains(error.code);

/// A message for a failed family action, in the user's language.
String familyErrorMessage(AppLocalizations l10n, Object error) {
  if (error is SocketException || error is TimeoutException) {
    return l10n.familyErrorOffline;
  }
  if (error is! FamilyException) return l10n.familyErrorGeneric;
  return switch (error.code) {
    'subscription_required' => l10n.familyErrorSubscriptionRequired,
    'invite_expired' => l10n.familyErrorInviteExpired,
    'invite_used' => l10n.familyErrorInviteUsed,
    'invite_invalid' ||
    'invite_key_invalid' ||
    'invite_not_found' ||
    'invalid_invite' => l10n.familyErrorInviteInvalid,
    'invite_revoked' => l10n.familyErrorInviteRevoked,
    'family_key_missing' => l10n.familyErrorKeyMissing,
    'sign_in_unavailable' => l10n.familyErrorSignInUnavailable,
    'no_purchase_found' => l10n.familyErrorNoPurchase,
    'subscription_verification_not_configured' ||
    'subscription_verification_failed' =>
      l10n.familyErrorVerificationUnavailable,
    'purchase_linked_to_other_account' =>
      l10n.familyErrorPurchaseLinkedElsewhere,
    'name_too_long' => l10n.familyErrorNameTooLong,
    'photo_unreadable' => l10n.familyErrorPhotoUnreadable,
    'too_large' => l10n.familyErrorTooLarge,
    'already_member' => l10n.familyErrorAlreadyMember,
    'family_full' => l10n.familyErrorFamilyFull,
    'quota_exceeded' => l10n.familyErrorQuotaExceeded,
    'version_conflict' => l10n.familyErrorVersionConflict,
    'terms_required' || 'terms_not_accepted' => l10n.familyErrorTermsRequired,
    'unauthorized' ||
    'not_signed_in' ||
    'signed_out' => l10n.familyErrorSignedOut,
    'forbidden' || 'not_author' || 'not_owner' => l10n.familyErrorNotAllowed,
    'not_found' || 'family_not_found' => l10n.familyErrorNotFound,
    'offline' || 'network' || 'network_error' => l10n.familyErrorOffline,
    'owner_cannot_leave' => l10n.familyErrorOwnerCannotLeave,
    'service_unavailable' => l10n.familyUnavailable,
    _ => l10n.familyErrorGeneric,
  };
}

void showFamilyMessage(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(duration: const Duration(seconds: 5), content: Text(message)),
    );
}

void showFamilyError(BuildContext context, Object error) {
  if (isFamilyCancellation(error)) return;
  AppLogger.event(
    'family_error_${error is FamilyException ? error.code : 'unknown'}',
  );
  showFamilyMessage(context, familyErrorMessage(context.l10n, error));
}

/// "1.2 GB" style sizes for the storage bar.
String formatFamilyBytes(BuildContext context, int bytes) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final format = NumberFormat('#,##0.#', locale);
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${format.format(value)} ${units[unit]}';
}

/// How a member is called on cards and in lists.
String familyMemberName(
  AppLocalizations l10n,
  String? displayName, {
  required bool isMe,
}) {
  final name = displayName?.trim() ?? '';
  if (isMe) return name.isEmpty ? l10n.familyYou : l10n.familyYouNamed(name);
  return name.isEmpty ? l10n.familyAMember : name;
}

/// The author of a family memory, by account id.
String familyAuthorName(
  AppLocalizations l10n,
  List<FamilyMember> members,
  String authorId, {
  required String? myId,
}) {
  final member = members.where((m) => m.accountId == authorId).firstOrNull;
  final isMe = authorId == myId;
  if (member == null && !isMe) return l10n.familyFormerMember;
  return familyMemberName(l10n, member?.displayName, isMe: isMe);
}

/// The family service, or null after telling the user family walls are
/// not available in this build.
FamilyService? familyServiceFor(BuildContext context) {
  final container = ProviderScope.containerOf(context, listen: false);
  final service = container.read(familyServiceOrNullProvider);
  if (service == null) {
    showFamilyMessage(context, context.l10n.familyUnavailable);
  }
  return service;
}

/// Runs [task] behind a blocking progress dialog.
Future<T> runWithFamilyProgress<T>(
  BuildContext context,
  String message,
  Future<T> Function() task,
) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  var open = true;
  unawaited(
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: FamilyProgressDialog(message: message),
      ),
    ).whenComplete(() => open = false),
  );
  try {
    return await task();
  } finally {
    if (open && navigator.mounted) navigator.pop();
  }
}

class FamilyProgressDialog extends StatelessWidget {
  const FamilyProgressDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Gates -----------------------------------------------------------------------

/// The signed-in account, after the sign-in screen if needed; null when the
/// user backs out or family walls are unavailable.
Future<FamilyAccount?> ensureFamilyAccount(BuildContext context) async {
  final service = familyServiceFor(context);
  if (service == null) return null;
  FamilyAccount? account;
  try {
    account = await service.watchAccount().first.timeout(
      const Duration(seconds: 10),
    );
  } catch (_) {
    account = null;
  }
  if (account != null) return account;
  if (!context.mounted) return null;
  return Navigator.of(context).push<FamilyAccount>(
    MaterialPageRoute(builder: (_) => const FamilySignInPage()),
  );
}

/// [account] once it has accepted the current family wall terms, after the
/// terms screen if needed; null when the user does not accept.
Future<FamilyAccount?> ensureFamilyTerms(
  BuildContext context,
  FamilyAccount account,
) async {
  if (account.termsAccepted) return account;
  return Navigator.of(context).push<FamilyAccount>(
    MaterialPageRoute(builder: (_) => FamilyTermsPage(account: account)),
  );
}

/// Signed in and terms accepted: what posting to a family wall needs.
Future<FamilyAccount?> ensureFamilyPosting(BuildContext context) async {
  final account = await ensureFamilyAccount(context);
  if (account == null || !context.mounted) return null;
  return ensureFamilyTerms(context, account);
}

// Create ----------------------------------------------------------------------

/// Premium, account, terms, a server-verified subscription, then a name.
/// Opens the new family wall.
Future<void> createFamilyFlow(BuildContext context) async {
  if (!await requirePremium(context, PremiumFeature.familyWall)) return;
  if (!context.mounted) return;
  final service = familyServiceFor(context);
  if (service == null) return;
  var account = await ensureFamilyPosting(context);
  if (account == null || !context.mounted) return;
  final l10n = context.l10n;
  final container = ProviderScope.containerOf(context, listen: false);

  try {
    if (!account.hasActiveSubscription) {
      account = await runWithFamilyProgress(
        context,
        l10n.familyCheckingSubscription,
        service.linkSubscription,
      );
      if (!context.mounted) return;
      if (!account.hasActiveSubscription) {
        showFamilyMessage(context, l10n.familyErrorSubscriptionRequired);
        return;
      }
    }

    final personalName = await _personalName(container);
    if (!context.mounted) return;
    final input = await showDialog<_FamilyNameInput>(
      context: context,
      builder: (_) => _CreateFamilyDialog(initialDisplayName: personalName),
    );
    if (input == null || !context.mounted) return;

    final family = await runWithFamilyProgress(
      context,
      l10n.familyCreating,
      () async {
        final family = await service.createFamily(input.name);
        if (input.displayName.isNotEmpty) {
          await service.setMyDisplayName(family.id, input.displayName);
        }
        return family;
      },
    );
    await container.read(familyWallsActiveProvider.notifier).setActive(true);
    AppLogger.event('family_created');
    if (!context.mounted) return;
    unawaited(context.push(RouteNames.familyWallFor(family.id)));
  } catch (error) {
    if (context.mounted) showFamilyError(context, error);
  }
}

Future<String> _personalName(ProviderContainer container) async {
  try {
    return await container.read(userDisplayNameProvider.future);
  } catch (_) {
    return '';
  }
}

class _FamilyNameInput {
  const _FamilyNameInput(this.name, this.displayName);

  final String name;
  final String displayName;
}

class _CreateFamilyDialog extends StatefulWidget {
  const _CreateFamilyDialog({required this.initialDisplayName});

  final String initialDisplayName;

  @override
  State<_CreateFamilyDialog> createState() => _CreateFamilyDialogState();
}

class _CreateFamilyDialogState extends State<_CreateFamilyDialog> {
  final _name = TextEditingController();
  late final _displayName = TextEditingController(
    text: widget.initialDisplayName,
  );

  @override
  void dispose() {
    _name.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.familyCreateTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey('family-name-field'),
              controller: _name,
              autofocus: true,
              maxLength: 60,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.familyNameLabel,
                hintText: l10n.familyNameHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const ValueKey('family-display-name-field'),
              controller: _displayName,
              maxLength: 40,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.familyMyNameLabel,
                helperText: l10n.familyMyNameHelper,
                helperMaxLines: 3,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _name.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(
                  _FamilyNameInput(_name.text.trim(), _displayName.text.trim()),
                ),
          child: Text(l10n.familyCreateAction),
        ),
      ],
    );
  }
}

// Join ------------------------------------------------------------------------

/// Joins the family in an invite [link] after sign-in and a confirmation,
/// then opens its wall. Joining needs no Premium of one's own: the owner's
/// subscription covers the family.
Future<void> joinFamilyFlow(BuildContext context, Uri link) async {
  final service = familyServiceFor(context);
  if (service == null) return;
  final l10n = context.l10n;
  if (!service.isInviteLink(link)) {
    showFamilyMessage(context, l10n.familyErrorInviteInvalid);
    return;
  }
  final account = await ensureFamilyAccount(context);
  if (account == null || !context.mounted) return;
  final container = ProviderScope.containerOf(context, listen: false);
  final personalName = await _personalName(container);
  if (!context.mounted) return;

  final displayName = await showDialog<String>(
    context: context,
    builder: (_) => _JoinFamilyDialog(initialDisplayName: personalName),
  );
  if (displayName == null || !context.mounted) return;

  try {
    final family = await runWithFamilyProgress(
      context,
      l10n.familyJoining,
      () async {
        final family = await service.acceptInvite(link);
        if (displayName.isNotEmpty) {
          await service.setMyDisplayName(family.id, displayName);
        }
        return family;
      },
    );
    await container.read(familyWallsActiveProvider.notifier).setActive(true);
    AppLogger.event('family_joined');
    if (!context.mounted) return;
    showFamilyMessage(context, l10n.familyJoined(family.name));
    unawaited(context.push(RouteNames.familyWallFor(family.id)));
  } catch (error) {
    if (context.mounted) showFamilyError(context, error);
  }
}

class _JoinFamilyDialog extends StatefulWidget {
  const _JoinFamilyDialog({required this.initialDisplayName});

  final String initialDisplayName;

  @override
  State<_JoinFamilyDialog> createState() => _JoinFamilyDialogState();
}

class _JoinFamilyDialogState extends State<_JoinFamilyDialog> {
  late final _displayName = TextEditingController(
    text: widget.initialDisplayName,
  );

  @override
  void dispose() {
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.familyJoinTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.familyJoinBody),
            const SizedBox(height: 14),
            TextField(
              key: const ValueKey('family-join-name-field'),
              controller: _displayName,
              maxLength: 40,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.familyMyNameLabel,
                helperText: l10n.familyMyNameHelper,
                helperMaxLines: 3,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_displayName.text.trim()),
          child: Text(l10n.familyJoinAction),
        ),
      ],
    );
  }
}

/// "Join with link": paste an invite link someone sent.
Future<void> pasteInviteFlow(BuildContext context) async {
  final text = await showDialog<String>(
    context: context,
    builder: (_) => const _PasteInviteDialog(),
  );
  if (text == null || !context.mounted) return;
  final link = Uri.tryParse(text.trim());
  if (link == null || !link.hasScheme) {
    showFamilyMessage(context, context.l10n.familyErrorInviteInvalid);
    return;
  }
  await joinFamilyFlow(context, link);
}

class _PasteInviteDialog extends StatefulWidget {
  const _PasteInviteDialog();

  @override
  State<_PasteInviteDialog> createState() => _PasteInviteDialogState();
}

class _PasteInviteDialogState extends State<_PasteInviteDialog> {
  final _link = TextEditingController();

  // Read only on request: iOS shows a paste notice for every clipboard read.
  Future<void> _paste() async {
    try {
      final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
      if (text != null && mounted) {
        setState(() => _link.text = text.trim());
      }
    } catch (_) {
      // Nothing to paste.
    }
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.familyJoinWithLink),
      content: TextField(
        key: const ValueKey('family-invite-link-field'),
        controller: _link,
        autofocus: true,
        keyboardType: TextInputType.url,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          labelText: l10n.familyInviteLinkLabel,
          hintText: 'https://…',
          suffixIcon: IconButton(
            tooltip: l10n.familyPaste,
            onPressed: _paste,
            icon: const Icon(Icons.content_paste_rounded),
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _link.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(_link.text.trim()),
          child: Text(l10n.continueAction),
        ),
      ],
    );
  }
}

// Confirmations ---------------------------------------------------------------

/// A yes/no question; true when the user confirms.
Future<bool> confirmFamilyAction(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool danger = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          style: danger
              ? FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: AppColors.text,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
