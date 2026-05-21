class PremiumEntitlement {
  const PremiumEntitlement({
    required this.isPremium,
    required this.isMockUnlocked,
    this.isStoreUnlocked = false,
  });

  static const freeMemoryLimit = 30;

  final bool isPremium;
  final bool isMockUnlocked;
  final bool isStoreUnlocked;

  bool canCreateMemory(int memoryCount) {
    return isPremium || memoryCount < freeMemoryLimit;
  }

  int remainingFreeMemories(int memoryCount) {
    if (isPremium) return 999999;
    return (freeMemoryLimit - memoryCount).clamp(0, freeMemoryLimit);
  }
}

abstract interface class PremiumEntitlementGateway {
  Future<bool> hasActiveEntitlement();
}
