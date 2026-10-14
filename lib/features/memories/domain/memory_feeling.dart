import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

enum MemoryFeeling {
  warm('Warm', Icons.favorite_rounded, BrandColors.rose),
  nostalgic('Nostalgic', Icons.history_edu_rounded, BrandColors.gold),
  proud('Proud', Icons.auto_awesome_rounded, BrandColors.amber),
  calm('Calm', Icons.spa_rounded, BrandColors.sage),
  important('Important', Icons.push_pin_rounded, BrandColors.blue);

  const MemoryFeeling(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static MemoryFeeling fromName(String value) {
    return MemoryFeeling.values.firstWhere(
      (feeling) => feeling.name == value,
      orElse: () => MemoryFeeling.warm,
    );
  }
}
