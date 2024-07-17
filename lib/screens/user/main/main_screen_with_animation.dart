import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/tabIcon_data.dart';
import 'package:mobile_ess/screens/attendance/checkout_location_screen.dart';
import 'package:mobile_ess/screens/attendance/qrcode_scanner_screen.dart';
import 'package:mobile_ess/screens/attendance/register_face_screen.dart';
import 'package:mobile_ess/screens/attendance/trip_location_screen.dart';
import 'package:mobile_ess/screens/attendance/wfh_location_screen.dart';
import 'package:mobile_ess/screens/attendance/wfo_location_new_screen.dart';
import 'package:mobile_ess/screens/user/persetujuan/daftar_persetujuan_screen.dart';
import 'package:mobile_ess/screens/user/persetujuan/history_approval_screen.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/bottom_bar_view.dart';
import 'package:mobile_ess/screens/user/profile/profile_screen.dart';
import 'package:mobile_ess/screens/user/permintaan/daftar_permintaan_screen.dart';
import 'package:mobile_ess/screens/user/permintaan/submition_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainScreenController extends GetxController {
  var absenIn = false.obs;
  var absenOut = false.obs;
}

class MainScreenWithAnimation extends StatefulWidget {
  const MainScreenWithAnimation({super.key});

  @override
  State<MainScreenWithAnimation> createState() =>
      _MainScreenWithAnimationState();
}

class _MainScreenWithAnimationState extends State<MainScreenWithAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  final MainScreenController x = Get.put(MainScreenController());
  final String _apiUrl = API_URL;
  final List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(color: const Color(backgroundNew));

  String? workLocation;

  @override
  void initState() {
    super.initState();
    initializeTabIcons();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    tabBody = const HomeScreen();
    _checkFaceData();
    getDataAbsenKaryawan();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void initializeTabIcons() {
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;
  }

  Future<void> getDataAbsenKaryawan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final karyawan = jsonDecode(prefs.getString('userData')!)['data'];
    final nrp = karyawan['pernr'];
    final entitas = karyawan['cocd'];

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse(
              '$_apiUrl/attendance/get_report_hg_attendance?page=1&perPage=5&search=$nrp&entitas=$entitas&lokasi=semua&tahun=2024&status=semua&pangkat=semua'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        );

        final responseData = jsonDecode(response.body);
        _updateAbsenStatus(responseData);
      } catch (e) {
        print(e);
      }
    } else {
      print('Tidak ada token home');
    }
  }

  void _updateAbsenStatus(dynamic responseData) {
    final today = DateTime.now();
    final dateOnly = today.toIso8601String().substring(0, 10);

    if (responseData['dataku'][0]['in_date'] == dateOnly) {
      x.absenIn.value = true;
      x.absenOut.value = responseData['dataku'][0]['out_time'] != null;
      workLocation = responseData['dataku'][0]['working_location_status'];
    } else {
      x.absenIn.value = false;
      x.absenOut.value = false;
    }
    print('x.absenIn ${x.absenIn}');
    print('x.absenOut ${x.absenOut}');
  }

  Future<void> _checkFaceData() async {
    final prefs = await SharedPreferences.getInstance();
    final karyawan = jsonDecode(prefs.getString('userData')!)['data'];
    final userId = karyawan['pernr'];

    try {
      final ioClient = createIOClientWithInsecureConnection();
      final response = await ioClient.post(
        Uri.parse('https://hitfaceapi.my.id/api/face/check'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'id_user': userId}),
      );
      final responseData = json.decode(response.body);
      if (responseData['status'] == false) {
        Get.offAll(RegisterFaceScreen());
        print('Push ke register wajah');
      } else {
        print('Skip daftar wajah');
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(backgroundNew),
      child: Scaffold(
        body: Stack(
          children: [tabBody, bottomBar(context)],
        ),
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            getDataAbsenKaryawan();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(
                  'Absensi',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                actions: <Widget>[
                  Column(
                    children: <Widget>[
                      if (!x.absenIn.value && !x.absenOut.value)
                        clockInWidget(context)
                      else if (x.absenIn.value && !x.absenOut.value)
                        clockOutWidget(context)
                      else
                        sudahAbsenWidget(context),
                    ],
                  ),
                ],
              ),
            );
          },
          changeIndex: (int index) {
            changeTab(index);
          },
        ),
      ],
    );
  }

  void changeTab(int index) {
    animationController.reverse().then<dynamic>((data) {
      if (!mounted) return;
      setState(() {
        switch (index) {
          case 0:
            tabBody = const HomeScreen();
            break;
          case 1:
            tabBody = const DaftarPermintaanScreen();
            break;
          case 2:
            tabBody = const DaftarPersetujuanScreen();
            break;
          case 3:
            tabBody = const ProfileScreen();
            break;
        }
      });
    });
  }

  Widget clockInWidget(BuildContext context) {
    return Column(
      children: [
        buildOutlinedButton(
          context,
          icon: Icons.home,
          label: 'WFH',
          onPressed: () => navigateToScreen(
            context,
            const WFHLocationScreen(
                workLocation: 'Home', attendanceType: 'Check-In'),
          ),
        ),
        buildOutlinedButton(
          context,
          icon: Icons.work,
          label: 'WFO',
          onPressed: () => navigateToScreen(
            context,
            const WFOLocationNewScreen(workLocation: 'Office'),
          ),
        ),
        buildOutlinedButton(
          context,
          icon: Icons.car_crash,
          label: 'Business Trip',
          onPressed: () => navigateToScreen(
            context,
            const TripLocationScreen(
                workLocation: 'Trip', attendanceType: 'Check-In'),
          ),
        ),
      ],
    );
  }

  Widget clockOutWidget(BuildContext context) {
    return Column(
      children: [
        buildOutlinedButton(
          context,
          icon: Icons.outbound,
          label: 'Absen Pulang',
          onPressed: () {
            if (workLocation == 'Home') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const CheckoutLocationScreen(
                      attendanceType: 'Check-Out', workLocation: 'Home'),
                ),
              );
            } else if (workLocation == 'Trip') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const CheckoutLocationScreen(
                      attendanceType: 'Check-Out', workLocation: 'Trip'),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const CheckoutLocationScreen(
                      attendanceType: 'Check-Out', workLocation: 'Office'),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget sudahAbsenWidget(BuildContext context) {
    return Column(
      children: [
        buildContainer(
          context,
          label: 'Sudah Absen',
        ),
      ],
    );
  }

  Widget buildOutlinedButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 45,
      margin: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(primaryYellow)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(primaryBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(BuildContext context, {required String label}) {
    final size = MediaQuery.of(context).size;
    final padding5 = size.width * 0.0115;

    return Container(
      height: size.height * 0.07,
      padding: EdgeInsets.all(padding5),
      decoration: BoxDecoration(
        color: const Color(primaryYellow),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(primaryBlack),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => screen),
    );
  }
}
