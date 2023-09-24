import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/typography.dart';

GetSnackBar appSnackBar({required String message, bool isErrorSnackBar = false}) {
  return GetSnackBar(
    messageText: Text(
      message,
      style: Styles.poppinsTitleStyle.copyWith(
        color: Colors.white,
      ),
    ),
    borderRadius: 7,
    margin: const EdgeInsets.all(14),
    padding: EdgeInsets.all(12),
    backgroundColor: !isErrorSnackBar ? ColorPalette.primaryColor : Colors.red,
    duration: const Duration(seconds: 1),
  );
}
