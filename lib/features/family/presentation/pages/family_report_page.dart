import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_ui.dart';

extension FamilyReportReasonL10n on FamilyReportReason {
  String label(AppLocalizations l10n) => switch (this) {
    FamilyReportReason.spam => l10n.familyReportSpam,
    FamilyReportReason.harassment => l10n.familyReportHarassment,
    FamilyReportReason.hate => l10n.familyReportHate,
    FamilyReportReason.sexual => l10n.familyReportSexual,
    FamilyReportReason.violence => l10n.familyReportViolence,
    FamilyReportReason.selfHarm => l10n.familyReportSelfHarm,
    FamilyReportReason.illegal => l10n.familyReportIllegal,
    FamilyReportReason.privacy => l10n.familyReportPrivacy,
    FamilyReportReason.other => l10n.familyReportOther,
  };
}

/// Opens the report screen; true when a report was sent.
Future<bool> reportFamilyContent(
  BuildContext context, {
  required String familyId,
  required FamilyReportTarget target,
  required String targetId,
  String? authorId,
  String? authorName,
}) async {
  final sent = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => FamilyReportPage(
        familyId: familyId,
        target: target,
        targetId: targetId,
        authorId: authorId,
        authorName: authorName,
      ),
    ),
  );
  return sent ?? false;
}

/// Report a memory, photo or member to GK Coding, optionally blocking the
/// person too.
class FamilyReportPage extends ConsumerStatefulWidget {
  const FamilyReportPage({
    super.key,
    required this.familyId,
    required this.target,
    required this.targetId,
    this.authorId,
    this.authorName,
  });

  final String familyId;
  final FamilyReportTarget target;
  final String targetId;

  /// Who posted it (or the member reported); offered for blocking.
  final String? authorId;
  final String? authorName;

  @override
  ConsumerState<FamilyReportPage> createState() => _FamilyReportPageState();
}

class _FamilyReportPageState extends ConsumerState<FamilyReportPage> {
  FamilyReportReason? _reason;
  final _details = TextEditingController();
  var _alsoBlock = false;
  var _busy = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = switch (widget.target) {
      FamilyReportTarget.memory => l10n.familyReportMemoryTitle,
      FamilyReportTarget.photo => l10n.familyReportPhotoTitle,
      FamilyReportTarget.member => l10n.familyReportMemberTitle,
    };
    return FamilyPageScaffold(
      title: title,
      children: [
        Text(
          l10n.familyReportIntro,
          style: TextStyle(
            color: AppColors.muted,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        RadioGroup<FamilyReportReason>(
          groupValue: _reason,
          onChanged: (value) => setState(() => _reason = value),
          child: Column(
            children: [
              for (final reason in FamilyReportReason.values)
                RadioListTile<FamilyReportReason>(
                  key: ValueKey('family-report-${reason.name}'),
                  value: reason,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    reason.label(l10n),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('family-report-details'),
          controller: _details,
          maxLines: 4,
          maxLength: 1000,
          decoration: InputDecoration(
            labelText: l10n.familyReportDetailsLabel,
            hintText: l10n.familyReportDetailsHint,
          ),
        ),
        if (widget.authorId != null)
          CheckboxListTile(
            key: const ValueKey('family-report-block'),
            value: _alsoBlock,
            onChanged: (value) => setState(() => _alsoBlock = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(
              l10n.familyReportAlsoBlock(
                widget.authorName ?? l10n.familyAMember,
              ),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        if (widget.target == FamilyReportTarget.memory) ...[
          const SizedBox(height: 8),
          FamilyPoint(
            key: const ValueKey('family-report-evidence'),
            icon: Icons.visibility_rounded,
            text: l10n.familyReportEvidenceNote,
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            key: const ValueKey('family-report-send'),
            onPressed: _reason == null || _busy ? null : _send,
            icon: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Icon(Icons.flag_rounded),
            label: Text(l10n.familyReportSend),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.familyReportReviewNote,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 12.5),
        ),
      ],
    );
  }

  Future<void> _send() async {
    final reason = _reason;
    final service = familyServiceFor(context);
    if (reason == null || service == null) return;
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final details = _details.text.trim();
      await service.report(
        familyId: widget.familyId,
        target: widget.target,
        targetId: widget.targetId,
        reason: reason,
        details: details.isEmpty ? null : details,
      );
      final authorId = widget.authorId;
      if (_alsoBlock && authorId != null) {
        await service.block(authorId);
        ref.invalidate(familyMembersProvider(widget.familyId));
      }
      AppLogger.event('family_report_${widget.target.name}');
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.verified_rounded, color: AppColors.sage),
          title: Text(l10n.familyReportSentTitle),
          content: Text(l10n.familyReportSentBody),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.done),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) showFamilyError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
