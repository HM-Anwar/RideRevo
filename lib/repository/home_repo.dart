import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/constants.dart';
import 'package:uuid/uuid.dart';

class HomeRepo {
  Future<void> setPermissions() async {
    await Permission.location.request();
  }

  Future<Polyline> polyPoints(PointLatLng point, PointLatLng position) async {
    final polyLineCoordinates = <LatLng>[];
    PointLatLng currentLocation = PointLatLng(position.latitude, position.longitude);
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.GOOGLE_MAP_API_KEY,
      currentLocation,
      point,
      travelMode: TravelMode.driving,
    );
    for (var point in result.points) {
      polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
    Uuid uuid = const Uuid();
    var polylineId = uuid.v4();
    Polyline polyline = Polyline(
      polylineId: PolylineId(polylineId),
      points: polyLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      color: ColorPalette.primaryColor,
    );
    return polyline;
  }

  Future<void> createRide(Ride ride) async {
    try {
      await FirebaseFirestore.instance.collection("rides").doc(ride.rideId).set(ride.toJson());
    } catch (e) {
      print(e);
    }
  }
}
