import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/ProbationKaryawan.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/demografiAttendance.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/employeeMonitoring.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/ijinCutiKaryawan.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kehadiranKaryawanTable.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kehadiranTanpaKeterangan.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kontrakKaryawan.dart';
import 'package:mobile_ess/widgets/header_profile_widget.dart';
import 'package:mobile_ess/screens/user/home/icons_container_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class AdminHeaderScreen extends StatefulWidget {
  const AdminHeaderScreen({super.key});

  @override
  State<AdminHeaderScreen> createState() => _AdminHeaderScreenState();
}

class _AdminHeaderScreenState extends State<AdminHeaderScreen> {
  var vdata = {};
  Map<String, String> selectionValues = {
    '1': 'Demografi & Attendance',
    '2': 'Employee Monitoring',
    '3': 'Ijin Karyawan',
    '4': 'Ijin Cuti',
    '5': 'Tanpa Keterangan',
    '6': 'Kontrak Karyawan',
    '7': 'Probation Karyawan',
    '8': 'Task',
  };
  String? selectionValue = '1'; // Default value

  Widget _buildComponent() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
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
      case '3':
        return KehadiranKaryawanTable();
      case '4':
        return IjinCutiKaryawan();
      case '5':
        return KehadiranTanpaKeterangan();
      case '6':
        return KontrakKaryawan();
      case '7':
        return ProbationKaryawan();
      case '8':
      // return TaskMenuDashboard();
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
              Text(
                'PT Hasnur Informasi Teknologi',
                // userLogin.get('user')['entitas'],
                style: TextStyle(
                    fontSize: textMedium,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Quicksand'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Get.toNamed('/admin/announcement');
                  // Aksi ketika ikon lonceng di tekan
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: size.height * 0.33,
            width: size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HeaderProfileWidget(
                  userName: 'M. Abdullah Sani',
                  posision: 'Programmer',
                  imageUrl: '',
                  // userName: userLogin.get('user')['full_name'],
                  // posision: userLogin.get('user')['jabatan'],
                  // imageUrl: userLogin.get('user')['gambar'],
                  webUrl: '',
                ),
                Container(
                  height: size.height * 0.13,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const TitleWidget(title: 'Dashboard'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalWide, vertical: padding10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Kategori'),
                Container(
                  height: 40,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(
                          102, 158, 158, 158), // Set border color
                      width: 1, // Set border width
                    ),
                    borderRadius: BorderRadius.circular(
                        6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButton<String>(
                      style: TextStyle(
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
                          .map<DropdownMenuItem<String>>((String id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(selectionValues[id]!),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
          _buildComponent(),
        ],
      ),
    );
  }
}

class ComponentType1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Component Type 1'),
    );
  }
}

class ComponentType2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Component Type 2'),
    );
  }
}

class ComponentType3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Component Type 3'),
    );
  }
}
