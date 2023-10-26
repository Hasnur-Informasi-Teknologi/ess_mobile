import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Controller2 extends GetxController {
  var karyawan = {}.obs;
}

class IconsProfileContainerWidget extends StatefulWidget {
  // final BuildContext context;

  const IconsProfileContainerWidget({Key? key}) : super(key: key);

  @override
  State<IconsProfileContainerWidget> createState() => _IconsProfileContainerWidgetState();
}

class _IconsProfileContainerWidgetState extends State<IconsProfileContainerWidget> {
  Controller2 x = Get.put(Controller2());
  @override
  void initState() {
    super.initState();
    getDataKaryawan();
  }

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    x.karyawan.value = jsonDecode(prefs.getString('userData').toString())['data'];
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double icon = size.width * 0.06;
    double sizedBoxHeightExtraShort = size.width * 0.02;
    double paddingHorizontalExtraNarrow = size.width * 0.02;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
      ),
      itemCount: 3, // Jumlah total item
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            handleIconTap(index);
          },
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: sizedBoxHeightExtraTall),
              Icon(
                    getIcon(index), // Mendapatkan ikon berdasarkan indeks
                    color: const Color(primaryYellow),
                    size: icon,
                  ),
              SizedBox(height: sizedBoxHeightExtraShort),
              Text(
                getText(index),
                textAlign:
                    TextAlign.center, // Mendapatkan teks berdasarkan indeks
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: sizedBoxHeightExtraShort),
               Text(
                getValue(index),
                textAlign:
                    TextAlign.center, // Mendapatkan teks berdasarkan indeks
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: textSmall,
                ),
              ),
            ],
          ),), 
        );
      },
    );
  }

  IconData getIcon(int index) {
    // Mengembalikan ikon berdasarkan indeks
    switch (index) {
      case 0:
        return Icons.person_pin_outlined;
      case 1:
        return Icons.calendar_month;
      case 2:
        return Icons.edit_calendar_outlined;
      case 3:
        return Icons.group;
      case 4:
        return Icons.person;
      case 5:
        return Icons.settings;
      default:
        return Icons.error;
    }
  }
  

  String getText(int index) {
    // Mengembalikan teks berdasarkan indeks
    switch (index) {
      case 0:
        return 'Posisi';
      case 1:
        return 'Tanggal Bergabung';
      case 2:
        return 'Masa Kerja';
      case 3:
        return 'Employee';
      case 4:
        return 'User Administrations';
      case 5:
        return 'Settings';
      default:
        return 'Error';
    }
  }

  String getValue(int index) {
    // Mengembalikan teks berdasarkan indeks
    switch (index) {
      case 0:
        return x.karyawan['position']??'';
      case 1:
        return x.karyawan['hire_date']??'';
      case 2:
        return x.karyawan['masa_kerja']??'';
      case 3:
        return 'Employee';
      case 4:
        return 'User Administrations';
      case 5:
        return 'Settings';
      default:
        return 'Error';
    }
  }

  void handleIconTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/user/main/home/online_form');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (ctx) => const OnlineFormScreen(),
        //   ),
        // );
        break;
      case 1:
        Get.toNamed('/user/main/home/documents');
        break;
      case 2:
        Get.toNamed('/user/main/home/transactions');
        break;
      case 3:
        return print('Documents');
      case 4:
        return print('Documents');
      case 5:
        return print('Documents');
      default:
        return print('Error');
    }
  }
}
