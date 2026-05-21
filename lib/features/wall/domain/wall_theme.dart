import 'package:flutter/material.dart';

enum WallThemeId {
  warmMemoryRoom,
  midnightArchive,
  softPaperWall,
  travelCorkboard;

  static WallThemeId fromName(String value) {
    return WallThemeId.values.firstWhere(
      (theme) => theme.name == value,
      orElse: () => WallThemeId.warmMemoryRoom,
    );
  }
}

class WallThemePreset {
  const WallThemePreset({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.background,
    required this.depth,
    required this.surface,
    required this.accent,
    required this.secondaryGlow,
    required this.line,
    required this.isPremium,
  });

  final WallThemeId id;
  final String label;
  final String description;
  final IconData icon;
  final Color background;
  final Color depth;
  final Color surface;
  final Color accent;
  final Color secondaryGlow;
  final Color line;
  final bool isPremium;

  static const warmMemoryRoom = WallThemePreset(
    id: WallThemeId.warmMemoryRoom,
    label: 'Warm Memory Room',
    description: 'Soft dark warmth, gold light, and private-room depth.',
    icon: Icons.lightbulb_rounded,
    background: Color(0xFF0A070B),
    depth: Color(0xFF171018),
    surface: Color(0xFF241824),
    accent: Color(0xFFD2A24A),
    secondaryGlow: Color(0xFFE59A8D),
    line: Color(0xFF3A2C33),
    isPremium: false,
  );

  static const midnightArchive = WallThemePreset(
    id: WallThemeId.midnightArchive,
    label: 'Midnight Archive',
    description: 'Deep blue archive room with quiet museum-like focus.',
    icon: Icons.nights_stay_rounded,
    background: Color(0xFF050914),
    depth: Color(0xFF091326),
    surface: Color(0xFF101C34),
    accent: Color(0xFF8EA7C6),
    secondaryGlow: Color(0xFFD2A24A),
    line: Color(0xFF243452),
    isPremium: true,
  );

  static const softPaperWall = WallThemePreset(
    id: WallThemeId.softPaperWall,
    label: 'Soft Paper Wall',
    description: 'Cream paper, ink shadows, and calm scrapbook feeling.',
    icon: Icons.article_rounded,
    background: Color(0xFF241C14),
    depth: Color(0xFF493A27),
    surface: Color(0xFFE8D5B4),
    accent: Color(0xFFA87442),
    secondaryGlow: Color(0xFFFFF1D8),
    line: Color(0xFF6D5741),
    isPremium: true,
  );

  static const travelCorkboard = WallThemePreset(
    id: WallThemeId.travelCorkboard,
    label: 'Travel Corkboard',
    description: 'Corkboard warmth with map-grid hints for trips and places.',
    icon: Icons.travel_explore_rounded,
    background: Color(0xFF1F1308),
    depth: Color(0xFF3A2411),
    surface: Color(0xFF8A5A2B),
    accent: Color(0xFFF2C86B),
    secondaryGlow: Color(0xFF8EA7C6),
    line: Color(0xFF5F3E1E),
    isPremium: true,
  );

  static const all = [
    warmMemoryRoom,
    midnightArchive,
    softPaperWall,
    travelCorkboard,
  ];

  static WallThemePreset fromId(WallThemeId id) {
    return all.firstWhere(
      (theme) => theme.id == id,
      orElse: () => warmMemoryRoom,
    );
  }
}
