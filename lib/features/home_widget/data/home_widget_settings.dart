import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../memories/domain/memory_event.dart';

final homeWidgetSettingsProvider =
    AsyncNotifierProvider<HomeWidgetSettingsController, HomeWidgetSettings>(
      HomeWidgetSettingsController.new,
    );

/// Which memories the home screen widget shows (Settings › Home screen
/// widget).
class HomeWidgetSettings {
  const HomeWidgetSettings({
    this.source = allWalls,
    this.onThisDayFirst = true,
    this.photosFirst = true,
  });

  /// Every wall of one's own.
  static const allWalls = 'all';

  /// "My wall" only.
  static const myWall = 'my';

  /// [allWalls], [myWall], or the id of a named wall.
  final String source;

  /// A memory from this day in an earlier year comes first.
  final bool onThisDayFirst;

  /// Memories with a photo first; others only when none has one.
  final bool photosFirst;

  /// The memories of [source]; every wall when that wall no longer exists
  /// ([wallIds] are the named walls).
  List<MemoryEvent> filter(List<MemoryEvent> events, Set<String> wallIds) {
    return switch (source) {
      allWalls => events,
      myWall => [
        for (final event in events)
          if (event.wallId == null) event,
      ],
      final wallId when wallIds.contains(wallId) => [
        for (final event in events)
          if (event.wallId == wallId) event,
      ],
      _ => events,
    };
  }

  HomeWidgetSettings copyWith({
    String? source,
    bool? onThisDayFirst,
    bool? photosFirst,
  }) => HomeWidgetSettings(
    source: source ?? this.source,
    onThisDayFirst: onThisDayFirst ?? this.onThisDayFirst,
    photosFirst: photosFirst ?? this.photosFirst,
  );
}

class HomeWidgetSettingsController extends AsyncNotifier<HomeWidgetSettings> {
  static const _sourceKey = 'home_widget_source';
  static const _onThisDayKey = 'home_widget_on_this_day_first';
  static const _photosKey = 'home_widget_photos_first';

  @override
  Future<HomeWidgetSettings> build() async {
    final preferences = await SharedPreferences.getInstance();
    return HomeWidgetSettings(
      source: preferences.getString(_sourceKey) ?? HomeWidgetSettings.allWalls,
      onThisDayFirst: preferences.getBool(_onThisDayKey) ?? true,
      photosFirst: preferences.getBool(_photosKey) ?? true,
    );
  }

  Future<void> setSource(String source) async {
    await (await SharedPreferences.getInstance()).setString(_sourceKey, source);
    state = AsyncData(_current.copyWith(source: source));
  }

  Future<void> setOnThisDayFirst(bool value) async {
    await (await SharedPreferences.getInstance()).setBool(_onThisDayKey, value);
    state = AsyncData(_current.copyWith(onThisDayFirst: value));
  }

  Future<void> setPhotosFirst(bool value) async {
    await (await SharedPreferences.getInstance()).setBool(_photosKey, value);
    state = AsyncData(_current.copyWith(photosFirst: value));
  }

  HomeWidgetSettings get _current =>
      state.asData?.value ?? const HomeWidgetSettings();
}
