import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../app_lock/app_lock.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/logging/app_logger.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_event.dart';
import '../../premium/data/premium_entitlement_controller.dart';
import '../domain/on_this_day.dart';
import 'on_this_day_notifications.dart';
import 'on_this_day_providers.dart';
import 'on_this_day_settings.dart';

final onThisDaySchedulerProvider = NotifierProvider<OnThisDayScheduler, void>(
  OnThisDayScheduler.new,
);

/// The notifications for [reminders]: one per day, opening the first
/// memory and naming how many more there are.
///
/// With [private] (the app lock is on) the text names no memory, so nothing
/// personal shows on the lock screen.
List<OnThisDayNotification> onThisDayNotificationsFor(
  List<OnThisDayReminder> reminders,
  AppLocalizations l10n, {
  bool private = false,
}) {
  return [
    for (final (index, reminder) in reminders.indexed)
      OnThisDayNotification(
        id: LocalOnThisDayNotifications.firstId + index,
        at: reminder.at,
        title: l10n.onThisDayTitle,
        body: private
            ? l10n.onThisDayNotificationPrivate(reminder.matches.first.yearsAgo)
            : reminder.matches.length == 1
            ? l10n.onThisDayNotificationBody(
                reminder.matches.first.yearsAgo,
                reminder.matches.first.memory.title,
              )
            : l10n.onThisDayNotificationBodyMany(
                reminder.matches.length - 1,
                reminder.matches.first.memory.title,
              ),
        memoryId: reminder.matches.first.memory.id,
      ),
  ];
}

/// Keeps the On this day notifications in step with the settings, Premium
/// and the memories: the next 30 days are scheduled on app start, whenever
/// one of them changes and when the app comes back to the foreground.
/// Kept alive for the whole session by `LifeThreadsApp`.
class OnThisDayScheduler extends Notifier<void> {
  var _generation = 0;
  var _mayHaveScheduled = false;
  Future<void> _queue = Future.value();

  @override
  void build() {
    final lifecycle = AppLifecycleListener(onResume: _onResume);
    ref.onDispose(lifecycle.dispose);

    final settings = ref.watch(onThisDaySettingsProvider).asData?.value;
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;
    if (settings == null || entitlement == null) return;
    final notifications = ref.read(onThisDayNotificationsProvider);
    final generation = ++_generation;

    if (!settings.remindersEnabled || !entitlement.isPremium) {
      // Turned off, or Premium ended (possibly in an earlier session).
      // Users who never turned reminders on never touch the plugin.
      if (settings.remindersEnabled || _mayHaveScheduled) {
        _mayHaveScheduled = false;
        _enqueue(generation, notifications.cancelAll);
      }
      return;
    }

    final events = ref.watch(memoryRepositoryProvider).asData?.value.events;
    final selectedLocale = ref.watch(localeControllerProvider);
    final lock = ref.watch(appLockProvider);
    // Wait for all three, so start-up schedules once.
    if (events == null || selectedLocale.isLoading || !lock.ready) return;
    final l10n = _localizations(selectedLocale.value);
    final now = ref.read(onThisDayClockProvider)();
    _mayHaveScheduled = true;
    _enqueue(
      generation,
      () => _schedule(
        notifications,
        events,
        settings.minuteOfDay,
        now,
        l10n,
        private: lock.enabled,
      ),
    );
  }

  Future<void> _schedule(
    OnThisDayNotifications notifications,
    List<MemoryEvent> events,
    int minuteOfDay,
    DateTime now,
    AppLocalizations l10n, {
    required bool private,
  }) async {
    final location = await notifications.localLocation();
    final reminders = OnThisDay.upcoming(
      now: tz.TZDateTime.from(now, location),
      events: events,
      minuteOfDay: minuteOfDay,
    );
    await notifications.replaceScheduled(
      onThisDayNotificationsFor(reminders, l10n, private: private),
      channelName: l10n.onThisDayTitle,
      channelDescription: l10n.onThisDayChannelDescription,
    );
  }

  /// Runs plugin work one job at a time; a job is skipped when a newer
  /// build has replaced it.
  void _enqueue(int generation, Future<void> Function() job) {
    _queue = _queue.then((_) async {
      if (generation != _generation) return;
      try {
        await job();
      } catch (error, stackTrace) {
        AppLogger.recordCrash(error, stackTrace);
      }
    });
  }

  void _onResume() {
    ref.invalidate(onThisDayTodayProvider);
    ref.invalidateSelf();
  }

  AppLocalizations _localizations(Locale? selected) {
    final locale =
        selected ?? WidgetsBinding.instance.platformDispatcher.locale;
    final supported = AppLocalizations.supportedLocales.any(
      (candidate) => candidate.languageCode == locale.languageCode,
    );
    return lookupAppLocalizations(
      supported ? Locale(locale.languageCode) : const Locale('en'),
    );
  }

  /// Completes when the jobs queued so far have run; for tests.
  @visibleForTesting
  Future<void> idle() => _queue;
}
