import 'package:flutter/material.dart';

import 'font_sizes.dart';

class StylesFontStyles {
  static TextStyle get header => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      );

  static TextStyle get headline1 => const TextStyle(
        fontSize: StylesFontSizes.xxl,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.white,
      );

  static TextStyle get headline2 => const TextStyle(
        fontSize: StylesFontSizes.xl,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.4,
        color: Colors.white,
      );

  static TextStyle get title => const TextStyle(
        fontSize: StylesFontSizes.l,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
        color: Color.fromRGBO(255, 255, 255, 1),
      );

  static TextStyle get subtitle => const TextStyle(
        color: Colors.white,
        fontSize: 16,
      );

  static TextStyle get description => const TextStyle(
        fontSize: StylesFontSizes.m,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: Colors.white70,
      );

  static TextStyle get snackbar => const TextStyle(
        fontSize: StylesFontSizes.s,
        letterSpacing: 0.1,
        color: Colors.white70,
      );
}
