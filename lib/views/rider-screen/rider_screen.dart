import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/views/rider-screen/permission_wrapper/permission_wrapper.dart';
import 'package:ride_revo/views/rider-screen/rider_finished_screen.dart';

class RiderScreen extends GetView<RiderController> {
  const RiderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Ride? ride = controller.ride.value;

      if (ride?.status == Status.pending) {
        Future.delayed(Duration.zero, () {
          Get.offAllNamed(RouteHelper.getRiderNavbarRoute);
        });
      }
      if (ride?.status == Status.completed) {
        return const RiderFinishedScreen();
      }
      if (ride != null && ride.status.isRideAccepted) {
        return const PermissionWrapper();
      }
      if (ride == null) {
        Future.delayed(const Duration(seconds: 3), () {
          Get.offAllNamed(RouteHelper.getRiderNavbarRoute);
        });
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
