import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AppSwitcher extends StatelessWidget {
  const AppSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (controller) {
      final AppMode? appMode = controller.appMode;
      return ToggleSwitch(
        minWidth: 52,
        // cornerRadius: 20.0,
        radiusStyle: true,
        initialLabelIndex: controller.appMode!.user ? 0 : 1,
        activeFgColor: Colors.white,
        inactiveBgColor: ColorPalette.lightGreyColor.withOpacity(0.7),
        totalSwitches: 2,
        iconSize: 40.0,
        customTextStyles: const [
          Styles.poppinsTitleStyle,
        ],
        customIcons: [
          Icon(
            Icons.person,
            size: 20,
            color: appMode!.user ? Colors.white : Colors.black.withOpacity(0.7),
          ),
          Icon(
            Icons.sports_motorsports,
            size: 20,
            color: !appMode.user ? Colors.white : Colors.black.withOpacity(0.7),
          ),
        ],
        activeBgColors: const [
          [ColorPalette.primaryColor],
          [Colors.pink]
        ],

        onToggle: controller.onToggleMode,
      );
    });
  }
}
