import 'package:flutter/material.dart';

import 'font_sizes.dart';

class StylesFontStyles {
  static TextStyle get headline1 => const TextStyle(
        fontSize: StylesFontSizes.xxl,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.black,
      );

  static TextStyle get headline2 => const TextStyle(
        fontSize: StylesFontSizes.xl,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.4,
        color: Colors.black,
      );

  static TextStyle get title => const TextStyle(
        fontSize: StylesFontSizes.l,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
        color: Colors.black,
      );

  static TextStyle get subtitle => const TextStyle(
        fontSize: StylesFontSizes.m,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: Colors.black87,
      );
}
