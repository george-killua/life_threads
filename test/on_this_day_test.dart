import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_scheduler.dart';
import 'package:life_threads/features/on_this_day/domain/on_this_day.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

MemoryEvent memory(String id, DateTime occurredAt) => MemoryEvent(
  id: id,
  title: 'Memory $id',
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: occurredAt,
  createdAt: occurredAt,
  coverColor: Colors.amber,
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: '',
);

List<String> ids(List<OnThisDayMatch> matches) => [
  for (final match in matches) match.memory.id,
];

void main() {
  setUpAll(tz_data.initializeTimeZones);

  group('matchesOn', () {
    test('finds memories from the same month and day in earlier years', () {
      final matches = OnThisDay.matchesOn(DateTime(2026, 10, 12), [
        memory('three-years', DateTime(2023, 10, 12, 18, 30)),
        memory('other-day', DateTime(2023, 10, 13)),
        memory('other-month', DateTime(2023, 9, 12)),
        memory('one-year', DateTime(2025, 10, 12)),
      ]);

      expect(ids(matches), ['three-years', 'one-year']);
      expect([for (final m in matches) m.yearsAgo], [3, 1]);
    });

    test('leaves out memories from this year and the future', () {
      final matches = OnThisDay.matchesOn(DateTime(2026, 10, 12), [
        memory('today', DateTime(2026, 10, 12, 8)),
        memory('future', DateTime(2027, 10, 12)),
      ]);

      expect(matches, isEmpty);
    });

    test('leaves out the demo wall', () {
      final demoId = MemorySeedData.eventIds.first;
      final demo = memory(demoId, DateTime(2024, 3, 5));

      expect(OnThisDay.matchesOn(DateTime(2026, 3, 5), [demo]), isEmpty);
    });

    test('a Feb 29 memory comes back on Feb 28 in non-leap years', () {
      final leapDay = memory('leap', DateTime(2024, 2, 29));

      expect(ids(OnThisDay.matchesOn(DateTime(2025, 2, 28), [leapDay])), [
        'leap',
      ]);
      expect(OnThisDay.matchesOn(DateTime(2025, 3, 1), [leapDay]), isEmpty);
      // In a leap year it waits for Feb 29 itself.
      expect(OnThisDay.matchesOn(DateTime(2028, 2, 28), [leapDay]), isEmpty);
      expect(ids(OnThisDay.matchesOn(DateTime(2028, 2, 29), [leapDay])), [
        'leap',
      ]);
      // 2100 is not a leap year.
      expect(ids(OnThisDay.matchesOn(DateTime(2100, 2, 28), [leapDay])), [
        'leap',
      ]);
    });

    test('same-day memories: most years ago first, then time of day', () {
      final matches = OnThisDay.matchesOn(DateTime(2026, 5, 1), [
        memory('b-evening', DateTime(2020, 5, 1, 20)),
        memory('recent', DateTime(2025, 5, 1, 7)),
        memory('a-morning', DateTime(2020, 5, 1, 9)),
        memory('c-morning', DateTime(2020, 5, 1, 9)),
      ]);

      expect(ids(matches), ['a-morning', 'c-morning', 'b-evening', 'recent']);
    });

    test('matches on the local calendar day of a UTC timestamp', () {
      final utc = DateTime.utc(2022, 7, 3, 23, 30);
      final local = utc.toLocal();
      final matches = OnThisDay.matchesOn(
        DateTime(2026, local.month, local.day),
        [memory('utc', utc)],
      );

      expect(ids(matches), ['utc']);
    });
  });

  group('upcoming', () {
    tz.Location berlin() => tz.getLocation('Europe/Berlin');

    test('one reminder per matching day for the next 30 days', () {
      final now = tz.TZDateTime(berlin(), 2026, 10, 12, 8);
      final reminders = OnThisDay.upcoming(
        now: now,
        events: [
          memory('today-a', DateTime(2020, 10, 12)),
          memory('today-b', DateTime(2024, 10, 12)),
          memory('in-ten-days', DateTime(2023, 10, 22)),
          memory('day-30', DateTime(2023, 11, 10)),
          memory('day-31', DateTime(2023, 11, 11)),
        ],
      );

      expect([for (final r in reminders) r.at.day], [12, 22, 10]);
      expect(ids(reminders.first.matches), ['today-a', 'today-b']);
    });

    test('starts tomorrow when today\'s time has passed', () {
      final now = tz.TZDateTime(berlin(), 2026, 10, 12, 9, 30);
      final reminders = OnThisDay.upcoming(
        now: now,
        events: [
          memory('today', DateTime(2020, 10, 12)),
          memory('tomorrow', DateTime(2020, 10, 13)),
          memory('day-30', DateTime(2020, 11, 11)),
        ],
      );

      expect([for (final r in reminders) r.at.day], [13, 11]);
    });

    test('keeps the chosen local time across a DST change', () {
      final now = tz.TZDateTime(berlin(), 2026, 10, 20, 6);
      final reminders = OnThisDay.upcoming(
        now: now,
        minuteOfDay: 7 * 60 + 45,
        events: [
          memory('summer-time', DateTime(2021, 10, 24)),
          memory('winter-time', DateTime(2021, 10, 26)),
        ],
      );

      expect(reminders, hasLength(2));
      for (final reminder in reminders) {
        expect((reminder.at.hour, reminder.at.minute), (7, 45));
      }
      expect(reminders[0].at.timeZoneOffset, const Duration(hours: 2));
      expect(reminders[1].at.timeZoneOffset, const Duration(hours: 1));
    });

    test('uses the calendar day of the reminder\'s own time zone', () {
      final tokyo = tz.getLocation('Asia/Tokyo');
      // 23:00 UTC on Oct 11 is already Oct 12 in Tokyo.
      final now = tz.TZDateTime.from(DateTime.utc(2026, 10, 11, 23), tokyo);
      final reminders = OnThisDay.upcoming(
        now: now,
        events: [memory('tokyo-day', DateTime(2020, 10, 12))],
      );

      expect(reminders.first.at.day, 12);
      expect(reminders.first.at.isAfter(now), isTrue);
    });
  });

  test('notifications: one per day naming the first memory', () {
    final berlin = tz.getLocation('Europe/Berlin');
    final now = tz.TZDateTime(berlin, 2026, 10, 12, 8);
    final reminders = OnThisDay.upcoming(
      now: now,
      events: [
        memory('single', DateTime(2023, 10, 14)),
        memory('first', DateTime(2020, 10, 15)),
        memory('second', DateTime(2022, 10, 15)),
        memory('third', DateTime(2024, 10, 15)),
      ],
    );
    final l10n = lookupAppLocalizations(const Locale('en'));

    final notifications = onThisDayNotificationsFor(reminders, l10n);

    expect(notifications, hasLength(2));
    expect(notifications[0].body, '3 years ago today: Memory single');
    expect(notifications[0].memoryId, 'single');
    expect(
      notifications[1].body,
      'Memory first and 2 more memories from this day',
    );
    expect(notifications[1].memoryId, 'first');
    expect(notifications[0].title, 'On this day');
    expect(
      [for (final n in notifications) n.id],
      [
        LocalOnThisDayNotifications.firstId,
        LocalOnThisDayNotifications.firstId + 1,
      ],
    );
  });

  test('notification payloads round-trip the memory id', () {
    final payload = LocalOnThisDayNotifications.payloadFor('abc-123');

    expect(LocalOnThisDayNotifications.memoryIdFromPayload(payload), 'abc-123');
    expect(LocalOnThisDayNotifications.memoryIdFromPayload('other'), isNull);
    expect(LocalOnThisDayNotifications.memoryIdFromPayload(null), isNull);
  });
}
