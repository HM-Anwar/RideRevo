import 'package:flutter/material.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/typography.dart';

@immutable
class AppDecoration {
  const AppDecoration._();

  static InputDecoration textFieldDecoration = InputDecoration(
    isDense: true,
    fillColor: ColorPalette.lightGreyColor.withOpacity(0.2),
    filled: true,
    hintStyle: Styles.poppinsSubtitleStyle.copyWith(
      color: ColorPalette.greyColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: ColorPalette.lightGreyColor.withOpacity(0.2),
      ),
    ),
  );

  static InputDecoration locationFieldDecoration = InputDecoration(
    isDense: true,
    fillColor: ColorPalette.lightGreyColor.withOpacity(0.2),
    filled: true,
    hintStyle: Styles.poppinsSubtitleStyle.copyWith(
      color: ColorPalette.greyColor,
    ),
    focusColor: ColorPalette.primaryColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: ColorPalette.primaryColor),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: ColorPalette.primaryColor),
    ),
  );
}
