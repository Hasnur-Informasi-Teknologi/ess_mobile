import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/tabIcon_data.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/header.dart';
import 'package:mobile_ess/screens/attendance/checkout_location_screen.dart';
import 'package:mobile_ess/screens/attendance/qrcode_scanner_screen.dart';
import 'package:mobile_ess/screens/attendance/register_face_screen.dart';
import 'package:mobile_ess/screens/attendance/trip_location_screen.dart';
import 'package:mobile_ess/screens/attendance/wfh_location_screen.dart';
import 'package:mobile_ess/screens/attendance/wfo_location_new_screen.dart';
import 'package:mobile_ess/screens/attendance/wfo_location_screen.dart';
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

class AdminScreenController extends GetxController {
  var absenIn = false.obs;
  var absenOut = false.obs;
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
  final String _apiUrl = API_URL;

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
    // _checkFaceData();
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
    var nrp = karyawan['pernr'];
    var entitas = karyawan['cocd'];
    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.get(
          Uri.parse(
              '$_apiUrl/attendance/get_report_hg_attendance?page=1&perPage=5&search=$nrp&entitas=$entitas&lokasi=semua&tahun=2024&status=semua&pangkat=semua'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        final responseData = jsonDecode(response.body);

        DateTime today = DateTime.now();
        String dateString = today.toString();
        String dateOnly = dateString.substring(0, 10);

        if (responseData['dataku'][0]['in_date'] == dateOnly) {
          if (responseData['dataku'][0]['out_time'] == null) {
            x.absenIn.value = true;
            x.absenOut.value = false;
          } else {
            x.absenIn.value = true;
            x.absenOut.value = true;
          }
        } else {
          x.absenIn.value = false;
          x.absenOut.value = false;
        }
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
      final ioClient = createIOClientWithInsecureConnection();

      final response = await ioClient.post(
          Uri.parse('https://hitfaceapi.my.id/api/face/check'),
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
            // if (isLate == true && isEmpty == true) ModalDialog(),
            bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    Size size = MediaQuery.of(context).size;
    double padding5 = size.width * 0.0115;

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
                          x.absenIn == false && x.absenOut == false
                              ? clockInWidget(context)
                              : x.absenIn == true && x.absenOut == false
                                  ? clockOutWidget(context)
                                  : sudahAbsenWidget(context),
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

  Widget clockInWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(bottom: 10),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(primaryYellow))),
              onPressed: () {
                print('home');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const WFHLocationScreen(
                        workLocation: 'Home', attendanceType: 'Check-In'),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.home),
                  Text('WFH',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(primaryBlack))),
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
                side: const BorderSide(color: Color(primaryYellow))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) =>
                      const WFOLocationNewScreen(workLocation: 'Office'),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.work),
                Text('WFO',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(primaryBlack))),
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
                  side: const BorderSide(color: Color(primaryYellow))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const TripLocationScreen(
                        workLocation: 'Trip', attendanceType: 'Check-In'),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.car_crash),
                  Text('Bussiness Trip',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(primaryBlack))),
                ],
              )),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget clockOutWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(bottom: 10),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(primaryYellow))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) =>
                      const CheckoutLocationScreen(attendanceType: 'Check-Out'),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.outbound),
                Text('Absen Pulang',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(primaryBlack))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sudahAbsenWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding5 = size.width * 0.0115;

    return Column(
      children: [
        Container(
          height: size.height * 0.07,
          padding: EdgeInsets.all(padding5),
          decoration: BoxDecoration(
            color: const Color(primaryYellow),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Center(
            child: Text(
              'Sudah Absen',
              style: TextStyle(
                color: const Color(primaryBlack),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
