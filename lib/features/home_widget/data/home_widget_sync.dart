import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../../../core/localization/locale_controller.dart';
import '../../../core/logging/app_logger.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../app_lock/app_lock.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_event.dart';
import '../../on_this_day/data/on_this_day_providers.dart';
import '../domain/home_widget_days.dart';

final homeWidgetBridgeProvider = Provider<HomeWidgetBridge>(
  (ref) => const MethodChannelHomeWidgetBridge(),
);

final homeWidgetSyncProvider = NotifierProvider<HomeWidgetSync, void>(
  HomeWidgetSync.new,
);

/// The phone's side of the home screen widget.
abstract interface class HomeWidgetBridge {
  /// The folder the widget can read (the App Group on iOS); null when there
  /// is no widget on this platform.
  Future<String?> containerPath();

  /// Hands the widget its [payload] (JSON) and asks it to redraw.
  Future<void> update(String payload);
}

class MethodChannelHomeWidgetBridge implements HomeWidgetBridge {
  const MethodChannelHomeWidgetBridge();

  static const _channel = MethodChannel('dev.gkcoding.lifethreads/home_widget');

  @override
  Future<String?> containerPath() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      return null;
    }
    try {
      return await _channel.invokeMethod<String>('containerPath');
    } on MissingPluginException {
      return null;
    }
  }

  @override
  Future<void> update(String payload) =>
      _channel.invokeMethod<void>('update', {'payload': payload});
}

/// Keeps the home screen widget in step with the memories: a week of days
/// with their memory and a small copy of its photo. Nothing personal while
/// the app lock is on. Kept alive for the whole session by `LifeThreadsApp`.
class HomeWidgetSync extends Notifier<void> {
  static const imagesFolder = 'images';

  var _generation = 0;
  Future<void> _queue = Future.value();

  @override
  void build() {
    final events = ref
        .watch(memoryRepositoryProvider)
        .asData
        ?.value
        .visibleEvents;
    final lock = ref.watch(appLockProvider);
    final selectedLocale = ref.watch(localeControllerProvider);
    // Refreshed when the app comes back to the foreground.
    final today = ref.watch(onThisDayTodayProvider);
    if (events == null || !lock.ready || selectedLocale.isLoading) return;

    final l10n = _localizations(selectedLocale.value);
    final bridge = ref.read(homeWidgetBridgeProvider);
    final generation = ++_generation;
    _queue = _queue.then((_) async {
      if (generation != _generation) return;
      try {
        await _sync(bridge, events, today, l10n, locked: lock.enabled);
      } catch (error, stackTrace) {
        AppLogger.recordCrash(error, stackTrace);
      }
    });
  }

  Future<void> _sync(
    HomeWidgetBridge bridge,
    List<MemoryEvent> events,
    DateTime today,
    AppLocalizations l10n, {
    required bool locked,
  }) async {
    final container = await bridge.containerPath();
    if (container == null) return;
    final images = Directory(p.join(container, imagesFolder));
    await images.create(recursive: true);

    final days = locked
        ? [
            HomeWidgetDay(
              date: null,
              title: l10n.appLockLockedTitle,
              subtitle: l10n.homeWidgetLocked,
            ),
          ]
        : homeWidgetDays(today, events, l10n);

    final imageNames = <String, String>{};
    for (final day in days) {
      final memory = day.memory;
      if (memory == null || imageNames.containsKey(memory.id)) continue;
      final name = await _thumbnailFor(memory, images);
      if (name != null) imageNames[memory.id] = name;
    }
    // Photos of memories no longer shown (or of a locked app) go.
    await for (final file in images.list()) {
      if (file is File && !imageNames.containsValue(p.basename(file.path))) {
        await file.delete();
      }
    }

    await bridge.update(
      jsonEncode({
        'days': [
          for (final day in days)
            {
              'date': day.date == null ? null : _dateKey(day.date!),
              'title': day.title,
              'subtitle': day.subtitle,
              'memoryId': day.memory?.id,
              'image': switch (imageNames[day.memory?.id]) {
                final name? => '$imagesFolder/$name',
                null => null,
              },
            },
        ],
      }),
    );
  }

  /// A small JPEG of [memory]'s cover photo in [folder], made once per photo;
  /// its file name, or null without a photo.
  Future<String?> _thumbnailFor(MemoryEvent memory, Directory folder) async {
    final source = memory.coverPhotoPath;
    if (source == null || source.isEmpty) return null;
    final safeId = memory.id.replaceAll(RegExp('[^A-Za-z0-9_-]'), '_');
    final name = '$safeId-${source.hashCode.toUnsigned(32)}.jpg';
    final target = File(p.join(folder.path, name));
    if (await target.exists()) return name;

    final Uint8List bytes;
    if (source.startsWith('assets/')) {
      bytes = (await rootBundle.load(source)).buffer.asUint8List();
    } else {
      final file = File(source);
      if (!await file.exists()) return null;
      bytes = await file.readAsBytes();
    }
    final jpeg = await Isolate.run(() => homeWidgetThumbnail(bytes));
    if (jpeg == null) return null;
    await target.writeAsBytes(jpeg, flush: true);
    return name;
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

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

/// The photo turned upright and scaled so its longer side is at most
/// [maxSide] pixels, as JPEG; null when it can't be read. Large enough for
/// the biggest widget, small enough for the widget's memory limit.
Uint8List? homeWidgetThumbnail(Uint8List bytes, {int maxSide = 720}) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  final upright = img.bakeOrientation(decoded);
  final scaled = upright.width >= upright.height
      ? (upright.width > maxSide
            ? img.copyResize(upright, width: maxSide)
            : upright)
      : (upright.height > maxSide
            ? img.copyResize(upright, height: maxSide)
            : upright);
  return img.encodeJpg(scaled, quality: 82);
}
