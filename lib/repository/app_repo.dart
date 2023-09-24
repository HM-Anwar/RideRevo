import 'package:ride_revo/utils/enums.dart';
import 'package:ride_revo/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepo {
  Future<void> setAppMode(AppMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserMode', mode.user);
    print('App mode set to ${mode.user ? 'user' : 'rider'}');
  }

  Future<AppMode?> getAppMode() async {
    AppMode? appMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isUserMode = prefs.getBool('isUserMode');
    if (isUserMode != null) {
      print('App mode is ${isUserMode ? 'user' : 'rider'}');
      appMode = isUserMode ? AppMode.user : AppMode.rider;
    }
    return appMode;
  }
}
