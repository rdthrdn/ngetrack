import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color pink900 = Color(0xFFB97980);
  static const Color pink800 = Color(0xFFC88C93);
  static const Color pink50 = Color(0xFFF3E1E4);
  static const Color onGlass = Color(0xD91B1B1B); // 85%
  static const Color white90 = Color(0xE6FFFFFF); // 90%
  static const Color glassBorder = Color(0x59FFFFFF); // 35%

  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.dmSerifDisplay(
      fontSize: 32,
      color: onGlass,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.dmSerifDisplay(
      fontSize: 28,
      color: onGlass,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.dmSerifDisplay(
      fontSize: 24,
      color: onGlass,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      color: onGlass,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: onGlass,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: onGlass,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      color: onGlass,
      fontWeight: FontWeight.w600,
    ),
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pink900,
        primary: pink900,
        secondary: pink800,
        surface: pink50,
        onSurface: onGlass,
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: pink50,
    );
  }
}
