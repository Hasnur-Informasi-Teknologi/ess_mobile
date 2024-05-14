import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/persetujuan/history_approval_screen.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/bottom_navbar_controller.dart';
import 'package:mobile_ess/screens/user/profile/profile_screen.dart';
import 'package:mobile_ess/screens/user/permintaan/submition_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavBarController());

    return Scaffold(
        body: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeScreen(),
              SubmitionScreen(),
              HistoryApprovalScreen(),
              ProfileScreen(),
            ],
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.changePage(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.file_open_outlined,
              ),
              label: 'Submition',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.work_history_rounded,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
          ],
        ));
  }
}
