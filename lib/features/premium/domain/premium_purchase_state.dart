enum PremiumPurchaseStatus {
  idle,
  loading,
  storeUnavailable,
  productUnavailable,
  ready,
  pending,
  purchased,
  restored,
  failed,
}

class PremiumPurchaseState {
  const PremiumPurchaseState({
    required this.status,
    this.productId,
    this.price,
    this.message,
    this.canBuy = false,
    this.isRestoring = false,
  });

  const PremiumPurchaseState.idle() : this(status: PremiumPurchaseStatus.idle);

  final PremiumPurchaseStatus status;
  final String? productId;
  final String? price;
  final String? message;
  final bool canBuy;
  final bool isRestoring;

  bool get isBusy =>
      status == PremiumPurchaseStatus.loading ||
      status == PremiumPurchaseStatus.pending ||
      isRestoring;

  PremiumPurchaseState copyWith({
    PremiumPurchaseStatus? status,
    String? productId,
    String? price,
    String? message,
    bool? canBuy,
    bool? isRestoring,
  }) {
    return PremiumPurchaseState(
      status: status ?? this.status,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      message: message,
      canBuy: canBuy ?? this.canBuy,
      isRestoring: isRestoring ?? this.isRestoring,
    );
  }
}
