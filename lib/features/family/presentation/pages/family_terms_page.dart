import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/localization/legal_links.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../widgets/family_ui.dart';

/// The family wall rules, accepted once (per terms version) before creating
/// a family wall or posting to one. Pops the updated [FamilyAccount].
class FamilyTermsPage extends StatefulWidget {
  const FamilyTermsPage({super.key, required this.account});

  final FamilyAccount account;

  @override
  State<FamilyTermsPage> createState() => _FamilyTermsPageState();
}

class _FamilyTermsPageState extends State<FamilyTermsPage> {
  var _agreed = false;
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FamilyPageScaffold(
      title: l10n.familyTermsTitle,
      children: [
        FamilyPanel(
          icon: Icons.gavel_rounded,
          title: l10n.familyTermsHeadline,
          body: l10n.familyTermsIntro,
          actions: [
            FamilyAction(
              label: l10n.familyTermsReadFull,
              icon: Icons.open_in_new_rounded,
              secondary: true,
              onTap: _openTerms,
            ),
          ],
          child: Column(
            children: [
              FamilyPoint(
                icon: Icons.block_rounded,
                text: l10n.familyTermsZeroTolerance,
              ),
              FamilyPoint(
                icon: Icons.copyright_rounded,
                text: l10n.familyTermsOwnContent,
              ),
              FamilyPoint(
                icon: Icons.flag_rounded,
                text: l10n.familyTermsReport,
              ),
              FamilyPoint(
                icon: Icons.person_off_rounded,
                text: l10n.familyTermsBlock,
              ),
              FamilyPoint(
                icon: Icons.admin_panel_settings_rounded,
                text: l10n.familyTermsOwner,
              ),
              FamilyPoint(
                icon: Icons.gpp_bad_rounded,
                text: l10n.familyTermsConsequences,
              ),
            ],
          ),
        ),
        CheckboxListTile(
          key: const ValueKey('family-terms-agree'),
          value: _agreed,
          onChanged: _busy
              ? null
              : (value) => setState(() => _agreed = value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.familyTermsAgree,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: FilledButton(
            key: const ValueKey('family-terms-accept'),
            onPressed: _agreed && !_busy ? _accept : null,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.6),
                  )
                : Text(l10n.familyTermsAccept),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.familyTermsVersion(widget.account.requiredTermsVersion),
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }

  Future<void> _openTerms() async {
    final terms = LegalLinks.terms(context);
    try {
      await launchUrl(terms, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) showFamilyMessage(context, terms.toString());
    }
  }

  Future<void> _accept() async {
    final service = familyServiceFor(context);
    if (service == null) return;
    setState(() => _busy = true);
    try {
      final account = await service.acceptTerms(
        widget.account.requiredTermsVersion,
      );
      AppLogger.event('family_terms_accepted');
      if (!mounted) return;
      Navigator.of(context).pop(account);
    } catch (error) {
      if (mounted) showFamilyError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
