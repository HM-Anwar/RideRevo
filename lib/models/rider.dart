class Rider {
  final String phoneNo;
  final String bikeRegNo;
  final String bikeName;
  final String bikeModel;
  final String? imageUrl;
  final RiderLocation? location;
  final String name;

  Rider({
    required this.phoneNo,
    required this.bikeName,
    required this.bikeModel,
    required this.bikeRegNo,
    required this.imageUrl,
    this.location,
    required this.name,
  });

  factory Rider.fromJson(Map<dynamic, dynamic> json) {
    return Rider(
      phoneNo: json['phone_no'],
      bikeRegNo: json['reg_no'],
      bikeName: json['bike_name'],
      bikeModel: json['bike_model'],
      imageUrl: json['image_url'],
      location: json['location'] != null ? RiderLocation.fromJson(json['location']) : null,
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'phone_no': phoneNo,
        'bike_name': bikeName,
        'bike_model': bikeModel,
        'reg_no': bikeRegNo,
        'image_url': imageUrl,
        'location': location?.toJson(),
        'name': name,
      };

  Rider copyWith({
    String? phoneNo,
    String? bikeRegNo,
    String? bikeName,
    String? bikeModel,
    String? imageUrl,
    RiderLocation? location,
    String? name,
  }) {
    return Rider(
      phoneNo: phoneNo ?? this.phoneNo,
      bikeRegNo: bikeRegNo ?? this.bikeRegNo,
      bikeName: bikeName ?? this.bikeName,
      bikeModel: bikeModel ?? this.bikeModel,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      name: name ?? this.name,
    );
  }
}

class RiderLocation {
  final double latitude;
  final double longitude;

  RiderLocation({
    required this.latitude,
    required this.longitude,
  });

  factory RiderLocation.fromJson(Map<dynamic, dynamic> json) {
    return RiderLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
