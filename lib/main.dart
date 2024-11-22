import 'package:balink_mobile/landing.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balink',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.shade100,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

