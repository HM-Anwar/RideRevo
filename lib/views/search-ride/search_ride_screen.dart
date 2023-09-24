import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/ride_controller.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/views/search-ride/accept_screen.dart';
import 'package:ride_revo/views/search-ride/finished_screen.dart';
import 'package:ride_revo/views/search-ride/pending_screen.dart';

class SearchRideScreen extends StatefulWidget {
  const SearchRideScreen({super.key});

  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen> {
  final RideController controller = Get.find<RideController>();

  @override
  void initState() {
    controller.initializeStreamsAndMakerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.ride.value == null) {
          controller.getRideStream();
        }
        if (controller.ride.value != null) {
          print(controller.ride.value!.status);
          switch (controller.ride.value!.status) {
            case Status.pending:
              return const PendingScreen();
            case Status.accepted:
            case Status.arrived:
            case Status.riding:
              return AcceptScreen();

            case Status.completed:
              return const FinishedScreen();
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
