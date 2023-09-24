import 'dart:async';
import 'dart:io';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:location/location.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/repository/rider_repo.dart';
import 'package:ride_revo/repository/rider_home_repo.dart';
import 'package:ride_revo/views/widgets/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/enums.dart';

class RiderController extends GetxController {
  final RiderRepo riderRepo;
  RiderController({required this.riderRepo}) {
    executeRide();
  }

  Rx<Ride?> ride = Rx<Ride?>(null);
  StreamSubscription? rideSubscription;
  StreamSubscription? locationSubscription;

  AppUser? user;
  Status buttonStatus = Status.accepted;

  Rx<bool?> serviceEnabled = Rx<bool?>(null);

  Rx<Position?> currentLocation = Rx<Position?>(null);

  // polylines
  Set<Polyline> polyLines = <Polyline>{};
  GoogleMapController? riderMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Rx<Mode> locationButtonMode = Rx<Mode>(Mode.normal);

  void executeAction(Function() fn) async {
    await checkInternet(() async {
      try {
        locationButtonMode.value = Mode.loading;
        await fn();
        locationButtonMode.value = Mode.normal;
      } catch (e) {
        print(e);
        locationButtonMode.value = Mode.normal;
      }
    });
  }

  Future<void> checkInternet(Function() executeFn) async {
    bool internetAvailable = await hasNetwork();
    if (internetAvailable) {
      executeFn();
      return;
    }
    Get.showSnackbar(
      appSnackBar(
        message: 'You don\'t have an Internet Connection',
        isErrorSnackBar: true,
      ),
    );
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> getLocationPermission() async {
    executeAction(() async {
      serviceEnabled.value = false;
      PermissionStatus permissionStatus = PermissionStatus.denied;
      Location location = Location();

      LocationPermission locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
      }
      if (locationPermission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
      permissionStatus = await location.hasPermission();
      await Geolocator.getCurrentPosition();
      serviceEnabled.value = await location.serviceEnabled() && (permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.grantedLimited);
      print('====> LOCATION SERVICE: ${serviceEnabled.value}');
      if (serviceEnabled.value!) {
        getCurrentLocationStream();
      }
    });
  }

  void executeRide() async {
    AppController appController = Get.find<AppController>();
    if (await RiderHomeRepo.isRideExist && appController.appMode == AppMode.rider) {
      getRideStream();
      getUser();
      getCurrentLocationStream();
      everMarkerWhenRideChange();
      everMarkerWhenLocationChange();
    }
  }

  CameraPosition getCameraPosition() {
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      ),
      zoom: 18.0,
    );
    _animateCameraToPosition(cameraPosition);
    return cameraPosition;
  }

  void _animateCameraToPosition(CameraPosition cameraPosition) {
    riderMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  void getUser() async {
    ever(ride, (ride) async {
      if (ride != null) {
        user = await riderRepo.getUser(ride.rideId);
        update();
      }
    });
  }

  void onLaunchDialer() async {
    Uri url = Uri(
      scheme: 'tel',
      path: user!.phoneNumber,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onMapCreated(GoogleMapController controller) {
    riderMapController = controller;

    getPolyline();
    getMarker();
    update();
  }

  void everMarkerWhenRideChange() {
    ever(ride, (ride) {
      getMarker(ride);
    });
  }

  void everMarkerWhenLocationChange() {
    ever(currentLocation, (_) {
      getMarker();
    });
  }

  Future<void> getRideStream() async {
    rideSubscription = riderRepo.getRides().listen((ride) {
      this.ride.value = ride;
      update();
    });
  }

  void getCurrentLocationStream() {
    if (serviceEnabled.value != null && serviceEnabled.value == true) {
      locationSubscription = riderRepo.getCurrentLocation().listen((Position position) {
        print('=======> Location Updated');
        currentLocation.value = position;
        riderRepo.updateRiderLocation(position);
      });
    }
  }

  Future<void> getAcceptedPolyPoints() async {
    if (currentLocation.value != null) {
      PointLatLng? destination = PointLatLng(
        ride.value!.pickupLocation.latitude,
        ride.value!.pickupLocation.longitude,
      );
      PointLatLng? current = PointLatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      );

      // polyLines.clear();
      Polyline updatedPolyline = await riderRepo.polyPoints(destination, current);
      polyLines.add(updatedPolyline);
      update();
    }
  }

  void checkAcceptedStatus() {
    final distance = Geolocator.distanceBetween(
      currentLocation.value?.latitude??0.00,
      currentLocation.value?.longitude??0.00,
      ride.value!.pickupLocation.latitude,
      ride.value!.pickupLocation.longitude,
    );
    print('Distance: ${distance.toStringAsFixed(2)}');
    if (distance < 300) {
      print(currentLocation.value.toString());
      print(ride.value!.pickupLocation.toString());
      buttonStatus = Status.arrived;
      update();
    }
  }

  void checkCompletedStatus() {
    final distance = Geolocator.distanceBetween(
      currentLocation.value!.latitude,
      currentLocation.value!.longitude,
      ride.value!.destinationLocation.latitude,
      ride.value!.destinationLocation.longitude,
    );
    print('Distance: $distance');
    if (distance < 300) {
      buttonStatus = Status.completed;
      update();
    } else {
      buttonStatus = Status.pending;
      update();
    }
  }

  void getPolyline() {
    Ride? ride = this.ride.value;

    if (ride?.status == Status.accepted) {
      polyLines.clear();
      update();
      getAcceptedPolyPoints();
    } else if (ride?.status == Status.riding) {
      polyLines.clear();
      update();
      getRidingPolyLines();
    } else if (ride?.status == Status.arrived) {
      print('=======> PolyPoints Cleared');
      polyLines.clear();
      buttonStatus = Status.riding;
      update();
    }
  }

  void getRidingPolyLines() async {
    print('=======> PolyPoints Updated');
    print(currentLocation.toString());

    if (currentLocation.value != null) {
      PointLatLng? destination = PointLatLng(
        ride.value!.destinationLocation.latitude,
        ride.value!.destinationLocation.longitude,
      );
      PointLatLng? current = PointLatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      );

      // polyLines.clear();
      Polyline updatedPolyline = await riderRepo.polyPoints(destination, current);
      polyLines.add(updatedPolyline);
      update();
    }
  }

  void getMarker([Ride? rideModel]) {
    Ride? ride = rideModel ?? this.ride.value;
    // ever(ride, (ride) {
    if (ride?.status == Status.accepted) {
      markers.clear();
      update();
      getAcceptedMarker();

      // for rider buttons
      checkAcceptedStatus();
    } else if (ride?.status == Status.riding) {
      markers.clear();
      update();
      getRidingMarker();

      // for rider buttons
      checkCompletedStatus();
    } else {
      markers.removeWhere((key, value) => key.value == 'destination');
      update();
    }
    // });
  }

  void getAcceptedMarker() async {
    final marker = Marker(
      markerId: const MarkerId('pickup'),
      position: LatLng(
        currentLocation.value?.latitude ??0.00,
        currentLocation.value?.longitude??0.00,
      ),
    );
    markers[const MarkerId('pickup')] = marker;

    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        ride.value!.pickupLocation.latitude,
        ride.value!.pickupLocation.longitude,
      ),
    );
    markers[const MarkerId('destination')] = destinationMarker;
  }

  void getRidingMarker() async {
    final marker = Marker(
      markerId: const MarkerId('pickup'),
      position: LatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      ),
    );
    markers[const MarkerId('pickup')] = marker;

    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        ride.value!.destinationLocation.latitude,
        ride.value!.destinationLocation.longitude,
      ),
    );
    markers[const MarkerId('destination')] = destinationMarker;
  }

  void onArrivedPressed() {
    riderRepo.onArrivedRide(user!.rideId);
    polyLines.clear();
    buttonStatus = Status.riding;
    update();
  }

  void onStartedPressed() {
    riderRepo.onStartRide(user!.rideId);
    polyLines.clear();
    buttonStatus = Status.pending;
    getRidingPolyLines();
  }

  void onCompletePressed() {
    riderRepo.onCompleteStatus(user!.rideId);
  }

  void onCompleteRide() async {
    await riderRepo.onCompleteRide(ride.value!);
    resetValues();
    Get.offAllNamed(RouteHelper.getRiderNavbarRoute);
  }

  void resetValues() {
    polyLines.clear();
    markers.clear();
    cancelSubscription();
    update();
  }

  void onCancelRide() {
    riderRepo.onCancelRide(user!.rideId);
  }

  void cancelSubscription() {
    rideSubscription?.cancel();
    locationSubscription?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    cancelSubscription();
  }
}
