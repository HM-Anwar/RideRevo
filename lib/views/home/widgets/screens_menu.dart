import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/pop_menu_widget.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:unicons/unicons.dart';

class ScreensMenu extends StatelessWidget {
  const ScreensMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.greyColor.withOpacity(0.5),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<int>(
        position: PopupMenuPosition.over,
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        itemBuilder: (context) => [
          PopupMenuWidget(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(RouteHelper.getBookingRoute);
                  },
                  child: Column(
                    children: const [
                      Icon(
                        UniconsLine.receipt,
                        size: 27,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Bookings",
                        style: Styles.menuTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const SizedBox(
                  height: 48,
                  child: VerticalDivider(color: ColorPalette.greyColor),
                ),
                const SizedBox(width: 6),
                PrimaryButton(
                  onPressed: () {
                    Get.back();
                    return Get.toNamed(RouteHelper.getProfileRoute);
                  },
                  child: Column(
                    children: const [
                      Icon(
                        UniconsLine.user,
                        size: 27,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Profile",
                        style: Styles.menuTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        elevation: 2,
      ),
    );
  }
}
