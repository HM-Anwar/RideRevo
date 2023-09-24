import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_revo/models/auto_complete_prediction.dart';
import 'package:ride_revo/models/place_id.dart';
import 'package:ride_revo/utils/constants.dart';

class ApiRepo {
  String baseURL = "https://maps.googleapis.com";
  final String _apiKey = Constants.GOOGLE_MAP_API_KEY;

  Future<AutoCompletePrediction?> fetchPredictLocation(String query) async {
    String endPoint = "/maps/api/place/autocomplete/json";
    String params = "?input=$query&key=$_apiKey";
    try {
      Uri uri = Uri.parse(baseURL + endPoint + params);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        AutoCompletePrediction autoCompletePrediction = AutoCompletePrediction.fromMap(json);
        return autoCompletePrediction;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Place?> fetchLatLngFromPlaceId(String query) async {
    String endPoint = "/maps/api/place/details/json";

    String params = "?placeid=$query&key=$_apiKey";
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

  Future<Place?> fetchAddressFromLatLng(LatLng latLng) async {
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
