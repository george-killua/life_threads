import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.gold,
      onPrimary: Color(0xFF241505),
      secondary: AppColors.rose,
      onSecondary: Color(0xFF2A1010),
      tertiary: AppColors.sage,
      onTertiary: Color(0xFF111C12),
      surface: AppColors.wallDeep,
      onSurface: AppColors.text,
      error: Color(0xFFFF7D73),
      outline: AppColors.line,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.wallInk,
      colorScheme: colorScheme,
      fontFamily: 'Avenir',
      appBarTheme: const AppBarTheme(
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
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: Color(0xFF241505),
        extendedTextStyle: TextStyle(fontWeight: FontWeight.w900),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: const Color(0xFF241505),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.amber),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.panelWarm,
        selectedColor: AppColors.gold.withValues(alpha: 0.28),
        secondarySelectedColor: AppColors.gold,
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontWeight: FontWeight.w800,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w900,
        ),
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      cardTheme: CardThemeData(
        color: AppColors.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.panel,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.panel,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.panel,
        dragHandleColor: AppColors.line,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.panelWarm,
        hintStyle: const TextStyle(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
        ),
      ),
    );
  }
}
