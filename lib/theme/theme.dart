import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.blue,
    secondary: Colors.black,
  ),
  primaryColorLight: Colors.grey.shade100,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 20, 20, 20),
    primary: Colors.blue.shade800,
    secondary: Colors.white,
  ),
  primaryColorLight: Color.fromARGB(255, 48, 48, 48),
);
