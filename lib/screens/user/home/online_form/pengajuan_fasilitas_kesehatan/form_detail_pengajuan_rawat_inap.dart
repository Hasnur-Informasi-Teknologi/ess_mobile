import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/pengumuman_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormDetailPengajuanRawatInap extends StatefulWidget {
  const FormDetailPengajuanRawatInap({super.key});

  @override
  State<FormDetailPengajuanRawatInap> createState() =>
      _FormDetailPengajuanRawatInapState();
}

class _FormDetailPengajuanRawatInapState
    extends State<FormDetailPengajuanRawatInap> {
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
          'Detail Pengajuan Rawat Inap',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Jenis Penggantian',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      hintText: 'Jenis Penggantian',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Detail Penggantian',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      hintText: 'Detail Penggantian',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'No Kwitansi',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      hintText: 'No Kwitansi',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Tanggal Kwitansi',
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
                          '${dateTime.day}-${dateTime.month}-${dateTime.year}',
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
                          initialDateTime: dateTime,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => dateTime = newTime);
                            print(dateTime);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Jumlah',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      hintText: 'Rp 700.000',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Keterangan/Diagnosa',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      hintText: 'Keterangan',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Lampiran Bukti Pembayaran',
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
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      hintText: 'lampiran Bukti Pembayaran',
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
}