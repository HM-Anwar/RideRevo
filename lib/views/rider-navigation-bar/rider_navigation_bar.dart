import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_navbar_controller.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/booking/booking_screen.dart';

import 'package:ride_revo/views/rider-home/rider_home_screen.dart';
import 'package:ride_revo/views/rider-profile/rider_profile_screen.dart';
import 'package:unicons/unicons.dart';

class RiderNavBar extends StatelessWidget {
  const RiderNavBar({Key? key}) : super(key: key);
  static const List<Widget> screens = <Widget>[
    RiderHomeScreen(),
    BookingScreen(),
    RiderProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderNavBarController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: ColorPalette.primaryColor.withOpacity(0.5),
            labelTextStyle: MaterialStateProperty.all(Styles.menuTextStyle),
            iconTheme: MaterialStateProperty.all(
              const IconThemeData(
                color: ColorPalette.black,
                size: 25,
              ),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            height: 70,
            selectedIndex: controller.selectedIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.motorcycle,
                  size: 28,
                ),
                label: 'Rides',
              ),
              NavigationDestination(
                icon: Icon(UniconsLine.receipt),
                label: 'Bookings',
              ),
              NavigationDestination(
                icon: Icon(UniconsLine.user),
                label: 'Profile',
              ),
            ],
            onDestinationSelected: controller.onSelectIndex,
          ),
        ),
        body: screens[controller.selectedIndex],
      );
    });
  }
}
