import 'package:flutter/material.dart';
import 'package:mobile_ess/models/tabIcon_data.dart';
import 'package:mobile_ess/screens/user/history_approval/history_approval_screen.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/bottom_bar_view.dart';
import 'package:mobile_ess/screens/user/profile/profile_screen.dart';
import 'package:mobile_ess/screens/user/submition/submition_screen.dart';
import 'package:mobile_ess/themes/constant.dart';

class MainScreenWithAnimation extends StatefulWidget {
  const MainScreenWithAnimation({super.key});

  @override
  State<MainScreenWithAnimation> createState() =>
      _MainScreenWithAnimationState();
}

class _MainScreenWithAnimationState extends State<MainScreenWithAnimation>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: const Color(backgroundNew),
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    tabBody = const HomeScreen();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(backgroundNew),
      child: Scaffold(
        body: Stack(
          children: [tabBody, bottomBar()],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const HomeScreen();
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const SubmitionScreen();
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const HistoryApprovalScreen();
                });
              });
            } else if (index == 3) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const ProfileScreen();
                });
              });
            }
          },
        ),
      ],
    );
  }
}
