import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blue400 = Color.fromRGBO(32, 73, 255, 1);
const Color yellow = Color.fromRGBO(255, 203, 48, 1);

final ThemeData djangoTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: blue400,
    secondary: yellow,
    surface: Colors.grey.shade100,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),

  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black
    ),
    titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800
    ),
    bodyLarge: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey.shade600
    ),
    bodyMedium: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.grey.shade500
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: blue400),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.all(12),
    fillColor: Colors.white,
    filled: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: blue400,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: blue400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: blue400,
      side: const BorderSide(color: blue400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),

  iconTheme: const IconThemeData(
    color: blue400,
    size: 24,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: blue400,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  scaffoldBackgroundColor: Colors.grey.shade100,
);