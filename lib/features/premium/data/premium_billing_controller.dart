import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../domain/premium_product.dart';
import '../domain/premium_purchase_state.dart';
import 'premium_entitlement_controller.dart';

/// The plans on offer and the one chosen (yearly first).
final premiumPlansProvider =
    NotifierProvider<PremiumPlansController, PremiumPlans>(
      PremiumPlansController.new,
    );

class PremiumPlansController extends Notifier<PremiumPlans> {
  @override
  PremiumPlans build() => const PremiumPlans();

  // ignore: use_setters_to_change_properties
  void set(PremiumPlans plans) => state = plans;
}

final premiumBillingProvider =
    NotifierProvider<PremiumBillingController, PremiumPurchaseState>(
      PremiumBillingController.new,
    );

class PremiumBillingController extends Notifier<PremiumPurchaseState> {
  final InAppPurchase _store = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  ProductDetails? _subscriptionProduct;
  ProductDetails? _monthly;
  ProductDetails? _yearly;

  /// Open while an iOS restore waits for the store's answer: true once one
  /// of our purchases arrives, false when the store answers without one.
  Completer<bool>? _restoreDelivery;
  Future<_RestoreOutcome>? _restoreInFlight;

  /// How long a store-side restore may take to deliver its transactions.
  /// Without a delivery in this window the result is treated as unknown
  /// (silent restore) or "nothing found" (user-initiated restore).
  @visibleForTesting
  static Duration restoreDeliveryTimeout = const Duration(seconds: 6);

  @override
  PremiumPurchaseState build() {
    _subscription = _store.purchaseStream.listen(
      _handlePurchases,
      onError: (Object error) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.failed,
          message: PremiumPurchaseMessage.billingUpdateFailed,
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
          message: PremiumPurchaseMessage.storeUnavailable,
        );
        return;
      }

      final response = await _store.queryProductDetails(PremiumProductIds.all);

      if (response.error != null) {
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.storeUnavailable,
          message: PremiumPurchaseMessage.loadFailed,
        );
        return;
      }

      if (response.productDetails.isEmpty) {
        state = const PremiumPurchaseState(
          status: PremiumPurchaseStatus.productUnavailable,
          message: PremiumPurchaseMessage.productUnavailable,
        );
        return;
      }

      _monthly = _offerFor(
        response.productDetails,
        PremiumProductIds.monthlySubscription,
      );
      _yearly = _offerFor(
        response.productDetails,
        PremiumProductIds.yearlySubscription,
      );
      _subscriptionProduct =
          _yearly ??
          _monthly ??
          _pickSubscriptionOffer(response.productDetails);
      _publishPlans(_yearly != null ? PremiumPlan.yearly : PremiumPlan.monthly);
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
        status: PremiumPurchaseStatus.storeUnavailable,
        message: PremiumPurchaseMessage.loadFailed,
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
      message: PremiumPurchaseMessage.openingCheckout,
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
          message: PremiumPurchaseMessage.checkoutFailed,
        );
      }
    } catch (_) {
      state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.failed,
        productId: product.id,
        price: product.price,
        canBuy: true,
        message: PremiumPurchaseMessage.checkoutFailed,
      );
    }
  }

  Future<void> restorePurchases({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(
        isRestoring: true,
        message: PremiumPurchaseMessage.checking,
      );
    }

    // Overlapping restores (silent restore at load + a user tap) share one
    // run so they don't reset each other's delivery tracking.
    final inFlight = _restoreInFlight ??= _runRestore().whenComplete(
      () => _restoreInFlight = null,
    );

    try {
      final outcome = await inFlight;
      await _applyRestoreOutcome(outcome, silent: silent);
    } catch (_) {
      if (!silent) {
        state = state.copyWith(
          status: PremiumPurchaseStatus.failed,
          isRestoring: false,
          message: PremiumPurchaseMessage.restoreFailed,
        );
      }
    }
  }

  Future<_RestoreOutcome> _runRestore() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return _queryAndroidPurchases();
    }

    final delivery = _restoreDelivery = Completer<bool>();
    try {
      await _store.restorePurchases();
      // purchaseStream delivers restores asynchronously after this returns.
      // StoreKit 2 always answers with the current entitlements, so an
      // answer without our subscription means it expired or was refunded.
      final found = await delivery.future.timeout(restoreDeliveryTimeout);
      return found ? _RestoreOutcome.found : _RestoreOutcome.noneActive;
    } on TimeoutException {
      return _RestoreOutcome.nothingDelivered;
    } finally {
      _restoreDelivery = null;
    }
  }

  /// Play Billing answers "which subscriptions are active" directly, so the
  /// entitlement can be granted or revoked from a definitive result.
  Future<_RestoreOutcome> _queryAndroidPurchases() async {
    final addition = _store
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final response = await addition.queryPastPurchases();
    if (response.error != null) {
      throw StateError(response.error!.message);
    }

    final active = response.pastPurchases.where(
      (purchase) =>
          PremiumProductIds.all.contains(purchase.productID) &&
          (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored),
    );
    if (active.isEmpty) {
      final pending = response.pastPurchases.any(
        (purchase) =>
            PremiumProductIds.all.contains(purchase.productID) &&
            purchase.status == PurchaseStatus.pending,
      );
      if (pending) {
        _markPending();
        return _RestoreOutcome.found;
      }
      return _RestoreOutcome.noneActive;
    }

    for (final purchase in active) {
      await _deliverPurchase(purchase, PremiumPurchaseStatus.restored);
      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    }
    return _RestoreOutcome.found;
  }

  Future<void> _applyRestoreOutcome(
    _RestoreOutcome outcome, {
    required bool silent,
  }) async {
    switch (outcome) {
      case _RestoreOutcome.found:
        if (!silent) state = state.copyWith(isRestoring: false);
      case _RestoreOutcome.noneActive:
        await ref.read(premiumEntitlementProvider.notifier).revokeStoreUnlock();
        _showNothingFound(silent: silent);
      case _RestoreOutcome.nothingDelivered:
        // The store gave no answer in time. Keep the current entitlement on a
        // silent refresh; a late delivery still grants it.
        if (!silent) {
          await ref
              .read(premiumEntitlementProvider.notifier)
              .revokeStoreUnlock();
        }
        _showNothingFound(silent: silent);
    }
  }

  void _showNothingFound({required bool silent}) {
    // A user's own Restore that finds nothing ends a stale pending state.
    if (state.status == PremiumPurchaseStatus.pending && silent) return;
    if (!silent) {
      state = state.copyWith(
        status: _subscriptionProduct == null
            ? PremiumPurchaseStatus.idle
            : PremiumPurchaseStatus.ready,
        isRestoring: false,
        canBuy: _subscriptionProduct != null,
        message: PremiumPurchaseMessage.noSubscriptionFound,
      );
    } else if (_subscriptionProduct != null &&
        state.status == PremiumPurchaseStatus.ready) {
      state = state.copyWith(canBuy: true, isRestoring: false);
    }
  }

  void _markPending() {
    state = state.copyWith(
      status: PremiumPurchaseStatus.pending,
      message: PremiumPurchaseMessage.pending,
      canBuy: false,
    );
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    final hasOwnPurchase = purchases.any(
      (purchase) =>
          PremiumProductIds.all.contains(purchase.productID) &&
          purchase.status != PurchaseStatus.error &&
          purchase.status != PurchaseStatus.canceled &&
          !_isRevokedOrExpired(purchase),
    );
    if (!hasOwnPurchase) _markRestoreDelivered(found: false);
    for (final purchase in purchases) {
      if (PremiumProductIds.all.contains(purchase.productID)) {
        await _handleOwnPurchase(purchase);
      }

      // Every transaction must be finished, even for products this build
      // doesn't sell any more; otherwise Play refunds it and iOS redelivers it.
      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    }
  }

  Future<void> _handleOwnPurchase(PurchaseDetails purchase) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        _markRestoreDelivered();
        _markPending();
      case PurchaseStatus.purchased || PurchaseStatus.restored
          when _isRevokedOrExpired(purchase):
        // StoreKit 2 reports a refund (or a lapsed period) as a "purchased"
        // update. Ask the store what is still active: that grants Premium
        // for a current subscription and revokes it otherwise.
        if (_restoreInFlight == null) {
          unawaited(restorePurchases(silent: true));
        }
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
          message: PremiumPurchaseMessage.purchaseFailed,
        );
      case PurchaseStatus.canceled:
        state = PremiumPurchaseState(
          status: PremiumPurchaseStatus.failed,
          productId: _subscriptionProduct?.id,
          price: _subscriptionProduct?.price,
          canBuy: _subscriptionProduct != null,
          message: PremiumPurchaseMessage.canceled,
        );
    }
  }

  /// An App Store transaction that was refunded or whose period is over,
  /// read from its StoreKit 2 JSON (`revocationDate`, `expiresDate`, in ms).
  /// Play purchases carry neither and count as active.
  static bool _isRevokedOrExpired(PurchaseDetails purchase) {
    final Object? json;
    try {
      json = jsonDecode(purchase.verificationData.localVerificationData);
    } on FormatException {
      return false;
    }
    if (json is! Map) return false;
    if (json['revocationDate'] != null) return true;
    final expires = json['expiresDate'];
    return expires is num && expires < DateTime.now().millisecondsSinceEpoch;
  }

  void _markRestoreDelivered({bool found = true}) {
    final delivery = _restoreDelivery;
    if (delivery != null && !delivery.isCompleted) delivery.complete(found);
  }

  Future<void> _deliverPurchase(
    PurchaseDetails purchase,
    PremiumPurchaseStatus status,
  ) async {
    _markRestoreDelivered();
    await ref.read(premiumEntitlementProvider.notifier).grantStoreUnlock();
    state = PremiumPurchaseState(
      status: status,
      productId: purchase.productID,
      price: _subscriptionProduct?.price,
      canBuy: true,
      isRestoring: false,
      message: status == PremiumPurchaseStatus.restored
          ? PremiumPurchaseMessage.restored
          : PremiumPurchaseMessage.active,
    );
  }

  /// Chooses the plan to buy; the page shows its price.
  void selectPlan(PremiumPlan plan) {
    final product = plan == PremiumPlan.yearly ? _yearly : _monthly;
    if (product == null) return;
    _subscriptionProduct = product;
    _publishPlans(plan);
    state = state.copyWith(productId: product.id, price: product.price);
  }

  void _publishPlans(PremiumPlan selected) {
    final monthly = _monthly;
    final yearly = _yearly;
    int? savings;
    if (monthly != null && yearly != null && monthly.rawPrice > 0) {
      savings = ((1 - yearly.rawPrice / (monthly.rawPrice * 12)) * 100).floor();
      if (savings <= 0) savings = null;
    }
    ref
        .read(premiumPlansProvider.notifier)
        .set(
          PremiumPlans(
            monthlyPrice: monthly?.price,
            yearlyPrice: yearly?.price,
            savingsPercent: savings,
            selected: selected,
          ),
        );
  }

  ProductDetails? _offerFor(List<ProductDetails> products, String id) {
    final matching = [
      for (final product in products)
        if (product.id == id) product,
    ];
    return matching.isEmpty ? null : _pickSubscriptionOffer(matching);
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

enum _RestoreOutcome { found, noneActive, nothingDelivered }
