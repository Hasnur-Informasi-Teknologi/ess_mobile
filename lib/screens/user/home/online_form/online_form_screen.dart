import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';

class OnlineFormScreen extends StatelessWidget {
  const OnlineFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;
    double padding8 = size.width * 0.0188;
    double padding10 = size.width * 0.023;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Navigator.pop(context);
          },
        ),
        title: const Text(
          'Online Form',
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
            itemCount: 10, // Jumlah total item
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
        return Icons.assessment;
      case 1:
        return Icons.business_center;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.account_balance_wallet;
      case 4:
        return Icons.assignment_ind;
      case 5:
        return Icons.home;
      case 6:
        return Icons.person;
      case 7:
        return Icons.settings;
      case 8:
        return Icons.assignment;
      case 9:
        return Icons.description;
      default:
        return Icons.error;
    }
  }

  String getText(int index) {
    // Mengembalikan teks berdasarkan indeks
    switch (index) {
      case 0:
        return 'Pengajuan Training';
      case 1:
        return 'Pengajuan Aplikasi Recruitment';
      case 2:
        return 'Pengajuan Perjalanan Dinas';
      case 3:
        return 'Pengajuan Fasilitas Kesehatan';
      case 4:
        return 'Pengajuan Izin';
      case 5:
        return 'Pengajuan Bantuan Komunikasi';
      case 6:
        return 'Pengajuan Hardware & Software';
      case 7:
        return 'Pengajuan Surat Keterangan';
      case 8:
        return 'Pengajuan Cuti';
      case 9:
        return 'Penilaian Kinerja Karyawan';
      default:
        return 'Error';
    }
  }

  void handleIconTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/user/main/home/online_form/aplikasi_training');
        break;
      case 1:
        Get.toNamed('/user/main/home/online_form/aplikasi_recruitment');
        break;
      case 2:
        Get.toNamed('/user/main/home/online_form/pengajuan_perjalanan_dinas');
        break;
      case 3:
        Get.toNamed(
            '/user/main/home/online_form/pengajuan_fasilitas_kesehatan');
        break;
      case 4:
        Get.toNamed('/user/main/home/online_form/pengajuan_izin');
        break;
      case 5:
        return print('Documents');
      case 6:
        Get.toNamed('/user/main/home/online_form/pengajuan_hardware_software');
        break;
      case 7:
        Get.toNamed('/user/main/home/online_form/pengajuan_surat_keterangan');
        break;
      case 8:
        Get.toNamed('/user/main/home/online_form/pengajuan_cuti');
        break;
      case 9:
        return print('Documents');
      default:
        return print('Error');
    }
  }
}
