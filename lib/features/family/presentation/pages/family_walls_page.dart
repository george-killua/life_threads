import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_ui.dart';

/// All family walls of the account, with create, join and the account.
class FamilyWallsPage extends ConsumerWidget {
  const FamilyWallsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final service = ref.watch(familyServiceOrNullProvider);
    final accountState = ref.watch(familyAccountProvider);
    final account = accountState.asData?.value;
    final familiesState = ref.watch(familiesProvider);

    return FamilyPageScaffold(
      title: l10n.familyWallsTitle,
      actions: [
        if (account != null)
          IconButton(
            key: const ValueKey('family-account-button'),
            tooltip: l10n.familyAccountTitle,
            onPressed: () => context.push(RouteNames.familyAccount),
            icon: const Icon(Icons.account_circle_rounded),
            color: AppColors.gold,
          ),
      ],
      children: [
        FamilyPanel(
          icon: Icons.family_restroom_rounded,
          title: l10n.familyWallsHeadline,
          body: l10n.familyWallsIntro,
        ),
        if (service == null)
          FamilyPanel(
            icon: Icons.cloud_off_rounded,
            title: l10n.familyUnavailableTitle,
            body: l10n.familyUnavailable,
          )
        else if (accountState.isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          if (account == null)
            FamilyPanel(
              icon: Icons.login_rounded,
              title: l10n.familySignInNeededTitle,
              body: l10n.familySignInNeededBody,
              actions: [
                FamilyAction(
                  key: const ValueKey('family-sign-in-button'),
                  label: l10n.familySignIn,
                  icon: Icons.login_rounded,
                  onTap: () => ensureFamilyAccount(context),
                ),
              ],
            )
          else
            ...familiesState.when(
              loading: () => const [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (error, _) => [
                FamilyPanel(
                  icon: Icons.cloud_off_rounded,
                  title: l10n.familyLoadFailed,
                  body: familyErrorMessage(l10n, error),
                  actions: [
                    FamilyAction(
                      label: l10n.familyRetry,
                      icon: Icons.refresh_rounded,
                      onTap: () => ref.invalidate(familiesProvider),
                    ),
                  ],
                ),
              ],
              data: (families) => [
                if (families.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      l10n.familyNoWallsYet,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                for (final family in families) _FamilyTile(family: family),
              ],
            ),
          FamilyPanel(
            icon: Icons.add_home_rounded,
            title: l10n.familyStartTitle,
            body: l10n.familyStartBody,
            actions: [
              FamilyAction(
                key: const ValueKey('family-create-button'),
                label: l10n.familyCreateAction,
                icon: Icons.add_rounded,
                onTap: () => createFamilyFlow(context),
              ),
              FamilyAction(
                key: const ValueKey('family-join-button'),
                label: l10n.familyJoinWithLink,
                icon: Icons.link_rounded,
                secondary: true,
                onTap: () => pasteInviteFlow(context),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _FamilyTile extends StatelessWidget {
  const _FamilyTile({required this.family});

  final Family family;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isOwner = family.role == FamilyRole.owner;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.panelWarm.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push(RouteNames.familyWallFor(family.id)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.wallPlum,
                  foregroundColor: AppColors.amber,
                  child: Icon(Icons.diversity_1_rounded),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              family.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FamilyBadge(
                            label: isOwner
                                ? l10n.familyRoleOwner
                                : l10n.familyRoleMember,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.familyMemberCount(family.memberCount),
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.familySettingsTitle,
                  onPressed: () =>
                      context.push(RouteNames.familySettingsFor(family.id)),
                  icon: const Icon(Icons.tune_rounded),
                  color: AppColors.gold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
