import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/rider-screen/rider_map_screen.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class PermissionWrapper extends StatefulWidget {
  const PermissionWrapper({Key? key}) : super(key: key);

  @override
  State<PermissionWrapper> createState() => _PermissionWrapperState();
}

class _PermissionWrapperState extends State<PermissionWrapper> {
  final RiderController controller = Get.find<RiderController>();

  @override
  void initState() {
    controller.getLocationPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.serviceEnabled.value == false || controller.serviceEnabled.value == null) {
          return Scaffold(
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    controller.locationButtonMode.value.loading ? "Fetching Location" : "Please allow location permission",
                    textAlign: TextAlign.center,
                    style: Styles.titleStyle,
                  ),
                  const SizedBox(height: 17),
                  controller.locationButtonMode.value.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PrimaryButton(
                          onPressed: controller.getLocationPermission,
                          color: ColorPalette.primaryColor,
                          height: 46,
                          borderRadius: BorderRadius.circular(7),
                          child: const Text(
                            "Turn on Location",
                            style: Styles.poppinsButtonTextStyle,
                          ),
                        ),
                ],
              ),
            ),
          );
        }

        return const RiderMapScreen();
      },
    );
  }
}
