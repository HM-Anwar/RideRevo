// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ride_revo/controller/bottom_navbar_controller.dart';
// import 'package:ride_revo/utils/color_palette.dart';
// import 'package:ride_revo/utils/typography.dart';
// import 'package:ride_revo/views/booking/booking_screen.dart';
// import 'package:ride_revo/views/home/home_screen.dart';
// import 'package:ride_revo/views/profile/user_profile.dart';
// import 'package:unicons/unicons.dart';
//
// class NavBar extends StatelessWidget {
//   const NavBar({Key? key}) : super(key: key);
//   static const List<Widget> screens = <Widget>[
//     HomeScreen(),
//     BookingScreen(),
//     ProfileScreen(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BottomNavBarController>(builder: (controller) {
//       return Scaffold(
//         resizeToAvoidBottomInset: false,
//         bottomNavigationBar: NavigationBarTheme(
//           data: NavigationBarThemeData(
//             indicatorColor: ColorPalette.primaryColor.withOpacity(0.5),
//             labelTextStyle: MaterialStateProperty.all(Styles.menuTextStyle),
//             iconTheme: MaterialStateProperty.all(
//               const IconThemeData(
//                 color: ColorPalette.black,
//                 size: 25,
//               ),
//             ),
//           ),
//           child: NavigationBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             height: 70,
//             selectedIndex: controller.currentIndex,
//             destinations: const [
//               NavigationDestination(
//                 icon: Icon(UniconsLine.home_alt),
//                 label: 'Home',
//               ),
//               NavigationDestination(
//                 icon: Icon(UniconsLine.receipt),
//                 label: 'Bookings',
//               ),
//               NavigationDestination(
//                 icon: Icon(UniconsLine.user),
//                 label: 'Profile',
//               ),
//             ],
//             onDestinationSelected: controller.setCurrentIndex,
//           ),
//         ),
//         body: screens[controller.currentIndex],
//       );
//     });
//   }
// }
