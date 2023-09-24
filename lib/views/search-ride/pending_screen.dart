import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/ride_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/images.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/scroll_behavior.dart';
import 'package:slider_button/slider_button.dart';
import 'package:widget_loading/widget_loading.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 27,
          elevation: 0,
          title: Text(
            'Search for drivers',
            style: Styles.appBarStyle.copyWith(
              color: ColorPalette.black,
            ),
          ),
          toolbarHeight: 90,
        ),
        body: ScrollConfiguration(
          behavior: HideScrollBehavior(),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(Images.appLogo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      "Searching Riders...",
                      style: Styles.labelStyle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "This may take a few seconds",
                    textAlign: TextAlign.center,
                    style: Styles.labelSubtitleStyle.copyWith(
                      color: ColorPalette.greyColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Image.asset(
                        Images.searchRide,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        width: context.screenWidth,
                        height: context.screenHeight * 0.68,
                      ),
                      Positioned.fill(
                          top: context.screenHeight * 0.07,
                          bottom: context.screenWidth * 0.3,
                          left: context.screenWidth * 0.05,
                          right: context.screenWidth * 0.05,
                          child: const WiperLoading(
                            loading: true,
                            wiperColor: ColorPalette.primaryColor,
                            direction: WiperDirection.down,
                            wiperWidth: 7,
                            child: Text('Loading...'),
                          )),
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: context.screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 60,
                                child: SliderButton(
                                  backgroundColor: ColorPalette.lightGreyColor.withOpacity(0.5),
                                  width: context.screenWidth * 0.7,
                                  buttonColor: ColorPalette.primaryColor.withOpacity(0.5),
                                  buttonSize: 48,
                                  vibrationFlag: true,
                                  label: const Text(
                                    'Slide to cancel',
                                    style: Styles.labelStyle,
                                  ),
                                  icon: const Icon(
                                    Icons.close,
                                    size: 24,
                                  ),
                                  action: () {
                                    controller.onCancelSearchRide();
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Spacer(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
