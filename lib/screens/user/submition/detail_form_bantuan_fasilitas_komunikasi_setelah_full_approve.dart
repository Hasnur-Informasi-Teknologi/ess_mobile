import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class DetailFormFasilitasKomunikasiSetelahFullApprove extends StatelessWidget {
  const DetailFormFasilitasKomunikasiSetelahFullApprove({super.key});

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
          'Persetujuan Biaya Komunikasi',
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
              const TitleWidget(title: 'Diajukan Oleh'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'NRP',
                textRight: 'HG219942',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Nama',
                textRight: 'M. Abdullah Sani',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Jabatan',
                textRight: 'Manager',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal Pengajuan',
                textRight: '03/04/2023',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Fasilitas Komunikasi Diberikan Kepada'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'NRP',
                textRight: '782200XXX',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Nama',
                textRight: 'Nama',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Jabatan',
                textRight: 'Junior System Analyst',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Pangkat',
                textRight: 'Junior System Analyst',
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
              TitleCenterWithBadgeWidget(
                textLeft: 'Prioritas',
                textRight: 'Tinggi',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
                color: Colors.green,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Kelompok Jabatan & Kepangkatan',
                textRight: 'Board Of Commisioner',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Nominal Biaya Pulsa',
                textRight: 'Rp 1.000.000',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Jenis Fasilitas',
                textRight: 'Mobile Phone/HP',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Jenis Mobile Phone',
                textRight: 'Smartphone',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Merk Mobile Phone',
                textRight: 'Permintaan Khusus',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Tujuan Komunikasi (Internal)',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Alasan Tujuan Komunikasi (Internal)',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Tujuan Komunikasi (Eksternal)',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Alasan Tujuan Komunikasi (Eksternal)',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Keterangan',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Keterangan',
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
