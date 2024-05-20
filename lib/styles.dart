import 'package:flutter/material.dart';

class PixelTheme {
  static final ThemeData theme = ThemeData(
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: Color(0xFF001f3f), // Azul oscuro neón
    textTheme: TextTheme(
      headline1: TextStyle(
        fontFamily: 'Pixel',
        fontSize: 32,
        color: Colors.pinkAccent,
      ),
      bodyText1: TextStyle(
        fontFamily: 'Pixel',
        fontSize: 16,
        color: Colors.cyanAccent,
      ),
      bodyText2: TextStyle(
        fontFamily: 'Pixel',
        fontSize: 14,
        color: Colors.cyanAccent,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 0, 16, 31), // Azul oscuro neón
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.pinkAccent),
      ),
      labelStyle: TextStyle(
        fontFamily: 'Pixel',
        color: Colors.pinkAccent,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyanAccent),
        foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 1, 4, 6)), // Azul oscuro neón
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontFamily: 'Pixel',
          ),
        ),
      ),
    ),
  );
}
