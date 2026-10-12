import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/logging/app_logger.dart';
import '../data/premium_entitlement_controller.dart';
import '../domain/premium_feature.dart';

/// Whether Premium is active right now; false while the entitlement loads.
/// For UI that only shows or hides something (no upsell).
final premiumActiveProvider = Provider<bool>(
  (ref) =>
      ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false,
);

/// The one gate for Premium features: true when Premium is active,
/// otherwise opens the Premium page for [feature] and returns false.
///
/// ```dart
/// if (!await requirePremium(context, PremiumFeature.storyImage)) return;
/// ```
Future<bool> requirePremium(
  BuildContext context,
  PremiumFeature feature,
) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final entitlement = await container.read(premiumEntitlementProvider.future);
  if (entitlement.isPremium) return true;
  AppLogger.event('premium_gate_${feature.name}');
  if (context.mounted) {
    unawaited(context.push(RouteNames.upgrade, extra: feature));
  }
  return false;
}
