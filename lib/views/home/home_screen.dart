import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';

import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/decoration.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/home/widgets/screens_menu.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
   HomeController homeController = Get.find<HomeController>();
   homeController.setLocationPermissions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: context.screenHeight,
              width: context.screenWidth,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: controller.homeMarkers.values.toSet(),
                initialCameraPosition: controller.getCameraLocation(),
                polylines: controller.polyLines,
                onMapCreated: controller.onHomeMapCreated,
              ),
            ),
            const Positioned(
              top: 52,
              right: 24,
              child: ScreensMenu(),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: context.screenWidth,
                height: context.screenHeight * 0.34,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Container(
                      width: 72,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: ColorPalette.lightGreyColor,
                      ),
                    ),
                    const SizedBox(height: 21),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryButton(
                            onPressed: () {
                              controller.setLocationType(LocationType.pickup);
                              Get.offAllNamed(RouteHelper.getSearchLocationRoute());
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: TextEditingController(text: controller.pickUpLocation?.formattedAddress),
                              decoration: AppDecoration.locationFieldDecoration.copyWith(
                                hintText: 'Where you live?',
                                hintStyle: Styles.hintTextStyle.copyWith(
                                  color: ColorPalette.greyColor,
                                ),
                                prefixIcon: const Icon(UniconsSolid.house_user),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          PrimaryButton(
                            onPressed: () {
                              controller.setLocationType(LocationType.destination);
                              Get.offAllNamed(RouteHelper.getSearchLocationRoute());
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: TextEditingController(text: controller.destinationLocation?.formattedAddress),
                              decoration: AppDecoration.locationFieldDecoration.copyWith(
                                hintText: 'Where would you go?',
                                hintStyle: Styles.hintTextStyle.copyWith(
                                  color: ColorPalette.greyColor,
                                ),
                                prefixIcon: const Icon(Icons.location_on_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(height: 19),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                UniconsLine.map_pin_alt,
                                color: ColorPalette.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${controller.distanceInKm.toStringAsFixed(2)} km',
                                style: Styles.labelTitleStyle.copyWith(
                                  color: ColorPalette.greyColor,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                UniconsLine.wallet,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'PKR ${controller.estimatedFare.toStringAsFixed(2)}',
                                style: Styles.labelTitleStyle.copyWith(
                                  color: ColorPalette.greyColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 14),
                              controller.mode.loading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: ColorPalette.primaryColor,
                                      ),
                                    )
                                  : PrimaryButton(
                                      color: ColorPalette.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                      width: context.screenWidth,
                                      height: 57,
                                      onPressed: controller.locationAdded ? controller.onSearchRide : null,
                                      child: const Text(
                                        'Confirm Ride',
                                        style: Styles.poppinsButtonTextStyle,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
