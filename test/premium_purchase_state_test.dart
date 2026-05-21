import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/premium/domain/premium_purchase_state.dart';

void main() {
  group('PremiumPurchaseState', () {
    test('reports busy states', () {
      const loading = PremiumPurchaseState(
        status: PremiumPurchaseStatus.loading,
      );
      const pending = PremiumPurchaseState(
        status: PremiumPurchaseStatus.pending,
      );
      const restoring = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        isRestoring: true,
      );

      expect(loading.isBusy, isTrue);
      expect(pending.isBusy, isTrue);
      expect(restoring.isBusy, isTrue);
    });

    test('ready state can buy when enabled', () {
      const state = PremiumPurchaseState(
        status: PremiumPurchaseStatus.ready,
        productId: 'lifethreads_premium_lifetime',
        price: '€4.99',
        canBuy: true,
      );

      expect(state.isBusy, isFalse);
      expect(state.canBuy, isTrue);
      expect(state.price, '€4.99');
    });
  });
}
