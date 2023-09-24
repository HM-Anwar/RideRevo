import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class RideRepo {
  static Future<bool> get isUserRideExist => _checkUserRide();

  Future<void> onCancelSearchRide(String rideId) async {
    try {
      await FirebaseFirestore.instance.collection("rides").doc(rideId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> onCancelRide(String rideId) async {
    try {
      await FirebaseFirestore.instance.collection("rides").doc(rideId).update(
        {
          "status": Status.pending.name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> onCompleteRide(Ride ride) async {
    try {
      await FirebaseFirestore.instance.collection("ride_history").add(ride.toJson());
      await FirebaseFirestore.instance.collection("rides").doc(ride.rideId).delete();
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> _checkUserRide() async {
    try {
      if (AuthRepo.getUser == null) return false;
      final rideId = AuthRepo.getUser!.uid;
      final snapshot = await FirebaseFirestore.instance.collection("rides").doc(rideId).get();
      debugPrint('===> User Ride Exist:${snapshot.exists}');
      return snapshot.exists;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<Ride> getRides() {
    try {
      final rideId = AuthRepo.getUser!.uid;
      return FirebaseFirestore.instance.collection("rides").doc(rideId).snapshots().map((event) {
        return Ride.fromJson(event.data()!);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return const Stream.empty();
  }

  Stream<Rider?> getRiderDetails(String riderId) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("riders/$riderId");
      return ref.onValue.map((event) {
        var data = event.snapshot.value;
        if (data is Map) {
          Rider rider = Rider.fromJson(data);
          print(rider.location);
          return rider;
        } else {
          throw Exception('Data does not exist at $riderId');
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return const Stream.empty();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}
