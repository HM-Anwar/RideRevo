import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/controller/ride_controller.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class AcceptScreen extends StatelessWidget {
  AcceptScreen({Key? key}) : super(key: key);

  final Completer<GoogleMapController> mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (controller) {
      Rider? rider = controller.rider;
      if (rider == null) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: controller.getCameraPosition(),
              markers: controller.getRiderMarkers(),
              onMapCreated: controller.onMapCreated,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: context.screenWidth,
                height: context.screenHeight * 0.31,
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
                          const Center(
                            child: Text(
                              'Driver Details',
                              style: Styles.labelStyle,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(color: ColorPalette.lightGreyColor),
                          const SizedBox(height: 5),
                          ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage: rider.imageUrl != null
                                  ? NetworkImage(rider.imageUrl!)
                                  : const NetworkImage(
                                      'https://i.pravatar.cc/150?img=3',
                                    ),
                            ),
                            title: Text(
                              rider.name,
                              style: Styles.titleStyle,
                            ),
                            subtitle: Text(
                              '${rider.bikeName} ${rider.bikeModel}',
                              style: Styles.labelTitleStyle,
                            ),
                            trailing: Text(
                              rider.bikeRegNo,
                              style: Styles.labelStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PrimaryButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            title: const Text(
                                              'Cancel Ride',
                                              style: Styles.labelStyle,
                                            ),
                                            content: const Text(
                                              'Are you sure you want to cancel the ride?',
                                              style: Styles.labelSubtitleStyle,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text(
                                                  'No',
                                                  style: Styles.poppinsButtonTextStyle,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                  controller.onCancelRide();
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: Styles.poppinsButtonTextStyle.copyWith(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ));
                                },
                                isCircleBorder: true,
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundColor: ColorPalette.primaryColor.withOpacity(0.3),
                                  child: const Icon(
                                    Icons.close,
                                    color: ColorPalette.black,
                                  ),
                                ),
                              ),
                              PrimaryButton(
                                onPressed: controller.onLaunchDialer,
                                isCircleBorder: true,
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundColor: ColorPalette.primaryColor.withOpacity(0.8),
                                  child: const Icon(
                                    Icons.call,
                                    color: ColorPalette.greyColor,
                                  ),
                                ),
                              ),
                            ],
                          )
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
