import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/controller/rider_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';

import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class RiderMapScreen extends StatelessWidget {
  const RiderMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(builder: (controller) {
      return Scaffold(
        body: controller.user == null || controller.ride.value == null || controller.currentLocation.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  SizedBox(
                    height: context.screenHeight,
                    width: context.screenWidth,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: controller.markers.values.toSet(),
                      initialCameraPosition: controller.getCameraPosition(),
                      polylines: controller.polyLines,
                      zoomControlsEnabled: false,
                      onMapCreated: controller.onMapCreated,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: context.screenWidth,
                      height: context.screenHeight * 0.29,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(27),
                          topRight: Radius.circular(27),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(children: [
                        const SizedBox(height: 14),
                        Container(
                          width: 72,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: ColorPalette.lightGreyColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 21),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Ride Details',
                                  style: Styles.labelStyle,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Divider(color: ColorPalette.lightGreyColor),
                              const SizedBox(height: 4),
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: controller.user?.imageUrl != null
                                      ? NetworkImage(controller.user!.imageUrl!)
                                      : const NetworkImage(
                                          'https://i.pravatar.cc/150?img=7',
                                        ),
                                ),
                                title: Text(
                                  controller.user!.name.capitalizeFirst!,
                                  style: Styles.titleStyle,
                                ),
                                subtitle: Text(
                                  '${controller.ride.value!.estimateDistance.toStringAsFixed(2)} km',
                                  style: Styles.labelStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: PrimaryButton(
                                  onPressed: controller.onLaunchDialer,
                                  isCircleBorder: true,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: ColorPalette.primaryColor.withOpacity(0.8),
                                    child: const Icon(
                                      Icons.call,
                                      color: ColorPalette.greyColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: context.screenHeight * 0.02),
                              riderButton(context, controller),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget riderButton(BuildContext context, RiderController controller) {
    print('button status: ${controller.buttonStatus}');
    if (controller.buttonStatus == Status.arrived) {
      return Row(
        children: [
          Expanded(child: cancelButton(context, controller)),
          Expanded(
            flex: 4,
            child: PrimaryButton(
              onPressed: () {
                controller.onArrivedPressed();
              },
              width: context.screenWidth * 0.5,
              height: 57,
              borderRadius: BorderRadius.circular(7),
              color: ColorPalette.primaryColor.withOpacity(0.8),
              child: const Text(
                'Arrived',
                style: Styles.poppinsButtonTextStyle,
              ),
            ),
          ),
        ],
      );
    }
    if (controller.buttonStatus == Status.riding) {
      return Row(
        children: [
          Expanded(child: cancelButton(context, controller)),
          Expanded(
            flex: 4,
            child: PrimaryButton(
              onPressed: () {
                controller.onStartedPressed();
              },
              width: context.screenWidth * 0.5,
              height: 57,
              borderRadius: BorderRadius.circular(7),
              color: ColorPalette.primaryColor.withOpacity(0.8),
              child: const Text(
                'Start Ride',
                style: Styles.poppinsButtonTextStyle,
              ),
            ),
          ),
        ],
      );
    }
    if (controller.buttonStatus == Status.completed) {
      return PrimaryButton(
        onPressed: () {
          controller.onCompletePressed();
        },
        width: context.screenWidth,
        height: 57,
        borderRadius: BorderRadius.circular(7),
        color: ColorPalette.primaryColor.withOpacity(0.8),
        child: const Text(
          'Finished Ride',
          style: Styles.poppinsButtonTextStyle,
        ),
      );
    }
    return PrimaryButton(
      onPressed: () {
        showDialog(context: context, builder: (context) => cancelDialog(controller));
      },
      borderRadius: BorderRadius.circular(9),
      width: context.screenWidth,
      height: context.screenHeight * 0.07,
      borderSide: const BorderSide(color: ColorPalette.black),
      child: const Text(
        "Cancel Ride",
        style: Styles.poppinsButtonTextStyle,
      ),
    );
  }

  PrimaryButton cancelButton(BuildContext context, RiderController controller) {
    return PrimaryButton(
      onPressed: () {
        showDialog(context: context, builder: (context) => cancelDialog(controller));
      },
      isCircleBorder: true,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: ColorPalette.primaryColor.withOpacity(0.3),
        child: const Icon(
          Icons.close,
          color: ColorPalette.black,
        ),
      ),
    );
  }

  AlertDialog cancelDialog(RiderController controller) {
    return AlertDialog(
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
            controller.onCancelRide();
            Get.offAllNamed(RouteHelper.getRiderNavbarRoute);
          },
          child: Text(
            'Yes',
            style: Styles.poppinsButtonTextStyle.copyWith(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
