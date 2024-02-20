import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';

class Administrator extends StatelessWidget {
  const Administrator({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding8 = size.width * 0.0188;
    double padding10 = size.width * 0.023;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Administration',
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
            ),
            itemCount: 4, // Jumlah total item
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(padding8),
                child: InkWell(
                  onTap: () {
                    handleIconTap(index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          color: const Color(primaryYellow),
                          padding: EdgeInsets.all(padding10),
                          child: Icon(
                            getIcon(
                                index), // Mendapatkan ikon berdasarkan indeks
                            color: Colors.grey[700],
                            size: 25.0,
                          ),
                        ),
                      ),
                      SizedBox(height: padding10),
                      Text(
                        getText(index),
                        textAlign: TextAlign
                            .center, // Mendapatkan teks berdasarkan indeks
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: textSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData getIcon(int index) {
    // Mengembalikan ikon berdasarkan indeks
    switch (index) {
      case 0:
        return Icons.manage_accounts;
      case 1:
        return Icons.account_balance;
      case 2:
        return Icons.percent;
      case 3:
        return Icons.data_array;
      default:
        return Icons.error;
    }
  }

  String getText(int index) {
    // Mengembalikan teks berdasarkan indeks
    switch (index) {
      case 0:
        return 'User Management';
      case 1:
        return 'User Authorization';
      case 2:
        return 'Release Strategy';
      case 3:
        return 'Master Data';
      default:
        return 'Error';
    }
  }

  void handleIconTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/admin/administrator/user_management/user_management');
        break;
      case 1:
        Get.toNamed(
            '/admin/administrator/user_authorization/user_authorization');
        break;
      case 2:
        Get.toNamed('/admin/administrator/user_management/release_strategy');
        break;
      case 3:
        Get.toNamed('/admin/administrator/user_management/master_data');
        break;
      default:
        return print('Error');
    }
  }
}
