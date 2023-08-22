import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';

class FormPengajuanCuti extends StatefulWidget {
  const FormPengajuanCuti({super.key});

  @override
  State<FormPengajuanCuti> createState() => _FormPengajuanCutiState();
}

class _FormPengajuanCutiState extends State<FormPengajuanCuti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  double _maxHeightNama = 40.0;

  bool? _isDiBayar = false;
  bool? _isTidakDiBayar = false;
  bool? _isIzinLainnya = false;
  bool? _isRoster = false;

  @override
  Widget build(BuildContext context) {
    DateTime tanggalMulai = DateTime(3000, 2, 1, 10, 20);
    DateTime tanggalBerakhir = DateTime(3000, 2, 1, 10, 20);
    DateTime tanggalKembaliKerja = DateTime(3000, 2, 1, 10, 20);

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
          'Pengajuan Cuti',
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
                              'Atasan',
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
                                hintText: 'Pilih Entitas',
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
                              ' ',
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
                                hintText: 'Pilih Atasan',
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
                    'Atasan dari Atasan',
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0)),
                      constraints: BoxConstraints(maxHeight: _maxHeightNama),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Pilih Atasan dari Atasan',
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
                              'Karyawan Pengganti',
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
                                hintText: 'Pilih Entitas',
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
                              ' ',
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
                                hintText: 'Pilih Pengganti',
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
                    'Keterangan Cuti',
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
                  child: const LineWidget(),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Column(
                    children: [
                      buildCheckboxKeterangan(
                          'Cuti Tahunan Dibayar', _isDiBayar),
                      buildCheckboxKeterangan(
                          'Cuti Tahunan Tidak Dibayar', _isTidakDiBayar),
                      buildCheckboxKeterangan('Izin Lainnya', _isIzinLainnya),
                      buildCheckboxKeterangan('Cuti Roaster', _isRoster),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: Text(
                    'Keperluan Cuti',
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0)),
                      constraints: BoxConstraints(maxHeight: _maxHeightNama),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Keperluan Cuti',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: Text(
                    'Catatan Cuti',
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
                  child: const LineWidget(),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
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
                              'Cuti Yang Diambil',
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
                                hintText: '4 Hari',
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
                              'Sisa Cuti',
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
                                hintText: '12 Hari',
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
                    'Tanggal Pengajuan Cuti',
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
                  child: const LineWidget(),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
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
                              'Tanggal Mulai',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: const Color(primaryBlack),
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.9,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          CupertinoButton(
                            child: Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow,
                                  vertical: padding5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '${tanggalMulai.day}-${tanggalMulai.month}-${tanggalMulai.year}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: textMedium,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => SizedBox(
                                  height: 250,
                                  child: CupertinoDatePicker(
                                    backgroundColor: Colors.white,
                                    initialDateTime: tanggalMulai,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() => tanggalMulai = newTime);
                                      print(tanggalMulai);
                                    },
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ),
                              );
                            },
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
                              'Tanggal Berakhir',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: const Color(primaryBlack),
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.9,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          CupertinoButton(
                            child: Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow,
                                  vertical: padding5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    '${tanggalBerakhir.day}-${tanggalBerakhir.month}-${tanggalBerakhir.year}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: textMedium,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => SizedBox(
                                  height: 250,
                                  child: CupertinoDatePicker(
                                    backgroundColor: Colors.white,
                                    initialDateTime: tanggalBerakhir,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() => tanggalBerakhir = newTime);
                                      print(tanggalBerakhir);
                                    },
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: Text(
                    'Tanggal Kembali Kerja',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: const Color(primaryBlack),
                        fontSize: textMedium,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                CupertinoButton(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                        vertical: padding5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${tanggalKembaliKerja.day}-${tanggalKembaliKerja.month}-${tanggalKembaliKerja.year}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: textMedium,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                        height: 250,
                        child: CupertinoDatePicker(
                          backgroundColor: Colors.white,
                          initialDateTime: tanggalKembaliKerja,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalKembaliKerja = newTime);
                            print(tanggalKembaliKerja);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: Text(
                    'Alamat Cuti',
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0)),
                      constraints: BoxConstraints(maxHeight: _maxHeightNama),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Alamat Cuti',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: Text(
                    'No Telepon',
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0)),
                      constraints: BoxConstraints(maxHeight: _maxHeightNama),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '089XXXX',
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
      ),
    );
  }

  Widget buildCheckboxKeterangan(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isDiBayar = label == 'Cuti Tahunan Dibayar' ? newValue : false;
              _isTidakDiBayar =
                  label == 'Cuti Tahunan Tidak Dibayar' ? newValue : false;
              _isIzinLainnya = label == 'Izin Lainnya' ? newValue : false;
              _isRoster = label == 'Cuti Roaster' ? newValue : false;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: textMedium,
              fontFamily: 'Poppins',
              letterSpacing: 0.9,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
