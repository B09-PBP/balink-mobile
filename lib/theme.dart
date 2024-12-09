import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData djangoTheme = ThemeData(
  // Updated primary and secondary colors using colorScheme
  colorScheme: ColorScheme.fromSwatch(
  ).copyWith(
    primary: const Color.fromRGBO(32, 73, 255, 1),
    secondary: Colors.yellow.shade500, // Replacing accentColor with secondary
    surface: Colors.grey.shade100, // Replacing background with surface (updated for newer Flutter versions)
  ),

  // Updated TextTheme using newer Flutter typography styles
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
    titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
    bodyLarge: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
    bodyMedium: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
  ),

  // Updated InputDecorationTheme
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue.shade400),
    ),
    contentPadding: EdgeInsets.all(12),
  ),

  // Updated button styles with ElevatedButtonTheme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade600, // Replacing 'primary' with 'backgroundColor'
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Added padding for consistency
    ),
  ),

  // Defining default scaffold background using 'surface' instead of 'background'
  scaffoldBackgroundColor: Colors.grey.shade100,
);
