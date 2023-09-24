import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final Location location;
  final String formattedAddress;

  Place({
    required this.location,
    required this.formattedAddress,
  });

  factory Place.fromMap(Map<String, dynamic> json) {
    return Place(
      location: json['result'] == null
          ? Location.fromMap(List.from(json['results']).first['geometry']['location'])
          : Location.fromMap(
              json['result']['geometry']['location'],
            ),
      formattedAddress: json['result'] == null
          ? List.from(
              json['results'],
            ).first['formatted_address']
          : json['result']['formatted_address'],
    );
  }

  @override
  List<Object?> get props => [location, formattedAddress];
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );
}
