import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class RiderHomeRepo {
  static Future<bool> get isRideExist => _checkRide();

  static Future<bool> _checkRide() async {
    try {
      if (AuthRepo.getUser == null) return false;
      final driverId = AuthRepo.getUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('rides')
          .where(
            'driverId',
            isEqualTo: driverId,
          )
          .get();

      debugPrint('===> Ride Exist:${snapshot.docs.isNotEmpty}');
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<AppUser>> getUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    List<AppUser> users = snapshot.docs.map((e) => AppUser.fromJson(e.data())).toList();
    return users;
  }

  Future<List<Ride>> getRides() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where(
          'status',
          isEqualTo: Status.pending.name,
        )
        .get();

    List<Ride> rides = snapshot.docs.map((e) => Ride.fromJson(e.data())).toList();
    return rides;
  }

  Future<List<Ride>> getNearestRides() async {
    final position = await getCurrentLocation();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    double minRadius = 1;
    double maxRadius = 3000;

    final List<Ride> rides = await getRides();
    for (int i = 0; i < rides.length; i++) {
      final distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        rides[i].pickupLocation.latitude,
        rides[i].pickupLocation.longitude,
      );
      if (distance > maxRadius) {
        rides.removeAt(i);
      }
    }
    print(rides);
    return rides;
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (!await Geolocator.isLocationServiceEnabled()) {
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if(locationPermission == LocationPermission.deniedForever){
      await Geolocator.openAppSettings();
      throw Exception('Location permission denied forever');

    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> onAcceptRide(String rideId) async {
    final User user = AuthRepo.getUser!;
    await FirebaseFirestore.instance.collection('rides').doc(rideId).update({
      'status': Status.accepted.name,
      'driverId': user.uid,
    });

    await onRiderLocationUpdate();
  }

  Future<void> onRiderLocationUpdate() async {
    Position position = await getCurrentLocation();
    final dbRef = FirebaseDatabase.instance.ref('riders/${AuthRepo.getUser!.uid}');
    RiderLocation riderLocation = RiderLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    await dbRef.update({
      'location': riderLocation.toJson(),
    });
  }
}
