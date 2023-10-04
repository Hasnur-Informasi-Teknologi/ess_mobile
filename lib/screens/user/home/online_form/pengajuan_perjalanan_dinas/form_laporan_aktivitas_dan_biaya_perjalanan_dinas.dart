import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormLaporanAktivitasDanBiayaPerjalananDinas extends StatefulWidget {
  const FormLaporanAktivitasDanBiayaPerjalananDinas({super.key});

  @override
  State<FormLaporanAktivitasDanBiayaPerjalananDinas> createState() =>
      _FormLaporanAktivitasDanBiayaPerjalananDinasState();
}

class _FormLaporanAktivitasDanBiayaPerjalananDinasState
    extends State<FormLaporanAktivitasDanBiayaPerjalananDinas> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final double _maxHeightNama = 40.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
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
            'Laporan Aktivitas & Biaya Perjalanan Dinas',
          ),
        ),
        body: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Trip Number',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: '1234',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Accounting doc.',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: '232423',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'NRP',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: '78220012',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Nama',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: 'Nama',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Department',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: 'Departmen HRGS',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Perusahaan',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: 'PT Hasnur Informasi Teknologi',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Lokasi Dinas',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: 'PT Hasnur Informasi Teknologi',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Periode Dinas',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: '----',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                        vertical: padding10),
                    child: RowWithButtonWidget(
                      textLeft: 'Laporan Aktivitas Perjalanan Dinas',
                      textRight: 'Tambahkan +',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textSmall,
                      onTab: () {
                        Get.toNamed(
                            '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_laporan_aktivitas_dan_biaya_perjalanan_dinas/form_input_laporan_aktivitas_perjalanan_dinas');
                      },
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  InkWell(
                    onTap: () {
                      // Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalWide,
                          vertical: padding10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LineWidget(),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Tanggal',
                            textRight: ': dd/mm/yyyy',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Aktivitas',
                            textRight: ': Aktivitas',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Hasil Aktivitas',
                            textRight: ': Hasil Aktivitas',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Catatan :',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: '----',
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                        vertical: padding10),
                    child: RowWithButtonWidget(
                      textLeft: 'Laporan Biaya Perjalanan Dinas',
                      textRight: 'Tambahkan +',
                      fontSizeLeft: textMedium,
                      fontSizeRight: textSmall,
                      onTab: () {
                        Get.toNamed(
                            '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_laporan_aktivitas_dan_biaya_perjalanan_dinas/form_input_laporan_biaya_perjalanan_dinas');
                      },
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  InkWell(
                    onTap: () {
                      // Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalWide,
                          vertical: padding10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LineWidget(),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Tanggal',
                            textRight: ': dd/mm/yyyy',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Uraian',
                            textRight: ': Uraian',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Kategori',
                            textRight: ': Kategori',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Jumlah Kas Diterima',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormFieldWidget(
                                controller: _namaController,
                                maxHeightConstraints: _maxHeightNama,
                                hintText: '----',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Kelebihan Kas',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormFieldWidget(
                                controller: _namaController,
                                maxHeightConstraints: _maxHeightNama,
                                hintText: '----',
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Jumlah Pengurangan',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormFieldWidget(
                                controller: _namaController,
                                maxHeightConstraints: _maxHeightNama,
                                hintText: '----',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Pengurangan Kas',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormFieldWidget(
                                controller: _namaController,
                                maxHeightConstraints: _maxHeightNama,
                                hintText: '----',
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: TitleWidget(
                      title: 'Catatan :',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: TextFormFieldWidget(
                      controller: _namaController,
                      maxHeightConstraints: _maxHeightNama,
                      hintText: '----',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
