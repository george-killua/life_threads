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
  static Color get text => _palette.text;
  static Color get muted => _palette.muted;
  static Color get card => _palette.card;
  static Color get cardDark => _palette.cardDark;
  static Color get paperInk => _palette.paperInk;

  /// Secondary text on light paper panels.
  static Color get paperMuted => _palette.paperMuted;
  static Color get rope => _palette.rope;

  /// The dark core of a rope.
  static Color get ropeBody => _palette.ropeBody;

  /// The second, offset glow around a rope.
  static Color get ropeHalo => _palette.ropeHalo;

  /// Light and dark of the knots where ropes meet a card.
  static Color get knotLight => _palette.knotLight;
  static Color get knotDark => _palette.knotDark;

  /// The metal of pins, from highlight to deepest shade.
  static Color get pinHighlight => _palette.pinHighlight;
  static Color get pinMid => _palette.pinMid;
  static Color get pinShadow => _palette.pinShadow;
  static Color get pinDeep => _palette.pinDeep;

  /// The secondary accent.
  static Color get rose => _palette.rose;

  // Status colours mean the same on every theme.
  static const sage = BrandColors.sage;
  static const blue = BrandColors.blue;
  static const error = BrandColors.error;

  /// Success and error text on light paper panels.
  static const successInk = BrandColors.successInk;
  static const errorInk = BrandColors.errorInk;
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
  static const paperMuted = Color(0xFF6D5741);
  static const ropeBody = Color(0xFF4A3425);
  static const ropeHalo = Color(0xFF89A7D8);
  static const knotLight = Color(0xFFFFD77D);
  static const knotDark = Color(0xFF9C6727);
  static const pinHighlight = Color(0xFFE6C78A);
  static const pinMid = Color(0xFFB89255);
  static const pinShadow = Color(0xFF6A4824);
  static const pinDeep = Color(0xFF4A3118);
  static const error = Color(0xFFFF7D73);
  static const successInk = Color(0xFF38512D);
  static const errorInk = Color(0xFF7A2B24);
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
    required this.text,
    required this.muted,
    required this.card,
    required this.cardDark,
    required this.paperInk,
    required this.paperMuted,
    required this.rope,
    required this.ropeBody,
    required this.ropeHalo,
    required this.knotLight,
    required this.knotDark,
    required this.pinHighlight,
    required this.pinMid,
    required this.pinShadow,
    required this.pinDeep,
    required this.rose,
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
    text: BrandColors.text,
    muted: BrandColors.muted,
    card: BrandColors.card,
    cardDark: BrandColors.cardDark,
    paperInk: BrandColors.paperInk,
    paperMuted: BrandColors.paperMuted,
    rope: BrandColors.rope,
    ropeBody: BrandColors.ropeBody,
    ropeHalo: BrandColors.ropeHalo,
    knotLight: BrandColors.knotLight,
    knotDark: BrandColors.knotDark,
    pinHighlight: BrandColors.pinHighlight,
    pinMid: BrandColors.pinMid,
    pinShadow: BrandColors.pinShadow,
    pinDeep: BrandColors.pinDeep,
    rose: BrandColors.rose,
  );

  factory ThemePalette.of(WallThemePreset wall) {
    if (wall.id == WallThemeId.warmMemoryRoom) return warm;
    final paper = wall.cardStyle;
    Color mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;
    return ThemePalette(
      wallInk: wall.background,
      wallDeep: wall.depth,
      wallPlum: Color.lerp(wall.depth, wall.accent, 0.12)!,
      panel: Color.lerp(wall.background, wall.depth, 0.7)!,
      panelWarm: Color.lerp(wall.depth, wall.accent, 0.1)!,
      gold: wall.accent,
      amber: Color.lerp(wall.accent, Colors.white, 0.28)!,
      line: wall.line,
      text: mix(Colors.white, wall.accent, 0.06),
      muted: mix(const Color(0xFFB8B8B8), wall.accent, 0.3),
      card: paper.paper[1],
      cardDark: paper.paper[2],
      paperInk: paper.ink,
      paperMuted: mix(paper.ink, paper.paper[1], 0.3),
      rope: mix(wall.ropeGlow, Colors.black, 0.3),
      ropeBody: mix(wall.ropeGlow, Colors.black, 0.72),
      ropeHalo: wall.secondaryGlow,
      knotLight: mix(wall.ropeGlow, Colors.white, 0.3),
      knotDark: mix(wall.ropeGlow, Colors.black, 0.45),
      pinHighlight: mix(wall.accent, Colors.white, 0.4),
      pinMid: wall.accent,
      pinShadow: mix(wall.accent, Colors.black, 0.55),
      pinDeep: mix(wall.accent, Colors.black, 0.7),
      rose: wall.secondaryGlow,
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
  final Color text;
  final Color muted;
  final Color card;
  final Color cardDark;
  final Color paperInk;
  final Color paperMuted;
  final Color rope;
  final Color ropeBody;
  final Color ropeHalo;
  final Color knotLight;
  final Color knotDark;
  final Color pinHighlight;
  final Color pinMid;
  final Color pinShadow;
  final Color pinDeep;
  final Color rose;
}
