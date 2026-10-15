class PremiumProductIds {
  const PremiumProductIds._();

  /// Google Play / App Store auto-renewable monthly subscription.
  static const monthlySubscription = 'lifethreads_premium_monthly';

  /// The yearly plan, in the same subscription group; shown first.
  static const yearlySubscription = 'lifethreads_premium_yearly';

  static const all = {monthlySubscription, yearlySubscription};
}

enum PremiumPlan { yearly, monthly }

/// The plans the store offers, for the plan picker. A plan the store
/// doesn't have (yet) is null.
class PremiumPlans {
  const PremiumPlans({
    this.monthlyPrice,
    this.yearlyPrice,
    this.savingsPercent,
    this.selected = PremiumPlan.yearly,
  });

  final String? monthlyPrice;
  final String? yearlyPrice;

  /// How much the yearly plan saves against 12 months, e.g. 42.
  final int? savingsPercent;
  final PremiumPlan selected;

  bool get hasChoice => monthlyPrice != null && yearlyPrice != null;
}
