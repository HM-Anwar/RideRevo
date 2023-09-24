import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:widget_loading/widget_loading.dart';

class PickCurrentLocation extends StatelessWidget {
  const PickCurrentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        print('Loading ${controller.locationButtonMode.loading}');
        if (controller.locationType!.pickup) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: PrimaryButton(
              onPressed: controller.locationButtonMode.loading ? null : controller.getLocPermissionAndRoute,
              height: 42,
              isHoverDisable: true,
              child: Row(
                children: [
                  const Icon(
                    Icons.gps_fixed,
                    color: ColorPalette.primaryColor,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Select Current Location',
                    style: Styles.poppinsSubtitleStyle.copyWith(
                      color: ColorPalette.greyColor,
                    ),
                  ),
                  const Spacer(),
                  WiperLoading(
                    loading: controller.locationButtonMode.loading,
                    wiperColor: ColorPalette.primaryColor,
                    direction: WiperDirection.left,
                    wiperWidth: 7,
                    child: const SizedBox(
                      width: 65,
                      height: 19,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
