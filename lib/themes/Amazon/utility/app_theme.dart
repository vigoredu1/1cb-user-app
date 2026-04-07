import 'package:flutter/material.dart';

ThemeData AmzTheme() {
  return ThemeData(
    useMaterial3: false,

    // 🧱 Background
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2B2B2B),
      secondary: Color(0xFF6A5AAE), // ✅ purple accent
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),

    // 🧭 AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2B2B2B),
      ),
    ),

    // 📝 Text
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111111),
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F1111),
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFFDC2626),
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        color: Color(0xFF333333),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFF565959),
      ),
    ),

    // 🔘 Button (Purple like your screenshot)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A5AAE), // ✅ purple
        foregroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // same as your UI
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // 🔲 Outline Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2B2B2B),
        side: const BorderSide(color: Color(0xFF2B2B2B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // 🧭 Bottom nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF6A5AAE), // purple active icon
      unselectedItemColor: Color(0xFF9A9A9A),
      selectedLabelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
      elevation: 8,
    ),

    // 🔹 Divider
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),
  );
}