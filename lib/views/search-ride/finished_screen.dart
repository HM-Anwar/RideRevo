import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/ride_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/images.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:unicons/unicons.dart';

class FinishedScreen extends StatelessWidget {
  const FinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (controller) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              Images.arrivedLogo,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 19),
            const Text(
              'You have arrived at\nyour destination',
              textAlign: TextAlign.center,
              style: Styles.labelStyle,
            ),
            const SizedBox(height: 12),
            const Text(
              'See you on the next trip!',
              textAlign: TextAlign.center,
              style: Styles.labelSubtitleStyle,
            ),
            const SizedBox(height: 42),
            const Text(
              'Please pay the driver',
              textAlign: TextAlign.center,
              style: Styles.labelSubtitleStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  UniconsLine.receipt,
                  size: 32,
                ),
                const SizedBox(width: 7),
                Text(
                  'PKR ${controller.ride.value!.estimateFare.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: Styles.labelStyle,
                ),
              ],
            ),
            const SizedBox(height: 23),
            const Icon(
              UniconsLine.map_marker,
              size: 32,
            ),
            Text(
              '${controller.ride.value!.estimateDistance.toStringAsFixed(2)} km',
              textAlign: TextAlign.center,
              style: Styles.labelStyle,
            ),
            const SizedBox(height: 32),
            const Text(
              'Thank you for using Ride Revo',
              textAlign: TextAlign.center,
              style: Styles.labelSubtitleStyle,
            ),
            const SizedBox(height: 37),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: PrimaryButton(
                onPressed: controller.onCompleteRide,
                height: 57,
                color: ColorPalette.primaryColor,
                borderRadius: BorderRadius.circular(12),
                child: const Text(
                  'Return to Home',
                  style: Styles.poppinsButtonTextStyle,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
