import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../memories/data/memory_repository.dart';
import '../domain/on_this_day.dart';

/// The current time; overridden in tests.
final onThisDayClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Today's date. Refreshed when the app comes back to the foreground (see
/// `OnThisDayScheduler`), so the wall does not keep yesterday's memory.
final onThisDayTodayProvider = Provider<DateTime>((ref) {
  final now = ref.watch(onThisDayClockProvider)();
  return DateTime(now.year, now.month, now.day);
});

/// Today's On this day memories, most years ago first.
final onThisDayMatchesProvider = Provider<List<OnThisDayMatch>>((ref) {
  final events = ref
      .watch(memoryRepositoryProvider)
      .asData
      ?.value
      .visibleEvents;
  if (events == null) return const [];
  return OnThisDay.matchesOn(ref.watch(onThisDayTodayProvider), events);
});
