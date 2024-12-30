import 'package:flutter/material.dart';
import 'package:flutter_application_1/gen/fonts.gen.dart';

class ThemeApp {
  static const Color primaryColor = Color(0xFFFFFFFF); // سفید اصلی
  static const Color secondaryColor = Color(0xFFF7F7F7); // سفید روشن

  static ThemeData lightTheme(Color themeColor) {
    return ThemeData(
      fontFamily: FontFamily.appFont,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        //      Color.fromARGB(255, 52, 97, 122),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
        headlineMedium: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        labelMedium: TextStyle(color: Colors.black87, fontSize: 14),
        titleMedium: TextStyle(color: Colors.black87, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.black12.withOpacity(0.5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.black38),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        shadowColor: Colors.black12,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey,
        backgroundColor: secondaryColor,
      ).copyWith(
        primary: themeColor,
        secondary: Colors.black87,
        surface: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(Color themeColor) {
    return ThemeData(
      actionIconTheme: const ActionIconThemeData(),
      fontFamily: FontFamily.appFont,
      brightness: Brightness.dark,
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[700],
      appBarTheme: AppBarTheme(
        backgroundColor: themeColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white60),
        headlineMedium:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF1E3D3D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              BorderSide(color: const Color(0xFF1E3D3D).withOpacity(0.5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Color(0xFF1E3D3D)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ).copyWith(
        primary: themeColor,
        secondary: Colors.grey[700],
        surface: const Color(0xFF102828),
        brightness: Brightness.dark,
      ),
    );
  }
}
