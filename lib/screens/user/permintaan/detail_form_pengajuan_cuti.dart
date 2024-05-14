import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class DetailFormPengajuanCuti extends StatelessWidget {
  const DetailFormPengajuanCuti({super.key});

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
          'Persetujuan Pengajuan Cuti',
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
                textRight: 'HG8293829',
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
                textLeft: 'Entitas',
                textRight: 'PT Hasnur Informasi Teknologi',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Jabatan',
                textRight: 'System Analyst',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Atasan',
                textRight: 'Nama Atasan',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Atasan dari Atasan',
                textRight: 'Nama Atasan dari Atasan',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Nama Karyawan Pengganti',
                textRight: 'Nama Karyawan Pengganti',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Keterangan Cuti'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'Jenis Cuti',
                textRight: 'Cuti Tahunan Tidak Dibayar',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Keperluan Cuti',
                textRight: 'Libur Lebaran',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Catatan Cuti'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'Cuti Yang Akan Diambil',
                textRight: '4 Hari',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Sisa Cuti',
                textRight: '12 Hari',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Tanggal Pengajuan Cuti'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal Mulai',
                textRight: 'dd/mm/yyyy',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal berakhir',
                textRight: 'dd/mm/yyyy',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Alamat Cuti',
                textRight: 'Alamat Cuti',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'No Telepon',
                textRight: '0000-0000-0000',
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
