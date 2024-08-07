import 'package:flutter/material.dart';

class TabIconData {
  TabIconData(
      {this.imagePath = '',
      this.index = 0,
      this.selectedImagePath = '',
      this.isSelected = false,
      this.animationController,
      this.icon,
      this.iconSelected,
      this.title = ''});

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  IconData? icon;
  IconData? iconSelected;
  String title;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/fitness_app/tab_1.png',
      selectedImagePath: 'assets/fitness_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
      iconSelected: Icons.home,
      icon: Icons.home_outlined,
      title: 'Home',
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_2.png',
      selectedImagePath: 'assets/fitness_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
      iconSelected: Icons.file_open_rounded,
      icon: Icons.file_open_outlined,
      title: 'Permintaan',
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_3.png',
      selectedImagePath: 'assets/fitness_app/tab_3s.png',
      index: 2,
      isSelected: false,
      animationController: null,
      iconSelected: Icons.work_history_rounded,
      icon: Icons.work_history_outlined,
      title: 'Persetujuan',
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_4.png',
      selectedImagePath: 'assets/fitness_app/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,
      iconSelected: Icons.person_2_rounded,
      icon: Icons.person_2_outlined,
      title: 'Profile',
    ),
  ];
}
