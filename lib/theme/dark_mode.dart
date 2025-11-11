import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3B82F6),
  scaffoldBackgroundColor: Colors.black,
  textTheme: GoogleFonts.interTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: Colors.white, displayColor: Colors.white),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF14B8A6),
    surface: Color(0xFF1F2937),
    background: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF9CA3AF),
    onBackground: Colors.white,
  ),
);
