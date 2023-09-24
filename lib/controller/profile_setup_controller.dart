import 'dart:io';
import 'package:ride_revo/controller/user_controller.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/repository/profile_setup_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class ProfileSetupController extends GetxController {
  final ProfileSetupRepo profileSetupRepo;
  ProfileSetupController({required this.profileSetupRepo});

  String name = '';
  DateTime? dateOfBirth;
  String phoneNo = '';
  XFile? imageFile;
  Mode state = Mode.normal;

  void setName(String updatedName) {
    name = updatedName;
    update();
  }

  Future<void> setImageFile() async {
    XFile? updateFile = await profileSetupRepo.pickImage();
    if (updateFile != null) {
      imageFile = updateFile;
    }
    update();
  }

  void removeImageFile() {
    imageFile = null;
    update();
  }

  void setDateOfBirth(DateTime updatedDateOfBirth) {
    dateOfBirth = updatedDateOfBirth;
    update();
  }

  void setPhoneNo(String updatedPhoneNo) {
    phoneNo = updatedPhoneNo;
    update();
  }

  void setState(Mode updatedState) {
    state = updatedState;
    update();
  }

  Future<ResponseStatus> onContinuePressed() async {
    User user = AuthRepo.getUser!;
    setState(Mode.loading);
    ResponseStatus status = ResponseStatus.failed;
    try {
      String? imageURL;
      if (imageFile != null) {
        imageURL = await profileSetupRepo.createURLFromFirebase(user, File(imageFile!.path));
      }
      AppUser updatedUser = AppUser(
        rideId: user.uid,
        email: user.email!,
        name: name,
        dateOfBirth: dateOfBirth!,
        phoneNumber: phoneNo,
        accountType: AccountType.user,
        createdAt: DateTime.now(),
        isBlocked: false,
        isVerified: false,
        imageUrl: imageURL ?? user.photoURL,
      );
      await profileSetupRepo.createUserFromFirebase(updatedUser);
      await Get.find<UserController>().getUserDetails();

      status = ResponseStatus.success;
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(Mode.normal);
    return status;
  }
}
