import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:ride_revo/views/widgets/app_snackbar.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  String email = '';
  String password = '';
  bool isPasswordObscure = true;

  bool isLoading = false;

  void clearFields() {
    email = '';
    password = '';
    isPasswordObscure = true;

    update();
  }

  void onEmailChanged(String updatedEmail) {
    email = updatedEmail;
    update();
  }

  void onPasswordChanged(String updatedPassword) {
    password = updatedPassword;
    update();
  }

  void onPasswordObscurePressed() {
    isPasswordObscure = !isPasswordObscure;
    update();
  }

  Future<void> onSignInPressed() async {
    try {
      isLoading = true;
      update();

      await authRepo.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      bool? isUserProfile = await authRepo.isUserProfile();
      if (isUserProfile != null && !isUserProfile) {
        isLoading = false;
        update();
        return;
      }

      Get.showSnackbar(
        appSnackBar(message: 'Successfully Login'),
      );
      clearFields();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message.toString());
      Get.showSnackbar(
        appSnackBar(
          isErrorSnackBar: true,
          message: e.code.firebaseValue == 'Unknown' ? e.message.toString() : e.code.firebaseValue,
        ),
      );
    }
    isLoading = false;

    update();
  }

  Future<String?> onSignUpPressed() async {
    String? errorMessage;

    try {
      isLoading = true;
      update();
      await authRepo.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.showSnackbar(
        appSnackBar(message: 'Successfully Login'),
      );
      clearFields();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      Get.showSnackbar(
        appSnackBar(
          isErrorSnackBar: true,
          message: e.code.firebaseValue == 'Unknown' ? e.message.toString() : e.code.firebaseValue,
        ),
      );
    }
    isLoading = false;

    update();
    return errorMessage;
  }

  Future<void> onGooglePressed() async {
    try {
      isLoading = true;
      update();
      ResponseStatus status = await authRepo.signUpWithGoogle();
      bool? isUserProfile = await authRepo.isUserProfile();
      if (isUserProfile != null && !isUserProfile) {
        isLoading = false;
        update();
        return;
      }
      Get.showSnackbar(
        appSnackBar(
          message: status == ResponseStatus.success ? 'Successfully Login' : 'Failed to Login',
        ),
      );
    } on PlatformException catch (e) {
      debugPrint(e.code.platformValue);
      Get.showSnackbar(
        appSnackBar(
          isErrorSnackBar: true,
          message: e.code.platformValue,
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code.firebaseValue);
      Get.showSnackbar(
        appSnackBar(
          isErrorSnackBar: true,
          message: e.code.firebaseValue,
        ),
      );
    }

    isLoading = false;
    update();
  }
}
