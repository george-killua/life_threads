// Drives PremiumBillingController through a fake InAppPurchasePlatform.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:life_threads/app/app.dart';
import 'package:life_threads/features/premium/data/premium_billing_controller.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_product.dart';
import 'package:life_threads/features/premium/domain/premium_purchase_state.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeStore extends InAppPurchasePlatform with MockPlatformInterfaceMixin {
  final controller = StreamController<List<PurchaseDetails>>.broadcast();
  final completed = <String>[];
  Duration restoreDeliveryDelay = Duration.zero;
  List<PurchaseDetails> Function() onRestore = () => [];

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => controller.stream;
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async =>
      ProductDetailsResponse(
        productDetails: [
          ProductDetails(
            id: PremiumProductIds.monthlySubscription,
            title: 'P',
            description: 'P',
            price: '€2.99',
            rawPrice: 2.99,
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

PurchaseDetails _purchase(String id, PurchaseStatus status) => PurchaseDetails(
  purchaseID: 'tx-$id',
  productID: id,
  verificationData: PurchaseVerificationData(
    localVerificationData: '***',
    serverVerificationData: '***',
    source: 'fake',
  ),
  transactionDate: '0',
  status: status,
)..pendingCompletePurchase = true;

Future<void> _settle([int ms = 50]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeStore store;
  late ProviderContainer container;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    InAppPurchase
        .instance; // create singleton without registering a real platform
    store = FakeStore();
    InAppPurchasePlatform.instance = store;
    SharedPreferences.setMockInitialValues({
      'premium_store_unlock_enabled': true,
    });
    container = ProviderContainer();
    await container.read(premiumEntitlementProvider.future);
  });
  tearDown(() {
    container.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'completePurchase is called for a purchase of an unknown productID',
    () async {
      container.read(premiumBillingProvider);
      await _settle(1200); // let silent restore finish
      store.controller.add([
        _purchase('legacy_premium_yearly', PurchaseStatus.purchased),
      ]);
      await _settle();
      expect(store.completed, contains('legacy_premium_yearly'));
    },
  );

  test(
    'a pending purchase found by the silent restore stays pending',
    () async {
      store.onRestore = () => [
        _purchase(
          PremiumProductIds.monthlySubscription,
          PurchaseStatus.pending,
        ),
      ];
      container.read(premiumBillingProvider);
      await _settle(1200);
      final s = container.read(premiumBillingProvider);
      expect(
        s.status,
        PremiumPurchaseStatus.pending,
        reason: 'got ${s.status}, canBuy=${s.canBuy}',
      );
      expect(s.canBuy, isFalse);
    },
  );

  test(
    'active subscriber is not revoked when restore delivery is slow',
    () async {
      store.onRestore = () => [
        _purchase(
          PremiumProductIds.monthlySubscription,
          PurchaseStatus.restored,
        ),
      ];
      store.restoreDeliveryDelay = const Duration(milliseconds: 1500);
      final observed = <bool>[];
      container.listen(
        premiumEntitlementProvider,
        (_, next) => observed.add(next.value!.isPremium),
        fireImmediately: true,
      );
      container.read(premiumBillingProvider);
      await _settle(2000);
      expect(
        observed,
        everyElement(isTrue),
        reason: 'isPremium history: $observed',
      );
    },
  );

  testWidgets(
    'purchase delivered while the upgrade page is closed is completed and granted',
    (tester) async {
      try {
        SharedPreferences.setMockInitialValues({});
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(
          const MethodChannel('com.llfbandit.app_links/messages'),
          (_) async => null,
        );
        messenger.setMockStreamHandler(
          const EventChannel('com.llfbandit.app_links/events'),
          MockStreamHandler.inline(onListen: (_, _) {}),
        );

        await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
        await tester.pump();

        store.controller.add([
          _purchase(
            PremiumProductIds.monthlySubscription,
            PurchaseStatus.purchased,
          ),
        ]);
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          store.completed,
          contains(PremiumProductIds.monthlySubscription),
        );
        final scope = ProviderScope.containerOf(
          tester.element(find.byType(LifeThreadsApp)),
        );
        expect(scope.read(premiumEntitlementProvider).value!.isPremium, isTrue);

        await tester.pumpWidget(const SizedBox());
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
