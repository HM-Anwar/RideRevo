import 'package:flutter/material.dart';
import 'package:ride_revo/utils/color_palette.dart';

import 'styling/theme_color_style.dart';

class BackgroundTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  const BackgroundTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });
}

class FontTheme {
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle heading3;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle caption;

  const FontTheme({
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.body1,
    required this.body2,
    required this.caption,
  });
}

class FontFamily {
  final String primary;
  final String secondary;
  final String tertiary;

  FontFamily({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });
}

abstract class BaseTheme {
  ThemeColorStyle get themeColorStyle;

  BackgroundTheme get backgroundTheme;

  FontTheme get fontTheme;

  FontFamily get fontFamily;

  ThemeData get theme {
    return ThemeData(
      primaryColor: backgroundTheme.primaryColor,
      fontFamily: fontFamily.primary,
      colorScheme: ThemeData().colorScheme.copyWith(primary: ColorPalette.greyColor),
      appBarTheme: AppBarTheme(
        color: backgroundTheme.primaryColor,
      ),
      textTheme: TextTheme(
        headlineLarge: fontTheme.heading1,
        headlineMedium: fontTheme.heading2,
        headlineSmall: fontTheme.heading3,
        bodyLarge: fontTheme.body1,
        bodyMedium: fontTheme.body2,
        labelLarge: fontTheme.caption,
      ),
      extensions: <ThemeExtension<dynamic>>{
        themeColorStyle,
      },
    );
  }
}
