import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: MainAppBar(
          title: 'Settings',
          leading: const Icon(
            Icons.settings,
            color: ColorPalette.black,
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: context.height * 0.07),
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                controller.appUser!.imageUrl ?? Images.profilePlaceHolder,
              ),
            ),
            const SizedBox(height: 42),
            Text(
              controller.appUser!.name,
              style: Styles.appBarStyle,
            ),
            Text(
              "+92 ${controller.appUser!.phoneNumber.phoneFormat}",
              style: Styles.poppinsTitleStyle,
            ),
            const SizedBox(height: 42),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileButton(
                  icon: UniconsLine.user,
                  text: 'Edit Profile',
                  onPressed: () => Get.toNamed(RouteHelper.getEditProfileRoute),
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
            const SizedBox(height: 42),
            PrimaryButton(
              color: ColorPalette.primaryColor,
              width: 270,
              height: 52,
              borderRadius: BorderRadius.circular(9),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Get.offAllNamed(RouteHelper.getAuthRoute);
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
