import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IconsContainerController extends GetxController {
  var role_id = 4.obs;
}

class IconsContainerWidget extends StatefulWidget {
  // final BuildContext context;

  const IconsContainerWidget({Key? key}) : super(key: key);

  @override
  State<IconsContainerWidget> createState() => _IconsContainerWidgetState();
}

class _IconsContainerWidgetState extends State<IconsContainerWidget> {
  IconsContainerController x = Get.put(IconsContainerController());

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var role_id = prefs.getInt('role_id');
    x.role_id.value = role_id!.toInt();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double icon = size.width * 0.06;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    double sizedBoxHeightExtraShort = size.width * 0.02;
    double paddingHorizontalExtraNarrow = size.width * 0.02;

    return Obx(
      () => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
        ),
        itemCount: x.role_id == 4 ? 3 : 4, // Jumlah total item
        itemBuilder: (BuildContext context, int index) {
          if (x.role_id == 4) {
            return InkWell(
              onTap: () {
                handleIconTap(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: sizedBoxHeightExtraTall),
                  ClipRRect(
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
                  SizedBox(height: sizedBoxHeightExtraShort),
                  Text(
                    getText(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: textSmall,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                handleIconTap(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: sizedBoxHeightExtraTall),
                  ClipRRect(
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
                  SizedBox(height: sizedBoxHeightExtraShort),
                  Text(
                    getText(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: textSmall,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  IconData getIcon(int index) {
    // Mengembalikan ikon berdasarkan indeks
    switch (index) {
      case 0:
        return Icons.assignment;
      case 1:
        return Icons.description;
      case 2:
        return Icons.account_balance_wallet;
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
        return 'Online Form';
      case 1:
        return 'Documents';
      case 2:
        return 'Transactions';
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
        break;
      case 1:
        Get.toNamed('/user/main/home/documents');
        // Get.snackbar('Infomation', 'Coming Soon',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Colors.amber,
        //     icon: const Icon(
        //       Icons.info,
        //       color: Colors.white,
        //     ),
        //     shouldIconPulse: false);
        break;
      case 2:
        Get.toNamed('/user/main/home/transactions');
        // Get.snackbar('Infomation', 'Coming Soon',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Colors.amber,
        //     icon: const Icon(
        //       Icons.info,
        //       color: Colors.white,
        //     ),
        //     shouldIconPulse: false);
        break;
      case 3:
        Get.toNamed('/admin/karyawan');
        // Get.snackbar('Infomation', 'Coming Soon',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Colors.amber,
        //     icon: const Icon(
        //       Icons.info,
        //       color: Colors.white,
        //     ),
        //     shouldIconPulse: false);
        break;
      case 4:
        return print('Documents');
      case 5:
        return print('Documents');
      default:
        return print('Error');
    }
  }
}
