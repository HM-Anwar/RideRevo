import 'package:get/get.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:ride_revo/controller/auth_controller.dart';
import 'package:ride_revo/controller/booking_controller.dart';
import 'package:ride_revo/controller/home_controller.dart';
import 'package:ride_revo/controller/profile_setup_controller.dart';
import 'package:ride_revo/controller/ride_controller.dart';
import 'package:ride_revo/controller/rider_controller.dart';
import 'package:ride_revo/controller/rider_home_controller.dart';
import 'package:ride_revo/controller/rider_navbar_controller.dart';
import 'package:ride_revo/controller/rider_profile_controller.dart';
import 'package:ride_revo/controller/user_controller.dart';
import 'package:ride_revo/repository/api_repo.dart';
import 'package:ride_revo/repository/app_repo.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/repository/booking_repo.dart';
import 'package:ride_revo/repository/home_repo.dart';
import 'package:ride_revo/repository/profile_setup_repo.dart';
import 'package:ride_revo/repository/ride_repo.dart';
import 'package:ride_revo/repository/rider_home_repo.dart';
import 'package:ride_revo/repository/rider_profile_repo.dart';
import 'package:ride_revo/repository/rider_repo.dart';
import 'package:ride_revo/repository/user_repo.dart';

class Controllers {
  Controllers._();
  static void initialize()  {
    // User Repositories
    Get.put<AuthRepo>(AuthRepo());
    Get.put<ProfileSetupRepo>(ProfileSetupRepo());
    Get.put<HomeRepo>(HomeRepo());
    Get.put<ApiRepo>(ApiRepo());
    Get.put<UserRepo>(UserRepo());
    Get.put<RideRepo>(RideRepo());
    Get.put<AppRepo>(AppRepo());
    Get.put<BookingRepo>(BookingRepo());

    // Rider Repositories
    Get.put<RiderProfileRepo>(RiderProfileRepo());
    Get.put<RiderHomeRepo>(RiderHomeRepo());
    Get.put<RiderRepo>(RiderRepo());

    // Controllers
    Get.put<AuthController>(AuthController(authRepo: Get.find<AuthRepo>()));
    Get.put<ProfileSetupController>(ProfileSetupController(profileSetupRepo: Get.find<ProfileSetupRepo>()));
    Get.put<HomeController>(HomeController(homeRepo: Get.find<HomeRepo>(), apiRepo: Get.find<ApiRepo>()));
    Get.put<UserController>(UserController(userRepo: Get.find<UserRepo>()));
    Get.put<RideController>(RideController(rideRepo: Get.find<RideRepo>()));
    Get.put<AppController>(AppController(appRepo: Get.find<AppRepo>()));
    Get.put<BookingController>(BookingController(bookingRepo: Get.find<BookingRepo>()));

    // Rider Controllers
    Get.put<RiderProfileController>(RiderProfileController(riderProfileRepo: Get.find<RiderProfileRepo>()));
    Get.put<RiderHomeController>(RiderHomeController(riderHomeRepo: Get.find<RiderHomeRepo>()));
    Get.put<RiderNavBarController>(RiderNavBarController());
    Get.put<RiderController>(RiderController(riderRepo: Get.find<RiderRepo>()));
  }
}
