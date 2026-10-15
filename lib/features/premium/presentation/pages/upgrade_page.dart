import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/top_bar_page.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../wall/presentation/widgets/wall_background.dart';
import '../../data/premium_billing_controller.dart';
import '../../domain/premium_product.dart';
import '../../data/premium_entitlement_controller.dart';
import '../../domain/premium_entitlement.dart';
import '../../domain/premium_feature.dart';
import '../../domain/premium_purchase_state.dart';
import '../../../../core/widgets/app_toast.dart';

class UpgradePage extends ConsumerWidget {
  const UpgradePage({super.key, this.feature});

  /// The Premium feature that opened this page, if any.
  final PremiumFeature? feature;

  /// Whether debug builds offer the mock unlock (off for screenshots).
  @visibleForTesting
  static bool showDebugUnlock = kDebugMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryCount = ref
        .watch(memoryRepositoryProvider)
        .maybeWhen(data: (state) => state.events.length, orElse: () => 0);
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
    final purchaseState = ref.watch(premiumBillingProvider);
    final isPremium = entitlement?.isPremium ?? false;

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: context.l10n.premiumPageTitle,
            onBack: () => _leave(context),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
              children: [
                if (feature != null && !isPremium) ...[
                  _FeatureNotice(feature: feature!),
                  const SizedBox(height: 14),
                ],
                _SubscriptionHero(
                  isPremium: isPremium,
                  memoryCount: memoryCount,
                ),
                const SizedBox(height: 16),
                const _BenefitGrid(),
                const SizedBox(height: 16),
                _SubscriptionOfferCard(
                  isPremium: isPremium,
                  purchaseState: purchaseState,
                  plans: ref.watch(premiumPlansProvider),
                  onSelectPlan: (plan) => ref
                      .read(premiumBillingProvider.notifier)
                      .selectPlan(plan),
                  onPurchase: () => ref
                      .read(premiumBillingProvider.notifier)
                      .buySubscription(),
                  onRestore: () => ref
                      .read(premiumBillingProvider.notifier)
                      .restorePurchases(),
                  onRetry: () =>
                      ref.read(premiumBillingProvider.notifier).loadProduct(),
                  onMockUnlock: showDebugUnlock
                      ? () => _unlockMockPremium(context, ref)
                      : null,
                  onContinue: () => _leave(context),
                ),
                const SizedBox(height: 4),
                const _LegalLinks(),
                const SizedBox(height: 10),
                const _BillingReadyNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _unlockMockPremium(BuildContext context, WidgetRef ref) async {
    await ref.read(premiumEntitlementProvider.notifier).setMockUnlock(true);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showToast(context.l10n.developmentUnlockEnabled, kind: ToastKind.success);
    _leave(context);
  }

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.wall);
    }
  }
}

class _FeatureNotice extends StatelessWidget {
  const _FeatureNotice({required this.feature});

  final PremiumFeature feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.lock_rounded, color: AppColors.amber, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.l10n.premiumFeatureNotice(feature.label(context.l10n)),
            style: TextStyle(
              color: AppColors.amber,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubscriptionHero extends StatelessWidget {
  const _SubscriptionHero({required this.isPremium, required this.memoryCount});

  final bool isPremium;
  final int memoryCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.35,
          colors: [
            AppColors.gold.withValues(alpha: 0.36),
            AppColors.panelWarm.withValues(alpha: 0.94),
            AppColors.wallInk.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 42,
            offset: const Offset(0, 22),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withValues(alpha: 0.18),
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.32),
                  ),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.amber,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isPremium
                      ? context.l10n.lifetimeActive
                      : context.l10n.oneTimeLifetimeUnlock,
                  style: TextStyle(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            isPremium
                ? context.l10n.premiumHeroActiveTitle
                : context.l10n.premiumHeroLockedTitle,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              height: 1.02,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isPremium
                ? context.l10n.premiumHeroActiveBody
                : context.l10n.premiumHeroLockedBody(
                    PremiumEntitlement.freeMemoryLimit,
                  ),
            style: TextStyle(
              color: AppColors.muted,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          _LimitMeter(memoryCount: memoryCount, isPremium: isPremium),
        ],
      ),
    );
  }
}

class _LimitMeter extends StatelessWidget {
  const _LimitMeter({required this.memoryCount, required this.isPremium});

  final int memoryCount;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final progress = isPremium
        ? 1.0
        : (memoryCount / PremiumEntitlement.freeMemoryLimit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isPremium
                    ? context.l10n.premiumMemories
                    : context.l10n.freeMemories,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                isPremium
                    ? '$memoryCount / ${context.l10n.unlimited}'
                    : '$memoryCount / ${PremiumEntitlement.freeMemoryLimit}',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: AppColors.wallDeep,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 560;
        // Cards as tall as their text: a fixed grid cell clips the third
        // line with long translations or a larger text size.
        final cardWidth = isWide
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
        final cards = [
          _BenefitCard(
            icon: Icons.all_inclusive_rounded,
            title: context.l10n.benefitUnlimitedTitle,
            body: context.l10n.benefitUnlimitedBody,
          ),
          _BenefitCard(
            icon: Icons.palette_rounded,
            title: context.l10n.benefitThemesTitle,
            body: context.l10n.benefitThemesBody,
          ),
          _BenefitCard(
            icon: Icons.dashboard_customize_rounded,
            title: context.l10n.benefitLayoutsTitle,
            body: context.l10n.benefitLayoutsBody,
          ),
          _BenefitCard(
            icon: Icons.event_repeat_rounded,
            title: context.l10n.onThisDayTitle,
            body: context.l10n.benefitOnThisDayBody,
          ),
          _BenefitCard(
            icon: Icons.auto_stories_rounded,
            title: context.l10n.benefitStoriesTitle,
            body: context.l10n.benefitStoriesBody,
          ),
          _BenefitCard(
            icon: Icons.movie_filter_rounded,
            title: context.l10n.yearThreadTitle,
            body: context.l10n.benefitYearThreadBody,
          ),
          _BenefitCard(
            icon: Icons.diversity_3_rounded,
            title: context.l10n.benefitFamilyTitle,
            body: context.l10n.benefitFamilyBody,
          ),
        ];
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final card in cards) SizedBox(width: cardWidth, child: card),
          ],
        );
      },
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panel.withValues(alpha: 0.88),
            AppColors.panelWarm.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: AppColors.amber, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.32,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionOfferCard extends StatelessWidget {
  const _SubscriptionOfferCard({
    required this.isPremium,
    required this.purchaseState,
    required this.onPurchase,
    required this.onRestore,
    required this.onRetry,
    required this.onMockUnlock,
    required this.onContinue,
    required this.plans,
    required this.onSelectPlan,
  });

  final bool isPremium;
  final PremiumPurchaseState purchaseState;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;
  final VoidCallback onRetry;
  final VoidCallback? onMockUnlock;
  final PremiumPlans plans;
  final ValueChanged<PremiumPlan> onSelectPlan;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final price = purchaseState.price ?? '€4.99';
    final canBuy = purchaseState.canBuy && !purchaseState.isBusy;
    // The offer could not be loaded: the main button loads it again.
    final canRetry =
        !isPremium &&
        !purchaseState.isBusy &&
        (purchaseState.status == PremiumPurchaseStatus.storeUnavailable ||
            purchaseState.status == PremiumPurchaseStatus.productUnavailable);
    final message = purchaseState.message;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 26,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.lifetimeUnlock,
            style: TextStyle(
              color: AppColors.paperInk,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isPremium
                ? context.l10n.premiumActiveOnDevice
                : context.l10n.onePurchaseBody(_storeName),
            style: TextStyle(
              color: AppColors.paperMuted,
              height: 1.38,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!isPremium && plans.hasChoice) ...[
            const SizedBox(height: 14),
            // Yearly first: the better deal.
            _PlanPicker(plans: plans, onSelect: onSelectPlan),
          ],
          if (!isPremium) ...[
            const SizedBox(height: 14),
            _PricePill(
              price: price,
              purchaseState: purchaseState,
              yearly:
                  plans.selected == PremiumPlan.yearly &&
                  plans.yearlyPrice != null,
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const ValueKey('premium-subscribe'),
              style: _cardFilled,
              onPressed: isPremium
                  ? onContinue
                  : canBuy
                  ? onPurchase
                  : canRetry
                  ? onRetry
                  : null,
              icon: Icon(
                isPremium
                    ? Icons.check_rounded
                    : purchaseState.isBusy
                    ? Icons.hourglass_top_rounded
                    : canRetry
                    ? Icons.refresh_rounded
                    : Icons.lock_open_rounded,
              ),
              label: Text(
                isPremium
                    ? context.l10n.premiumActiveButton
                    : purchaseState.isBusy
                    ? context.l10n.processing
                    : canRetry
                    ? context.l10n.premiumTryAgain
                    : context.l10n.unlockPremium,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const ValueKey('premium-restore'),
              style: _cardOutlined,
              onPressed: purchaseState.isBusy ? null : onRestore,
              icon: const Icon(Icons.restore_rounded),
              label: Text(context.l10n.restorePurchase),
            ),
          ),
          if (onMockUnlock != null && !isPremium) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: _cardBody),
              onPressed: onMockUnlock,
              icon: const Icon(Icons.science_rounded),
              label: Text(context.l10n.enableDebugMockUnlock),
            ),
          ],
          if (message != null) ...[
            const SizedBox(height: 10),
            _PurchaseMessage(state: purchaseState),
          ],
          const SizedBox(height: 10),
          Text(
            plans.selected == PremiumPlan.yearly && plans.yearlyPrice != null
                ? context.l10n.purchasesHandledYearly(_storeName)
                : context.l10n.purchasesHandledByGooglePlay(_storeName),
            style: TextStyle(
              color: AppColors.paperMuted,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Text on the light offer card.
Color get _cardBody => AppColors.paperMuted;

/// Buttons made for the light offer card: the dark app theme's defaults
/// (light text, dark outline) disappear on cream.
final _cardFilled = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled)
        ? AppColors.gold.withValues(alpha: 0.38)
        : AppColors.gold,
  ),
  foregroundColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled)
        ? AppColors.paperInk.withValues(alpha: 0.55)
        : AppColors.paperInk,
  ),
  iconColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled)
        ? AppColors.paperInk.withValues(alpha: 0.55)
        : AppColors.paperInk,
  ),
  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
  elevation: const WidgetStatePropertyAll(0),
);

final _cardOutlined = ButtonStyle(
  foregroundColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled)
        ? _cardBody.withValues(alpha: 0.45)
        : _cardBody,
  ),
  iconColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled)
        ? _cardBody.withValues(alpha: 0.45)
        : AppColors.gold,
  ),
  side: WidgetStatePropertyAll(
    BorderSide(color: AppColors.paperInk.withValues(alpha: 0.22), width: 1.4),
  ),
  backgroundColor: WidgetStatePropertyAll(Colors.white.withValues(alpha: 0.35)),
  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
);

class _PricePill extends StatelessWidget {
  const _PricePill({
    required this.price,
    required this.purchaseState,
    this.yearly = false,
  });

  final String price;
  final PremiumPurchaseState purchaseState;
  final bool yearly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.paperInk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.gold,
            size: 19,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              purchaseState.status == PremiumPurchaseStatus.ready
                  ? yearly
                        ? context.l10n.premiumYearlyWithPrice(price)
                        : context.l10n.lifetimeUnlockWithPrice(price)
                  : _statusLabel(context, purchaseState.status),
              style: TextStyle(
                color: AppColors.paperInk,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context, PremiumPurchaseStatus status) {
    return switch (status) {
      PremiumPurchaseStatus.loading => context.l10n.loadingPlayStoreProduct,
      PremiumPurchaseStatus.storeUnavailable =>
        context.l10n.playStoreUnavailable,
      PremiumPurchaseStatus.productUnavailable =>
        context.l10n.productNotConfigured,
      PremiumPurchaseStatus.pending => context.l10n.purchasePending,
      PremiumPurchaseStatus.purchased => context.l10n.purchased,
      PremiumPurchaseStatus.restored => context.l10n.restored,
      PremiumPurchaseStatus.failed => context.l10n.purchaseFailed,
      PremiumPurchaseStatus.idle => context.l10n.preparingCheckout,
      PremiumPurchaseStatus.ready => context.l10n.lifetimeUnlockWithPrice(
        price,
      ),
    };
  }
}

class _PurchaseMessage extends StatelessWidget {
  const _PurchaseMessage({required this.state});

  final PremiumPurchaseState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = state.message;
    if (message == null) return const SizedBox.shrink();
    final text = switch (message) {
      PremiumPurchaseMessage.billingUpdateFailed =>
        l10n.premiumMessageBillingUpdateFailed,
      PremiumPurchaseMessage.storeUnavailable =>
        l10n.premiumMessageStoreUnavailable,
      PremiumPurchaseMessage.productUnavailable =>
        l10n.premiumMessageProductUnavailable,
      PremiumPurchaseMessage.loadFailed => l10n.premiumMessageLoadFailed,
      PremiumPurchaseMessage.openingCheckout =>
        l10n.premiumMessageOpeningCheckout,
      PremiumPurchaseMessage.checkoutFailed =>
        l10n.premiumMessageCheckoutFailed,
      PremiumPurchaseMessage.checking => l10n.premiumMessageChecking,
      PremiumPurchaseMessage.restoreFailed => l10n.premiumMessageRestoreFailed,
      PremiumPurchaseMessage.noSubscriptionFound =>
        l10n.premiumMessageNoSubscriptionFound,
      PremiumPurchaseMessage.pending => l10n.premiumMessagePending,
      PremiumPurchaseMessage.purchaseFailed =>
        l10n.premiumMessagePurchaseFailed,
      PremiumPurchaseMessage.canceled => l10n.premiumMessageCanceled,
      PremiumPurchaseMessage.restored => l10n.premiumMessageRestored,
      PremiumPurchaseMessage.active => l10n.premiumMessageActive,
    };
    final (
      Color background,
      Color foreground,
      IconData icon,
    ) = switch (message) {
      PremiumPurchaseMessage.restored || PremiumPurchaseMessage.active => (
        AppColors.sage.withValues(alpha: 0.22),
        AppColors.successInk,
        Icons.check_circle_rounded,
      ),
      PremiumPurchaseMessage.openingCheckout ||
      PremiumPurchaseMessage.checking ||
      PremiumPurchaseMessage.pending ||
      PremiumPurchaseMessage.noSubscriptionFound ||
      PremiumPurchaseMessage.canceled => (
        AppColors.paperInk.withValues(alpha: 0.06),
        _cardBody,
        Icons.info_outline_rounded,
      ),
      _ => (
        AppColors.rose.withValues(alpha: 0.18),
        AppColors.errorInk,
        Icons.error_outline_rounded,
      ),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: foreground,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The store that bills the subscription on this device; Apple does not
/// allow naming other platforms in the iOS app.
String get _storeName => switch (defaultTargetPlatform) {
  TargetPlatform.iOS || TargetPlatform.macOS => 'App Store',
  _ => 'Google Play',
};

/// Terms of Use and Privacy Policy next to the subscription, as the stores
/// require for auto-renewing subscriptions.
class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  static final _terms = Uri.parse('https://gkcoding.dev/lifethreads/terms');
  static final _privacy = Uri.parse('https://gkcoding.dev/lifethreads/privacy');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget link(String label, Uri uri, Key key) => TextButton(
      key: key,
      onPressed: () => launchUrl(uri, mode: LaunchMode.externalApplication),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.muted,
        // The app font: a bare TextStyle would fall back to the system font.
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
        ),
      ),
      child: Text(label),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        link(l10n.viewTerms, _terms, const ValueKey('premium-terms')),
        link(
          l10n.viewPrivacyPolicy,
          _privacy,
          const ValueKey('premium-privacy'),
        ),
      ],
    );
  }
}

class _BillingReadyNotice extends StatelessWidget {
  const _BillingReadyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shopping_bag_rounded, color: AppColors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.premiumLocalFirstTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.l10n.premiumLocalFirstBody,
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Yearly or monthly, side by side; yearly first, with its saving.
class _PlanPicker extends StatelessWidget {
  const _PlanPicker({required this.plans, required this.onSelect});

  final PremiumPlans plans;
  final ValueChanged<PremiumPlan> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final savings = plans.savingsPercent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _PlanOption(
            key: const ValueKey('premium-plan-yearly'),
            title: l10n.premiumPlanYearly,
            price: plans.yearlyPrice!,
            badge: savings == null ? null : l10n.premiumSavePercent(savings),
            selected: plans.selected == PremiumPlan.yearly,
            onTap: () => onSelect(PremiumPlan.yearly),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PlanOption(
            key: const ValueKey('premium-plan-monthly'),
            title: l10n.premiumPlanMonthly,
            price: plans.monthlyPrice!,
            selected: plans.selected == PremiumPlan.monthly,
            onTap: () => onSelect(PremiumPlan.monthly),
          ),
        ),
      ],
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    super.key,
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String price;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: selected
            ? AppColors.gold
            : AppColors.paperInk.withValues(alpha: 0.2),
        width: selected ? 2 : 1,
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected
            ? AppColors.gold.withValues(alpha: 0.16)
            : Colors.transparent,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.paperInk,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: AppColors.paperInk,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        color: AppColors.paperInk,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
