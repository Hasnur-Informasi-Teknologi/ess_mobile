import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class DetailFormPermintaanHardwareSoftware extends StatelessWidget {
  const DetailFormPermintaanHardwareSoftware({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textMedium = size.width * 0.0329; // 14 px
    double textLarge = size.width * 0.04; // 18 px
    double padding20 = size.width * 0.047; // 20 px
    double paddingHorizontalNarrow = size.width * 0.035; // 15 px
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
          'Persetujuan Permintaan Hardware & Software',
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
                textLeft: 'Tanggal Pengajuan',
                textRight: 'dd/mm/yyyy',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tipe Karyawan',
                textRight: 'Karyawan Baru',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'NRP',
                textRight: '78220012',
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
                textLeft: 'Departemen',
                textRight: 'Busines Solution',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Diminta Oleh',
                textRight: 'nama',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Phone',
                textRight: '08XXX',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Lokasi',
                textRight: 'Banjarbaru',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Hardware & Software yang Diminta'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'Hardware',
                textRight: 'Dekstop, Printer, Mouse, Keyboard',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Software',
                textRight:
                    'Microsoft Project 2007, Microsoft Project 2007, Microsoft Project 2007',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              Text(
                'Penjelasan',
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
                'Penjelasan',
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
                'Tambahan Permintaan Hardware & Software',
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
                'Tambahan Permintaan Hardware & Software',
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
