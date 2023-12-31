import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/header.dart';
import 'package:mobile_ess/screens/user/history_approval/history_approval_screen.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/bottom_navbar_controller.dart';
import 'package:mobile_ess/screens/user/profile/profile_screen.dart';
import 'package:mobile_ess/screens/user/submition/submition_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavBarController());

    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            AdminHeaderScreen(),
            // SubmitionScreen(),
            HistoryApprovalScreen(),
            ProfileScreen(),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey,
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.changePage(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.file_open_rounded,
                ),
                label: 'Submition',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                ),
                label: 'dsa',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'asd',
              ),
            ],
          );
        },
      ),
    );
  }
}
