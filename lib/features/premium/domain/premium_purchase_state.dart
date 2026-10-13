/// What the Premium page tells the user about the store; translated there.
enum PremiumPurchaseMessage {
  billingUpdateFailed,
  storeUnavailable,
  productUnavailable,
  loadFailed,
  openingCheckout,
  checkoutFailed,
  checking,
  restoreFailed,
  noSubscriptionFound,
  pending,
  purchaseFailed,
  canceled,
  restored,
  active,
}

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
  final PremiumPurchaseMessage? message;
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
    PremiumPurchaseMessage? message,
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
