import 'package:flutter/material.dart';
import 'package:mobile_ess/screens/user/home/detail_pengumuman/pengumuman_screen.dart';
import 'package:mobile_ess/screens/user/home/request_attendance/request_attendance_karwayan_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/header_profile_widget.dart';
import 'package:mobile_ess/widgets/icons_container_widget.dart';
import 'package:mobile_ess/widgets/jadwal_kerja_card_widget.dart';
import 'package:mobile_ess/widgets/pengumuman_card_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName, _pt, _imageUrl, _webUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PT Hasnur Informasi Teknologi',
                style: TextStyle(
                    fontSize: textMedium,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Quicksand'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Aksi ketika ikon lonceng di tekan
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: size.height * 0.35,
            width: size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                const HeaderProfileWidget(
                  userName: 'M. Abdullah Sani',
                  posision: 'Programmer',
                  imageUrl: '',
                  webUrl: '',
                ),
                Container(
                  height: size.height * 0.2,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: IconsContainerWidget(
                    context: context,
                  ),
                ),
              ],
            ),
          ),
          const TitleWidget(title: 'Kehadiran'),
          RowWithButtonWidget(
            textLeft: 'Jangan lupa Absen Pagi Ini!',
            textRight: 'Request attendance',
            fontSizeLeft: textSmall,
            fontSizeRight: textSmall,
            onTab: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          const RequestAttendanceKaryawanScreen()));
            },
          ),
          const JadwalKerjaCardWidget(),
          const SizedBox(
            height: sizedBoxHeightExtraTall,
          ),
          RowWithButtonWidget(
            textLeft: 'Pengumuman',
            textRight: 'Lihat Semua',
            fontSizeLeft: textLarge,
            fontSizeRight: textSmall,
            onTab: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const PengumumanScreen()));
            },
          ),
          Column(
            children: List.generate(4, (index) {
              return const PengumumanCardWidget();
            }),
          )
        ],
      ),
    );
  }
}
