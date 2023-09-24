import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/constants.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:uuid/uuid.dart';

class RiderRepo {
  Future<AppUser?> getUser(String rideId) async {
    AppUser? user;
    try {
      final riderDoc = await FirebaseFirestore.instance.collection("users").doc(rideId).get();
      user = AppUser.fromJson(riderDoc.data()!);
    } catch (e) {
      debugPrint(e.toString());
    }
    return user;
  }

  Stream<Ride?> getRides() {
    try {
      final riderId = AuthRepo.getUser!.uid;
      return FirebaseFirestore.instance
          .collection("rides")
          .where(
            'driverId',
            isEqualTo: riderId,
          )
          .snapshots()
          .asyncMap((event) {
        if (event.docs.isEmpty) return null;
        return Ride.fromJson(event.docs.first.data());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return const Stream.empty();
  }

  Stream<Position> getCurrentLocation() {
    try {
      return Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 10,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return const Stream.empty();
  }

  Future<void> updateRiderLocation(Position position) async {
    try {
      final riderId = AuthRepo.getUser!.uid;
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('riders/$riderId');
      RiderLocation riderLocation = RiderLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      dbRef.update({
        'location': riderLocation.toJson(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
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

  Future<void> onArrivedRide(String userRideId) async {
    await FirebaseFirestore.instance.collection('rides').doc(userRideId).update({
      'status': Status.arrived.name,
    });
  }

  Future<void> onStartRide(String userRideId) async {
    await FirebaseFirestore.instance.collection('rides').doc(userRideId).update({
      'status': Status.riding.name,
    });
  }

  Future<void> onCompleteStatus(String userRideId) async {
    await FirebaseFirestore.instance.collection('rides').doc(userRideId).update({
      'status': Status.completed.name,
    });
  }

  Future<void> onCancelRide(String userRideId) async {
    await FirebaseFirestore.instance.collection('rides').doc(userRideId).update({
      'status': Status.pending.name,
    });
  }

  Future<void> onCompleteRide(Ride ride) async {
    try {
      await FirebaseFirestore.instance.collection("ride_history").add(ride.toJson());
      await FirebaseFirestore.instance.collection("rides").doc(ride.rideId).delete();
    } catch (e) {
      print(e);
    }
  }
}
