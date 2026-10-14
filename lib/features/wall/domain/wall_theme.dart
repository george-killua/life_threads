import 'package:flutter/material.dart';

import 'wall_card_style.dart';

enum WallThemeId {
  warmMemoryRoom,
  midnightArchive,
  softPaperWall,
  travelCorkboard,
  autumnHarvest,
  winterLights,
  springBlossom,
  summerEvening;

  static WallThemeId fromName(String value) {
    return WallThemeId.values.firstWhere(
      (theme) => theme.name == value,
      orElse: () => WallThemeId.warmMemoryRoom,
    );
  }
}

/// The months a limited theme can be chosen and shown (northern-hemisphere
/// seasons).
enum WallThemeSeason {
  spring([3, 4, 5]),
  summer([6, 7, 8]),
  autumn([9, 10, 11]),
  winter([12, 1, 2]);

  const WallThemeSeason(this.months);

  final List<int> months;

  bool contains(DateTime time) => months.contains(time.month);

  /// The last day of this season that is on or after [time].
  DateTime endAfter(DateTime time) {
    final lastMonth = months.last;
    final year = lastMonth < time.month ? time.year + 1 : time.year;
    // Day 0 of the next month is the last day of lastMonth.
    return DateTime(year, lastMonth + 1, 0);
  }
}

class WallThemePreset {
  const WallThemePreset({
    required this.id,
    required this.icon,
    required this.background,
    required this.depth,
    required this.surface,
    required this.accent,
    required this.secondaryGlow,
    required this.line,
    required this.ropeGlow,
    required this.cardStyle,
    required this.isPremium,
    this.season,
  });

  final WallThemeId id;
  final IconData icon;
  final Color background;
  final Color depth;
  final Color surface;
  final Color accent;
  final Color secondaryGlow;
  final Color line;

  /// Glow and pin colour of the ropes connecting memories on the wall.
  final Color ropeGlow;

  /// How memory cards look on this wall.
  final WallCardStyle cardStyle;
  final bool isPremium;

  /// Set for limited themes: they can only be used during this season.
  final WallThemeSeason? season;

  bool isAvailableAt(DateTime time) => season?.contains(time) ?? true;

  static const warmMemoryRoom = WallThemePreset(
    id: WallThemeId.warmMemoryRoom,
    icon: Icons.lightbulb_rounded,
    background: Color(0xFF0A070B),
    depth: Color(0xFF171018),
    surface: Color(0xFF241824),
    accent: Color(0xFFD2A24A),
    secondaryGlow: Color(0xFFE59A8D),
    line: Color(0xFF3A2C33),
    ropeGlow: Color(0xFFF2C86B),
    cardStyle: WallCardStyle.classic,
    isPremium: false,
  );

  static const midnightArchive = WallThemePreset(
    id: WallThemeId.midnightArchive,
    icon: Icons.nights_stay_rounded,
    background: Color(0xFF050914),
    depth: Color(0xFF091326),
    surface: Color(0xFF101C34),
    accent: Color(0xFF8EA7C6),
    secondaryGlow: Color(0xFFD2A24A),
    line: Color(0xFF243452),
    ropeGlow: Color(0xFFB9CBE3),
    cardStyle: WallCardStyle.archive,
    isPremium: true,
  );

  static const softPaperWall = WallThemePreset(
    id: WallThemeId.softPaperWall,
    icon: Icons.article_rounded,
    background: Color(0xFF241C14),
    depth: Color(0xFF493A27),
    surface: Color(0xFFE8D5B4),
    accent: Color(0xFFA87442),
    secondaryGlow: Color(0xFFFFF1D8),
    line: Color(0xFF6D5741),
    ropeGlow: Color(0xFFE0A86A),
    cardStyle: WallCardStyle.creamPaper,
    isPremium: true,
  );

  static const travelCorkboard = WallThemePreset(
    id: WallThemeId.travelCorkboard,
    icon: Icons.travel_explore_rounded,
    background: Color(0xFF1F1308),
    depth: Color(0xFF3A2411),
    surface: Color(0xFF8A5A2B),
    accent: Color(0xFFF2C86B),
    secondaryGlow: Color(0xFF8EA7C6),
    line: Color(0xFF5F3E1E),
    ropeGlow: Color(0xFFE0614F),
    cardStyle: WallCardStyle.polaroid,
    isPremium: true,
  );

  static const autumnHarvest = WallThemePreset(
    id: WallThemeId.autumnHarvest,
    icon: Icons.eco_rounded,
    background: Color(0xFF140A05),
    depth: Color(0xFF2B140A),
    surface: Color(0xFF5A2A12),
    accent: Color(0xFFE08A3C),
    secondaryGlow: Color(0xFFC9483A),
    line: Color(0xFF4A2A18),
    ropeGlow: Color(0xFFF0A65A),
    cardStyle: WallCardStyle.kraft,
    isPremium: true,
    season: WallThemeSeason.autumn,
  );

  static const winterLights = WallThemePreset(
    id: WallThemeId.winterLights,
    icon: Icons.ac_unit_rounded,
    background: Color(0xFF060B12),
    depth: Color(0xFF0E1A26),
    surface: Color(0xFF1C3040),
    accent: Color(0xFFBFE3F2),
    secondaryGlow: Color(0xFFF2D27A),
    line: Color(0xFF29404F),
    ropeGlow: Color(0xFFFFE6A3),
    cardStyle: WallCardStyle.frost,
    isPremium: true,
    season: WallThemeSeason.winter,
  );

  static const springBlossom = WallThemePreset(
    id: WallThemeId.springBlossom,
    icon: Icons.local_florist_rounded,
    background: Color(0xFF120A10),
    depth: Color(0xFF26141F),
    surface: Color(0xFF3C2433),
    accent: Color(0xFFF2A7C3),
    secondaryGlow: Color(0xFFA7BD92),
    line: Color(0xFF4A3040),
    ropeGlow: Color(0xFFF7C4D6),
    cardStyle: WallCardStyle.blossom,
    isPremium: true,
    season: WallThemeSeason.spring,
  );

  static const summerEvening = WallThemePreset(
    id: WallThemeId.summerEvening,
    icon: Icons.wb_twilight_rounded,
    background: Color(0xFF0D0812),
    depth: Color(0xFF241330),
    surface: Color(0xFF4A2340),
    accent: Color(0xFFFFB25B),
    secondaryGlow: Color(0xFFFF7A8A),
    line: Color(0xFF3F2645),
    ropeGlow: Color(0xFFFFC77A),
    cardStyle: WallCardStyle.polaroid,
    isPremium: true,
    season: WallThemeSeason.summer,
  );

  /// Year-round themes, in picker order.
  static const all = [
    warmMemoryRoom,
    midnightArchive,
    softPaperWall,
    travelCorkboard,
  ];

  /// Limited themes; each is only available during its season.
  static const seasonal = [
    springBlossom,
    summerEvening,
    autumnHarvest,
    winterLights,
  ];

  static const everyTheme = [...all, ...seasonal];

  static List<WallThemePreset> seasonalAt(DateTime time) =>
      seasonal.where((theme) => theme.isAvailableAt(time)).toList();

  static WallThemePreset fromId(WallThemeId id) {
    return everyTheme.firstWhere(
      (theme) => theme.id == id,
      orElse: () => warmMemoryRoom,
    );
  }

  /// The theme Auto shows at [time]: Soft Paper Wall by day, Warm Memory
  /// Room in the evening, Midnight Archive at night.
  static WallThemePreset autoAt(DateTime time) {
    final hour = time.hour;
    if (hour >= 7 && hour < 18) return softPaperWall;
    if (hour >= 18 && hour < 22) return warmMemoryRoom;
    return midnightArchive;
  }
}
