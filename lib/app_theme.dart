import 'package:flutter/material.dart';

class AppTheme {
  static const Color colorPrincipal = Color(0xF9DA0700); // color principal (medio rojito)
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(primary: colorPrincipal, secondary: colorPrincipal),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black, centerTitle: true),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPrincipal, foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: colorPrincipal, width: 1.4),
        borderRadius: BorderRadius.circular(6),
      ),
      labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
      hintStyle: const TextStyle(color: Colors.white38),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
  );
}
