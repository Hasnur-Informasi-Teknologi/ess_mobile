import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/TaskMenuDashboard.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/demografiAttendance.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/employeeMonitoring.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/ijinCutiKaryawan.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kehadiranKaryawanTable.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kehadiranTanpaKeterangan.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kontrakKaryawan.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/header_profile_widget.dart';
import 'package:mobile_ess/screens/user/home/icons_container_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

class AdminController extends GetxController {
  var karyawan = {}.obs;
  var role_id = 1.obs;
  Map<String, String> selectionDashboards = {
    '1': 'Admin',
    '2': 'User',
  }.obs;
}

class AdminHeaderScreen extends StatefulWidget {
  const AdminHeaderScreen({super.key});

  @override
  State<AdminHeaderScreen> createState() => _AdminHeaderScreenState();
}

class _AdminHeaderScreenState extends State<AdminHeaderScreen> {
  final String _apiUrl = API_URL;
  var vdata = {};
  AdminController x = Get.put(AdminController());
  bool _isLoading = false;
  String? versionMobile;
  String? currantVersionMobile;
  bool _isNewVersion = true;
  var latString, longString;

  @override
  void initState() {
    super.initState();
    getDataKaryawan();
    getDataWorkSchedule();
    fetchDataAndCompareVersions();
  }

  Future<void> _openURL() async {
    final Uri iosURL = Uri.parse('https://testflight.apple.com/join/pbpSHQPi');
    final Uri androidURL = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.hasnurgroup.ess');

    if (Platform.isIOS) {
      if (!await launchUrl(iosURL)) {
        throw Exception('Could not launch $iosURL');
      }
    } else {
      if (!await launchUrl(androidURL)) {
        throw Exception('Could not launch $androidURL');
      }
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      _packageInfo = info;
      currantVersionMobile = info.version;
    });
  }

  Future<void> getVersionMobile() async {
    try {
      final ioClient = createIOClientWithInsecureConnection();
      final response = await ioClient.get(
        Uri.parse('$_apiUrl/mobile_version'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );
      final responseData = jsonDecode(response.body);
      if (responseData["data"].isNotEmpty) {
        setState(() {
          versionMobile = responseData["data"][0]["version"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchDataAndCompareVersions() async {
    try {
      await Future.wait([
        _initPackageInfo(),
        getVersionMobile(),
      ]);

      compareVersions();
    } catch (e) {
      print(e);
    }
  }

  bool isNewVersion(String localVersion, String remoteVersion) {
    List<int> localParts = localVersion.split('.').map(int.parse).toList();
    List<int> remoteParts = remoteVersion.split('.').map(int.parse).toList();
    print(localParts);
    print(remoteParts);

    for (int i = 0; i < localParts.length; i++) {
      if (localParts[i] < remoteParts[i]) {
        return false;
      } else if (localParts[i] > remoteParts[i]) {
        return true;
      }
    }
    return true;
  }

  void compareVersions() {
    print("saat ini $versionMobile");
    if (versionMobile == null) {
      _isNewVersion = true;
    } else {
      String localVersion = _packageInfo.version;
      String remoteVersion = versionMobile!;
      _isNewVersion = isNewVersion(localVersion, remoteVersion);
      print(_isNewVersion);

      // if ((_packageInfo.version != versionMobile)) {
      //   _isNewVersion = false;
      // } else {
      //   _isNewVersion = true;
      // }
    }
  }

  Future<void> getDataWorkSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final nrp = karyawan['pernr'];
    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse('$_apiUrl/get_work_schedules/$nrp'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
        );
        final responseData = jsonDecode(response.body);
        if (responseData["data"] != null) {
          setState(() {
            latString = responseData["data"][0]["latitude"] ?? 00.00;
            longString = responseData["data"][0]["longitude"] ?? 00.00;
            prefs.setString('latString', latString);
            prefs.setString('longString', longString);
          });
        } else {
          print('Data is empty');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('tidak ada token home');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    await getDataKaryawan();
    await getDataWorkSchedule();
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> getToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  // }

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    x.role_id.value = prefs.getInt('role_id')!.toInt();
    if (x.role_id == 1) {
      x.selectionDashboards = {
        '1': 'Admin',
        '2': 'User',
      };
    } else {
      x.selectionDashboards = {
        '2': 'User',
      };
    }
    String? token = prefs.getString('token');
    x.karyawan.value =
        jsonDecode(prefs.getString('userData').toString())['data'];
  }

  String? selectionDashboard = '1'; // Default value

  Map<String, String> selectionValues = {
    '1': 'Demografi & Attendance',
    '2': 'Employee Monitoring',
    '6': 'Kontrak Karyawan',
    '8': 'Task',
  };
  String? selectionValue = '1'; // Default value

  Widget _buildComponent() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 10),
      child: _getComponentByKey(selectionValue.toString()),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Widget _getComponentByKey(String key) {
    switch (key) {
      case '1':
        return DemografiAttendanceScreen();
      case '2':
        return DashboardEmployeeMonitoringScreen();
      case '6':
        return KontrakKaryawan();
      case '8':
        return TaskMenuDashboardScreen();
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    var userLogin = Hive.box('userLogin');
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;

    // Check if new version is available and show modal if necessary
    if (!_isNewVersion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModal(context);
      });
    }

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _isNewVersion
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            x.karyawan['pt'] ?? 'PT Hasnur Informasi Teknologi',
                            style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Quicksand'),
                          ),
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.notifications),
                        //   onPressed: () {
                        //     getToken();
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView(
                    children: [
                      Container(
                        // height: size.height * 0.28,
                        height: size.height * 0.38,
                        width: size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(() => HeaderProfileWidget(
                                  userName: x.karyawan['nama'] ?? 'Admin',
                                  posision: x.karyawan['pernr'] ?? '7822000',
                                  imageUrl: '',
                                  webUrl: '',
                                )),
                            Container(
                              // height: size.height * 0.13,
                              height: size.height * 0.23,
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const IconsContainerWidget(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalWide),
                            child: const TitleWidget(title: 'Dashboard'),
                          ),
                          // ================
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalWide,
                                vertical: padding10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(102, 158, 158,
                                          158), // Set border color
                                      width: 1, // Set border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors
                                              .black, // Set the font size for the dropdown items
                                        ),
                                        value: selectionDashboard,
                                        iconSize: 24,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            if (newValue == '1') {
                                              Get.offAllNamed('/admin/main');
                                            } else {
                                              Get.offAllNamed('/user/main');
                                            }
                                            selectionDashboard = newValue;
                                          });
                                        },
                                        items: x.selectionDashboards.keys
                                            .map<DropdownMenuItem<String>>(
                                                (String id) {
                                          return DropdownMenuItem<String>(
                                            value: id,
                                            child: Text(
                                                x.selectionDashboards[id]!),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide,
                            vertical: padding10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Kategori'),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      102, 158, 158, 158), // Set border color
                                  width: 1, // Set border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors
                                          .black, // Set the font size for the dropdown items
                                    ),
                                    value: selectionValue,
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectionValue = newValue;
                                      });
                                    },
                                    items: selectionValues.keys
                                        .map<DropdownMenuItem<String>>(
                                            (String id) {
                                      return DropdownMenuItem<String>(
                                        value: id,
                                        child: Text(selectionValues[id]!),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      _buildComponent(),
                    ],
                  ),
                ),
              )
            : Container();
  }

  void showModal(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Text(
                'Update App?',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textLarge,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Text(
                'A new version of Upgrader is available! Version $versionMobile is now available- you have $currantVersionMobile.',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Text(
                'Would you like to update it now?',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isNewVersion = true;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'LATER',
                        style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: padding5,
                ),
                InkWell(
                  onTap: () {
                    _openURL();
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: const Color(primaryYellow),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'UPDATE NOW',
                        style: TextStyle(
                          color: const Color(primaryBlack),
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
          ],
        );
      },
    );
  }
}
