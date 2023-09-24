import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_revo/controller/auth_controller.dart';
import 'package:ride_revo/helper/route_helper.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/color_palette.dart';
import 'package:ride_revo/utils/decoration.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/utils/typography.dart';
import 'package:ride_revo/views/widgets/primary_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return WillPopScope(
          onWillPop: () async {
            authController.clearFields();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 180),
                      Text(
                        'Create Your Account',
                        style: Styles.appNameStyle.copyWith(
                          color: ColorPalette.black,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            keyboardAppearance: Brightness.dark,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (email) => authController.onEmailChanged(email),
                            decoration: AppDecoration.textFieldDecoration.copyWith(
                              hintText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            keyboardAppearance: Brightness.dark,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (password) => authController.onPasswordChanged(password),
                            obscureText: authController.isPasswordObscure,
                            decoration: AppDecoration.textFieldDecoration.copyWith(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: authController.onPasswordObscurePressed,
                                icon: !authController.isPasswordObscure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                              ),
                            ),
                          ),
                          const SizedBox(height: 27),
                          !authController.isLoading
                              ? PrimaryButton(
                                  onPressed: () async {
                                    await authController.onSignUpPressed();
                                    if (AuthRepo.getUser != null) {
                                      RouteHelper.assignProfileSetupRoute();
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  color: ColorPalette.primaryColor,
                                  width: context.screenWidth,
                                  height: 58,
                                  child: Text(
                                    'Sign up',
                                    style: Styles.poppinsButtonTextStyle.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: Styles.poppinsSubtitleStyle.copyWith(
                                  color: ColorPalette.greyColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              PrimaryButton(
                                onPressed: () {
                                  authController.clearFields();
                                  return Get.offAllNamed(RouteHelper.getAuthRoute);
                                },
                                child: Text(
                                  "Sign in",
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
