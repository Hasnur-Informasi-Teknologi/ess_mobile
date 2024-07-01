import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IconUserController extends GetxController {
  var karyawan = {}.obs;
}

class IconsProfileContainerWidget extends StatefulWidget {
  // final BuildContext context;

  const IconsProfileContainerWidget({Key? key}) : super(key: key);

  @override
  State<IconsProfileContainerWidget> createState() =>
      _IconsProfileContainerWidgetState();
}

class _IconsProfileContainerWidgetState
    extends State<IconsProfileContainerWidget> {
  IconUserController x = Get.put(IconUserController());
  @override
  void initState() {
    super.initState();
    getDataKaryawan();
  }

  String calculateMasaKerja(String hireDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime hireDateTime = formatter.parse(hireDate);
    final DateTime today = DateTime.now();

    int years = today.year - hireDateTime.year;
    int months = today.month - hireDateTime.month;
    int days = today.day - hireDateTime.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(today.year, today.month, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (months >= 12) {
      years += months ~/ 12;
      months = months % 12;
    }

    return '$years tahun, $months bulan, $days hari';
  }

  String formatDate(String hireDate) {
    try {
      final DateFormat originalFormat = DateFormat('yyyy-MM-dd');
      final DateFormat desiredFormat = DateFormat('dd-MM-yyyy');
      final DateTime dateTime = originalFormat.parse(hireDate);
      return desiredFormat.format(dateTime);
    } catch (e) {
      return hireDate;
    }
  }

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    x.karyawan.value =
        jsonDecode(prefs.getString('userData').toString())['data'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double icon = size.width * 0.06;
    double sizedBoxHeightExtraShort = size.width * 0.02;
    double paddingHorizontalExtraNarrow = size.width * 0.025;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: 3, // Jumlah total item
      itemBuilder: (BuildContext context, int index) {
        return Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                height: size.height * 0.05,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    color: const Color(primaryYellow),
                    padding: EdgeInsets.all(paddingHorizontalExtraNarrow),
                    child: Icon(
                      getIcon(index),
                      color: Colors.grey[700],
                      size: icon,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.077,
                child: Column(children: [
                  SizedBox(height: sizedBoxHeightExtraShort),
                  Text(
                    getText(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: sizedBoxHeightExtraShort),
                  Text(
                    getValue(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: textSmall,
                    ),
                  ),
                ]),
              )
            ],
          ),
        );
      },
    );
  }

  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_pin_outlined;
      case 1:
        return Icons.calendar_month;
      case 2:
        return Icons.edit_calendar_outlined;
      default:
        return Icons.error;
    }
  }

  String getText(int index) {
    switch (index) {
      case 0:
        return 'Posisi';
      case 1:
        return 'Tanggal Bergabung';
      case 2:
        return 'Masa Kerja';
      default:
        return 'Error';
    }
  }

  String getValue(int index) {
    switch (index) {
      case 0:
        return x.karyawan['position'] ?? '';
      case 1:
        String hireDate = x.karyawan['hire_date'] ?? '';
        if (hireDate.isNotEmpty) {
          return formatDate(hireDate);
        } else {
          return '';
        }
      case 2:
        String hireDate = x.karyawan['hire_date'] ?? '';
        if (hireDate.isNotEmpty) {
          return calculateMasaKerja(hireDate);
        } else {
          return '';
        }

      default:
        return 'Error';
    }
  }
}
