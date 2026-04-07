import 'package:flutter/material.dart';

ThemeData nexusTheme() {
  return ThemeData(
    // 🌸 Soft pink background (from splash)
    scaffoldBackgroundColor: const Color(0xFFFFF3F6),

    colorScheme: const ColorScheme.light(
      // 🎀 Primary: elegant peach-pink (saree tone)
      primary: Color(0xFFF28BA8),

      // 🌼 Secondary: warm golden yellow (kurti tone)
      secondary: Color(0xFFF6C453),
    ),

    // 🧭 AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF2B2B2B),
      elevation: 0.8,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2B2B2B),
      ),
    ),

    // 📝 Text styles
    textTheme: const TextTheme(
      // Section headings
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2B2B2B),
      ),

      // Product title
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF3A3A3A),
      ),

      // Product price (wine pink from dress)
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFFC24A6A),
      ),

      // Description
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFF8A8A8A),
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF6E6E6E),
      ),
    ),

    // 🟣 Primary Button (peach pink)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF28BA8),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    // 🟡 Secondary / Outline Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFC24A6A),
        side: const BorderSide(color: Color(0xFFC24A6A)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    // 🧭 Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFF28BA8),
      unselectedItemColor: Color(0xFF9A9A9A),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
