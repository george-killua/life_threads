import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/data/backup_reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regression/backup_support.dart';

void main() {
  final events = [
    for (var i = 0; i < 6; i++)
      event(id: 'm$i').copyWith(createdAt: DateTime(2025, 1, 1 + i)),
  ];

  test('reminds once five memories are in no backup', () {
    expect(const BackupReminderState().shouldRemind(events), isTrue);
    expect(
      const BackupReminderState().shouldRemind(events.take(4).toList()),
      isFalse,
    );
  });

  test('only memories created after the last backup count', () {
    final state = BackupReminderState(lastSavedAt: DateTime(2025, 1, 3, 12));
    expect(state.unsavedMemories(events), 3);
    expect(state.shouldRemind(events), isFalse);
  });

  test('a snooze hides the reminder until it runs out', () {
    final state = BackupReminderState(snoozedUntil: DateTime(2025, 2, 1));
    expect(state.shouldRemind(events, now: DateTime(2025, 1, 20)), isFalse);
    expect(state.shouldRemind(events, now: DateTime(2025, 2, 2)), isTrue);
  });

  test('saving a backup clears the snooze and is remembered', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final reminder = container.read(backupReminderProvider.notifier);
    await container.read(backupReminderProvider.future);

    await reminder.snooze();
    await reminder.markSaved();

    final state = container.read(backupReminderProvider).value!;
    expect(state.snoozedUntil, isNull);
    expect(state.lastSavedAt, isNotNull);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('backup_last_saved_at'), isNotNull);
  });
}
