import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../backup/data/backup_service.dart';
import '../../../backup/data/cloud_sync_service.dart';
import '../../../backup/domain/backup_models.dart';
import '../../../backup/presentation/widgets/archive_feedback.dart';
import '../../../backup/presentation/widgets/archive_password_dialog.dart';
import '../../../capsule/data/memory_capsule_service.dart';
import '../../../capsule/domain/memory_capsule_models.dart';
import '../../../capsule/presentation/widgets/memory_capsule_dialogs.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../../wall/data/wall_theme_controller.dart';
import '../../../wall/domain/wall_theme.dart';
import '../../../wall/presentation/widgets/wall_background.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final memoryState = ref.watch(memoryRepositoryProvider);
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
    final selectedLocale = ref.watch(localeControllerProvider).asData?.value;
    final selectedTheme =
        ref.watch(wallThemeProvider).asData?.value ??
        WallThemePreset.warmMemoryRoom;
    final isPremium = entitlement?.isPremium ?? false;
    final effectiveTheme = selectedTheme.isPremium && !isPremium
        ? WallThemePreset.warmMemoryRoom
        : selectedTheme;

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.settingsTitle,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SettingsCard(
                icon: Icons.language_rounded,
                title: l10n.languageTitle,
                body: l10n.languageBody,
                child: _LanguageSelector(
                  selectedLocale: selectedLocale,
                  onSelect: (locale) => _selectLanguage(context, ref, locale),
                ),
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
                icon: Icons.enhanced_encryption_rounded,
                title: l10n.premiumArchiveTitle,
                body: l10n.premiumArchiveBody,
                badge: isPremium ? l10n.premiumBadge : l10n.unlockBadge,
                actions: [
                  _SettingsAction(
                    label: isPremium ? l10n.exportArchive : l10n.unlockExport,
                    icon: Icons.ios_share_rounded,
                    onTap: memoryState.asData == null
                        ? null
                        : () => _exportBackup(context, ref, memoryState.value!),
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
              _SettingsCard(
                icon: Icons.cloud_done_rounded,
                title: l10n.cloudSyncTitle,
                body: l10n.cloudSyncBody,
                badge: l10n.vpsBadge,
                actions: [
                  _SettingsAction(
                    label: isPremium ? l10n.backUpNow : l10n.unlockBackup,
                    icon: Icons.cloud_upload_rounded,
                    onTap: memoryState.asData == null
                        ? null
                        : () => _uploadCloudBackup(
                            context,
                            ref,
                            memoryState.value!,
                          ),
                  ),
                  _SettingsAction(
                    label: l10n.restoreLatest,
                    icon: Icons.cloud_download_rounded,
                    onTap: () => _restoreCloudBackup(context, ref),
                  ),
                  _SettingsAction(
                    label: l10n.copyKey,
                    icon: Icons.key_rounded,
                    onTap: () => _copyCloudSyncKey(context, ref),
                  ),
                  _SettingsAction(
                    label: l10n.useKey,
                    icon: Icons.login_rounded,
                    onTap: () => _useCloudSyncKey(context, ref),
                  ),
                  _SettingsAction(
                    label: l10n.deleteCloud,
                    icon: Icons.delete_outline_rounded,
                    danger: true,
                    onTap: () => _deleteCloudBackup(context, ref),
                  ),
                ],
              ),
              _SettingsCard(
                icon: Icons.palette_rounded,
                title: l10n.themeTitle,
                body: l10n.themeBody,
                badge: isPremium ? l10n.premiumBadge : l10n.oneFreeBadge,
                child: _ThemeSelector(
                  selectedTheme: effectiveTheme,
                  isPremium: isPremium,
                  onSelect: (theme) => _selectTheme(context, ref, theme),
                ),
              ),
              _SettingsCard(
                icon: Icons.workspace_premium_rounded,
                title: l10n.premiumTitle,
                body: entitlement?.isPremium == true
                    ? l10n.premiumActiveBody
                    : l10n.premiumLockedBody,
                badge: entitlement?.isPremium == true
                    ? l10n.activeBadge
                    : l10n.unlockBadge,
                actions: [
                  _SettingsAction(
                    label: l10n.openPremium,
                    icon: Icons.workspace_premium_rounded,
                    onTap: () => context.push(RouteNames.upgrade),
                  ),
                ],
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
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
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
    );
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
    final label = _languageLabel(context, locale);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.languageSelected(label))),
    );
  }

  String _languageLabel(BuildContext context, Locale? locale) {
    final l10n = context.l10n;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(uri.toString())),
    );
  }

  Future<void> _exportBackup(
    BuildContext context,
    WidgetRef ref,
    MemoryState state,
  ) async {
    final l10n = context.l10n;
    final isPremium =
        ref.read(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    if (!isPremium) {
      await context.push(RouteNames.upgrade);
      return;
    }

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
      await shareExportedArchive(context, result);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exportFailed('$error'))));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importRejected(error.message))),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.importFailed('$error'))));
    }
  }

  Future<void> _uploadCloudBackup(
    BuildContext context,
    WidgetRef ref,
    MemoryState state,
  ) async {
    final l10n = context.l10n;
    final isPremium =
        ref.read(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    if (!isPremium) {
      await context.push(RouteNames.upgrade);
      return;
    }

    final password = await showArchivePasswordDialog(
      context,
      purpose: ArchivePasswordPurpose.export,
    );
    if (!context.mounted || password == null) return;
    if (password.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cloudBackupNeedsPassword)));
      return;
    }

    try {
      final sync = await ref
          .read(cloudSyncServiceProvider)
          .uploadBackup(state: state, password: password);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.cloudBackupSaved(sync.memoryCount ?? state.events.length),
          ),
        ),
      );
    } on CloudSyncException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cloudBackupFailed(error.message))),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cloudBackupFailed('$error'))));
    }
  }

  Future<void> _restoreCloudBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final password = await showArchivePasswordDialog(
      context,
      purpose: ArchivePasswordPurpose.import,
    );
    if (!context.mounted || password == null) return;

    try {
      final backup = await ref
          .read(cloudSyncServiceProvider)
          .downloadAndPrepareImport(password: password);
      final result = await ref
          .read(memoryRepositoryProvider.notifier)
          .importBackup(backup);
      if (!context.mounted) return;
      await showArchiveImportSummary(context, result);
    } on BackupValidationException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cloudRestoreRejected(error.message))),
      );
    } on CloudSyncException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cloudRestoreFailed(error.message))),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cloudRestoreFailed('$error'))),
      );
    }
  }

  Future<void> _copyCloudSyncKey(BuildContext context, WidgetRef ref) async {
    final key = await ref.read(cloudSyncServiceProvider).ensureSyncKey();
    await Clipboard.setData(ClipboardData(text: key));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.syncKeyCopied)));
  }

  Future<void> _useCloudSyncKey(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final service = ref.read(cloudSyncServiceProvider);
    final controller = TextEditingController(
      text: await service.ensureSyncKey(),
    );
    if (!context.mounted) {
      controller.dispose();
      return;
    }

    final key = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.useSyncKeyTitle),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: l10n.syncKeyLabel,
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(controller.text),
            icon: const Icon(Icons.login_rounded),
            label: Text(l10n.useKey),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!context.mounted || key == null) return;

    try {
      await service.setSyncKey(key);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.syncKeySaved)));
    } on CloudSyncException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _deleteCloudBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteCloudBackupTitle),
        content: Text(l10n.deleteCloudBackupBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;

    try {
      await ref.read(cloudSyncServiceProvider).deleteRemoteBackup();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.cloudBackupDeleted)));
    } on CloudSyncException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deleteFailed(error.message))));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.capsuleRejected(error.message))),
      );
    } catch (error) {
      if (draft != null) {
        await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.capsuleImportFailed('$error'))),
      );
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
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    await ref.read(memoryRepositoryProvider.notifier).clearAllData();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.allLocalDataCleared)));
  }

  Future<void> _showBetaFeedback(BuildContext context) async {
    AppLogger.event('beta_feedback_opened');
    await showDialog<void>(
      context: context,
      builder: (_) => const _BetaFeedbackDialog(),
    );
  }

  Future<void> _selectTheme(
    BuildContext context,
    WidgetRef ref,
    WallThemePreset theme,
  ) async {
    final isPremium =
        ref.read(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    if (theme.isPremium && !isPremium) {
      await context.push(RouteNames.upgrade);
      return;
    }

    await ref.read(wallThemeProvider.notifier).selectTheme(theme);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.themeSelected(_themeLabel(context, theme))),
      ),
    );
  }
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
              style: const TextStyle(
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedbackEmpty)));
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

    final uri = Uri(
      scheme: 'mailto',
      path: 'info@gkcoding.dev',
      queryParameters: {
        'subject':
            'LifeThreads closed beta feedback - ${_feedbackCategoryLabel(context, _category)}',
        'body': body,
      },
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
    messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackCopied)));
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

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.selectedTheme,
    required this.isPremium,
    required this.onSelect,
  });

  final WallThemePreset selectedTheme;
  final bool isPremium;
  final ValueChanged<WallThemePreset> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final theme in WallThemePreset.all)
          _ThemeOption(
            theme: theme,
            selected: selectedTheme.id == theme.id,
            locked: theme.isPremium && !isPremium,
            onTap: () => onSelect(theme),
          ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.theme,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final WallThemePreset theme;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected
                ? theme.accent.withValues(alpha: 0.16)
                : AppColors.wallInk.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? theme.accent.withValues(alpha: 0.7)
                  : AppColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [theme.background, theme.depth, theme.surface],
                  ),
                  border: Border.all(
                    color: theme.accent.withValues(alpha: 0.42),
                  ),
                ),
                child: Icon(theme.icon, color: theme.accent, size: 23),
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
                            _themeLabel(context, theme),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (locked)
                          const Icon(
                            Icons.lock_rounded,
                            color: AppColors.gold,
                            size: 17,
                          )
                        else if (selected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.gold,
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _themeDescription(context, theme),
                      style: const TextStyle(
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
    );
  }
}

String _themeLabel(BuildContext context, WallThemePreset theme) {
  return switch (theme.id) {
    WallThemeId.warmMemoryRoom => context.l10n.themeWarmMemoryRoom,
    WallThemeId.midnightArchive => context.l10n.themeMidnightArchive,
    WallThemeId.softPaperWall => context.l10n.themeSoftPaperWall,
    WallThemeId.travelCorkboard => context.l10n.themeTravelCorkboard,
  };
}

String _themeDescription(BuildContext context, WallThemePreset theme) {
  return switch (theme.id) {
    WallThemeId.warmMemoryRoom => context.l10n.themeWarmMemoryRoomDescription,
    WallThemeId.midnightArchive => context.l10n.themeMidnightArchiveDescription,
    WallThemeId.softPaperWall => context.l10n.themeSoftPaperWallDescription,
    WallThemeId.travelCorkboard => context.l10n.themeTravelCorkboardDescription,
  };
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
              if (badge != null)
                Container(
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
            ],
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              body,
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
