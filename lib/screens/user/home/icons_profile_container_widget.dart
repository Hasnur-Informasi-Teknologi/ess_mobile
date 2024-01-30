import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                height: size.height * 0.075,
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
        return x.karyawan['hire_date'] ?? '';
      case 2:
        return x.karyawan['masa_kerja'] ?? '';
      default:
        return 'Error';
    }
  }
}
