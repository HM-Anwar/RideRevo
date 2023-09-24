import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/images.dart';
import 'package:ride_revo/utils/typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    setAppMode();
    timer = Timer(const Duration(seconds: 2), navigation);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(Images.appLogo),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Ride Revo',
            textAlign: TextAlign.center,
            style: Styles.appNameStyle,
          ),
          Text(
            'Ride with peace of mind',
            textAlign: TextAlign.center,
            style: Styles.poppinsSubtitleStyle.copyWith(
              color: ColorPalette.greyColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  void setAppMode() async {
    final AppController controller = Get.find<AppController>();

    final AppMode? appMode = await controller.getAppMode();
    if (appMode == null) {
      await controller.setAppMode(AppMode.user);
    }
  }

  Future navigation() async {
    if (AuthRepo.getUser == null) {
      Get.offAllNamed(RouteHelper.getAuthRoute);
    } else {
      RouteHelper.checkAndAssignAuthRoute();
    }
  }
}
