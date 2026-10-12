import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../memories/data/memory_seed_data.dart';
import '../../memories/domain/memory_event.dart';

final backupReminderProvider =
    AsyncNotifierProvider<BackupReminderController, BackupReminderState>(
      BackupReminderController.new,
    );

class BackupReminderState {
  const BackupReminderState({this.lastSavedAt, this.snoozedUntil});

  /// The last time a backup file reached the share sheet's target.
  final DateTime? lastSavedAt;
  final DateTime? snoozedUntil;

  /// The backup is the only full copy that leaves the phone, so remind once
  /// a handful of memories exist that no backup holds yet.
  static const unsavedThreshold = 5;

  int unsavedMemories(List<MemoryEvent> events) {
    final saved = lastSavedAt;
    return events
        .where((event) => !MemorySeedData.isDemoEventId(event.id))
        .where((event) => saved == null || event.createdAt.isAfter(saved))
        .length;
  }

  bool shouldRemind(List<MemoryEvent> events, {DateTime? now}) {
    final until = snoozedUntil;
    if (until != null && (now ?? DateTime.now()).isBefore(until)) return false;
    return unsavedMemories(events) >= unsavedThreshold;
  }
}

class BackupReminderController extends AsyncNotifier<BackupReminderState> {
  static const _lastSavedKey = 'backup_last_saved_at';
  static const _snoozedUntilKey = 'backup_reminder_snoozed_until';
  static const snoozeDuration = Duration(days: 14);

  @override
  Future<BackupReminderState> build() async {
    final preferences = await SharedPreferences.getInstance();
    return BackupReminderState(
      lastSavedAt: _date(preferences.getInt(_lastSavedKey)),
      snoozedUntil: _date(preferences.getInt(_snoozedUntilKey)),
    );
  }

  Future<void> markSaved() async {
    final preferences = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await preferences.setInt(_lastSavedKey, now.millisecondsSinceEpoch);
    await preferences.remove(_snoozedUntilKey);
    state = AsyncData(BackupReminderState(lastSavedAt: now));
  }

  Future<void> snooze() async {
    final preferences = await SharedPreferences.getInstance();
    final until = DateTime.now().add(snoozeDuration);
    await preferences.setInt(_snoozedUntilKey, until.millisecondsSinceEpoch);
    state = AsyncData(
      BackupReminderState(
        lastSavedAt: state.asData?.value.lastSavedAt,
        snoozedUntil: until,
      ),
    );
  }

  static DateTime? _date(int? millis) =>
      millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
}
