import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class JadwalKerjaController extends GetxController {
  var date = [].obs;
  var bulan = "1".obs;
  var jam_masuk = "".obs;
  var jam_keluar = "".obs;
  var status = "".obs;
  var sistem_kerja = "".obs;
  // var index = 0.obs;
  var index = (-1).obs;
}

class JadwalKerjaCardWidget extends StatefulWidget {
  const JadwalKerjaCardWidget({super.key});

  @override
  State<JadwalKerjaCardWidget> createState() => _JadwalKerjaCardWidgetState();
}

class _JadwalKerjaCardWidgetState extends State<JadwalKerjaCardWidget> {
  JadwalKerjaController x = Get.put(JadwalKerjaController());
  final String _apiUrl = API_URL;

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse('$_apiUrl/attendance_report/' + karyawan['pernr']),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        final responseData = jsonDecode(response.body);

        // x.date.value = responseData['data'];
        x.date.value = List.from(responseData['data'].reversed);
        x.bulan.value = x.date[0]['attendance_month'].toString();
        x.jam_masuk.value = x.date[0]['clock_in_time'] ?? '-';
        x.jam_keluar.value = x.date[0]['clock_out_time'] ?? '-';
        x.status.value = x.date[0]['clock_in_status'] ?? '-';
        x.sistem_kerja.value = x.date[0]['working_location_status'] ?? '-';

        if (x.date.isNotEmpty) {
          x.index.value = x.date.length - 1;
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('tidak ada token home');
    }
  }

  get_month(value) {
    if (value == '1') {
      return 'Januari';
    } else if (value == '2') {
      return 'Februari';
    } else if (value == '3') {
      return 'Maret';
    } else if (value == '4') {
      return 'April';
    } else if (value == '5') {
      return 'Mei';
    } else if (value == '6') {
      return 'Juni';
    } else if (value == '7') {
      return 'Juli';
    } else if (value == '8') {
      return 'Agustus';
    } else if (value == '9') {
      return 'September';
    } else if (value == '10') {
      return 'Oktober';
    } else if (value == '11') {
      return 'November';
    } else if (value == '12') {
      return 'Desember';
    }
  }

  @override
  void initState() {
    super.initState();
    // main();
    getDataKaryawan();
  }

  List<T> map<T>(List list, Function handler) {
    // CARA 4 dengan index value
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.025;
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
            Obx(
              () => RowWidget(
                textLeft: 'Laporan Absensi',
                textRight: get_month(x.bulan),
                fontWeightLeft: FontWeight.bold,
                fontWeightRight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: map<Widget>(x.date, (index, url) {
                      print(index);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding8),
                        child: GestureDetector(
                          onTap: () {
                            print(index);
                            x.jam_masuk.value =
                                x.date[index]['clock_in_time'] ?? '-';
                            x.jam_keluar.value =
                                x.date[index]['clock_out_time'] ?? '-';
                            x.status.value =
                                x.date[index]['clock_in_status'] ?? '-';
                            x.sistem_kerja.value =
                                x.date[index]['working_location_status'] ?? '-';
                            x.bulan.value =
                                x.date[index]['attendance_month'] ?? '-';
                            x.index.value = index;
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Obx(() => Container(
                                  width: size.width * 1 / 12,
                                  color: x.index.toInt() == index
                                      ? const Color.fromARGB(255, 7, 58, 100)
                                      : const Color(primaryYellow),
                                  padding: EdgeInsets.all(padding10),
                                  child: Text(
                                    x.date[index]['attendance_day'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: x.index.toInt() == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: textSmall,
                                      fontWeight: x.index.toInt() == index
                                          ? FontWeight.w700
                                          : FontWeight.normal,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      );
                    })),
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(
              textLeft: 'Jam Masuk',
              textRight: 'Jam Keluar',
              fontWeightLeft: FontWeight.bold,
              fontWeightRight: FontWeight.bold,
            ),
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
            const RowWidget(
              textLeft: 'Sistem Kerja',
              textRight: 'Status',
              fontWeightLeft: FontWeight.bold,
              fontWeightRight: FontWeight.bold,
            ),
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
