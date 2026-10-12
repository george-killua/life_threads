import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../app/router/app_router.dart';
import '../../../core/logging/app_logger.dart';

final onThisDayNotificationsProvider = Provider<OnThisDayNotifications>(
  (ref) => LocalOnThisDayNotifications(
    onOpenMemory: (memoryId) => AppRouter.router.push('/memories/$memoryId'),
  ),
);

/// A scheduled "On this day" notification.
class OnThisDayNotification {
  const OnThisDayNotification({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
    required this.memoryId,
  });

  final int id;
  final tz.TZDateTime at;
  final String title;
  final String body;

  /// The memory a tap opens.
  final String memoryId;
}

/// The device side of On this day reminders, behind an interface so the
/// scheduling can be tested without the plugin.
abstract interface class OnThisDayNotifications {
  /// The device's time zone.
  Future<tz.Location> localLocation();

  /// Asks for permission to notify; true when notifications may be shown.
  Future<bool> requestPermission();

  /// Replaces every scheduled On this day notification with [notifications].
  Future<void> replaceScheduled(
    List<OnThisDayNotification> notifications, {
    required String channelName,
    required String channelDescription,
  });

  /// Cancels every scheduled On this day notification.
  Future<void> cancelAll();
}

class LocalOnThisDayNotifications implements OnThisDayNotifications {
  LocalOnThisDayNotifications({required this.onOpenMemory});

  /// Notification ids are [firstId] + day index; nothing else in the app
  /// uses this range.
  static const firstId = 52000;
  static const _lastId = firstId + 63;
  static const _channelId = 'on_this_day';
  static const _payloadPrefix = 'on-this-day:';

  final ValueChanged<String> onOpenMemory;
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;
  tz.Location? _location;

  static String payloadFor(String memoryId) => '$_payloadPrefix$memoryId';

  static String? memoryIdFromPayload(String? payload) {
    if (payload == null || !payload.startsWith(_payloadPrefix)) return null;
    final id = payload.substring(_payloadPrefix.length);
    return id.isEmpty ? null : id;
  }

  @override
  Future<tz.Location> localLocation() async {
    final known = _location;
    if (known != null) return known;
    tz_data.initializeTimeZones();
    tz.Location location;
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      location = tz.getLocation(info.identifier);
    } catch (_) {
      AppLogger.event('on_this_day_timezone_fallback');
      location = _locationWithCurrentOffset();
    }
    tz.setLocalLocation(location);
    return _location = location;
  }

  @override
  Future<bool> requestPermission() async {
    await _ensureReady();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  @override
  Future<void> replaceScheduled(
    List<OnThisDayNotification> notifications, {
    required String channelName,
    required String channelDescription,
  }) async {
    await _ensureReady();
    await cancelAll();
    for (final notification in notifications) {
      await _plugin.zonedSchedule(
        id: notification.id,
        scheduledDate: notification.at,
        title: notification.title,
        body: notification.body,
        payload: payloadFor(notification.memoryId),
        // Inexact is fine for a daily nudge and needs no alarm permission.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            channelName,
            channelDescription: channelDescription,
            styleInformation: BigTextStyleInformation(notification.body),
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _ensureReady();
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id < firstId || request.id > _lastId) continue;
      await _plugin.cancel(id: request.id);
    }
  }

  Future<void> _ensureReady() => _ready ??= _initialize();

  Future<void> _initialize() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_on_this_day'),
        // Permission is asked only when the user turns reminders on.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) => _open(response.payload),
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _open(launch!.notificationResponse?.payload);
    }
  }

  void _open(String? payload) {
    final memoryId = memoryIdFromPayload(payload);
    if (memoryId == null) return;
    AppLogger.event('on_this_day_opened');
    onOpenMemory(memoryId);
  }

  /// Without the device's zone name, any zone at today's UTC offset still
  /// puts the reminder at the right hour until the next DST change (the
  /// schedule is rebuilt on every app start).
  static tz.Location _locationWithCurrentOffset() {
    final offset = DateTime.now().timeZoneOffset;
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final location in tz.timeZoneDatabase.locations.values) {
      if (location.timeZone(now).offset == offset) return location;
    }
    return tz.UTC;
  }
}
