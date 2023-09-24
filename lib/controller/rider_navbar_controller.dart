import 'package:get/get.dart';

class RiderNavBarController extends GetxController {
  int selectedIndex = 0;

  void onSelectIndex(int index) {
    selectedIndex = index;
    update();
  }

  void clearIndex() {
    selectedIndex = 0;
    update();
  }
}
