import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/home/online_form/form_aplikasi_training_screen/form_aplikasi_training_screen.dart';
import 'package:mobile_ess/themes/constant.dart';

class OnlineFormScreen extends StatelessWidget {
  const OnlineFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
            itemCount: 15, // Jumlah total item
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            getIcon(
                                index), // Mendapatkan ikon berdasarkan indeks
                            color: Colors.grey[700],
                            size: 25.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        getText(index),
                        textAlign: TextAlign
                            .center, // Mendapatkan teks berdasarkan indeks
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10.0,
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
      case 10:
        return Icons.group;
      case 11:
        return Icons.account_balance_wallet;
      case 12:
        return Icons.assignment_ind;
      case 13:
        return Icons.home;
      case 14:
        return Icons.person;
      default:
        return Icons.error;
    }
  }

  String getText(int index) {
    // Mengembalikan teks berdasarkan indeks
    switch (index) {
      case 0:
        return 'Aplikasi Training';
      case 1:
        return 'Aplikasi Recruitment';
      case 2:
        return 'Hasil Interview';
      case 3:
        return 'Pengajuan Cuti';
      case 4:
        return 'Perpanjangan Cuti';
      case 5:
        return 'Pengajuan Lembur';
      case 6:
        return 'Pengajuan Penpanjangan Dinas';
      case 7:
        return 'Laporan Perpanjangan Dinas';
      case 8:
        return 'Izin Keluar';
      case 9:
        return 'Rawat Inap';
      case 10:
        return 'Rawat Jalan';
      case 11:
        return 'Surat Keterangan';
      case 12:
        return 'Bantuan Komunikasi';
      case 13:
        return 'Permintaan Hardware & Software';
      case 14:
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
        return print('Documents');
      case 2:
        return print('Documents');
      case 3:
        return print('Documents');
      case 4:
        return print('Documents');
      case 5:
        return print('Documents');
      case 6:
        return print('Documents');
      case 7:
        return print('Documents');
      case 8:
        return print('Documents');
      case 9:
        return print('Documents');
      case 10:
        return print('Documents');
      case 11:
        return print('Documents');
      case 12:
        return print('Documents');
      case 13:
        return print('Documents');
      case 14:
        return print('Documents');
      default:
        return print('Error');
    }
  }
}
