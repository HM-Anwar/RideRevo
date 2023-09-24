import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/models/place_id.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/repository/booking_repo.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/views/widgets/app_snackbar.dart';

class BookingController extends GetxController {
  final BookingRepo bookingRepo;

  BookingController({required this.bookingRepo});

  List<Ride>? rides;
  List<Place?> place = [];
  List<bool> isLoadingList = [];

  Mode showLocationButtonMode = Mode.normal;

  List<Color> colors = [];

  Future<void> checkInternet(Function() executeFn) async {
    bool internetAvailable = await hasNetwork();
    if (internetAvailable) {
      await executeFn();
    } else {
      Get.showSnackbar(
        appSnackBar(
          message: 'You don\'t have an Internet Connection',
          isErrorSnackBar: true,
        ),
      );
    }
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void generateRandomColors() {
    Random random = Random();
    for (int i = 0; i < 10; i++) {
      Color color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
      colors.add(color);
    }
  }

  void setShowLocationButtonMode(Mode mode) {
    showLocationButtonMode = mode;
    update();
  }

  Future<void> getRidesHistory(AppMode appMode) async {
    print('===> getRidesHistory');
    rides = null;
    update();

    await checkInternet(() async {
      rides = await bookingRepo.getUserRideHistory(appMode);
      update();
      getLoadingList();
    });
  }

  void getLoadingList() {
    isLoadingList = List.generate(rides!.length, (index) => false);
    update();
  }

  void setLoader(int index, bool isLoading) {
    isLoadingList[index] = isLoading;
    update();
  }

  Future<void> getAddressFromLatLong(LatLng to, LatLng from, int index) async {
    if (place.isEmpty) {
      try {
        setLoader(index, true);
        await checkInternet(() async {
          place.add(await bookingRepo.fetchAddressFromLatLng(to));
          place.add(await bookingRepo.fetchAddressFromLatLng(from));
          update();
        });
        setLoader(index, false);
      } catch (e) {
        setShowLocationButtonMode(Mode.normal);

        print(e);
      }
    }

    // print(place[1]!.formattedAddress);
  }

  void clearPlace() {
    place.clear();
    update();
  }
}
