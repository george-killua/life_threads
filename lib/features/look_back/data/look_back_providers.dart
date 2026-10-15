import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../memories/data/memory_repository.dart';
import '../../year_thread/data/year_thread_providers.dart';
import '../domain/month_look_back.dart';

/// The current time; overridden in tests.
final lookBackClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// The month ("2026-09") whose wall card was dismissed with "Not now".
final lookBackCardDismissalProvider =
    AsyncNotifierProvider<LookBackCardDismissal, String?>(
      LookBackCardDismissal.new,
    );

class LookBackCardDismissal extends AsyncNotifier<String?> {
  static const _key = 'look_back_card_dismissed_month';

  static String keyFor(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';

  @override
  Future<String?> build() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_key);
  }

  Future<void> dismiss(int year, int month) async {
    final key = keyFor(year, month);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, key);
    state = AsyncData(key);
  }
}

/// The month the wall's "Your month in memories" card offers, or null when
/// the card is hidden: in the first week of a month, for the month before
/// when it has memories, until dismissed. Thread of the Year's card goes
/// first (early January).
final lookBackWallCardProvider = Provider<MonthLookBack?>((ref) {
  final month = MonthLookBack.cardMonth(ref.watch(lookBackClockProvider)());
  if (month == null) return null;
  if (ref.watch(yearThreadWallCardYearProvider) != null) return null;
  final state = ref.watch(memoryRepositoryProvider).asData?.value;
  if (state == null) return null;
  final dismissal = ref.watch(lookBackCardDismissalProvider);
  if (!dismissal.hasValue ||
      dismissal.value ==
          LookBackCardDismissal.keyFor(month.year, month.month)) {
    return null;
  }
  final lookBack = MonthLookBack.of(month.year, month.month, state);
  return lookBack.isEmpty ? null : lookBack;
});
