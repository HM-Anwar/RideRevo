import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/repository/ride_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class RideController extends GetxController {
  final RideRepo rideRepo;
  RideController({required this.rideRepo});

  StreamSubscription? rideSubscription;
  StreamSubscription? riderDetailSubscription;
  Rx<Ride?> ride = Rx(null);
  Rider? rider;
  BitmapDescriptor? riderMarkerIcon;

  GoogleMapController? mapController;

  void initializeStreamsAndMakerIcon(){
    getRideStream();
    getRiderDetailStream();
    loadRiderMarkerIcon();
  }

  void onLaunchDialer() async {
    Uri url = Uri(
      scheme: 'tel',
      path: rider!.phoneNo,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    update();
  }

  void _animateCameraToPosition(CameraPosition cameraPosition) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  CameraPosition getCameraPosition() {
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(
        rider!.location!.latitude,
        rider!.location!.longitude,
      ),
      zoom: 18.0,
    );
    _animateCameraToPosition(cameraPosition);
    return cameraPosition;
  }

  Set<Marker> getRiderMarkers() {
    return {
      Marker(
        markerId: const MarkerId('rider'),
        position: LatLng(rider!.location!.latitude, rider!.location!.longitude),
        icon: riderMarkerIcon!,
      ),
    };
  }

  void onCancelSearchRide() async {
    Get.find<HomeController>().resetLocationValues(allReset: true);
    String rideId = AuthRepo.getUser!.uid;

    await rideRepo.onCancelSearchRide(rideId);
    Get.offAllNamed(RouteHelper.getHomeRoute);
  }

  void onCancelRide() async {
    String rideId = AuthRepo.getUser!.uid;
    await rideRepo.onCancelRide(rideId);
  }

  void getRideStream() async {
    if (await RideRepo.isUserRideExist) {
      rideSubscription = rideRepo.getRides().listen((rideData) {
        ride.value = rideData;
        update();
      });
    }
  }

  void getRiderDetailStream() async {
    ever<Ride?>(ride, (ride) {
      if (ride?.driverId != null) {
        String riderId = ride!.driverId!;
        riderDetailSubscription = rideRepo.getRiderDetails(riderId).listen((riderData) {
          rider = riderData;
          update();
        });
      }
    });
  }

  void onCompleteRide() async {
    await rideRepo.onCompleteRide(ride.value!);
    Get.find<HomeController>().resetLocationValues(allReset: true);
    Get.offAllNamed(RouteHelper.getHomeRoute);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    return await rideRepo.getBytesFromAsset(path, width);
  }

  Future<void> loadRiderMarkerIcon() async {
    ever<Ride?>(ride, (ride) async {
      if (ride?.driverId != null && riderMarkerIcon == null) {
        print('loadRiderMarkerIcon');
        final Uint8List markerIconData = await getBytesFromAsset('assets/images/rider-marker.png', 130);
        riderMarkerIcon = BitmapDescriptor.fromBytes(markerIconData);
        update();
      }
    });
  }

  void resetValues() {
    cancelStream();
    mapController?.dispose();

    ride.value = null;
    rider = null;
    riderMarkerIcon = null;
    update();
  }

  void cancelStream() {
    rideSubscription?.cancel();
    riderDetailSubscription?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();

    cancelStream();
  }
}
