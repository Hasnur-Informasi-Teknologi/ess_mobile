import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class DetailFormPenggantianBiayaRawatInapSetelahFullApprove
    extends StatelessWidget {
  const DetailFormPenggantianBiayaRawatInapSetelahFullApprove({super.key});

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
          'Persetujuan Biaya Rawat Inap',
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
                textLeft: 'Pangkat',
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
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal Masuk',
                textRight: '05/05/2023',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Periode Rawat',
                textRight: '24 - 30 April 2023',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Perusahaan',
                textRight: 'PT Hasnur Informasi Teknologi',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Nama Pasien',
                textRight: 'Nama',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Lokasi Kerja',
                textRight: 'Landasan Ulin, Banjarbaru',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Hubungan Dengan Karyawan',
                textRight: 'Anak ke 1',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(
                  title:
                      'Daftar Pengajuan jenis Penggantian Biaya Kesehatan Rawat Inap'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              InkWell(
                onTap: () {
                  // Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LineWidget(),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'Jenis Penggantian',
                      textRight: ': Rawat Inap',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'Detail Penggantian',
                      textRight: ': Kamar Rawat Inap',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'No Kuitansi',
                      textRight: ': 0589383',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'Jumlah',
                      textRight: ': Rp 2.500.000',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              InkWell(
                onTap: () {
                  // Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LineWidget(),
                    const SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'Jenis Penggantian',
                      textRight: ': Rawat Inap',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'Detail Penggantian',
                      textRight: ': Kamar Rawat Inap',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'No Kuitansi',
                      textRight: ': 0589383',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TitleCenterWidget(
                      textLeft: 'Jumlah',
                      textRight: ': Rp 2.500.000',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Keterangan'),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              TitleCenterWidget(
                textLeft: 'Tanggal Diterima',
                textRight: '12/05/2023',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Dokumen',
                textRight: 'Dokumen Lengkap',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Kelas Kamar yang Diajukan',
                textRight: 'Kelas 2',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Kelas Kamar Sesuai Kebijakan',
                textRight: 'Kelas 3',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Alasan Perbedaan',
                textRight:
                    'Kelas Kamar yang diajukan tidak sesuai dengan pangkat',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Total Pengajuan',
                textRight: 'Rp 550.000',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Total Diganti Perusahaan',
                textRight: 'Rp 450.000',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Selisih',
                textRight: 'Rp 100.000',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Catatan',
                textRight: 'Catatan',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
