import 'package:flutter/material.dart';

import 'base_theme.dart';
import 'styling/theme_color_style.dart';

class LightTheme extends BaseTheme {
  @override
  BackgroundTheme get backgroundTheme {
    return const BackgroundTheme(
      primaryColor: Color(0xFFFEBB1B),
      secondaryColor: Color(0xFFFFFFFF),
      tertiaryColor: Color(0xFF35383F),
    );
  }

  @override
  ThemeColorStyle get themeColorStyle {
    return const ThemeColorStyle(
      primaryColor: Color(0xFFFEBB1B),
      secondaryColor: Color(0xFFFFFFFF),
      tertiaryColor: Color(0xFF35383F),
    );
  }

  @override
  FontTheme get fontTheme {
    return const FontTheme(
      heading1: TextStyle(
        fontSize: 26,
      ),
      heading2: TextStyle(
        fontSize: 24,
      ),
      heading3: TextStyle(
        fontSize: 22,
        height: 1.4,
      ),
      body1: TextStyle(
        fontSize: 20,
        height: 1.4,
      ),
      body2: TextStyle(
        fontSize: 18,
        height: 1.4,
      ),
      caption: TextStyle(
        fontSize: 16,
      ),
    );
  }

  @override
  FontFamily get fontFamily {
    return FontFamily(
      primary: 'Inter',
      secondary: 'Poppins',
      tertiary: 'NotoSans',
    );
  }
}
