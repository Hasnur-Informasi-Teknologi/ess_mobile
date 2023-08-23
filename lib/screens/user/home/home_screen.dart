import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/pengumuman_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/header_profile_widget.dart';
import 'package:mobile_ess/screens/user/home/icons_container_widget.dart';
import 'package:mobile_ess/widgets/jadwal_kerja_card_widget.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
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
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
            // height: size.height * 0.43,
            height: size.height * 0.3,

            width: size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const HeaderProfileWidget(
                  userName: 'M. Abdullah Sani',
                  posision: 'Programmer',
                  imageUrl: '',
                  webUrl: '',
                ),
                Container(
                  // height: size.height * 0.23,
                  height: size.height * 0.11,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const IconsContainerWidget(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const TitleWidget(title: 'Kehadiran'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalWide, vertical: padding10),
            child: RowWithButtonWidget(
              textLeft: 'Jangan lupa Absen Pagi Ini!',
              textRight: 'Request attendance',
              fontSizeLeft: textSmall,
              fontSizeRight: textSmall,
              onTab: () {
                Get.toNamed('/user/main/home/request_attendance');
              },
            ),
          ),
          const JadwalKerjaCardWidget(),
          SizedBox(
            height: sizedBoxHeightExtraTall,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalWide, vertical: padding10),
            child: RowWithButtonWidget(
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
