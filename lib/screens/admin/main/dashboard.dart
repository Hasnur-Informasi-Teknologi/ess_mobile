import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/models/tabIcon_data.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/header.dart';
import 'package:mobile_ess/screens/attendance/checkout_location_screen.dart';
import 'package:mobile_ess/screens/attendance/qrcode_scanner_screen.dart';
import 'package:mobile_ess/screens/attendance/register_face_screen.dart';
import 'package:mobile_ess/screens/attendance/trip_location_screen.dart';
import 'package:mobile_ess/screens/attendance/wfh_location_screen.dart';
import 'package:mobile_ess/screens/attendance/wfo_location_new_screen.dart';
import 'package:mobile_ess/screens/attendance/wfo_location_screen.dart';
import 'package:mobile_ess/screens/user/history_approval/daftar_persetujuan_screen.dart';
import 'package:mobile_ess/screens/user/history_approval/history_approval_screen.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/bottom_bar_view.dart';
import 'package:mobile_ess/screens/user/profile/profile_screen.dart';
import 'package:mobile_ess/screens/user/submition/daftar_permintaan_screen.dart';
import 'package:mobile_ess/screens/user/submition/submition_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminScreenController extends GetxController {
  var absenIn = false.obs;
}

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  AdminScreenController x = Get.put(AdminScreenController());
  bool isLate = false;
  bool isEmpty = true;

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
        vsync: this, duration: const Duration(milliseconds: 10));
    tabBody = const AdminHeaderScreen();
    // tabBody = const HomeScreen();
    _checkFaceData();
    getDataAbsenKaryawan();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<void> getDataAbsenKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(
              'http://hg-attendance.hasnurgroup.com/api/attendance_report/' +
                  karyawan['pernr']),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        final responseData = jsonDecode(response.body);

        DateTime today = DateTime.now();
        String dateString = today.toString();
        String dateOnly = dateString.substring(0, 10);

        if (responseData['data'][0]['date'] == dateOnly) {
          if (responseData['data'][0]['clock_in_status'] == 'LATE') {
            print('Terlambat');
            setState(() {
              isLate = true;
            });
          } else {
            setState(() {
              isLate = false;
            });
            print('Normal');
          }
        }

        print('Tanggal saja: $dateOnly');
        x.absenIn.value =
            responseData['date'] == responseData['data'][0]['date'];
      } catch (e) {
        print(e);
      }
    } else {
      print('tidak ada token home');
    }
  }

  Future<void> _checkFaceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final userId = karyawan['pernr'];

    var userData = jsonDecode(prefs.getString('userData').toString())['data'];
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response =
          await http.post(Uri.parse('https://hitfaceapi.my.id/api/face/check'),
              headers: headers,
              body: jsonEncode(<String, String>{
                'id_user': userData['pernr'] as String,
              }));
      final responseData = json.decode(response.body);
      if (responseData['status'] == false) {
        Get.offAll(RegisterFaceScreen());
        print('push ke register wajah');
      } else {
        print('skip daftar wajah');
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
          children: [
            tabBody,
            if (isLate == true && isEmpty == true) ModalDialog(),
            bottomBar(),
          ],
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
                        Column(children: <Widget>[
                          x.absenIn == false
                              ? Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Color(primaryYellow))),
                                          onPressed: () {
                                            print('home');
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const WFHLocationScreen(
                                                            workLocation:
                                                                'Home',
                                                            attendanceType:
                                                                'Check-In')),
                                                (route) => false);
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.home),
                                              Text('WFH',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(primaryBlack))),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Color(primaryYellow))),
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const WFOLocationNewScreen(
                                                          workLocation:
                                                              'Office')),
                                              (route) => false);
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.work),
                                            Text('WFO',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Color(primaryBlack))),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Color(primaryYellow))),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const TripLocationScreen(
                                                            workLocation:
                                                                'Trip',
                                                            attendanceType:
                                                                'Check-In')),
                                                (route) => false);
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.car_crash),
                                              Text('Bussiness Trip',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(primaryBlack))),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: OutlinedButton(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.outbound),
                                              Text('Absen Pulang',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(primaryBlack))),
                                            ],
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Color(primaryYellow))),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const CheckoutLocationScreen(
                                                            attendanceType:
                                                                'Check-Out')),
                                                (route) => false);
                                          }),
                                    ),
                                  ],
                                ),
                        ])
                      ],
                    ));
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const AdminHeaderScreen();
                  // tabBody = const HomeScreen();
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const DaftarPermintaanScreen();
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = const DaftarPersetujuanScreen();
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

class ModalDialog extends StatefulWidget {
  @override
  _ModalDialogState createState() => _ModalDialogState();
}

class _ModalDialogState extends State<ModalDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    return Scaffold(
      backgroundColor: Colors.grey,
      body: AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            Center(
              child: Text(
                'Anda Terlambat',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textLarge,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            InkWell(
              onTap: () {
                // Navigator.pop(context);
                setState(() {});
              },
              child: Container(
                height: size.height * 0.04,
                padding: EdgeInsets.all(padding5),
                decoration: BoxDecoration(
                  color: const Color(primaryYellow),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Color(primaryBlack),
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
