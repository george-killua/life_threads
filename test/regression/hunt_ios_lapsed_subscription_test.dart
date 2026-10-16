// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// an expired iOS (StoreKit 2) subscription must end Premium.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:life_threads/features/premium/data/premium_billing_controller.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_product.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeStore extends InAppPurchasePlatform with MockPlatformInterfaceMixin {
  final controller = StreamController<List<PurchaseDetails>>.broadcast();
  final completed = <String>[];
  Duration restoreDeliveryDelay = Duration.zero;
  List<PurchaseDetails> Function() onRestore = () => [];
  Object? queryError;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => controller.stream;
  @override
  Future<bool> isAvailable() async => true;
  bool offerYearly = false;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async =>
      queryError != null
      ? throw queryError!
      : ProductDetailsResponse(
          productDetails: [
            ProductDetails(
              id: PremiumProductIds.monthlySubscription,
              title: 'P',
              description: 'P',
              price: '€2.99',
              rawPrice: 2.99,
              currencyCode: 'EUR',
            ),
            if (offerYearly)
              ProductDetails(
                id: PremiumProductIds.yearlySubscription,
                title: 'P',
                description: 'P',
                price: '€20.99',
                rawPrice: 20.99,
                currencyCode: 'EUR',
              ),
          ],
          notFoundIDs: const [],
        );
  @override
  Future<void> completePurchase(PurchaseDetails p) async =>
      completed.add(p.productID);
  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    final batch = onRestore();
    Future<void>.delayed(restoreDeliveryDelay, () => controller.add(batch));
  }
}

Future<void> _settle([int ms = 50]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeStore store;
  late ProviderContainer container;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    InAppPurchase.instance;
    store = FakeStore();
    InAppPurchasePlatform.instance = store;
    // Was a subscriber; the subscription has since expired.
    SharedPreferences.setMockInitialValues({
      'premium_store_unlock_enabled': true,
    });
    PremiumBillingController.restoreDeliveryTimeout = const Duration(
      milliseconds: 200,
    );
    container = ProviderContainer();
    await container.read(premiumEntitlementProvider.future);
  });
  tearDown(() {
    container.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'silent restore that finds no current entitlement revokes premium',
    () async {
      // StoreKit 2 restorePurchases() walks Transaction.currentEntitlements and
      // sends the (empty) list on purchaseStream, then completes.
      store.onRestore = () => [];
      container.read(premiumBillingProvider); // as app.dart does at startup
      await _settle(800);
      final e = container.read(premiumEntitlementProvider).value!;
      expect(
        e.isPremium,
        isFalse,
        reason: 'expired iOS subscription still premium after launch restore',
      );
    },
  );
}
