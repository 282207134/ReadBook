import 'package:flutter/material.dart';

const ink = Color(0xFF646475);
const muted = Color(0xFFA7A7B1);
const green = Color(0xFF32CD77);
const blue = Color(0xFF0396FF);
const line = Color(0xFFF0F0F2);

ThemeData bookstoreTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: green,
    primary: green,
    surface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: ink, fontSize: 14, height: 1.5),
    bodySmall: TextStyle(color: muted, fontSize: 12),
    titleMedium: TextStyle(color: ink, fontSize: 16),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    foregroundColor: ink,
    centerTitle: true,
    elevation: 0.6,
    shadowColor: Color(0x22000000),
    titleTextStyle: TextStyle(
      color: ink,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: muted, fontSize: 14),
    contentPadding: const EdgeInsets.all(12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: green),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: blue,
      textStyle: const TextStyle(fontSize: 12),
    ),
  ),
  dividerTheme: const DividerThemeData(color: line, thickness: 1, space: 1),
);
