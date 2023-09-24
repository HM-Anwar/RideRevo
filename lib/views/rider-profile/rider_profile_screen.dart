import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/rider_navbar_controller.dart';
import 'package:ride_revo/controller/user_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/images.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/profile_button.dart';
import 'package:ride_revo/views/widgets/main_appbar.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';
import 'package:unicons/unicons.dart';
import 'package:widget_loading/widget_loading.dart';

class RiderProfileScreen extends StatefulWidget {
  const RiderProfileScreen({Key? key}) : super(key: key);

  @override
  State<RiderProfileScreen> createState() => _RiderProfileScreenState();
}

class _RiderProfileScreenState extends State<RiderProfileScreen> {
  @override
  void initState() {
    UserController controller = Get.find<UserController>();
    if (controller.rider == null) {
      controller.getRiderDetails();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: MainAppBar(
          title: 'Profile',
          leading: const Icon(
            UniconsLine.user,
            color: ColorPalette.black,
          ),
        ),
        body: Column(
          children: [
            controller.rider == null
                ? CircularWidgetLoading(
                    dotColor: ColorPalette.primaryColor,
                    child: SizedBox(
                      height: context.height * 0.5,
                      width: context.width,
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: context.height * 0.07),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          controller.rider?.imageUrl ?? Images.profilePlaceHolder,
                        ),
                      ),
                      const SizedBox(height: 42),
                      Text(
                        controller.rider!.name,
                        style: Styles.appBarStyle,
                      ),
                      Text(
                        "+92 ${controller.rider!.phoneNo.phoneFormat}",
                        style: Styles.poppinsTitleStyle,
                      ),
                      const SizedBox(height: 42),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProfileButton(
                            icon: UniconsLine.user,
                            text: 'Edit Profile',
                            onPressed: () => Get.toNamed(RouteHelper.getEditRiderProfileRoute),
                          ),
                          const SizedBox(
                            height: 70,
                            width: 70,
                            child: VerticalDivider(
                              // color: ColorPalette.black,
                              thickness: 2,
                            ),
                          ),
                          ProfileButton(
                            icon: UniconsLine.lock,
                            text: 'Privacy Policy',
                            onPressed: () => Get.toNamed(RouteHelper.getPrivacyPolicyRoute),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: controller.rider == null ? 0 : 64),
            PrimaryButton(
              color: ColorPalette.primaryColor,
              width: 270,
              height: 52,
              borderRadius: BorderRadius.circular(9),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Get.offAllNamed(RouteHelper.getAuthRoute);
                  Get.find<RiderNavBarController>().clearIndex();
                }
              },
              child: const Text(
                'Logout',
                style: Styles.poppinsButtonTextStyle,
              ),
            ),
          ],
        ),
      );
    });
  }
}
