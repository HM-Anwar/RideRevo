import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/models/ride.dart';
import 'package:ride_revo/repository/rider_home_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class RiderHomeController extends GetxController {
  final RiderHomeRepo riderHomeRepo;
  RiderHomeController({required this.riderHomeRepo});

  List<Ride> rides = [];
  List<AppUser> users = [];

  AppUser? selectedUser;

  Mode mode = Mode.normal;

  Mode acceptButton = Mode.normal;

  void setMode(Mode mode) {
    this.mode = mode;
    update();
  }

  void executeLoader(Function() func) async {
    try {
      setMode(Mode.loading);
      await func();
      setMode(Mode.normal);
    } catch (e) {
      setMode(Mode.normal);
      print(e);
    }
  }

  Future<void> onGetSelectedUser(Ride ride) async {
    for (AppUser user in users) {
      if (user.rideId == ride.rideId) {
        selectedUser = user;
        update();
      }
    }
  }

  Future<void> getUsersFromRides() async {
    final userList = await riderHomeRepo.getUsers();
    for (Ride ride in rides) {
      for (AppUser user in userList) {
        if (ride.rideId == user.rideId && !users.contains(user)) {
          users.add(user);
        }
      }
    }
    update();
  }

  Future<void> getNearestRides() async {
    rides = await riderHomeRepo.getNearestRides();
    update();
  }

  void onSearchRides() {
    executeLoader(() async {
      await getNearestRides();
      await getUsersFromRides();
    });
  }

  void setAcceptButtonMode(Mode mode) {
    acceptButton = mode;
    update();
  }

  Future<void> executeAcceptMode(Function func) async {
    try {
      setAcceptButtonMode(Mode.loading);
      print('==> before Button Mode ${acceptButton}');
      await func();
      print('==> After Button Mode ${acceptButton}');
      setAcceptButtonMode(Mode.normal);
    } catch (e) {
      print(e);
      print('==> Catch Button Mode ${acceptButton}');
      setAcceptButtonMode(Mode.normal);
    }
  }

  void onAcceptRide() async {
    await executeAcceptMode(() async {
      String rideId = selectedUser!.rideId;
      await riderHomeRepo.onAcceptRide(rideId);
      final controller = Get.find<RiderController>();
      controller.executeRide();
      await Future.delayed(const Duration(seconds: 5));
      resetValues();
      Get.offAllNamed(RouteHelper.getRiderScreenRoute);
    });
  }

  void resetValues() {
    rides = [];
    users = [];
    selectedUser = null;
    update();
  }
}
