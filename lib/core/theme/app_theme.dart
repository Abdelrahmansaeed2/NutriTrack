import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryDarkGreen = Color(0xFF006C49);
  static const Color secondaryGreen = Color(0xFF10B981);
  static const Color darkSlate = Color(0xFF121C2A);
  static const Color mutedSage = Color(0xFF3C4A42);
  static const Color lightBackground = Color(0xFFF8F9FF);
  static const Color white = Color(0xFFFFFFFF);
  
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color greySage = Color(0xFF6C7A71);
  static const Color lightGreySage = Color(0xFFBBCABF);
  
  // Tag & Accent Colors
  static const Color accentBlue = Color(0xFF2170E4);
  static const Color darkBlue = Color(0xFF0058BE);
  static const Color accentRed = Color(0xFFB91A24);
  static const Color softBlueBg = Color(0xFFEFF4FF);
  static const Color softBlueBg2 = Color(0xFFE6EEFF);
  static const Color softRedBg = Color(0xFFFFDAD7);
  static const Color softYellowBg = Color(0xFFFEF08A);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.primaryDarkGreen,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDarkGreen,
        secondary: AppColors.secondaryGreen,
        background: AppColors.lightBackground,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onBackground: AppColors.darkSlate,
        onSurface: AppColors.darkSlate,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.darkSlate,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkSlate,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkSlate,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkSlate,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.mutedSage,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.mutedSage,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.mutedSage,
        ),
      ),
    );
  }
}
