import 'package:get/get.dart';
import 'package:ride_revo/repository/app_repo.dart';
import 'package:ride_revo/utils/enums.dart';

class AppController extends GetxController {
  final AppRepo appRepo;
  AppController({required this.appRepo}) {
    getAppMode();
  }

  AppMode? appMode;

  void onToggleMode(int? index) {
    if (index == 0) {
      if (appMode == AppMode.user) return;
      setAppMode(AppMode.user);
    } else {
      if (appMode == AppMode.rider) return;

      setAppMode(AppMode.rider);
    }
  }

  Future<void> setAppMode(AppMode mode) async {
    await appRepo.setAppMode(mode);
    appMode = mode;
    update();
  }

  Future<AppMode?> getAppMode() async {
    AppMode? mode = await appRepo.getAppMode();
    appMode = mode;
    update();
    return mode;
  }
}
