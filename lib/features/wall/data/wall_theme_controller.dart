import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../premium/data/premium_entitlement_controller.dart';
import '../domain/wall_theme.dart';

final wallThemeProvider =
    AsyncNotifierProvider<WallThemeController, WallThemePreset>(
      WallThemeController.new,
    );

/// Whether the wall follows the time of day instead of one chosen theme.
final wallThemeAutoProvider =
    AsyncNotifierProvider<WallThemeAutoController, bool>(
      WallThemeAutoController.new,
    );

/// The current time, refreshed every minute, for Auto and seasonal themes.
final wallClockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

/// The theme the app actually shows. Premium themes, seasonal themes and
/// Auto need Premium; a seasonal theme also ends with its season. Anything
/// not allowed right now falls back to Warm Memory Room.
final effectiveWallThemeProvider = Provider<WallThemePreset>((ref) {
  final isPremium =
      ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false;
  if (!isPremium) return WallThemePreset.warmMemoryRoom;

  final now = ref.watch(wallClockProvider).asData?.value ?? DateTime.now();
  if (ref.watch(wallThemeAutoProvider).asData?.value ?? false) {
    return WallThemePreset.autoAt(now);
  }
  final selected =
      ref.watch(wallThemeProvider).asData?.value ??
      WallThemePreset.warmMemoryRoom;
  return selected.isAvailableAt(now)
      ? selected
      : WallThemePreset.warmMemoryRoom;
});

class WallThemeController extends AsyncNotifier<WallThemePreset> {
  static const _selectedThemeKey = 'selected_wall_theme';

  @override
  Future<WallThemePreset> build() async {
    final preferences = await SharedPreferences.getInstance();
    final id = WallThemeId.fromName(
      preferences.getString(_selectedThemeKey) ?? '',
    );
    return WallThemePreset.fromId(id);
  }

  /// Chooses one fixed theme, which also turns Auto off.
  Future<void> selectTheme(WallThemePreset theme) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_selectedThemeKey, theme.id.name);
    state = AsyncData(theme);
    await ref.read(wallThemeAutoProvider.notifier).setEnabled(false);
  }
}

class WallThemeAutoController extends AsyncNotifier<bool> {
  static const _autoKey = 'wall_theme_auto';

  @override
  Future<bool> build() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_autoKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_autoKey, enabled);
    state = AsyncData(enabled);
  }
}
