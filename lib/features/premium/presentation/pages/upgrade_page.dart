import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../wall/presentation/widgets/wall_background.dart';
import '../../data/premium_billing_controller.dart';
import '../../data/premium_entitlement_controller.dart';
import '../../domain/premium_entitlement.dart';
import '../../domain/premium_purchase_state.dart';

class UpgradePage extends ConsumerWidget {
  const UpgradePage({super.key});

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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
            children: [
              _UpgradeTopBar(onBack: () => _leave(context)),
              const SizedBox(height: 18),
              _LifetimeHero(isPremium: isPremium, memoryCount: memoryCount),
              const SizedBox(height: 16),
              const _BenefitGrid(),
              const SizedBox(height: 16),
              _MoveDeviceCard(
                onOpen: () => context.push(RouteNames.archiveTransfer),
              ),
              const SizedBox(height: 16),
              _LifetimeOfferCard(
                isPremium: isPremium,
                purchaseState: purchaseState,
                onPurchase: () => ref
                    .read(premiumBillingProvider.notifier)
                    .buyLifetimeUnlock(),
                onRestore: () => ref
                    .read(premiumBillingProvider.notifier)
                    .restorePurchases(),
                onMockUnlock: kDebugMode
                    ? () => _unlockMockPremium(context, ref)
                    : null,
                onContinue: () => _leave(context),
              ),
              const SizedBox(height: 14),
              const _BillingReadyNotice(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _unlockMockPremium(BuildContext context, WidgetRef ref) async {
    await ref.read(premiumEntitlementProvider.notifier).setMockUnlock(true);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Development lifetime unlock enabled.')),
    );
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

class _UpgradeTopBar extends StatelessWidget {
  const _UpgradeTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'LifeThreads Premium',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _LifetimeHero extends StatelessWidget {
  const _LifetimeHero({required this.isPremium, required this.memoryCount});

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
                child: const Icon(
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
                  isPremium ? 'Lifetime active' : 'One-time lifetime unlock',
                  style: const TextStyle(
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
                ? 'Your memory wall is unlimited.'
                : 'Move your memories between devices safely.',
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
                ? 'Premium lifetime unlock is active. Encrypted archive export, premium themes, and advanced layouts are available.'
                : 'Free includes ${PremiumEntitlement.freeMemoryLimit} memories. Premium adds encrypted archive export/import, safe device transfer, themes, and advanced layouts.',
            style: const TextStyle(
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
                isPremium ? 'Premium memories' : 'Free memories',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                isPremium
                    ? '$memoryCount / unlimited'
                    : '$memoryCount / ${PremiumEntitlement.freeMemoryLimit}',
                style: const TextStyle(
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
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 2 : 1,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: isWide ? 2.65 : 3.45,
          children: const [
            _BenefitCard(
              icon: Icons.all_inclusive_rounded,
              title: 'Unlimited memories',
              body:
                  'No 30-memory ceiling. Keep building the wall as life grows.',
            ),
            _BenefitCard(
              icon: Icons.archive_rounded,
              title: 'Encrypted archives',
              body:
                  'Export and import a password-protected zip with photos, notes, ropes, layout, and metadata.',
            ),
            _BenefitCard(
              icon: Icons.devices_rounded,
              title: 'Move to another device',
              body:
                  'Carry your private memory wall to a new phone without active cloud sync.',
            ),
            _BenefitCard(
              icon: Icons.palette_rounded,
              title: 'Premium wall themes',
              body:
                  'Unlock richer wall moods for family, travel, archive, and gallery styles.',
            ),
            _BenefitCard(
              icon: Icons.dashboard_customize_rounded,
              title: 'Advanced layouts',
              body:
                  'More ways to arrange threads, timelines, anchors, and memory clusters.',
            ),
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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

class _MoveDeviceCard extends StatelessWidget {
  const _MoveDeviceCard({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_clock_rounded,
            color: AppColors.amber,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cloud sync is planned later',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Premium Archive is the safe transfer feature now: export, move the zip, and import on another device.',
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onOpen,
                  icon: const Icon(Icons.devices_rounded),
                  label: const Text('How device transfer works'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LifetimeOfferCard extends StatelessWidget {
  const _LifetimeOfferCard({
    required this.isPremium,
    required this.purchaseState,
    required this.onPurchase,
    required this.onRestore,
    required this.onMockUnlock,
    required this.onContinue,
  });

  final bool isPremium;
  final PremiumPurchaseState purchaseState;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;
  final VoidCallback? onMockUnlock;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final price = purchaseState.price ?? '€4.99';
    final canBuy = purchaseState.canBuy && !purchaseState.isBusy;
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
          const Text(
            'Lifetime unlock',
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
                ? 'Premium is active on this device.'
                : 'One purchase. No monthly subscription for the first premium version. Keep, protect, and move your memory wall.',
            style: TextStyle(
              color: Color(0xFF6D5741),
              height: 1.38,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!isPremium) ...[
            const SizedBox(height: 14),
            _PricePill(price: price, purchaseState: purchaseState),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isPremium
                  ? onContinue
                  : canBuy
                  ? onPurchase
                  : null,
              icon: Icon(
                isPremium
                    ? Icons.check_rounded
                    : purchaseState.isBusy
                    ? Icons.hourglass_top_rounded
                    : Icons.lock_open_rounded,
              ),
              label: Text(
                isPremium
                    ? 'Premium Active'
                    : purchaseState.isBusy
                    ? 'Processing...'
                    : 'Unlock Premium',
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: purchaseState.isBusy ? null : onRestore,
            icon: const Icon(Icons.restore_rounded),
            label: const Text('Restore purchase'),
          ),
          if (onMockUnlock != null && !isPremium) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onMockUnlock,
              icon: const Icon(Icons.science_rounded),
              label: const Text('Enable debug mock unlock'),
            ),
          ],
          if (message != null) ...[
            const SizedBox(height: 10),
            _PurchaseMessage(state: purchaseState),
          ],
          const SizedBox(height: 10),
          const Text(
            'Purchases are handled by Google Play. The unlock is stored locally after purchase or restore.',
            style: TextStyle(
              color: Color(0xFF7A654E),
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

class _PricePill extends StatelessWidget {
  const _PricePill({required this.price, required this.purchaseState});

  final String price;
  final PremiumPurchaseState purchaseState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF352817).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.gold,
            size: 19,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              purchaseState.status == PremiumPurchaseStatus.ready
                  ? 'Lifetime unlock • $price'
                  : _statusLabel(purchaseState.status),
              style: const TextStyle(
                color: AppColors.paperInk,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(PremiumPurchaseStatus status) {
    return switch (status) {
      PremiumPurchaseStatus.loading => 'Loading Play Store product...',
      PremiumPurchaseStatus.storeUnavailable => 'Play Store unavailable',
      PremiumPurchaseStatus.productUnavailable => 'Product not configured',
      PremiumPurchaseStatus.pending => 'Purchase pending',
      PremiumPurchaseStatus.purchased => 'Purchased',
      PremiumPurchaseStatus.restored => 'Restored',
      PremiumPurchaseStatus.failed => 'Purchase failed',
      PremiumPurchaseStatus.idle => 'Preparing checkout...',
      PremiumPurchaseStatus.ready => 'Lifetime unlock • $price',
    };
  }
}

class _PurchaseMessage extends StatelessWidget {
  const _PurchaseMessage({required this.state});

  final PremiumPurchaseState state;

  @override
  Widget build(BuildContext context) {
    final isError =
        state.status == PremiumPurchaseStatus.failed ||
        state.status == PremiumPurchaseStatus.storeUnavailable ||
        state.status == PremiumPurchaseStatus.productUnavailable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isError ? AppColors.rose : AppColors.sage).withValues(
          alpha: 0.18,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        state.message ?? '',
        style: TextStyle(
          color: isError ? const Color(0xFF7A2B24) : const Color(0xFF38512D),
          height: 1.35,
          fontWeight: FontWeight.w800,
        ),
      ),
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
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shopping_bag_rounded, color: AppColors.amber),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium is local-first',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
                SizedBox(height: 5),
                Text(
                  'Premium unlocks local-first value now. Cloud sync is planned later and is not active in this version.',
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
