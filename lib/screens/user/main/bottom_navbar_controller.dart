import 'package:get/get.dart';

// class MainController extends GetxController {}

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
