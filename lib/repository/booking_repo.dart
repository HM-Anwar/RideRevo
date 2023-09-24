import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_revo/models/place_id.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:http/http.dart' as http;
import 'package:ride_revo/utils/constants.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';

class BookingRepo {
  final String _apiKey = Constants.GOOGLE_MAP_API_KEY;

  Future<List<Ride>> getUserRideHistory(AppMode appMode) async {
    final User? currentUser = AuthRepo.getUser;

    final rideCollection = FirebaseFirestore.instance.collection('ride_history');
    final ridesData = await rideCollection.where(appMode.user ? 'rideId' : 'driverId', isEqualTo: currentUser!.uid).get();

    List<Ride> rides = ridesData.docs.map((e) => Ride.fromJson(e.data())).toList();
    sortRidesByDate(rides);
    return rides;
  }

  void sortRidesByDate(List<Ride> rides) {
    rides.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<Ride>> getDriverRideHistory() async {
    final User? currentUser = AuthRepo.getUser;
    final rideCollection = FirebaseFirestore.instance.collection('ride_history');
    final ridesData = await rideCollection.where('driverId', isEqualTo: currentUser!.uid).get();
    List<Ride> rides = ridesData.docs.map((e) => Ride.fromJson(e.data())).toList();
    return rides;
  }

  Future<Place?> fetchAddressFromLatLng(LatLng latLng) async {
    String baseURL = "https://maps.googleapis.com";

    String endPoint = "/maps/api/geocode/json";

    String params = "?latlng=${latLng.latitude},${latLng.longitude}&key=$_apiKey";
    try {
      Uri uri = Uri.parse(baseURL + endPoint + params);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        Place placeId = Place.fromMap(json);
        return placeId;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
