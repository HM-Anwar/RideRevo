import 'package:equatable/equatable.dart';
import 'package:ride_revo/utils/enums.dart';

class AppUser extends Equatable {
  final String name;
  final String email;
  final DateTime createdAt;
  final bool isVerified;
  final bool isBlocked;
  final DateTime dateOfBirth;
  final AccountType accountType;
  final String? imageUrl;
  final DateTime? updatedAt;
  final String phoneNumber;
  final String rideId;

  AppUser({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.isVerified,
    required this.isBlocked,
    required this.dateOfBirth,
    required this.accountType,
    required this.rideId,
    this.imageUrl,
    this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      rideId: json['rideId'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] == null ? json['updatedAt'] : DateTime.parse(json['updatedAt']),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      isVerified: json['isVerified'],
      isBlocked: json['isBlocked'],
      accountType: json['accountType'] == 'user' ? AccountType.user : AccountType.rider,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'rideId': rideId,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isVerified': isVerified,
      'isBlocked': isBlocked,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'accountType': accountType == AccountType.user ? 'user' : 'rider',
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? rideId,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isBlocked,
    DateTime? dateOfBirth,
    AccountType? accountType,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      rideId: rideId ?? this.rideId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      accountType: accountType ?? this.accountType,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        imageUrl,
        rideId,
        phoneNumber,
        createdAt,
        updatedAt,
        isVerified,
        isBlocked,
        dateOfBirth,
        accountType,
      ];
}
