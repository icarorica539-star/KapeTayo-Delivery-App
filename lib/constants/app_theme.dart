import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  static const Color primary    = Color(0xFF3E2723); // deep espresso
  static const Color accent     = Color(0xFFD7A86E); // warm caramel
  static const Color background = Color(0xFFFAF3E0); // soft cream
  static const Color surface    = Color(0xFFFFFFFF); // white
  static const Color textDark   = Color(0xFF1C1009); // near black
  static const Color textLight  = Color(0xFFFFF8F0); // off-white

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primary,
    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: surface,
      onPrimary: textLight,
      onSecondary: textDark,
      onSurface: textDark,
    ),

    
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: textDark,
      displayColor: textDark,
    ),

    
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: textLight,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: textLight),
      titleTextStyle: TextStyle(
        color: textLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),

    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: textLight,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ─────────────────────────────────────────────
    // TEXT BUTTON
    // ─────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),

    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      labelStyle: const TextStyle(color: primary),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFF9E9E9E),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      elevation: 8,
    ),

   
    iconTheme: const IconThemeData(color: primary),
  );
}