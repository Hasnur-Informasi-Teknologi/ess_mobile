import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/admin/components/demografiAttendance.dart';
import 'package:mobile_ess/screens/admin/components/employeeMonitoring.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/pengumuman_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/header_profile_widget.dart';
import 'package:mobile_ess/widgets/icons_container_widget.dart';
import 'package:mobile_ess/widgets/jadwal_kerja_card_widget.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/pengumuman_card_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminHeaderScreen extends StatefulWidget {
  const AdminHeaderScreen({super.key});

  @override
  State<AdminHeaderScreen> createState() => _AdminHeaderScreenState();
}

class _AdminHeaderScreenState extends State<AdminHeaderScreen> {
  String? _userName, _pt, _imageUrl, _webUrl;
  var vdata = {};
  final _formKey = GlobalKey<FormState>();
  Map<String, String> selectionValues = {
    '1': 'Demografi & Attendance',
    '2': 'Employee Monitoring',
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
      default:
        return SizedBox.shrink();
    }
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
    
    @override
    void initState() {
      super.initState();
    }
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
                style: TextStyle(
                    fontSize: textMedium,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Quicksand'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
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
            height: size.height * 0.43,
            width: size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const HeaderProfileWidget(
                  userName: 'M. Abdullah Sani',
                  posision: 'Programmer',
                  imageUrl: '',
                  webUrl: '',
                ),
                Container(
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
                        color: Colors.black, // Set the font size for the dropdown items
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
