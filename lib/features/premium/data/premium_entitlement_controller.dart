import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/premium_entitlement.dart';

final premiumEntitlementProvider =
    AsyncNotifierProvider<PremiumEntitlementController, PremiumEntitlement>(
      PremiumEntitlementController.new,
    );

class PremiumEntitlementController extends AsyncNotifier<PremiumEntitlement> {
  static const _mockUnlockKey = 'premium_mock_unlock_enabled';
  static const _storeUnlockKey = 'premium_store_unlock_enabled';

  @override
  Future<PremiumEntitlement> build() async {
    final preferences = await SharedPreferences.getInstance();
    final mockUnlocked =
        kDebugMode && (preferences.getBool(_mockUnlockKey) ?? false);
    final storeUnlocked = preferences.getBool(_storeUnlockKey) ?? false;

    return PremiumEntitlement(
      isPremium: storeUnlocked || mockUnlocked,
      isMockUnlocked: mockUnlocked,
      isStoreUnlocked: storeUnlocked,
    );
  }

  Future<void> setMockUnlock(bool enabled) async {
    if (!kDebugMode) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_mockUnlockKey, enabled);
    await _emit(preferences);
  }

  Future<void> grantStoreUnlock() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_storeUnlockKey, true);
    await _emit(preferences);
  }

  Future<void> _emit(SharedPreferences preferences) async {
    final mockUnlocked =
        kDebugMode && (preferences.getBool(_mockUnlockKey) ?? false);
    final storeUnlocked = preferences.getBool(_storeUnlockKey) ?? false;
    state = AsyncData(
      PremiumEntitlement(
        isPremium: storeUnlocked || mockUnlocked,
        isMockUnlocked: mockUnlocked,
        isStoreUnlocked: storeUnlocked,
      ),
    );
  }
}
