import 'package:flutter/material.dart';

class CompanyColors {
  CompanyColors._();
  static const _bluePrimaryValue = 0xFF28aede;

  static const MaterialColor utama = const MaterialColor(
    _bluePrimaryValue,
    const <int, Color>{
      50:  const Color(0xFFd7f4f4),
      100: const Color(0xFFc3eeee),
      200: const Color(0xFFafe9e9),
      300: const Color(0xFF9ce3e3),
      400: const Color(0xFF88dddd),
      500: const Color(_bluePrimaryValue),
      600: const Color(0xFF4ccdcd),
      700: const Color(0xFF32b3b3),
      800: const Color(0xFF278b8b),
      900: const Color(0xFF1c6363),
    },
  );
}