import 'package:flutter/material.dart';

class ThemeColorStyle extends ThemeExtension<ThemeColorStyle> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  const ThemeColorStyle({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  ThemeExtension<ThemeColorStyle> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
  }) {
    return ThemeColorStyle(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
    );
  }

  @override
  ThemeExtension<ThemeColorStyle> lerp(
      ThemeExtension<ThemeColorStyle>? other, double t) {
    if (other is! ThemeColorStyle) {
      return this;
    }
    return ThemeColorStyle(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
    );
  }
}
