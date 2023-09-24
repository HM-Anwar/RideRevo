import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/auth_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/images.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/authentication/widgets/app_switcher.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 70),
                const Align(
                  alignment: Alignment.centerRight,
                  child: AppSwitcher(),
                ),
                const SizedBox(height: 42),
                Image.asset(Images.authLogo),
                const SizedBox(height: 27),
                const Text(
                  'Let\'s you in',
                  style: Styles.appNameStyle,
                ),
                const Spacer(),
                !authController.isLoading
                    ? PrimaryButton(
                        onPressed: () async {
                          await authController.onGooglePressed();
                          if (AuthRepo.getUser != null) {
                            RouteHelper.checkAndAssignAuthRoute();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorPalette.lightGreyColor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 58,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.googleLogo,
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 9),
                            const Text(
                              'Continue with Google',
                              style: Styles.poppinsButtonTextStyle,
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                const SizedBox(height: 42),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorPalette.lightGreyColor.withOpacity(0.5),
                        thickness: 1.0,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'or',
                        style: Styles.poppinsButtonTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorPalette.lightGreyColor.withOpacity(0.5),
                        thickness: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                PrimaryButton(
                  onPressed: () => Get.toNamed(RouteHelper.getSignInRoute),
                  borderRadius: BorderRadius.circular(12),
                  width: MediaQuery.of(context).size.width,
                  height: 57,
                  color: ColorPalette.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 9),
                      Text(
                        'Sign in with password',
                        style: Styles.poppinsButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Styles.poppinsSubtitleStyle.copyWith(
                        color: ColorPalette.greyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    PrimaryButton(
                      onPressed: () => Get.toNamed(RouteHelper.getSignUpRoute),
                      child: Text(
                        "Sign up",
                        style: Styles.poppinsSubtitleStyle.copyWith(
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
