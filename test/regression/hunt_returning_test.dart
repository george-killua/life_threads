// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// notifications and search.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_scheduler.dart';
import 'package:life_threads/features/search/memory_search.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../support/on_this_day_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    tz_data.initializeTimeZones();
    await initializeDateFormatting('en');
  });

  // N1-01: the scheduler re-runs on every app start/resume and replaces all
  // pending notifications. On the 1st of a month, before the reminder time,
  // the look-back for the month that just ended must still be scheduled.
  test(
    'N1-01 look-back for October survives opening the app on Nov 1 08:00',
    () {
      final berlin = tz.getLocation('Europe/Berlin');
      final now = tz.TZDateTime(berlin, 2026, 11, 1, 8);
      final events = [
        memory('oct-a', DateTime(2026, 10, 3)),
        memory('oct-b', DateTime(2026, 10, 20)),
      ];
      final l10n = lookupAppLocalizations(const Locale('en'));
      final n = lookBackNotificationFor(now, events, 9 * 60, l10n);
      expect(
        n,
        isNotNull,
        reason: 'October look-back due today 09:00 was dropped',
      );
      expect(n!.lookBack, (year: 2026, month: 10));
      expect((n.at.month, n.at.day, n.at.hour), (11, 1, 9));
    },
  );

  // N1-02: the device time zone is cached for the life of the process, so a
  // traveller who resumes the app in a new zone keeps getting reminders at
  // 09:00 of the old zone.
  test('N1-02 localLocation follows a device time-zone change', () async {
    var zone = 'Europe/Berlin';
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_timezone'),
          (call) async => zone,
        );
    final notifications = LocalOnThisDayNotifications(
      onOpenMemory: (_) {},
      onOpenLookBack: (_, _) {},
    );
    expect((await notifications.localLocation()).name, 'Europe/Berlin');
    zone = 'America/New_York'; // user flew; app resumed from background
    expect((await notifications.localLocation()).name, 'America/New_York');
  });

  // N1-03: Arabic is a shipped locale; users routinely type alef without
  // hamza. "احمد" should find a memory with "أحمد".
  test('N1-03 Arabic search folds hamza-alef variants', () {
    final state = stateWith([
      memory('a', DateTime(2025, 5, 1)).copyWith(title: 'عيد ميلاد أحمد'),
    ]);
    expect(searchMemories(state, 'احمد').map((e) => e.id), ['a']);
  });
}
