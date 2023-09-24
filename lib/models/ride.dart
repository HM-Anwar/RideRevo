import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/enums.dart';

class Ride {
  final String rideId;
  final String? driverId;
  final Status status;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final double estimateFare;
  final double estimateDistance;
  final DateTime createdAt;

  Ride({
    required this.rideId,
    this.driverId,
    required this.status,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.estimateFare,
    required this.estimateDistance,
    required this.createdAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json["rideId"],
      driverId: json["driverId"],
      status: Status.values.firstWhere((element) => element.name == json["status"]),
      pickupLocation: LatLng(json["pickupLocation"]["latitude"], json["pickupLocation"]["longitude"]),
      destinationLocation: LatLng(json["destinationLocation"]["latitude"], json["destinationLocation"]["longitude"]),
      estimateDistance: json["estimateDistance"],
      estimateFare: json["estimateFare"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rideId": rideId,
      "driverId": driverId,
      "status": status.name,
      "pickupLocation": {
        "latitude": pickupLocation.latitude,
        "longitude": pickupLocation.longitude,
      },
      "destinationLocation": {
        "latitude": destinationLocation.latitude,
        "longitude": destinationLocation.longitude,
      },
      "estimateDistance": estimateDistance,
      "estimateFare": estimateFare,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
