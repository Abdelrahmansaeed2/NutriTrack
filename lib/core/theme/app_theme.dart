// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppTheme {
//   static const Color primaryBrandColor = Color(0xFF10B981); // Emerald Green

//   static ThemeData get lightTheme {
//     final baseTextTheme = GoogleFonts.interTextTheme();

//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: primaryBrandColor,
//         primary: primaryBrandColor,
//       ),
//       textTheme: baseTextTheme.copyWith(
//         displayLarge: baseTextTheme.displayLarge?.copyWith(
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//         ),
//         bodyLarge: baseTextTheme.bodyLarge?.copyWith(
//           color: Colors.black87,
//         ),
//         bodyMedium: baseTextTheme.bodyMedium?.copyWith(
//           color: Colors.black54,
//         ),
//       ),
//       cardTheme: CardThemeData(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         clipBehavior: Clip.antiAlias,
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       ),
//       appBarTheme: const AppBarTheme(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black87,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryBrandColor,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static const Color primary             = Color(0xFF006C49);
  static const Color primaryContainer    = Color(0xFF10B981);
  static const Color primaryFixed        = Color(0xFF6FFBBE);
  static const Color onPrimary           = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer  = Color(0xFF00422B);

  static const Color secondary           = Color(0xFF0058BE);
  static const Color secondaryFixed      = Color(0xFFD8E2FF);

  static const Color tertiary            = Color(0xFFB91A24);
  static const Color tertiaryFixed       = Color(0xFFFFDAD7);

  static const Color surface             = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer    = Color(0xFFE6EEFF);
  static const Color surfaceContainerHigh= Color(0xFFDEE9FC);
  static const Color surfaceVariant      = Color(0xFFD9E3F6);
  static const Color surfaceContainerHighest = Color(0xFFD9E3F6);
  static const Color onSurface          = Color(0xFF121C2A);
  static const Color onSurfaceVariant   = Color(0xFF3C4A42);
  static const Color outlineVariant     = Color(0xFFBBCABF);
  static const Color error              = Color(0xFFBA1A1A);
  static const Color onError            = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryContainer,
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: onPrimary,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryFixed,
        tertiary: tertiary,
        tertiaryContainer: tertiaryFixed,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        surfaceContainerLowest: surfaceContainerLowest,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        error: error,
        onError: onError,
        outline: const Color(0xFF6C7A71),
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          color: onSurface,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: onSurfaceVariant,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: onSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: surfaceContainer,
        thickness: 1,
      ),
    );
  }
}