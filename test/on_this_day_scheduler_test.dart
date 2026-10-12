import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_scheduler.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_settings.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

import 'support/on_this_day_fakes.dart';

late FakeOnThisDayNotifications notifications;
late FakeMemoryRepository repository;

ProviderContainer startScheduler({
  required bool enabled,
  bool isPremium = true,
}) {
  SharedPreferences.setMockInitialValues({
    'on_this_day_reminders_enabled': enabled,
  });
  notifications = FakeOnThisDayNotifications();
  repository = FakeMemoryRepository([
    memory('today', DateTime(2020, 10, 12, 18)),
    memory('in-a-week', DateTime(2023, 10, 19)),
    memory('this-year', DateTime(2026, 10, 13)),
  ]);
  final container = ProviderContainer(
    overrides: [
      memoryRepositoryProvider.overrideWith(() => repository),
      premiumEntitlementProvider.overrideWith(
        () => FakePremium(isPremium: isPremium),
      ),
      onThisDayNotificationsProvider.overrideWithValue(notifications),
      onThisDayClockProvider.overrideWithValue(
        () => DateTime(2026, 10, 12, 7, 30),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(onThisDaySchedulerProvider, (_, _) {});
  return container;
}

/// Lets the async providers load and the scheduler's queued jobs run.
Future<void> settle(ProviderContainer container) async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
    container.read(onThisDaySchedulerProvider);
    await container.read(onThisDaySchedulerProvider.notifier).idle();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(tz_data.initializeTimeZones);

  test('schedules the next days with a match when turned on', () async {
    final container = startScheduler(enabled: true);
    await settle(container);

    expect(notifications.scheduled, hasLength(1));
    final scheduled = notifications.scheduled.single;
    expect([for (final n in scheduled) n.memoryId], ['today', 'in-a-week']);
    expect(
      [for (final n in scheduled) (n.at.day, n.at.hour)],
      [(12, 9), (19, 9)],
    );
    expect(notifications.cancelCount, 0);
  });

  test('does nothing for users who never turned reminders on', () async {
    final container = startScheduler(enabled: false);
    await settle(container);

    expect(notifications.scheduled, isEmpty);
    expect(notifications.cancelCount, 0);
  });

  test('cancels when Premium is not active', () async {
    final container = startScheduler(enabled: true, isPremium: false);
    await settle(container);

    expect(notifications.scheduled, isEmpty);
    expect(notifications.cancelCount, 1);
  });

  test('cancels everything when turned off', () async {
    final container = startScheduler(enabled: true);
    await settle(container);

    await container
        .read(onThisDaySettingsProvider.notifier)
        .setRemindersEnabled(false);
    await settle(container);

    expect(notifications.scheduled, hasLength(1));
    expect(notifications.cancelCount, 1);
  });

  test('reschedules when memories or the time change', () async {
    final container = startScheduler(enabled: true);
    await settle(container);

    repository.replaceEvents([memory('new', DateTime(2019, 10, 15))]);
    await settle(container);
    expect([for (final n in notifications.scheduled.last) n.memoryId], ['new']);

    await container
        .read(onThisDaySettingsProvider.notifier)
        .setTime(const TimeOfDay(hour: 20, minute: 15));
    await settle(container);
    final last = notifications.scheduled.last.single;
    expect((last.at.day, last.at.hour, last.at.minute), (15, 20, 15));
    expect(notifications.scheduled, hasLength(3));
  });
}
