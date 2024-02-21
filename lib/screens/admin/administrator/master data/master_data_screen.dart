import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';

class MasterDataScreen extends StatelessWidget {
  const MasterDataScreen({super.key});

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
          'Master Data',
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
            itemCount: 8, // Jumlah total item
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
        return Icons.edit_document;
      case 1:
        return Icons.edit_document;
      case 2:
        return Icons.edit_document;
      case 3:
        return Icons.edit_document;
      case 4:
        return Icons.edit_document;
      case 5:
        return Icons.edit_document;
      case 6:
        return Icons.edit_document;
      case 7:
        return Icons.admin_panel_settings;
      default:
        return Icons.error;
    }
  }

  String getText(int index) {
    // Mengembalikan teks berdasarkan indeks
    switch (index) {
      case 0:
        return 'Entitas';
      case 1:
        return 'Cuti Bersama';
      case 2:
        return 'Cuti Roster';
      case 3:
        return 'Rawat jalan';
      case 4:
        return 'Rawat Inap';
      case 5:
        return 'Uang Makan';
      case 6:
        return 'Kamar Hotel';
      case 7:
        return 'PIC HRGS';
      default:
        return 'Error';
    }
  }

  void handleIconTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/admin/administrator/master_data/entitas');
        break;
      case 1:
        Get.toNamed('/admin/administrator/master_data/cuti_bersama');
        break;
      case 2:
        Get.toNamed('/admin/administrator/master_data/cuti_roster');
        break;
      case 3:
        Get.toNamed('/admin/administrator/user_management/rawat_jalan');
      case 4:
        Get.toNamed('/admin/administrator/user_management/rawat_inap');
      case 5:
        Get.toNamed('/admin/administrator/user_management/uang_makan');
      case 6:
        Get.toNamed('/admin/administrator/user_management/kamar_hotel');
      case 7:
        Get.toNamed('/admin/administrator/user_management/pic_hrgs');
        break;
      default:
        return print('Error');
    }
  }
}
// master data screen