import 'package:flutter/material.dart';

import '../../features/wall/domain/wall_theme.dart';
import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark => forWall(WallThemePreset.warmMemoryRoom);

  /// The app theme for a wall theme: buttons, chips, dialogs, sheets and
  /// fields take the wall's accent and surfaces. Warm Memory Room keeps the
  /// original palette exactly.
  static ThemeData forWall(WallThemePreset wall) {
    final palette = ThemePalette.of(wall);
    final accent = palette.gold;
    final onAccent = _onColor(accent);
    final highlight = palette.amber;
    final panel = palette.panel;
    final panelWarm = palette.panelWarm;

    final colorScheme = ColorScheme.dark(
      primary: accent,
      onPrimary: onAccent,
      secondary: wall.secondaryGlow,
      onSecondary: _onColor(wall.secondaryGlow),
      tertiary: AppColors.sage,
      onTertiary: const Color(0xFF111C12),
      surface: wall.depth,
      onSurface: AppColors.text,
      error: const Color(0xFFFF7D73),
      outline: wall.line,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: wall.background,
      extensions: [wall.cardStyle],
      colorScheme: colorScheme,
      fontFamily: 'Avenir',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: onAccent,
        extendedTextStyle: const TextStyle(fontWeight: FontWeight.w900),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: highlight),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: panelWarm,
        selectedColor: accent.withValues(alpha: 0.28),
        secondarySelectedColor: accent,
        labelStyle: TextStyle(
          color: AppColors.muted,
          fontWeight: FontWeight.w800,
        ),
        secondaryLabelStyle: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
        ),
        side: BorderSide(color: wall.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: panel,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: panel,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: panel,
        dragHandleColor: wall.line,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panelWarm,
        hintStyle: TextStyle(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: wall.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: wall.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: accent, width: 1.4),
        ),
      ),
    );
  }

  /// Dark text on light accents, light text on dark ones.
  static Color _onColor(Color background) {
    return background.computeLuminance() > 0.35
        ? const Color(0xFF241505)
        : AppColors.text;
  }
}
