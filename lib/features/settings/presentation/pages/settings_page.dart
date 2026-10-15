import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/top_bar_page.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../app_lock/app_lock.dart';
import '../../../backup/data/backup_reminder.dart';
import '../../../backup/data/backup_service.dart';
import '../../../backup/domain/backup_models.dart';
import '../../../backup/presentation/widgets/archive_feedback.dart';
import '../../../backup/presentation/widgets/archive_password_dialog.dart';
import '../../../capsule/data/memory_capsule_service.dart';
import '../../../capsule/domain/memory_capsule_models.dart';
import '../../../capsule/presentation/widgets/memory_capsule_dialogs.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../on_this_day/data/on_this_day_notifications.dart';
import '../../../on_this_day/data/on_this_day_settings.dart';
import '../../../onboarding/onboarding_preferences.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../../premium/domain/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../../stories/data/music_catalog.dart';
import '../../../wall/presentation/widgets/wall_background.dart';
import '../../../wall/presentation/widgets/wall_theme_picker.dart';
import '../../../../core/widgets/app_toast.dart';

/// Settings: a short list. Backup and the app's information have screens
/// of their own; Thread of the Year and family walls are in the wall's More
/// menu.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
    final selectedLocale = ref.watch(localeControllerProvider).asData?.value;
    final displayName = ref.watch(userDisplayNameProvider).asData?.value ?? '';
    final isPremium = entitlement?.isPremium ?? false;
    final onThisDay =
        ref.watch(onThisDaySettingsProvider).asData?.value ??
        const OnThisDaySettings();
    // Reminders only run with Premium; after it ends the switch shows off.
    final remindersOn = onThisDay.remindersEnabled && isPremium;
    final appLock = ref.watch(appLockProvider);

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: l10n.settingsTitle,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _PremiumBanner(
                  isPremium: isPremium,
                  onTap: () => context.push(RouteNames.upgrade),
                ),
                _SettingsGroup(
                  title: l10n.settingsGroupYou,
                  children: [
                    _SettingsRow(
                      key: const ValueKey('settings-name'),
                      icon: Icons.person_rounded,
                      title: l10n.settingsNameTitle,
                      value: displayName,
                      onTap: () => _editName(context, ref, displayName),
                    ),
                    _SettingsRow(
                      key: const ValueKey('settings-language'),
                      icon: Icons.language_rounded,
                      title: l10n.languageTitle,
                      value: _languageLabel(l10n, selectedLocale),
                      onTap: () =>
                          _chooseLanguage(context, ref, selectedLocale),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 2),
                      child: WallThemeSummary(),
                    ),
                  ],
                ),
                _SettingsGroup(
                  title: l10n.settingsGroupPrivacy,
                  children: [
                    _SettingsRow(
                      key: const ValueKey('settings-app-lock'),
                      icon: Icons.lock_rounded,
                      title: l10n.appLockTitle,
                      value: l10n.appLockSubtitle,
                      mergeSemantics: true,
                      onTap: () => _setAppLock(context, ref, !appLock.enabled),
                      trailing: Switch.adaptive(
                        value: appLock.enabled,
                        onChanged: (value) => _setAppLock(context, ref, value),
                      ),
                    ),
                  ],
                ),
                _SettingsGroup(
                  title: l10n.settingsGroupReminders,
                  children: [
                    _SettingsRow(
                      key: const ValueKey('settings-on-this-day'),
                      icon: Icons.event_repeat_rounded,
                      title: l10n.onThisDayTitle,
                      value: isPremium
                          ? l10n.onThisDayReminderSwitch
                          : l10n.premiumBadge,
                      // One control for screen readers, and the whole row
                      // toggles like a list tile.
                      mergeSemantics: true,
                      onTap: () =>
                          _setOnThisDayReminders(context, ref, !remindersOn),
                      trailing: Switch.adaptive(
                        value: remindersOn,
                        onChanged: (value) =>
                            _setOnThisDayReminders(context, ref, value),
                      ),
                    ),
                    if (remindersOn)
                      _SettingsRow(
                        icon: Icons.schedule_rounded,
                        title: l10n.onThisDayReminderAt(
                          onThisDay.time.format(context),
                        ),
                        onTap: () =>
                            _pickOnThisDayTime(context, ref, onThisDay),
                      ),
                  ],
                ),
                _SettingsGroup(
                  title: l10n.settingsGroupMore,
                  children: [
                    _SettingsRow(
                      key: const ValueKey('settings-backup-data'),
                      icon: Icons.enhanced_encryption_rounded,
                      title: l10n.backupDataTitle,
                      value: l10n.backupDataSubtitle,
                      onTap: () => context.push(RouteNames.backupData),
                    ),
                    _SettingsRow(
                      key: const ValueKey('settings-about-help'),
                      icon: Icons.info_rounded,
                      title: l10n.aboutHelpTitle,
                      value: l10n.aboutHelpSubtitle,
                      onTap: () => context.push(RouteNames.aboutHelp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Backup and restore, moving to a new phone, and (last, in red) clearing
/// everything.
class BackupDataPage extends ConsumerWidget {
  const BackupDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final memoryState = ref.watch(memoryRepositoryProvider);
    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: l10n.backupDataTitle,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _SettingsCard(
                  icon: Icons.enhanced_encryption_rounded,
                  title: l10n.backupArchiveTitle,
                  body: l10n.backupArchiveBody,
                  actions: [
                    _SettingsAction(
                      label: l10n.exportArchive,
                      icon: Icons.ios_share_rounded,
                      onTap: memoryState.asData == null
                          ? null
                          : () =>
                                _exportBackup(context, ref, memoryState.value!),
                    ),
                    _SettingsAction(
                      label: l10n.importArchive,
                      icon: Icons.restore_rounded,
                      onTap: () => _importBackup(context, ref),
                    ),
                    _SettingsAction(
                      label: l10n.importCapsule,
                      icon: Icons.inventory_2_rounded,
                      onTap: () => _importCapsule(context, ref),
                    ),
                    _SettingsAction(
                      label: l10n.moveDevices,
                      icon: Icons.devices_rounded,
                      onTap: () => context.push(RouteNames.archiveTransfer),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _SettingsCard(
                  icon: Icons.delete_forever_rounded,
                  title: l10n.clearAllDataTitle,
                  body: l10n.clearAllDataBody,
                  danger: true,
                  actions: [
                    _SettingsAction(
                      label: l10n.clearData,
                      icon: Icons.delete_outline_rounded,
                      danger: true,
                      onTap: () => _clearAllData(context, ref),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Feedback, privacy policy and terms, music credits and the app version.
class AboutHelpPage extends StatelessWidget {
  const AboutHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: l10n.aboutHelpTitle,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _SettingsCard(
                  icon: Icons.feedback_rounded,
                  title: l10n.betaFeedbackTitle,
                  body: l10n.betaFeedbackBody,
                  badge: l10n.closedBetaBadge,
                  actions: [
                    _SettingsAction(
                      label: l10n.sendFeedback,
                      icon: Icons.mail_outline_rounded,
                      onTap: () => _showBetaFeedback(context),
                    ),
                  ],
                ),
                _SettingsCard(
                  icon: Icons.lock_rounded,
                  title: l10n.privacyTitle,
                  body: l10n.privacyBody,
                  actions: [
                    _SettingsAction(
                      label: l10n.viewPrivacyPolicy,
                      icon: Icons.policy_rounded,
                      onTap: () => _openExternalUrl(
                        context,
                        Uri.parse('https://gkcoding.dev/lifethreads/privacy'),
                        eventName: 'privacy_policy_opened',
                      ),
                    ),
                    _SettingsAction(
                      label: l10n.viewTerms,
                      icon: Icons.gavel_rounded,
                      onTap: () => _openExternalUrl(
                        context,
                        Uri.parse('https://gkcoding.dev/lifethreads/terms'),
                        eventName: 'terms_opened',
                      ),
                    ),
                  ],
                ),
                _SettingsCard(
                  icon: Icons.music_note_rounded,
                  title: l10n.musicCreditsTitle,
                  body: l10n.musicCreditsBody,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final track in bundledMusicTracks)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            l10n.musicCreditLine(
                              track.title,
                              track.artist,
                              track.license,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ),
                _SettingsCard(
                  icon: Icons.info_rounded,
                  title: l10n.appVersionTitle,
                  body: '',
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final info = snapshot.data;
                      return Text(
                        info == null
                            ? 'LifeThreads'
                            : '${info.version}+${info.buildNumber}',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
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

/// Turns the app lock on (after Face ID or the passcode) or off.
Future<void> _setAppLock(
  BuildContext context,
  WidgetRef ref,
  bool enabled,
) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final done = await ref
      .read(appLockProvider.notifier)
      .setEnabled(enabled, reason: l10n.appLockReason);
  if (!done && enabled) {
    messenger.showToast(l10n.appLockUnavailable, kind: ToastKind.error);
  }
}

/// Edits the name in a sheet.
Future<void> _editName(
  BuildContext context,
  WidgetRef ref,
  String displayName,
) {
  final l10n = context.l10n;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.settingsNameTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.settingsNameBody,
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 14),
          _DisplayNameEditor(
            initialName: displayName,
            onSave: (name) async {
              await ref
                  .read(userDisplayNameProvider.notifier)
                  .setDisplayName(name);
              if (!sheetContext.mounted) return;
              Navigator.of(sheetContext).pop();
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showToast(l10n.settingsNameSaved, kind: ToastKind.success);
            },
          ),
        ],
      ),
    ),
  );
}

/// Picks the language in a sheet.
Future<void> _chooseLanguage(
  BuildContext context,
  WidgetRef ref,
  Locale? selectedLocale,
) async {
  final chosen = await showModalBottomSheet<({Locale? locale})>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              sheetContext.l10n.languageTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            _LanguageSelector(
              selectedLocale: selectedLocale,
              onSelect: (locale) =>
                  Navigator.of(sheetContext).pop((locale: locale)),
            ),
          ],
        ),
      ),
    ),
  );
  if (chosen == null || !context.mounted) return;
  await _selectLanguage(context, ref, chosen.locale);
}

/// Status and a way in, at the top of Settings.
class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner({required this.isPremium, required this.onTap});

  final bool isPremium;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: AppColors.gold.withValues(alpha: 0.45)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Material(
        color: AppColors.gold.withValues(alpha: 0.12),
        shape: shape,
        child: InkWell(
          key: const ValueKey('settings-premium'),
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.gold,
                  size: 30,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.premiumTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPremium
                            ? l10n.premiumActiveBody
                            : l10n.premiumLockedBody,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isPremium ? l10n.activeBadge : l10n.unlockBadge,
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
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

/// A titled group of rows on one panel.
class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, bottom: 8),
            // Its own node: not read as part of the first row.
            child: Semantics(
              container: true,
              header: true,
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.panelWarm.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.line),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0)
                      Divider(height: 1, indent: 56, color: AppColors.line),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One row: icon, title, a short grey line, and a chevron or [trailing].
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.trailing,
    this.mergeSemantics = false,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// Reads the row and its [trailing] control as one (a switch row).
  final bool mergeSemantics;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final row = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (value != null && value!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      value!,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing ??
                Icon(
                  rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: AppColors.muted,
                ),
          ],
        ),
      ),
    );
    if (!mergeSemantics) return row;
    return Semantics(container: true, child: MergeSemantics(child: row));
  }
}

Future<void> _selectLanguage(
  BuildContext context,
  WidgetRef ref,
  Locale? locale,
) async {
  if (locale == null) {
    await ref.read(localeControllerProvider.notifier).useSystemLanguage();
  } else {
    await ref.read(localeControllerProvider.notifier).selectLocale(locale);
  }
  if (!context.mounted) return;
  // The page still shows the old language here: word the confirmation in
  // the language just chosen.
  final l10n = lookupAppLocalizations(_effectiveLocale(locale));
  final label = _languageLabel(l10n, locale);
  ScaffoldMessenger.of(
    context,
  ).showToast(l10n.languageSelected(label), kind: ToastKind.success);
}

/// [locale], or the phone's language when it is "System" (English when
/// LifeThreads does not support the phone's language).
Locale _effectiveLocale(Locale? locale) {
  if (locale != null) return locale;
  final phone = WidgetsBinding.instance.platformDispatcher.locale;
  final supported = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == phone.languageCode,
  );
  return supported ? Locale(phone.languageCode) : const Locale('en');
}

String _languageLabel(AppLocalizations l10n, Locale? locale) {
  return switch (locale?.languageCode) {
    null => l10n.systemLanguage,
    'de' => l10n.germanLanguage,
    'ar' => l10n.arabicLanguage,
    _ => l10n.englishLanguage,
  };
}

Future<void> _openExternalUrl(
  BuildContext context,
  Uri uri, {
  required String eventName,
}) async {
  AppLogger.event(eventName);
  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || opened) return;
  } catch (_) {
    // Fall through to clipboard fallback.
  }
  await Clipboard.setData(ClipboardData(text: uri.toString()));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showToast(uri.toString());
}

Future<void> _exportBackup(
  BuildContext context,
  WidgetRef ref,
  MemoryState state,
) async {
  final l10n = context.l10n;
  final password = await showArchivePasswordDialog(
    context,
    purpose: ArchivePasswordPurpose.export,
  );
  if (!context.mounted || password == null) return;

  try {
    final result = await ref
        .read(backupServiceProvider)
        .exportBackup(state, password: password);
    if (!context.mounted) return;
    await shareExportedArchive(
      context,
      result,
      onSaved: ref.read(backupReminderProvider.notifier).markSaved,
    );
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(l10n.exportFailed('$error'), kind: ToastKind.error);
  }
}

Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final password = await showArchivePasswordDialog(
    context,
    purpose: ArchivePasswordPurpose.import,
  );
  if (!context.mounted || password == null) return;

  try {
    final backup = await ref
        .read(backupServiceProvider)
        .pickAndPrepareImport(password: password);
    if (!context.mounted || backup == null) return;
    final result = await ref
        .read(memoryRepositoryProvider.notifier)
        .importBackup(backup);
    if (!context.mounted) return;
    await showArchiveImportSummary(context, result);
  } on BackupValidationException catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(l10n.importRejected(error.message), kind: ToastKind.error);
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(l10n.importFailed('$error'), kind: ToastKind.error);
  }
}

Future<void> _importCapsule(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final password = await showMemoryCapsulePasswordDialog(
    context,
    purpose: MemoryCapsulePasswordPurpose.import,
  );
  if (!context.mounted || password == null) return;

  MemoryCapsuleImportDraft? draft;
  try {
    draft = await ref
        .read(memoryCapsuleServiceProvider)
        .pickAndPrepareImport(password: password);
    if (!context.mounted || draft == null) return;

    final confirmed = await showMemoryCapsuleImportPreview(context, draft);
    if (!context.mounted) return;
    if (!confirmed) {
      await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
      return;
    }

    final result = await ref
        .read(memoryRepositoryProvider.notifier)
        .importBackup(draft.backup);
    if (!context.mounted) return;
    await showArchiveImportSummary(context, result);
  } on BackupValidationException catch (error) {
    if (draft != null) {
      await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(l10n.capsuleRejected(error.message), kind: ToastKind.error);
  } catch (error) {
    if (draft != null) {
      await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(l10n.capsuleImportFailed('$error'), kind: ToastKind.error);
  }
}

Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(l10n.clearAllDataQuestion),
      content: Text(l10n.clearAllDataQuestionBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.clearAll),
        ),
      ],
    ),
  );
  if (!context.mounted || confirmed != true) return;
  try {
    await ref.read(memoryRepositoryProvider.notifier).clearAllData();
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(l10n.somethingWentWrong, kind: ToastKind.error);
    return;
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showToast(l10n.allLocalDataCleared, kind: ToastKind.success);
}

Future<void> _showBetaFeedback(BuildContext context) async {
  AppLogger.event('beta_feedback_opened');
  await showDialog<void>(
    context: context,
    builder: (_) => const _BetaFeedbackDialog(),
  );
}

Future<void> _setOnThisDayReminders(
  BuildContext context,
  WidgetRef ref,
  bool enabled,
) async {
  final settings = ref.read(onThisDaySettingsProvider.notifier);
  if (!enabled) {
    await settings.setRemindersEnabled(false);
    return;
  }
  if (!await requirePremium(context, PremiumFeature.onThisDay)) return;

  // Permission is asked here, when the user turns reminders on.
  bool granted;
  try {
    granted = await ref
        .read(onThisDayNotificationsProvider)
        .requestPermission();
  } catch (error, stackTrace) {
    AppLogger.recordCrash(error, stackTrace);
    granted = false;
  }
  if (!context.mounted) return;
  if (!granted) {
    ScaffoldMessenger.of(context).showToast(
      context.l10n.onThisDayNotificationsDenied,
      kind: ToastKind.error,
    );
    return;
  }
  AppLogger.event('on_this_day_reminders_on');
  await settings.setRemindersEnabled(true);
}

Future<void> _pickOnThisDayTime(
  BuildContext context,
  WidgetRef ref,
  OnThisDaySettings current,
) async {
  final time = await showTimePicker(
    context: context,
    initialTime: current.time,
  );
  if (time == null) return;
  await ref.read(onThisDaySettingsProvider.notifier).setTime(time);
}

class _BetaFeedbackDialog extends StatefulWidget {
  const _BetaFeedbackDialog();

  @override
  State<_BetaFeedbackDialog> createState() => _BetaFeedbackDialogState();
}

class _BetaFeedbackDialogState extends State<_BetaFeedbackDialog> {
  final _feedbackController = TextEditingController();
  var _category = _FeedbackCategory.general;
  var _sending = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.betaFeedbackTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.betaFeedbackIntro),
            const SizedBox(height: 16),
            DropdownButtonFormField<_FeedbackCategory>(
              initialValue: _category,
              decoration: InputDecoration(labelText: l10n.feedbackType),
              items: [
                for (final category in _FeedbackCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(_feedbackCategoryLabel(context, category)),
                  ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _category = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              minLines: 5,
              maxLines: 9,
              decoration: InputDecoration(
                labelText: l10n.feedbackLabel,
                hintText: l10n.feedbackHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.betaFeedbackNotIncluded,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: _sending ? null : _send,
          icon: const Icon(Icons.mail_outline_rounded),
          label: Text(_sending ? l10n.preparing : l10n.send),
        ),
      ],
    );
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showToast(l10n.feedbackEmpty);
      return;
    }

    setState(() => _sending = true);
    final diagnostics = await AppLogger.betaDiagnostics();
    if (!mounted) return;

    final body = [
      'Category: ${_feedbackCategoryLabel(context, _category)}',
      '',
      'Feedback:',
      feedback,
      '',
      diagnostics,
    ].join('\n');

    final subject =
        'LifeThreads closed beta feedback - ${_feedbackCategoryLabel(context, _category)}';
    // Uri(queryParameters:) form-encodes spaces as '+', which mail apps show
    // literally in mailto links (RFC 6068), so encode each value by hand.
    final uri = Uri.parse(
      'mailto:info@gkcoding.dev'
      '?subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body)}',
    );

    final messenger = ScaffoldMessenger.of(context);

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      if (opened) {
        AppLogger.event('beta_feedback_email_opened');
        Navigator.of(context).pop();
        return;
      }
    } catch (_) {
      AppLogger.event('beta_feedback_email_failed');
    }

    await Clipboard.setData(ClipboardData(text: body));
    if (!mounted) return;
    setState(() => _sending = false);
    messenger.showToast(l10n.feedbackCopied, kind: ToastKind.success);
  }
}

enum _FeedbackCategory {
  general,
  bug,
  crash,
  design,
  missingFeature,
  performance,
}

String _feedbackCategoryLabel(
  BuildContext context,
  _FeedbackCategory category,
) {
  final l10n = context.l10n;
  return switch (category) {
    _FeedbackCategory.general => l10n.feedbackGeneral,
    _FeedbackCategory.bug => l10n.feedbackBug,
    _FeedbackCategory.crash => l10n.feedbackCrash,
    _FeedbackCategory.design => l10n.feedbackDesign,
    _FeedbackCategory.missingFeature => l10n.feedbackMissingFeature,
    _FeedbackCategory.performance => l10n.feedbackPerformance,
  };
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.selectedLocale,
    required this.onSelect,
  });

  final Locale? selectedLocale;
  final ValueChanged<Locale?> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedCode = selectedLocale?.languageCode ?? 'system';
    final choices = [
      _LanguageChoice(
        code: 'system',
        label: l10n.systemLanguage,
        icon: Icons.phone_iphone_rounded,
      ),
      _LanguageChoice(
        code: 'en',
        locale: const Locale('en'),
        label: l10n.englishLanguage,
        icon: Icons.language_rounded,
      ),
      _LanguageChoice(
        code: 'de',
        locale: const Locale('de'),
        label: l10n.germanLanguage,
        icon: Icons.translate_rounded,
      ),
      _LanguageChoice(
        code: 'ar',
        locale: const Locale('ar'),
        label: l10n.arabicLanguage,
        icon: Icons.format_textdirection_r_to_l_rounded,
      ),
    ];

    return Column(
      children: [
        for (final choice in choices)
          _LanguageOption(
            choice: choice,
            selected: selectedCode == choice.code,
            onTap: () => onSelect(choice.locale),
          ),
      ],
    );
  }
}

class _LanguageChoice {
  const _LanguageChoice({
    required this.code,
    required this.label,
    required this.icon,
    this.locale,
  });

  final String code;
  final String label;
  final IconData icon;
  final Locale? locale;
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final _LanguageChoice choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.gold.withValues(alpha: 0.16)
                : AppColors.wallInk.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.gold.withValues(alpha: 0.7)
                  : AppColors.line,
            ),
          ),
          child: Row(
            children: [
              Icon(choice.icon, color: AppColors.gold, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  choice.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? AppColors.gold : AppColors.muted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisplayNameEditor extends StatefulWidget {
  const _DisplayNameEditor({required this.initialName, required this.onSave});

  final String initialName;
  final Future<void> Function(String name) onSave;

  @override
  State<_DisplayNameEditor> createState() => _DisplayNameEditorState();
}

class _DisplayNameEditorState extends State<_DisplayNameEditor> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void didUpdateWidget(covariant _DisplayNameEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialName == widget.initialName) return;
    // Only hydrate from provider when the field still matches the old
    // loaded value (or is empty after initial async load). Never wipe
    // in-progress edits the user typed while prefs were loading.
    final current = _controller.text.trim();
    final oldInitial = oldWidget.initialName.trim();
    if (current.isEmpty || current == oldInitial) {
      _controller.text = widget.initialName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty || name == widget.initialName.trim()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(name);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canSave =
        !_saving &&
        _controller.text.trim().isNotEmpty &&
        _controller.text.trim() != widget.initialName.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (canSave) _save();
          },
          decoration: InputDecoration(
            hintText: l10n.settingsNameHint,
            filled: true,
            fillColor: AppColors.wallInk.withValues(alpha: 0.35),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: canSave ? _save : null,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(l10n.save),
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.body,
    this.actions = const [],
    this.child,
    this.badge,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final List<Widget> actions;
  final Widget? child;
  final String? badge;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? AppColors.error : AppColors.gold;

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
            ],
          ),
          // The badge goes under the title, so the title keeps the width.
          if (badge != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
          if (body.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(
                color: AppColors.muted,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (child != null) ...[const SizedBox(height: 12), child!],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 16),
            // Full width inside the card's padding, one under the other.
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.gold;

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
