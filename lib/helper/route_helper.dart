import 'package:get/get.dart';
import 'package:ride_revo/controller/app_controller.dart';
import 'package:ride_revo/controller/rider_controller.dart';
import 'package:ride_revo/controller/user_controller.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/repository/ride_repo.dart';
import 'package:ride_revo/repository/rider_home_repo.dart';
import 'package:ride_revo/views/authentication/auth_screen.dart';
import 'package:ride_revo/views/authentication/sign_in_screen.dart';
import 'package:ride_revo/views/authentication/sign_up_screen.dart';
import 'package:ride_revo/views/booking/booking_screen.dart';
import 'package:ride_revo/views/home/home_screen.dart';
import 'package:ride_revo/views/home/pick_location_screen.dart';
import 'package:ride_revo/views/rider-home/rider_home_screen.dart';
import 'package:ride_revo/views/rider-navigation-bar/rider_navigation_bar.dart';
import 'package:ride_revo/views/rider-profile-setup/rider_profile_setup.dart';
import 'package:ride_revo/views/rider-profile/edit_rider_profile.dart';
import 'package:ride_revo/views/rider-screen/rider_screen.dart';
import 'package:ride_revo/views/search-ride/search_ride_screen.dart';
import 'package:ride_revo/views/splash_screen.dart';
import 'package:ride_revo/views/user-profile/edit_profile.dart';
import 'package:ride_revo/views/widgets/privacy_policy.dart';
import 'package:ride_revo/views/user-profile/user_profile.dart';
import '../views/profile-setup/profile_setup_screen.dart';
import 'package:ride_revo/views/home/search_location_screen.dart';
import 'package:ride_revo/utils/extensions.dart';

class RouteHelper {
  RouteHelper._();

  static const String _initial = '/';
  static const String _auth = '/auth';
  static const String _home = '/home';
  static const String _signIn = '/sign-in';
  static const String _signUp = '/sign-up';
  static const String _profileSetupScreen = '/profile-setup';
  static const String _searchLocation = '/search-location';
  static const String _pickLocation = '/pick-location';
  static const String _profile = '/booking';
  static const String _booking = '/profile';
  static const String _searchRide = '/search-ride';
  static const String _privacyPolicy = '/privacy-policy';
  static const String _editProfile = '/edit-profile';

  // Rider Routes
  static const String _riderProfile = '/rider-profile';
  static const String _riderHome = '/rider-home';
  static const String _riderNavbar = '/rider-navbar';
  static const String _riderScreen = '/rider-screen';
  static const String _editRiderProfile = '/edit-rider-profile';

  // Getters
  static String get getInitialRoute => _initial;
  static String get getAuthRoute => _auth;
  static String get getHomeRoute => _home;
  static String get getSignInRoute => _signIn;
  static String get getSignUpRoute => _signUp;
  static String get getProfileSetupRoute => _profileSetupScreen;
  static String get getPickLocationRoute => _pickLocation;
  static String get getBookingRoute => _booking;
  static String get getProfileRoute => _profile;
  static String get getSearchRideRoute => _searchRide;
  static String get getPrivacyPolicyRoute => _privacyPolicy;
  static String get getEditProfileRoute => _editProfile;
  static String getSearchLocationRoute() => _searchLocation;
  static Future<void> checkAndAssignAuthRoute() => _checkAndAssignAuthRoute();

  // Rider Getters
  static String get getRiderProfileRoute => _riderProfile;
  static String get getRiderHomeRoute => _riderHome;
  static String get getRiderNavbarRoute => _riderNavbar;
  static String get getRiderScreenRoute => _riderScreen;
  static String get getEditRiderProfileRoute => _editRiderProfile;

// Screens List
  static List<GetPage> routes = [
    // Global Screens
    GetPage(name: _initial, page: () => const SplashScreen()),
    GetPage(name: _auth, page: () => const AuthScreen()),
    GetPage(name: _signIn, page: () => const SignInScreen()),
    GetPage(name: _signUp, page: () => const SignUpScreen()),

    // User Screens
    GetPage(name: _home, page: () => const HomeScreen()),
    GetPage(name: _profileSetupScreen, page: () => const ProfileSetupScreen()),
    GetPage(name: _searchLocation, page: () => const SearchLocationScreen()),
    GetPage(name: _pickLocation, page: () => const PickLocationScreen()),
    GetPage(name: _booking, page: () => const BookingScreen()),
    GetPage(name: _profile, page: () => const UserProfileScreen()),
    GetPage(name: _searchRide, page: () => const SearchRideScreen()),
    GetPage(name: _privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: _editProfile, page: () => const EditProfileScreen()),

    // Rider Screens
    GetPage(name: _riderProfile, page: () => const RiderProfileSetup()),
    GetPage(name: _riderHome, page: () => const RiderHomeScreen()),
    GetPage(name: _riderNavbar, page: () => const RiderNavBar()),
    GetPage(name: _riderScreen, page: () => const RiderScreen()),
    GetPage(name: _editRiderProfile, page: () => const EditRiderProfileScreen()),
  ];

  // Auth Route
  static Future<void> _checkAndAssignAuthRoute() async {
    final AppController appController = Get.find<AppController>();
    if (appController.appMode!.user) {
      assignUserRoutes();
    } else {
      assignRiderRoute();
    }
  }

  static Future<void> assignUserRoutes() async {
    if (!await AuthRepo.checkAppProfile()) {
      Get.offAllNamed(getProfileSetupRoute);
    }
    if (await RideRepo.isUserRideExist) {
      await Get.find<UserController>().getUserDetails();
      Get.offAllNamed(getSearchRideRoute);
    } else {
      await Get.find<UserController>().getUserDetails();
      Get.offAllNamed(getHomeRoute);
    }
  }

  static assignProfileSetupRoute() {
    AppController appController = Get.find<AppController>();
    if (appController.appMode!.user) {
      Get.offAllNamed(getProfileSetupRoute);
    } else {
      Get.offAllNamed(getRiderProfileRoute);
    }
  }

  static Future<void> assignRiderRoute() async {
    if (!await AuthRepo.checkAppProfile()) {
      Get.offAllNamed(getRiderProfileRoute);
      return;
    }
    if (await RiderHomeRepo.isRideExist) {
      final controller = Get.find<RiderController>();
      controller.executeRide();
      Get.offAllNamed(getRiderScreenRoute);
    } else {
      Get.offAllNamed(getRiderNavbarRoute);
    }
  }
}
