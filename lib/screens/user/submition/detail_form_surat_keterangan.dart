import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class DetailFormSuratKeterangan extends StatelessWidget {
  const DetailFormSuratKeterangan({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textMedium = size.width * 0.0329; // 14 px
    double textLarge = size.width * 0.04; // 18 px
    double padding10 = size.width * 0.023;
    double padding20 = size.width * 0.047; // 20 px
    double paddingHorizontalNarrow = size.width * 0.035; // 15 px
    double paddingHorizontalWide = size.width * 0.0585; // 25 px
    const double sizedBoxHeightTall = 15;
    const double sizedBoxHeightShort = 8;
    const double sizedBoxHeightExtraTall = 20;

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
          },
        ),
        title: Text(
          'Detail Surat Keterangan',
          style: TextStyle(
            color: Colors.black,
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalNarrow, vertical: padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleCenterWidget(
                textLeft: 'No SK',
                textRight: '09/KJFDI/9302',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Surat Dibuat Untuk'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'NRP',
                textRight: '7821291',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Nama',
                textRight: 'Nama Karyawan',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Posisi',
                textRight: 'Junior System Analyst',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Status Karyawan',
                textRight: 'Permanen',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Entitas',
                textRight: 'PT Hasnur Informasi Teknologi',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Lokasi Kerja',
                textRight: 'Banjarbaru, Kalimantan Selatan',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal',
                textRight: '05/06/2023',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tujuan Dikeluarkan Surat',
                textRight: 'Pengangkatan Jabatan',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal Dikeluarkannya Surat',
                textRight: '04/04/2023',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
