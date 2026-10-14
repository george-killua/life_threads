import 'package:flutter/material.dart';

import '../../features/wall/domain/wall_theme.dart';

/// App colours. The wall, panel and accent colours follow the wall theme in
/// use (see [AppColors.use]); the rest are fixed.
class AppColors {
  const AppColors._();

  static ThemePalette _palette = ThemePalette.warm;

  /// Switches the theme-following colours to [palette]. The app calls this
  /// whenever the wall theme changes, then rebuilds every screen.
  static void use(ThemePalette palette) => _palette = palette;

  static Color get wallInk => _palette.wallInk;
  static Color get wallDeep => _palette.wallDeep;
  static Color get wallPlum => _palette.wallPlum;
  static Color get panel => _palette.panel;
  static Color get panelWarm => _palette.panelWarm;
  static Color get gold => _palette.gold;
  static Color get amber => _palette.amber;
  static Color get line => _palette.line;

  static const card = BrandColors.card;
  static const cardDark = BrandColors.cardDark;
  static const rope = BrandColors.rope;
  static const rose = BrandColors.rose;
  static const sage = BrandColors.sage;
  static const blue = BrandColors.blue;
  static const text = BrandColors.text;
  static const muted = BrandColors.muted;
  static const paperInk = BrandColors.paperInk;
}

/// The original Warm Memory Room palette, fixed. Used where colours must not
/// change with the theme: exported stories and films, and colours saved with
/// memories.
class BrandColors {
  const BrandColors._();

  static const wallInk = Color(0xFF0A070B);
  static const wallDeep = Color(0xFF171018);
  static const wallPlum = Color(0xFF241824);
  static const panel = Color(0xFF1D1720);
  static const panelWarm = Color(0xFF2A1E22);
  static const card = Color(0xFFFFF1D8);
  static const cardDark = Color(0xFFE7C995);
  static const rope = Color(0xFFA87442);
  static const gold = Color(0xFFD2A24A);
  static const amber = Color(0xFFF2C86B);
  static const rose = Color(0xFFE59A8D);
  static const sage = Color(0xFFA7BD92);
  static const blue = Color(0xFF8EA7C6);
  static const text = Color(0xFFFFF8EA);
  static const muted = Color(0xFFC2B6A8);
  static const line = Color(0xFF3A2C33);
  static const paperInk = Color(0xFF261C17);
}

/// The theme-following colours for one wall theme.
@immutable
class ThemePalette {
  const ThemePalette({
    required this.wallInk,
    required this.wallDeep,
    required this.wallPlum,
    required this.panel,
    required this.panelWarm,
    required this.gold,
    required this.amber,
    required this.line,
  });

  /// Warm Memory Room keeps the original palette exactly.
  static const warm = ThemePalette(
    wallInk: BrandColors.wallInk,
    wallDeep: BrandColors.wallDeep,
    wallPlum: BrandColors.wallPlum,
    panel: BrandColors.panel,
    panelWarm: BrandColors.panelWarm,
    gold: BrandColors.gold,
    amber: BrandColors.amber,
    line: BrandColors.line,
  );

  factory ThemePalette.of(WallThemePreset wall) {
    if (wall.id == WallThemeId.warmMemoryRoom) return warm;
    return ThemePalette(
      wallInk: wall.background,
      wallDeep: wall.depth,
      wallPlum: Color.lerp(wall.depth, wall.accent, 0.12)!,
      panel: Color.lerp(wall.background, wall.depth, 0.7)!,
      panelWarm: Color.lerp(wall.depth, wall.accent, 0.1)!,
      gold: wall.accent,
      amber: Color.lerp(wall.accent, Colors.white, 0.28)!,
      line: wall.line,
    );
  }

  final Color wallInk;
  final Color wallDeep;
  final Color wallPlum;
  final Color panel;
  final Color panelWarm;

  /// The accent: buttons, icons, highlights.
  final Color gold;

  /// A lighter accent for text and small highlights.
  final Color amber;
  final Color line;
}
