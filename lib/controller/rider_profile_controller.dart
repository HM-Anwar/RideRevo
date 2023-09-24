import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/auth_repo.dart';
import 'package:ride_revo/repository/rider_profile_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class RiderProfileController extends GetxController {
  final RiderProfileRepo riderProfileRepo;

  RiderProfileController({required this.riderProfileRepo});

  String name = '';
  String bikeName = '';
  String bikeModel = '';
  String bikeRegNo = '';
  String phoneNo = '';
  XFile? imageFile;
  Mode state = Mode.normal;

  Future<void> setImageFile() async {
    XFile? updateFile = await riderProfileRepo.pickImage();
    if (updateFile != null) {
      imageFile = updateFile;
    }
    update();
  }

  void removeImageFile() {
    imageFile = null;
    update();
  }

  void setName(String updatedName) {
    name = updatedName;
    update();
  }

  void setBikeName(String updatedBikeName) {
    bikeName = updatedBikeName;
    update();
  }

  void setBikeModel(String updatedBikeModel) {
    bikeModel = updatedBikeModel;
    update();
  }

  void setBikeRegNo(String updatedBikeRegNo) {
    bikeRegNo = updatedBikeRegNo;
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

  Future<void> executeLoader(Function() func) async {
    try {
      setState(Mode.loading);
      await func();
      setState(Mode.normal);
    } catch (e) {
      print(e);
      setState(Mode.normal);
    }
  }

  Future<ResponseStatus> onContinuePressed() async {
    ResponseStatus status = ResponseStatus.failed;
    User user = AuthRepo.getUser!;
    await executeLoader(() async {
      String? imageURL;
      if (imageFile != null) {
        imageURL = await riderProfileRepo.createURLFromFirebase(File(imageFile!.path));
      }
      Rider rider = Rider(
        name: name,
        phoneNo: phoneNo,
        bikeName: bikeName,
        bikeModel: bikeModel,
        bikeRegNo: bikeRegNo,
        imageUrl: imageURL ?? user.photoURL,
      );

      await riderProfileRepo.createUserFromDB(rider);
      status = ResponseStatus.success;
    });
    print(status);
    return status;
  }
}
