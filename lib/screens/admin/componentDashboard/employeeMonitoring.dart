import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/ijinCutiKaryawan.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kehadiranKaryawanTable.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kehadiranTanpaKeterangan.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class EmployeeMonitoringController extends GetxController {
  var status = "Kehadiran".obs;
}

class DashboardEmployeeMonitoringScreen extends StatefulWidget {
  const DashboardEmployeeMonitoringScreen({super.key});

  @override
  State<DashboardEmployeeMonitoringScreen> createState() =>
      DashboardEmployeeMonitoringScreenState();
}

class DashboardEmployeeMonitoringScreenState
    extends State<DashboardEmployeeMonitoringScreen> {
  // ========================================================
  EmployeeMonitoringController x = Get.put(EmployeeMonitoringController());
  Map<String, String> entitasValues = {
    '1': 'Entitas',
  };
  String? entitasValue = '1'; // Default value
  // ========================================================
  Map<String, String> lokasiValues = {
    '1': 'Lokasi Kerja',
  };
  String? lokasiValue = '1'; // Default value
  // ========================================================
  Map<String, String> periodeValues = {
    '1': 'Periode',
  };
  String? periodeValue = '1'; // Default value
  String lokasiKerja = 'Lokasi Kerja';
  String periode = 'Periode';
  String pangkat = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: const TitleWidget(title: 'Employee Monitoring'),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalWide, vertical: padding10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                            value: entitasValue,
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              setState(() {
                                entitasValue = newValue;
                              });
                            },
                            items: entitasValues.keys
                                .map<DropdownMenuItem<String>>((String id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(entitasValues[id]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
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
                            value: lokasiValue,
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String? newValue) {
                              setState(() {
                                lokasiValue = newValue;
                              });
                            },
                            items: lokasiValues.keys
                                .map<DropdownMenuItem<String>>((String id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(lokasiValues[id]!),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 100,
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
                        child: TextFormField(
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Pangkat', // placeholder
                          ),
                          // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black87,
                            elevation: 5,
                            primary: x.status == 'Kehadiran'
                                ? Color(primaryYellow)
                                : Color.fromARGB(169, 227, 225, 219),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            x.status.value = "Kehadiran";
                          },
                          child: Text(
                            'Kehadiran',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black87,
                            elevation: 5,
                            primary: x.status == 'Izin'
                                ? Color(primaryYellow)
                                : Color.fromARGB(169, 227, 225, 219),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            x.status.value = "Izin";
                          },
                          child: Text(
                            'Izin',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black87,
                            elevation: 5,
                            primary: x.status == 'Cuti'
                                ? Color(primaryYellow)
                                : Color.fromARGB(169, 227, 225, 219),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            x.status.value = "Cuti";
                          },
                          child: Text(
                            'Cuti',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black87,
                            elevation: 5,
                            primary: x.status == 'Tanpa Keterangan'
                                ? Color(primaryYellow)
                                : Color.fromARGB(169, 227, 225, 219),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          onPressed: () {
                            x.status.value = "Tanpa Keterangan";
                          },
                          child: Text(
                            'Tanpa Keterangan',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      width: 100,
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
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: 'From', // placeholder
                        ),
                        // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 100,
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
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: 'To', // placeholder
                        ),
                        // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 150,
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
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: 'Search', // placeholder
                        ),
                        // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black87,
                        elevation: 5,
                        primary: Color(primaryYellow),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(children: [
                        Icon(Icons.download),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Export',
                          style: TextStyle(fontSize: 10),
                        )
                      ]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Kehadiran()
            ],
          ),
        ),
      ],
    );
  }
}

class Kehadiran extends StatelessWidget {
  const Kehadiran({super.key});

  @override
  Widget build(BuildContext context) {
    EmployeeMonitoringController x = Get.put(EmployeeMonitoringController());
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double sizedBoxHeightTall = size.height * 0.0163;
    double padding5 = size.width * 0.0115;
    return Obx(() {
      if (x.status == 'Kehadiran') {
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TitleWidget(title: 'Daftar Kehadiran'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Karyawan',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Clock-In',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Clock-Out',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: List.generate(40, (index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      maxRadius: 23,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        maxRadius: 20,
                                        backgroundImage: AssetImage(
                                            'assets/images/user-profile-default.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Budi Setiawan',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: textSmall,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    'NRP : 78220001',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: textSmall,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: size.width * 1 / 7,
                            padding: EdgeInsets.all(padding5),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Text(
                              '08.00',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textSmall,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 1 / 7,
                            padding: EdgeInsets.all(padding5),
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Text(
                              '17.00',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textSmall,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        );
      }
      else if(x.status=='Izin'){
        return KehadiranKaryawanTable();
      }
      else if(x.status=='Cuti'){
        return IjinCutiKaryawan();
      }
      else if(x.status=='Tanpa Keterangan'){
        return KehadiranTanpaKeterangan();
      }
      else{
        return Container(child: Text("sss"),);
      }
    });
  }
}
