import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:ride_revo/controller/booking_controller.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/views/booking/widgets/booking_card.dart';
import 'package:ride_revo/views/widgets/main_appbar.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  AppMode get appMode => Get.find<AppController>().appMode!;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    final controller = Get.find<BookingController>();
    print('===> BookingScreen Mode ${widget.appMode}');
    controller.getRidesHistory(widget.appMode);
    controller.generateRandomColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: MainAppBar(
          title: 'Rides History',
          isCenter: true,
          actionButton: PrimaryButton(
            isHoverDisable: true,
            padding: const EdgeInsets.all(44),
            onPressed: () => controller.getRidesHistory(widget.appMode),
            child: const Icon(Icons.refresh),
          ),
        ),
        body: controller.rides == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.rides!.length,
                itemBuilder: (context, index) {
                  Ride ride = controller.rides![index];
                  LatLng to = ride.pickupLocation;
                  LatLng from = ride.destinationLocation;
                  return BookingCard(
                    boxColor: controller.colors[index],
                    appMode: widget.appMode,
                    isLoading: controller.isLoadingList[index],
                    onPressed: () async {
                      await controller.getAddressFromLatLong(to, from, index);
                      if (context.mounted && controller.place.isNotEmpty) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return showLocationDialog(controller);
                          },
                        );
                      }
                    },
                    createdAt: ride.createdAt,
                    amount: ride.estimateFare,
                    distance: ride.estimateDistance,
                  );
                },
              ),
      );
    });
  }

  AlertDialog showLocationDialog(BookingController controller) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      title: Column(
        children: [
          Text(controller.place[0]!.formattedAddress),
          const Icon(
            Icons.route,
            size: 50,
            color: ColorPalette.primaryColor,
          ),
        ],
      ),
      content: Text(controller.place[1]!.formattedAddress),
      actions: [
        TextButton(
            onPressed: () {
              controller.clearPlace();
              Get.back();
            },
            child: const Text('Close'))
      ],
    );
  }
}
