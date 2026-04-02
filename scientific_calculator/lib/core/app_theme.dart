import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.lightOnSurface,
      displayColor: AppColors.lightOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainerLow: AppColors.lightSurfaceContainerLow,
        surfaceContainer: AppColors.lightSurfaceContainer,
        surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.manrope(
          color: AppColors.lightOnSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.manrope(
          color: AppColors.lightOnSurface,
          fontWeight: FontWeight.w700,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.darkOnSurface,
      displayColor: AppColors.darkOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.manrope(
          color: AppColors.darkOnSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.manrope(
          color: AppColors.darkOnSurface,
          fontWeight: FontWeight.w700,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

