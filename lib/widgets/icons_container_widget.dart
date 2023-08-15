import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/home/online_form/online_form_screen.dart';
import 'package:mobile_ess/themes/constant.dart';

class IconsContainerWidget extends StatelessWidget {
  // final BuildContext context;

  const IconsContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double icon = size.width * 0.06;
    double sizedBoxHeightExtraShort = size.width * 0.02;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalExtraNarrow = size.width * 0.02;
    double padding5 = size.width * 0.0188;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
      ),
      itemCount: 6, // Jumlah total item
      itemBuilder: (BuildContext context, int index) {
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
                    getIcon(index), // Mendapatkan ikon berdasarkan indeks
                    color: Colors.grey[700],
                    size: icon,
                  ),
                ),
              ),
              SizedBox(height: sizedBoxHeightExtraShort),
              Text(
                getText(index),
                textAlign:
                    TextAlign.center, // Mendapatkan teks berdasarkan indeks
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: textSmall,
                ),
              ),
            ],
          ),
        );
      },
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
        return Icons.group;
      case 3:
        return Icons.account_balance_wallet;
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
        return 'Employee';
      case 3:
        return 'Transactions';
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
        return print('Documents');
      case 2:
        return print('Documents');
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
