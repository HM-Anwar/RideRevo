import 'package:flutter/material.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/typography.dart';

class MainAppBar extends AppBar {
  MainAppBar({super.key, required String title, bool isCenter = false, Widget? actionButton, Widget? leading})
      : super(
          backgroundColor: Colors.white,
          titleSpacing: 27,
          elevation: 0,
          leadingWidth: 0,
          centerTitle: isCenter,
          title: leading == null
              ? Text(
                  title,
                  style: Styles.appBarStyle.copyWith(
                    color: ColorPalette.black,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    leading,
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: Styles.appBarStyle.copyWith(
                        color: ColorPalette.black,
                      ),
                    ),
                  ],
                ),
          toolbarHeight: 90,
          actions: actionButton != null ? [actionButton] : null,
        );
}
