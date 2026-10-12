import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_ui.dart';

/// Signs in for family walls. Pops the [FamilyAccount] on success.
///
/// Sign in with Apple is offered on Apple platforms (App Review requires it
/// next to Google sign-in); Google everywhere.
class FamilySignInPage extends ConsumerStatefulWidget {
  const FamilySignInPage({super.key});

  @override
  ConsumerState<FamilySignInPage> createState() => _FamilySignInPageState();
}

class _FamilySignInPageState extends ConsumerState<FamilySignInPage> {
  var _busy = false;

  bool get _offersApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FamilyPageScaffold(
      title: l10n.familySignInTitle,
      children: [
        FamilyPanel(
          icon: Icons.family_restroom_rounded,
          title: l10n.familySignInHeadline,
          child: Column(
            children: [
              FamilyPoint(
                icon: Icons.groups_rounded,
                text: l10n.familySignInWhy,
              ),
              FamilyPoint(
                icon: Icons.phone_iphone_rounded,
                text: l10n.familySignInMyWallStays,
              ),
              FamilyPoint(
                icon: Icons.lock_rounded,
                text: l10n.familySignInEncrypted,
              ),
              FamilyPoint(
                icon: Icons.badge_rounded,
                text: l10n.familySignInWhatWeGet,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (_offersApple) ...[
          _ProviderButton(
            key: const ValueKey('family-sign-in-apple'),
            label: l10n.familySignInApple,
            icon: Icons.apple,
            background: Colors.white,
            foreground: Colors.black,
            onPressed: _busy ? null : () => _signIn(apple: true),
          ),
          const SizedBox(height: 12),
        ],
        _ProviderButton(
          key: const ValueKey('family-sign-in-google'),
          label: l10n.familySignInGoogle,
          icon: Icons.g_mobiledata_rounded,
          background: AppColors.card,
          foreground: AppColors.paperInk,
          onPressed: _busy ? null : () => _signIn(apple: false),
        ),
        if (_busy) ...[
          const SizedBox(height: 20),
          const Center(child: CircularProgressIndicator()),
        ],
        const SizedBox(height: 18),
        Text(
          l10n.familySignInFinePrint,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12.5,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _signIn({required bool apple}) async {
    final service = familyServiceFor(context);
    if (service == null) return;
    setState(() => _busy = true);
    try {
      final FamilyAccount account = apple
          ? await service.signInWithApple()
          : await service.signInWithGoogle();
      await ref.read(familyWallsActiveProvider.notifier).setActive(true);
      AppLogger.event(apple ? 'family_sign_in_apple' : 'family_sign_in_google');
      if (!mounted) return;
      Navigator.of(context).pop(account);
    } catch (error) {
      if (mounted) showFamilyError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    super.key,
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        icon: Icon(icon, size: 26),
        label: Text(label),
      ),
    );
  }
}
