import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class JadwalKerjaController extends GetxController{
  var date=[].obs;
  var bulan="".obs;
  var jam_masuk="".obs;
  var jam_keluar="".obs;
  var status="".obs;
  var sistem_kerja="".obs;
  var index=0.obs;
}

class JadwalKerjaCardWidget extends StatefulWidget {
  const JadwalKerjaCardWidget({super.key});

  @override
  State<JadwalKerjaCardWidget> createState() => _JadwalKerjaCardWidgetState();
}

class _JadwalKerjaCardWidgetState extends State<JadwalKerjaCardWidget> {
  JadwalKerjaController x = Get.put(JadwalKerjaController());

   Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var karyawan=jsonDecode(prefs.getString('userData').toString())['data'];
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://hg-attendance.hasnurgroup.com/api/attendance_report/'+karyawan['pernr']),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        final responseData = jsonDecode(response.body);
        x.date.value=responseData['data'];
        x.jam_masuk.value=x.date[0]['clock_in_time'];
        x.jam_keluar.value=x.date[0]['clock_out_time'];
        x.status.value=x.date[0]['clock_in_status'];
        x.sistem_kerja.value=x.date[0]['working_location_status'];
      } catch (e) {
        print(e);
      }
    } else {
      print('tidak ada token home');
    }
  }

    @override
    void initState() {
        super.initState();
        // main();
        getDataKaryawan();
    }

  List<T> map<T>(List list, Function handler) { // CARA 4 dengan index value
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
   

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightShort = size.height * 0.01;

    double padding8 = size.width * 0.0188;
    double padding10 = size.width * 0.023;
    double padding20 = size.width * 0.047;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding20),
      child: Container(
        padding: EdgeInsets.all(padding10),
        height: size.height * 0.23,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const RowWidget(textLeft: 'Jadwal Kerja', textRight: 'April 2023'),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children : map<Widget>(x.date, (index, url) { // listItem adalah variable List/array 
                        return  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding8),
                    child: GestureDetector(
                      onTap: (){
                        x.jam_masuk.value=x.date[index]['clock_in_time'];
                        x.jam_keluar.value=x.date[index]['clock_out_time'];
                        x.status.value=x.date[index]['clock_in_status'];
                        x.sistem_kerja.value=x.date[index]['working_location_status'];
                        x.index.value=index;
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Obx(() => Container(
                          width: size.width * 1 / 12,
                          color: x.index.toInt()==index?const Color.fromARGB(255, 96, 170, 231):Color(primaryYellow),
                          padding: EdgeInsets.all(padding10),
                          child: Text(
                            x.date[index]['attendance_day'].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: textSmall,
                            ),
                          ),
                        )),
                      ),
                    ),
                  );
                }
                 )
              ),), 
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(textLeft: 'Jam Masuk', textRight: 'Jam Keluar'),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Obx(() => RowWidget(
              textLeft: x.jam_masuk.toString(),
              textRight: x.jam_keluar.toString(),
              fontWeightLeft: FontWeight.w300,
              fontWeightRight: FontWeight.w300,
            )), 
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(textLeft: 'Sitem Kerja', textRight: 'Status'),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Obx(() => RowWidget(
              textLeft: x.sistem_kerja.toString(),
              textRight: x.status.toString(),
              fontWeightLeft: FontWeight.w300,
              fontWeightRight: FontWeight.w300,
            )), 
          ],
        ),
      ),
    );
  }
}
