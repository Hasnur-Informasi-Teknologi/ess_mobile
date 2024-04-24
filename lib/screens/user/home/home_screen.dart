import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/admin/main/dashboard.dart';
import 'package:mobile_ess/screens/user/home/icons_profile_container_widget.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/pengumuman_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:mobile_ess/widgets/header_profile_widget.dart';
import 'package:mobile_ess/screens/user/home/icons_container_widget.dart';
import 'package:mobile_ess/widgets/jadwal_kerja_card_widget.dart';
import 'package:mobile_ess/widgets/pengumuman_card_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController {
  var karyawan = {}.obs;
  var role_id = 4.obs;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _apiUrl = API_URL;
  Controller x = Get.put(Controller());

  @override
  void initState() {
    getDataKaryawan();
    super.initState();
  }

  String? selectionDashboard = '2';

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    x.role_id.value = prefs.getInt('role_id')!.toInt();
    String? token = prefs.getString('token');
    x.karyawan.value =
        jsonDecode(prefs.getString('userData').toString())['data'];
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$_apiUrl/get_data_karyawan'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        final responseData = jsonDecode(response.body);
        print(responseData);
      } catch (e) {}
    } else {
      print('tidak ada token home');
    }
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getString('nrp'));
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('nrp');
    prefs.remove('role_id');
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    x.karyawan['pt'] ?? 'PT Hasnur Informasi Teknologi',
                    style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Quicksand'),
                  )),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  getToken();
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            // height: size.height * 0.43,
            height: size.height * 0.55,
            width: size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => HeaderProfileWidget(
                      userName: x.karyawan['nama'] ?? 'M. Abdullah Sani',
                      posision: x.karyawan['pernr'] ?? '7822000',
                      imageUrl: x.karyawan['pernr'] ?? '',
                      webUrl: '',
                    )),
                Container(
                  // height: size.height * 0.23,
                  height: size.height * 0.15,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: const IconsProfileContainerWidget(),
                ),
                SizedBox(
                  height: padding10,
                ),
                Container(
                  height: size.height * 0.23,
                  // height: size.height * 0.11,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: const IconsContainerWidget(),
                ),
              ],
            ),
          ),
          Obx(
            () => x.role_id == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: const TitleWidget(title: 'Dashboard'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide,
                            vertical: padding10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 100,
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(102, 158, 158, 158),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    value: selectionDashboard,
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        if (newValue == '1') {
                                          Get.toNamed('/admin/main');
                                        } else {
                                          Get.toNamed('/user/main');
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const MainScreenWithAnimation()));
                                        }
                                        selectionDashboard = newValue;
                                      });
                                    },
                                    items: {'1': 'Admin', '2': 'User'}
                                        .keys
                                        .map<DropdownMenuItem<String>>(
                                      (String id) {
                                        return DropdownMenuItem<String>(
                                          value: id,
                                          child: Text(
                                              {'1': 'Admin', '2': 'User'}[id]!),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Text(''),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const TitleWidget(title: 'Kehadiran'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalWide, vertical: padding10),
            child: RowWithButtonWidget(
              textLeft: 'Jangan lupa Absen Pagi Ini!',
              textRight: 'Request attendance',
              fontSizeLeft: textSmall,
              fontSizeRight: textSmall,
              onTab: () {
                Get.toNamed('/user/main/home/request_attendance');
              },
            ),
          ),
          const JadwalKerjaCardWidget(),
          // SizedBox(
          //   height: sizedBoxHeightExtraTall,
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: paddingHorizontalWide, vertical: padding10),
          //   child: RowWithButtonWidget(
          //     textLeft: 'Pengumuman',
          //     textRight: 'Lihat Semua',
          //     fontSizeLeft: textLarge,
          //     fontSizeRight: textSmall,
          //     onTab: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (ctx) => const PengumumanScreen()));
          //     },
          //   ),
          // ),
          // Column(
          //   children: List.generate(4, (index) {
          //     return const PengumumanCardWidget();
          //   }),
          // ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
