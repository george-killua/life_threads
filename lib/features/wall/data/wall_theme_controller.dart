import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../premium/data/premium_entitlement_controller.dart';
import '../domain/wall_theme.dart';

final wallThemeProvider =
    AsyncNotifierProvider<WallThemeController, WallThemePreset>(
      WallThemeController.new,
    );

/// The theme the app actually shows: the saved choice, or Warm Memory Room
/// while that choice is a Premium theme and Premium is not active.
final effectiveWallThemeProvider = Provider<WallThemePreset>((ref) {
  final selected =
      ref.watch(wallThemeProvider).asData?.value ??
      WallThemePreset.warmMemoryRoom;
  final isPremium =
      ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false;
  return selected.isPremium && !isPremium
      ? WallThemePreset.warmMemoryRoom
      : selected;
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

  Future<void> selectTheme(WallThemePreset theme) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_selectedThemeKey, theme.id.name);
    state = AsyncData(theme);
  }
}
