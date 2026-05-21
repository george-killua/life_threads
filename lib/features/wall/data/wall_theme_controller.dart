import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/wall_theme.dart';

final wallThemeProvider =
    AsyncNotifierProvider<WallThemeController, WallThemePreset>(
      WallThemeController.new,
    );

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
