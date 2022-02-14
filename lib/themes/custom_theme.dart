import 'package:flutter/material.dart';

var primaryColor = Colors.blue;

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Nunito',
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.greenAccent,
      ),
      scaffoldBackgroundColor: const Color(0xFFfafbfe),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          onPrimary: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
