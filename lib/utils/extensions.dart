import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/utils/enums.dart';

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

extension ParseString on String {
  String get firebaseValue => split('-').join(' ').capitalizeFirst!;
  String get platformValue => split('_').join(' ').capitalizeFirst!;

  String get phoneFormat => replaceFirst('0', '');
}

extension ParseEnum on Enum {
  bool get loading => this == Mode.loading;

  //Location type
  bool get pickup => this == LocationType.pickup;

  // App mode
  bool get user => this == AppMode.user;
}

extension ParseController on HomeController {
  bool get locationAdded => pickUpLocation != null && destinationLocation != null;
}

extension ParseStatus on Status {
  bool get isRideAccepted => this == Status.accepted || this == Status.arrived || this == Status.riding;
}
