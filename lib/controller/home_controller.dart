import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_revo/controller/ride_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/models/auto_complete_prediction.dart';
import 'package:ride_revo/models/place_id.dart' as model;
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/repository/api_repo.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/repository/home_repo.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/views/widgets/app_snackbar.dart';

class HomeController extends GetxController {
  final HomeRepo homeRepo;
  final ApiRepo apiRepo;
  HomeController({required this.apiRepo, required this.homeRepo});
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String searchLocation = '';
  AutoCompletePrediction? autoCompletePrediction;
  Timer? timer;

  Prediction? selectedPredictLocation;
  LatLng? selectedMoveLatLong;
  model.Place? selectedLocation;

  LocationType? locationType;
  model.Place? pickUpLocation;
  model.Place? destinationLocation;
  Mode mode = Mode.normal;

  // fare and distance
  double distanceInKm = 0.0;
  double estimatedFare = 0.0;

  // Polylines
  Set<Polyline> polyLines = <Polyline>{};

  // Home Map Config
  GoogleMapController? homeMapController;
  Map<MarkerId, Marker> homeMarkers = <MarkerId, Marker>{};
  CameraPosition homeCameraPosition = const CameraPosition(
    target: LatLng(24.8967, 67.0197),
    zoom: 14,
  );
  // Location Calculations
  double? zoomLevel;
  double? centerLatitude;
  double? centerLongitude;

  // Location Button Config
  Mode locationButtonMode = Mode.normal;

  // location Service
  Rx<bool> serviceEnabled = Rx<bool>(false);

  void executeAction(Function() fn) async {
    await checkInternet(() async {
      try {
        locationButtonMode = Mode.loading;
        update();
        await fn();
        locationButtonMode = Mode.normal;
        update();
      } catch (e) {
        print(e);
        locationButtonMode = Mode.normal;
        update();
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

  Future<void> getLocPermissionAndRoute() async {
    executeAction(() async {
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
      Position currentPosition = await Geolocator.getCurrentPosition();
      serviceEnabled.value = await location.serviceEnabled() && (permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.grantedLimited);
      print('====> LOCATION SERVICE: ${serviceEnabled.value}');
      if (serviceEnabled.value) {
        onSelectLiveLocation(currentPosition);
      }
    });
  }

  void onSelectLiveLocation(Position currentPosition) {
    model.Place place = model.Place(
      location: model.Location(
        lat: currentPosition.latitude,
        lng: currentPosition.longitude,
      ),
      formattedAddress: '',
    );
    updateSelectedLocation(place);

    Get.offAllNamed(RouteHelper.getPickLocationRoute);
  }

  void setCameraBetween2points() {
    centerLatitude = (pickUpLocation!.location.lat + destinationLocation!.location.lat) / 2;
    centerLongitude = (pickUpLocation!.location.lng + destinationLocation!.location.lng) / 2;
  }

  void calculateZoomLevel(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
    double mapWidth,
    double mapHeight,
  ) {
    const double WORLD_WIDTH = 256;
    const double ZOOM_MAX = 21;

    double latDiff = (lat1 - lat2).abs();
    double lngDiff = (lon1 - lon2).abs();

    double latZoom = log(mapHeight * WORLD_WIDTH / (latDiff * 256)) / log(2);
    double lngZoom = log(mapWidth * WORLD_WIDTH / (lngDiff * 256)) / log(2);
    double zoom = min(latZoom, lngZoom);

    zoomLevel = max(0, min(zoom, ZOOM_MAX));
  }

  CameraPosition getCameraLocation() {
    if (pickUpLocation != null) {
      homeCameraPosition = CameraPosition(
        target: LatLng(
          pickUpLocation!.location.lat,
          pickUpLocation!.location.lng,
        ),
        zoom: 16.0,
      );
    }
    if (locationAdded) {
      setCameraBetween2points();
      calculateZoomLevel(
        pickUpLocation!.location.lat,
        pickUpLocation!.location.lng,
        destinationLocation!.location.lat,
        destinationLocation!.location.lng,
        Get.width,
        Get.height,
      );
      homeCameraPosition = CameraPosition(
        target: LatLng(
          centerLatitude!,
          centerLongitude!,
        ),
        zoom: zoomLevel!,
      );
    }

    return homeCameraPosition;
  }

  void onCreateHomeMarkers() {
    if (pickUpLocation != null) {
      final marker = Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          pickUpLocation!.location.lat,
          pickUpLocation!.location.lng,
        ),
      );
      homeMarkers[const MarkerId('pickup')] = marker;
    }
    if (destinationLocation != null) {
      final marker = Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          destinationLocation!.location.lat,
          destinationLocation!.location.lng,
        ),
      );
      homeMarkers[const MarkerId('destination')] = marker;
    }
  }

  void onHomeMapCreated(GoogleMapController controller) {
    homeMapController = controller;
    onCreateHomeMarkers();
    // onAnimateHomeCameraToPosition();
    if (locationAdded) {
      getPolyPoints();
      calculateDistanceAndFare();
      print('===> Location added');
    }
    update();
  }

  void setLocationType(LocationType type) {
    locationType = type;
    update();
  }

  Future<void> setLocationPermissions() async {
    await homeRepo.setPermissions();
  }

  void onChangedSearchLocation(String value) {
    searchLocation = value;
    update();

    if (timer?.isActive ?? false) timer!.cancel();

    if (value.length > 2) {
      timer = Timer(const Duration(milliseconds: 500), () {
        getPredictLocation();
      });
    }
    update();
  }

  void getPredictLocation() async {
    autoCompletePrediction = await apiRepo.fetchPredictLocation(searchLocation);
    update();
  }

  void setPredictedLocation(Prediction predictedLocation) {
    selectedPredictLocation = predictedLocation;
    update();
  }

  Future<void> setSelectedLocation(Prediction prediction) async {
    model.Place? placeId = await apiRepo.fetchLatLngFromPlaceId(prediction.placeId);
    updateSelectedLocation(placeId!);
  }

  void updateSelectedLocation(model.Place placeId) {
    selectedLocation = placeId;
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    selectedMoveLatLong = LatLng(
      selectedLocation!.location.lat,
      selectedLocation!.location.lng,
    );
    final marker = Marker(
        markerId: const MarkerId('place_name'),
        position: LatLng(
          selectedLocation!.location.lat,
          selectedLocation!.location.lng,
        ));

    markers[const MarkerId('place_name')] = marker;
    update();
  }

  void onCameraMove(CameraPosition position) {
    selectedMoveLatLong = position.target;

    final marker = Marker(
      markerId: const MarkerId('place_name'),
      position: position.target,
    );

    markers[const MarkerId('place_name')] = marker;
    update();
  }

  set setMode(Mode mode) {
    this.mode = mode;
    update();
  }

  Future<void> onConfirmLocation() async {
    await executeLoader(() async {
      model.Place? place = await apiRepo.fetchAddressFromLatLng(selectedMoveLatLong!);
      if (locationType!.pickup) {
        pickUpLocation = place;
      } else {
        destinationLocation = place;
      }
      resetLocationValues();
    });

    Get.offAllNamed(RouteHelper.getHomeRoute);
  }

  Future<void> getPolyPoints() async {
    PointLatLng? destination = PointLatLng(
      destinationLocation!.location.lat,
      destinationLocation!.location.lng,
    );
    PointLatLng? current = PointLatLng(
      pickUpLocation!.location.lat,
      pickUpLocation!.location.lng,
    );

    // polyLines.clear();
    Polyline updatedPolyline = await homeRepo.polyPoints(destination, current);
    polyLines.add(updatedPolyline);
    update();
  }

  void calculateDistanceAndFare() {
    final distance = Geolocator.distanceBetween(
      pickUpLocation!.location.lat,
      pickUpLocation!.location.lng,
      destinationLocation!.location.lat,
      destinationLocation!.location.lng,
    );

    double km = distance / 1000;
    distanceInKm = km;
    estimatedFare = distanceInKm * 70;
  }

  Future<void> onSearchRide() async {
    await executeLoader(() async {
      String rideId = AuthRepo.getUser!.uid;

      LatLng pickUpLatLng = LatLng(
        pickUpLocation!.location.lat,
        pickUpLocation!.location.lng,
      );
      LatLng destinationLatLng = LatLng(
        destinationLocation!.location.lat,
        destinationLocation!.location.lng,
      );

      Ride ride = Ride(
        rideId: rideId,
        status: Status.pending,
        pickupLocation: pickUpLatLng,
        destinationLocation: destinationLatLng,
        estimateFare: estimatedFare.toPrecision(2),
        estimateDistance: distanceInKm.toPrecision(2),
        createdAt: DateTime.now(),
      );

      await homeRepo.createRide(ride);
    });
    Get.offAllNamed(RouteHelper.getSearchRideRoute);
  }

  void resetLocationValues({bool allReset = false}) {
    markers = <MarkerId, Marker>{};
    autoCompletePrediction = null;
    searchLocation = '';
    selectedPredictLocation = null;
    selectedMoveLatLong = null;
    selectedLocation = null;
    locationType = null;
    timer?.cancel();

    if (allReset == true) {
      pickUpLocation = null;
      destinationLocation = null;
      polyLines = <Polyline>{};
      homeMarkers = <MarkerId, Marker>{};
      distanceInKm = 0.0;
      estimatedFare = 0.0;
      Get.find<RideController>().cancelStream();
    }

    update();
  }

  Future<void> executeLoader(Function() function) async {
    try {
      setMode = Mode.loading;
      await function();
      setMode = Mode.normal;
    } catch (e) {
      setMode = Mode.normal;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('Home Controller Disposed');
    homeMapController?.dispose();
    timer?.cancel();
  }
}
