import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';

import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class PickLocationScreen extends StatelessWidget {
  const PickLocationScreen({Key? key}) : super(key: key);
  static LatLng? location;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(RouteHelper.getSearchLocationRoute());
        return true;
      },
      child: GetBuilder<HomeController>(builder: (controller) {
        if (controller.selectedLocation != null) {
          location = LatLng(
            controller.selectedLocation!.location.lat,
            controller.selectedLocation!.location.lng,
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: location!,
                  zoom: 16.4746,
                ),
                onMapCreated: controller.onMapCreated,
                markers: Set<Marker>.of(controller.markers.values),
                onCameraMove: controller.onCameraMove,
              ),
              Positioned(
                bottom: 27,
                left: 24,
                right: 24,
                child: controller.mode.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.primaryColor,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : PrimaryButton(
                        width: context.screenWidth,
                        height: 57,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () async {
                          await controller.onConfirmLocation();
                        },
                        color: ColorPalette.primaryColor,
                        child: const Text(
                          'Confirm Location',
                          style: Styles.poppinsButtonTextStyle,
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
