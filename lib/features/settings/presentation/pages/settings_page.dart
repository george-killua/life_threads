import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../backup/data/backup_service.dart';
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
    final memoryState = ref.watch(memoryRepositoryProvider);
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
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
                  const Expanded(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _SettingsCard(
                icon: Icons.lock_rounded,
                title: 'Privacy',
                body:
                    'LifeThreads is local-first. Your memories, photos, notes, locations, and connections stay on this device unless you export a backup yourself.',
              ),
              _SettingsCard(
                icon: Icons.feedback_rounded,
                title: 'Beta feedback',
                body:
                    'Send beta feedback with safe diagnostics. Logs include app events and crash types only, never memory text, photo paths, backups, or exact locations.',
                badge: 'Closed beta',
                actions: [
                  _SettingsAction(
                    label: 'Send Feedback',
                    icon: Icons.mail_outline_rounded,
                    onTap: () => _showBetaFeedback(context),
                  ),
                ],
              ),
              _SettingsCard(
                icon: Icons.enhanced_encryption_rounded,
                title: 'Premium Archive',
                body:
                    'Move your memories between devices safely. Export an archive with memories, photos, notes, ropes, wall layout, and metadata. Add password protection when you need it.',
                badge: isPremium ? 'Premium' : 'Unlock',
                actions: [
                  _SettingsAction(
                    label: isPremium ? 'Export Archive' : 'Unlock Export',
                    icon: Icons.ios_share_rounded,
                    onTap: memoryState.asData == null
                        ? null
                        : () => _exportBackup(context, ref, memoryState.value!),
                  ),
                  _SettingsAction(
                    label: 'Import Archive',
                    icon: Icons.restore_rounded,
                    onTap: () => _importBackup(context, ref),
                  ),
                  _SettingsAction(
                    label: 'Import Capsule',
                    icon: Icons.inventory_2_rounded,
                    onTap: () => _importCapsule(context, ref),
                  ),
                  _SettingsAction(
                    label: 'Move Devices',
                    icon: Icons.devices_rounded,
                    onTap: () => context.push(RouteNames.archiveTransfer),
                  ),
                ],
              ),
              _SettingsCard(
                icon: Icons.palette_rounded,
                title: 'Theme',
                body:
                    'Choose how your private wall should feel. Free users get Warm Memory Room. Premium unlocks every wall mood.',
                badge: isPremium ? 'Premium' : '1 free',
                child: _ThemeSelector(
                  selectedTheme: effectiveTheme,
                  isPremium: isPremium,
                  onSelect: (theme) => _selectTheme(context, ref, theme),
                ),
              ),
              _SettingsCard(
                icon: Icons.workspace_premium_rounded,
                title: 'Premium',
                body: entitlement?.isPremium == true
                    ? 'Premium lifetime unlock is active.'
                    : 'One-time unlock: unlimited memories, encrypted archive export/import, moving to another device, premium themes, and advanced layouts.',
                badge: entitlement?.isPremium == true ? 'Active' : 'Unlock',
                actions: [
                  _SettingsAction(
                    label: 'Open Premium',
                    icon: Icons.workspace_premium_rounded,
                    onTap: () => context.push(RouteNames.upgrade),
                  ),
                ],
              ),
              _SettingsCard(
                icon: Icons.info_rounded,
                title: 'App version',
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
                title: 'Clear all data',
                body:
                    'Delete all memories, connections, wall notes, nails, and copied photos from this device.',
                danger: true,
                actions: [
                  _SettingsAction(
                    label: 'Clear Data',
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

  Future<void> _exportBackup(
    BuildContext context,
    WidgetRef ref,
    MemoryState state,
  ) async {
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
      ).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    }
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
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
        SnackBar(content: Text('Import rejected: ${error.message}')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $error')));
    }
  }

  Future<void> _importCapsule(BuildContext context, WidgetRef ref) async {
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
        SnackBar(content: Text('Capsule rejected: ${error.message}')),
      );
    } catch (error) {
      if (draft != null) {
        await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capsule import failed: $error')));
    }
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This permanently removes all local LifeThreads data on this device. Export a backup first if you want to keep it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    await ref.read(memoryRepositoryProvider.notifier).clearAllData();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All local data cleared.')));
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${theme.label} selected.')));
  }
}

class _BetaFeedbackDialog extends StatefulWidget {
  const _BetaFeedbackDialog();

  @override
  State<_BetaFeedbackDialog> createState() => _BetaFeedbackDialogState();
}

class _BetaFeedbackDialogState extends State<_BetaFeedbackDialog> {
  final _feedbackController = TextEditingController();
  var _category = 'General feedback';
  var _sending = false;

  static const _categories = [
    'General feedback',
    'Bug',
    'Crash',
    'Design issue',
    'Missing feature',
    'Performance',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Beta feedback'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Write what happened or what felt wrong. Safe diagnostics will be attached without private memory content.',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final category in _categories)
                  DropdownMenuItem(value: category, child: Text(category)),
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
              decoration: const InputDecoration(
                labelText: 'Feedback',
                hintText:
                    'Example: I tapped Add > Quick photo and the screen froze.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Not included: memory titles, stories, notes, photo paths, backup paths, exact locations.',
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
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _sending ? null : _send,
          icon: const Icon(Icons.mail_outline_rounded),
          label: Text(_sending ? 'Preparing...' : 'Send'),
        ),
      ],
    );
  }

  Future<void> _send() async {
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a short feedback message first.')),
      );
      return;
    }

    setState(() => _sending = true);
    final diagnostics = await AppLogger.betaDiagnostics();
    if (!mounted) return;

    final body = [
      'Category: $_category',
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
        'subject': 'LifeThreads closed beta feedback - $_category',
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
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'No email app opened. Feedback copied to clipboard for info@gkcoding.dev.',
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
                            theme.label,
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
                      theme.description,
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
