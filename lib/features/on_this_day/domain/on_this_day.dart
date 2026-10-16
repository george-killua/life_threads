import 'package:timezone/timezone.dart' as tz;

import '../../memories/data/memory_seed_data.dart';
import '../../memories/domain/memory_event.dart';

/// A memory whose anniversary is on a given day.
class OnThisDayMatch {
  const OnThisDayMatch({required this.memory, required this.yearsAgo});

  final MemoryEvent memory;
  final int yearsAgo;
}

/// One reminder on a day that has at least one match.
class OnThisDayReminder {
  const OnThisDayReminder({required this.at, required this.matches});

  final tz.TZDateTime at;

  /// Never empty; the first one is the memory the reminder opens.
  final List<OnThisDayMatch> matches;
}

class OnThisDay {
  const OnThisDay._();

  static const defaultMinuteOfDay = 9 * 60;
  static const scheduleDays = 30;

  /// The memories that happened on [day]'s month and day in an earlier
  /// year. A Feb 29 memory comes back on Feb 28 in years without a Feb 29.
  /// Demo-wall memories and memories from [day]'s year are left out.
  ///
  /// Sorted by most years ago first: the older a memory, the less likely
  /// it comes back on its own, so it is the one worth surfacing. Ties go to
  /// the earlier time of day, then the id, so the wall card and the
  /// notification open the same memory all day.
  static List<OnThisDayMatch> matchesOn(
    DateTime day,
    Iterable<MemoryEvent> events,
  ) {
    final matches = <OnThisDayMatch>[];
    for (final event in events) {
      if (MemorySeedData.isUntouchedDemo(event)) continue;
      final occurred = event.occurredAt.toLocal();
      if (occurred.year >= day.year) continue;
      if (!_isAnniversary(occurred, day)) continue;
      matches.add(
        OnThisDayMatch(memory: event, yearsAgo: day.year - occurred.year),
      );
    }
    matches.sort((first, second) {
      final byYears = second.yearsAgo.compareTo(first.yearsAgo);
      if (byYears != 0) return byYears;
      final firstTime = _minuteOfDay(first.memory.occurredAt.toLocal());
      final secondTime = _minuteOfDay(second.memory.occurredAt.toLocal());
      final byTime = firstTime.compareTo(secondTime);
      if (byTime != 0) return byTime;
      return first.memory.id.compareTo(second.memory.id);
    });
    return matches;
  }

  /// One reminder at [minuteOfDay] (local to [now]'s location) for each of
  /// the next [days] days that has a match, starting today if that time is
  /// still ahead, otherwise tomorrow.
  static List<OnThisDayReminder> upcoming({
    required tz.TZDateTime now,
    required Iterable<MemoryEvent> events,
    int minuteOfDay = defaultMinuteOfDay,
    int days = scheduleDays,
  }) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    final first = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    final startOffset = first.isAfter(now) ? 0 : 1;
    final reminders = <OnThisDayReminder>[];
    for (var offset = startOffset; offset < startOffset + days; offset++) {
      final at = tz.TZDateTime(
        now.location,
        now.year,
        now.month,
        now.day + offset,
        hour,
        minute,
      );
      final matches = matchesOn(DateTime(at.year, at.month, at.day), events);
      if (matches.isEmpty) continue;
      reminders.add(OnThisDayReminder(at: at, matches: matches));
    }
    return reminders;
  }

  static bool _isAnniversary(DateTime occurred, DateTime day) {
    if (occurred.month != day.month) return false;
    if (occurred.day == day.day) return true;
    return occurred.month == DateTime.february &&
        occurred.day == 29 &&
        day.day == 28 &&
        !_isLeapYear(day.year);
  }

  static bool _isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  static int _minuteOfDay(DateTime time) => time.hour * 60 + time.minute;
}
