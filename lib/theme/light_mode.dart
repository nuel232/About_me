import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF3B82F6),
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.interTextTheme(
    ThemeData.light().textTheme,
  ).apply(bodyColor: Colors.black, displayColor: Colors.black),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF14B8A6),
    surface: Color(0xFFF9FAFB),
    background: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF374151),
    onBackground: Colors.black,
  ),
);
