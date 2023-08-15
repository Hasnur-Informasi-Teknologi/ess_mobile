import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';

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
  double _maxHeightNama = 40.0;

  bool? _isKasbon = false;
  bool? _isNonKasbon = false;
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
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
                    child: Text(
                      'Trip Number',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '1234',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Accounting doc.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '232423',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'NRP',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '78220012',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Nama',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Nama',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Department',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Departmen HRGS',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Perusahaan',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'PT Hasnur Informasi Teknologi',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Lokasi Dinas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'PT Hasnur Jaya Utama',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Text(
                      'Periode Dinas',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '----',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
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
                    child: Text(
                      'Catatan :',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '----',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
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
                              child: Text(
                                'Jumlah Kas Diterima',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormField(
                                controller: _namaController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'NRP Kosong';
                                //   } else if (value.length < 8) {
                                //     return 'Password Kosong';
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0)),
                                  constraints:
                                      BoxConstraints(maxHeight: _maxHeightNama),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '----',
                                  hintStyle: TextStyle(
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    color: const Color(textPlaceholder),
                                  ),
                                ),
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
                              child: Text(
                                'Kelebihan Kas',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormField(
                                controller: _namaController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'NRP Kosong';
                                //   } else if (value.length < 8) {
                                //     return 'Password Kosong';
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0)),
                                  constraints:
                                      BoxConstraints(maxHeight: _maxHeightNama),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '----',
                                  hintStyle: TextStyle(
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    color: const Color(textPlaceholder),
                                  ),
                                ),
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
                              child: Text(
                                'Jumlah Pengurangan',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormField(
                                controller: _namaController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'NRP Kosong';
                                //   } else if (value.length < 8) {
                                //     return 'Password Kosong';
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0)),
                                  constraints:
                                      BoxConstraints(maxHeight: _maxHeightNama),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '----',
                                  hintStyle: TextStyle(
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    color: const Color(textPlaceholder),
                                  ),
                                ),
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
                              child: Text(
                                'Kekurangan Kas',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: sizedBoxHeightShort,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TextFormField(
                                controller: _namaController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'NRP Kosong';
                                //   } else if (value.length < 8) {
                                //     return 'Password Kosong';
                                //   }
                                //   return null;
                                // },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 0)),
                                  constraints:
                                      BoxConstraints(maxHeight: _maxHeightNama),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '----',
                                  hintStyle: TextStyle(
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    color: const Color(textPlaceholder),
                                  ),
                                ),
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
                    child: Text(
                      'Catatan :',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: TextFormField(
                      controller: _namaController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'NRP Kosong';
                      //   } else if (value.length < 8) {
                      //     return 'Password Kosong';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints: BoxConstraints(maxHeight: _maxHeightNama),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '----',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: const Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
