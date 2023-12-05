import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/kontrakScreen.dart';
import 'package:mobile_ess/screens/admin/componentDashboard/probationKaryawanScreen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/cupertino_datepicker_widget.dart';
import 'package:mobile_ess/widgets/request_attendance_table_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class KontrakKaryawanController extends GetxController{
  var pilih="1".obs;
}

class KontrakKaryawan extends StatefulWidget {
  const KontrakKaryawan({super.key});

  @override
  State<KontrakKaryawan> createState() => KontrakKaryawanState();
}

class KontrakKaryawanState extends State<KontrakKaryawan> {
  KontrakKaryawanController x = Get.put(KontrakKaryawanController());
  // ========================================================
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
  // ========================================================
   Map<String, String> pilihValues = {
    '1': 'Kontrak',
    '2': 'Probation',
  };
  String? periodeValue = '1'; // Default value
  String lokasiKerja = 'Lokasi Kerja';
  String periode = 'Periode';
  String pangkat = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightTall = size.height * 0.0163;
    double padding5 = size.width * 0.0115;

    return Column(
      children: [
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
                          child: DropdownButtonHideUnderline(
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
                          child: DropdownButtonHideUnderline(
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
                          enabledBorder: InputBorder.none,
                            hintText: 'Pangkat', // placeholder
                          ),
                          // onChanged: (val)=>vdata['Username']=val, // pilih salah satu
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors
                                    .black, // Set the font size for the dropdown items
                              ),
                              value: x.pilih.value,
                              iconSize: 24,
                              elevation: 16,
                              onChanged: (String? newValue) {
                                x.pilih.value = newValue.toString();
                                print(newValue);
                              },
                              items: pilihValues.keys
                                  .map<DropdownMenuItem<String>>((String id) {
                                return DropdownMenuItem<String>(
                                  value: id,
                                  child: Text(pilihValues[id]!),
                                );
                              }).toList(),
                            ),
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
                          child: DropdownButtonHideUnderline(
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
                          enabledBorder: InputBorder.none,
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
              Obx(() {
                if(x.pilih=='1'){
                  return KontrakEmployeeScreen();
                }
                else if(x.pilih=='2'){
                  return ProbationKaryawanScreen();
                }
                else{
                  return Text("woke");
                }
              }), 
            ],
          ),
        ),
      ],
    );
  }
}
