import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

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
  ProductDetails? _subscriptionProduct;
  var _awaitingRestoreResult = false;
  var _deliveredDuringRestore = false;

  @override
  PremiumPurchaseState build() {
    _subscription = _store.purchaseStream.listen(
      _handlePurchases,
      onError: (Object error) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.failed,
          message: 'Billing update failed. Please try again.',
          canBuy: _subscriptionProduct != null,
          productId: _subscriptionProduct?.id,
          price: _subscriptionProduct?.price,
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
          message: 'Store billing is not available on this device.',
        );
        return;
      }

      final response = await _store.queryProductDetails(
        PremiumProductIds.all,
      );

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
              'Premium subscription is not available yet. Check the store product setup.',
        );
        return;
      }

      _subscriptionProduct = _pickSubscriptionOffer(response.productDetails);
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        productId: _subscriptionProduct!.id,
        price: _subscriptionProduct!.price,
        canBuy: true,
      );

      // Refresh entitlement from the store (active subscription → premium).
      unawaited(restorePurchases(silent: true));
    } catch (_) {
      state = const PremiumPurchaseState(
        status: PremiumPurchaseStatus.failed,
        message: 'Could not load Premium from the store. Please try again.',
      );
    }
  }

  Future<void> buySubscription() async {
    final product = _subscriptionProduct;
    if (product == null) {
      await loadProduct();
      return;
    }

    state = state.copyWith(
      status: PremiumPurchaseStatus.pending,
      message: 'Opening store checkout.',
      canBuy: false,
    );

    try {
      final purchaseParam = _purchaseParamFor(product);
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

  Future<void> restorePurchases({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(
        isRestoring: true,
        message: 'Checking your subscription.',
      );
    }

    _awaitingRestoreResult = true;
    _deliveredDuringRestore = false;

    try {
      await _store.restorePurchases();
      // purchaseStream delivers restores asynchronously after this returns.
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!_deliveredDuringRestore) {
        await ref.read(premiumEntitlementProvider.notifier).revokeStoreUnlock();
        if (!silent) {
          state = state.copyWith(
            status: _subscriptionProduct == null
                ? PremiumPurchaseStatus.idle
                : PremiumPurchaseStatus.ready,
            isRestoring: false,
            canBuy: _subscriptionProduct != null,
            message: 'No active Premium subscription was found.',
          );
        } else if (_subscriptionProduct != null) {
          state = state.copyWith(
            status: PremiumPurchaseStatus.ready,
            canBuy: true,
            isRestoring: false,
          );
        }
      } else if (!silent) {
        state = state.copyWith(isRestoring: false);
      }
    } catch (_) {
      if (!silent) {
        state = state.copyWith(
          status: PremiumPurchaseStatus.failed,
          isRestoring: false,
          message: 'Restore failed. Please try again.',
        );
      }
    } finally {
      _awaitingRestoreResult = false;
    }
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != PremiumProductIds.monthlySubscription) {
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(
            status: PremiumPurchaseStatus.pending,
            message: 'Purchase is pending. Premium unlocks after approval.',
            canBuy: false,
          );
        case PurchaseStatus.purchased:
          await _deliverPurchase(purchase, PremiumPurchaseStatus.purchased);
        case PurchaseStatus.restored:
          await _deliverPurchase(purchase, PremiumPurchaseStatus.restored);
        case PurchaseStatus.error:
          state = PremiumPurchaseState(
            status: PremiumPurchaseStatus.failed,
            productId: _subscriptionProduct?.id,
            price: _subscriptionProduct?.price,
            canBuy: _subscriptionProduct != null,
            message:
                purchase.error?.message ?? 'Purchase failed. Please try again.',
          );
        case PurchaseStatus.canceled:
          state = PremiumPurchaseState(
            status: PremiumPurchaseStatus.failed,
            productId: _subscriptionProduct?.id,
            price: _subscriptionProduct?.price,
            canBuy: _subscriptionProduct != null,
            message: 'Purchase canceled.',
          );
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
    if (_awaitingRestoreResult) {
      _deliveredDuringRestore = true;
    }
    await ref.read(premiumEntitlementProvider.notifier).grantStoreUnlock();
    state = PremiumPurchaseState(
      status: status,
      productId: purchase.productID,
      price: _subscriptionProduct?.price,
      canBuy: true,
      isRestoring: false,
      message: status == PremiumPurchaseStatus.restored
          ? 'Premium subscription restored.'
          : 'Premium subscription is active.',
    );
  }

  ProductDetails _pickSubscriptionOffer(List<ProductDetails> products) {
    // Prefer a Google Play offer that already carries an offerToken.
    for (final product in products) {
      if (product is GooglePlayProductDetails && product.offerToken != null) {
        return product;
      }
    }
    return products.first;
  }

  PurchaseParam _purchaseParamFor(ProductDetails product) {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final offerToken = product is GooglePlayProductDetails
          ? product.offerToken
          : null;
      return GooglePlayPurchaseParam(
        productDetails: product,
        offerToken: offerToken,
      );
    }
    return PurchaseParam(productDetails: product);
  }
}
