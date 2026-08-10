import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ألوان مستوحاة من العلم السعودي (أخضر) مع لمسة ذهبية
class AppColors {
  AppColors._();

  static const primaryGreen = Color(0xFF0B5A3A);
  static const deepGreen = Color(0xFF073F28);
  static const gold = Color(0xFFC9A15A);
  static const cream = Color(0xFFF8F5EE);
  static const boardLight = Color(0xFFEEE7D8);
  static const boardDark = Color(0xFF6B8F6B);
  static const danger = Color(0xFFB3261E);
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final textTheme = GoogleFonts.tajawalTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.gold,
        brightness: Brightness.light,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
