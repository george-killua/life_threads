import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/premium_product.dart';
import '../domain/premium_purchase_state.dart';
import 'premium_entitlement_controller.dart';

final premiumBillingProvider =
    NotifierProvider<PremiumBillingController, PremiumPurchaseState>(
      PremiumBillingController.new,
    );

class PremiumBillingController extends Notifier<PremiumPurchaseState> {
  final InAppPurchase _store = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  ProductDetails? _lifetimeProduct;

  @override
  PremiumPurchaseState build() {
    _subscription = _store.purchaseStream.listen(
      _handlePurchases,
      onError: (Object error) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.failed,
          message: 'Billing update failed. Please try again.',
          canBuy: _lifetimeProduct != null,
          productId: _lifetimeProduct?.id,
          price: _lifetimeProduct?.price,
        );
      },
    );
    ref.onDispose(() => _subscription?.cancel());
    Future.microtask(loadProduct);
    return const PremiumPurchaseState.idle();
  }

  Future<void> loadProduct() async {
    state = state.copyWith(status: PremiumPurchaseStatus.loading);

    try {
      final available = await _store.isAvailable();
      if (!available) {
        state = const PremiumPurchaseState(
          status: PremiumPurchaseStatus.storeUnavailable,
          message: 'Google Play Billing is not available on this device.',
        );
        return;
      }

      final response = await _store.queryProductDetails({
        PremiumProductIds.lifetimeUnlock,
      });

      if (response.error != null) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.failed,
          message: response.error!.message,
        );
        return;
      }

      if (response.productDetails.isEmpty) {
        state = const PremiumPurchaseState(
          status: PremiumPurchaseStatus.productUnavailable,
          message:
              'Premium is not available yet. Check the Play Console product setup.',
        );
        return;
      }

      _lifetimeProduct = response.productDetails.first;
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        productId: _lifetimeProduct!.id,
        price: _lifetimeProduct!.price,
        canBuy: true,
      );
    } catch (_) {
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.failed,
        message: 'Could not load Premium from Google Play. Please try again.',
      );
    }
  }

  Future<void> buyLifetimeUnlock() async {
    final product = _lifetimeProduct;
    if (product == null) {
      await loadProduct();
      return;
    }

    state = state.copyWith(
      status: PremiumPurchaseStatus.pending,
      message: 'Opening Google Play checkout.',
      canBuy: false,
    );

    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      final started = await _store.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!started) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.failed,
          productId: product.id,
          price: product.price,
          canBuy: true,
          message: 'Could not start checkout. Please try again.',
        );
      }
    } catch (_) {
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.failed,
        productId: product.id,
        price: product.price,
        canBuy: true,
        message: 'Checkout failed to open. Please try again.',
      );
    }
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(
      isRestoring: true,
      message: 'Checking your previous purchases.',
    );
    try {
      await _store.restorePurchases();
      final restored =
          state.status == PremiumPurchaseStatus.restored ||
          state.status == PremiumPurchaseStatus.purchased;
      if (!restored) {
        state = state.copyWith(
          status: _lifetimeProduct == null
              ? PremiumPurchaseStatus.idle
              : PremiumPurchaseStatus.ready,
          isRestoring: false,
          canBuy: _lifetimeProduct != null,
          message: 'No previous premium purchase was found.',
        );
      }
    } catch (_) {
      state = state.copyWith(
        status: PremiumPurchaseStatus.failed,
        isRestoring: false,
        message: 'Restore failed. Please try again.',
      );
    }
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != PremiumProductIds.lifetimeUnlock) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(
            status: PremiumPurchaseStatus.pending,
            message: 'Purchase is pending. Premium unlocks after approval.',
            canBuy: false,
          );
          break;
        case PurchaseStatus.purchased:
          await _deliverPurchase(purchase, PremiumPurchaseStatus.purchased);
          break;
        case PurchaseStatus.restored:
          await _deliverPurchase(purchase, PremiumPurchaseStatus.restored);
          break;
        case PurchaseStatus.error:
          state = PremiumPurchaseState(
            status: PremiumPurchaseStatus.failed,
            productId: _lifetimeProduct?.id,
            price: _lifetimeProduct?.price,
            canBuy: _lifetimeProduct != null,
            message:
                purchase.error?.message ?? 'Purchase failed. Please try again.',
          );
          break;
        case PurchaseStatus.canceled:
          state = PremiumPurchaseState(
            status: PremiumPurchaseStatus.failed,
            productId: _lifetimeProduct?.id,
            price: _lifetimeProduct?.price,
            canBuy: _lifetimeProduct != null,
            message: 'Purchase canceled.',
          );
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    }
  }

  Future<void> _deliverPurchase(
    PurchaseDetails purchase,
    PremiumPurchaseStatus status,
  ) async {
    await ref.read(premiumEntitlementProvider.notifier).grantStoreUnlock();
    state = PremiumPurchaseState(
      status: status,
      productId: purchase.productID,
      price: _lifetimeProduct?.price,
      canBuy: true,
      message: status == PremiumPurchaseStatus.restored
          ? 'Premium purchase restored.'
          : 'Premium lifetime unlock is active.',
    );
  }
}
