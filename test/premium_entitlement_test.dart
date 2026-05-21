import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';

void main() {
  group('PremiumEntitlement', () {
    test('free users can create up to the memory limit', () {
      const entitlement = PremiumEntitlement(
        isPremium: false,
        isMockUnlocked: false,
      );

      expect(entitlement.canCreateMemory(0), isTrue);
      expect(entitlement.canCreateMemory(29), isTrue);
      expect(entitlement.canCreateMemory(30), isFalse);
    });

    test('premium users can create beyond the memory limit', () {
      const entitlement = PremiumEntitlement(
        isPremium: true,
        isMockUnlocked: false,
        isStoreUnlocked: true,
      );

      expect(entitlement.canCreateMemory(30), isTrue);
      expect(entitlement.canCreateMemory(300), isTrue);
    });
  });
}
