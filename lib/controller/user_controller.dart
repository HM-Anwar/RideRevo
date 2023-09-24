import 'package:get/get.dart';
import 'package:ride_revo/models/app_user.dart';
import 'package:ride_revo/models/rider.dart';
import 'package:ride_revo/repository/user_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class UserController extends GetxController {
  final UserRepo userRepo;
  UserController({required this.userRepo});

  AppUser? appUser;

  Rider? rider;

  String? name;
  String? email;
  String? phoneNo;
  String? bikeName;
  String? bikeModel;

  Mode buttonMode = Mode.normal;

  set setButtonMode(Mode mode) {
    buttonMode = mode;
    update();
  }

  Future<void> executeAction(Function() fn) async {
    try {
      setButtonMode = Mode.loading;
      await fn();
      setButtonMode = Mode.normal;
    } catch (e) {
      print(e);
      setButtonMode = Mode.normal;
    }
  }

  void setName(String value) {
    name = value;
    update();
  }

  void setEmail(String value) {
    email = value;
    update();
  }

  void setPhoneNo(String value) {
    phoneNo = value;
    update();
  }

  void setBikeName(String value) {
    bikeName = value;
    update();
  }

  void setBikeModel(String value) {
    bikeModel = value;
    update();
  }

  Future<void> getUserDetails() async {
    appUser ??= await userRepo.getUserDetails();
    update();
  }

  Future<void> updateUserDetails() async {
    appUser = appUser!.copyWith(
      name: name,
      email: email,
      dateOfBirth: null, // TODO: Add date of birth
      phoneNumber: phoneNo,
      updatedAt: DateTime.now(),
    );
    print(appUser!.toJson());
    await executeAction(() async {
      await userRepo.updateUserDetails(appUser!);
      getUserDetails();
    });
  }

  Future<void> getRiderDetails() async {
    rider ??= await userRepo.getRiderDetails();
    update();
  }

  Future<void> updateRiderDetails() async {
    rider = rider?.copyWith(
      name: name,
      phoneNo: phoneNo,
      bikeModel: bikeModel,
      bikeName: bikeName,
    );
    print(rider?.toJson());
    await executeAction(() async {
      await userRepo.updateRiderDetails(rider!);
      getRiderDetails();
    });
  }
}
