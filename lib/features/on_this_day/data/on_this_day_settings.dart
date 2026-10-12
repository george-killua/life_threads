import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/on_this_day.dart';

final onThisDaySettingsProvider =
    AsyncNotifierProvider<OnThisDaySettingsController, OnThisDaySettings>(
      OnThisDaySettingsController.new,
    );

class OnThisDaySettings {
  const OnThisDaySettings({
    this.remindersEnabled = false,
    this.minuteOfDay = OnThisDay.defaultMinuteOfDay,
  });

  /// The user's choice; reminders only go out while Premium is active too.
  final bool remindersEnabled;
  final int minuteOfDay;

  TimeOfDay get time =>
      TimeOfDay(hour: minuteOfDay ~/ 60, minute: minuteOfDay % 60);
}

class OnThisDaySettingsController extends AsyncNotifier<OnThisDaySettings> {
  static const _enabledKey = 'on_this_day_reminders_enabled';
  static const _minuteKey = 'on_this_day_reminder_minute';

  @override
  Future<OnThisDaySettings> build() async {
    final preferences = await SharedPreferences.getInstance();
    return OnThisDaySettings(
      remindersEnabled: preferences.getBool(_enabledKey) ?? false,
      minuteOfDay:
          preferences.getInt(_minuteKey) ?? OnThisDay.defaultMinuteOfDay,
    );
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_enabledKey, enabled);
    state = AsyncData(
      OnThisDaySettings(
        remindersEnabled: enabled,
        minuteOfDay: _current.minuteOfDay,
      ),
    );
  }

  Future<void> setTime(TimeOfDay time) async {
    final minuteOfDay = time.hour * 60 + time.minute;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_minuteKey, minuteOfDay);
    state = AsyncData(
      OnThisDaySettings(
        remindersEnabled: _current.remindersEnabled,
        minuteOfDay: minuteOfDay,
      ),
    );
  }

  OnThisDaySettings get _current =>
      state.asData?.value ?? const OnThisDaySettings();
}
