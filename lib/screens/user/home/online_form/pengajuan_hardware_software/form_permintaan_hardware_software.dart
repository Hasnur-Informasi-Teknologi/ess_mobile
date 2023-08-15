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

class FormPermintaanHardwareSoftware extends StatefulWidget {
  const FormPermintaanHardwareSoftware({super.key});

  @override
  State<FormPermintaanHardwareSoftware> createState() =>
      _FormPermintaanHardwareSoftwareState();
}

class _FormPermintaanHardwareSoftwareState
    extends State<FormPermintaanHardwareSoftware> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  double _maxHeightNama = 40.0;

  bool? _isDesktop = false;
  bool? _isPrinter = false;
  bool? _isMonitor = false;
  bool? _isKeyboard = false;
  bool? _isLaptop = false;
  bool? _isMouse = false;

  bool? _isMsVisio = false;
  bool? _isAutocad = false;
  bool? _isMsProject = false;
  bool? _isAdobeAcrobat = false;
  bool? _isMsPublisher = false;
  bool? _isMsAccess = false;

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
          'Permintatan Hardware & Software',
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
                    'Tipe Karyawan',
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
                      hintText: 'Karyawan Baru',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Departemen',
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
                      hintText: 'Departemen',
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
                    'Lokasi',
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
                      hintText: 'Lokasi',
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
                    'Tanggal Pengajuan',
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
                    'Diminta Oleh',
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
                      hintText: 'Diminta Oleh',
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
                      hintText: 'No Telepon',
                      hintStyle: TextStyle(
                        fontSize: textMedium,
                        fontFamily: 'Poppins',
                        color: const Color(textPlaceholder),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: const TitleWidget(
                      title: 'Hardware dan Software yang Diminta'),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Hardware',
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxHardware('Desktop', _isDesktop),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxHardware('Printer', _isPrinter),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxHardware('Monitor', _isMonitor),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxHardware('Keyboard', _isKeyboard),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxHardware('Laptop', _isLaptop),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxHardware('Mouse', _isMouse),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Software',
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxSoftware('MS Visio 2007', _isMsVisio),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxSoftware('Autocad', _isAutocad),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxSoftware(
                          'Ms Project 2007', _isMsProject),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxSoftware(
                          'Adobe Acrobat', _isAdobeAcrobat),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxSoftware(
                          'Ms Publisher 2007', _isMsPublisher),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildCheckboxSoftware('Ms Access', _isMsAccess),
                    )
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Penjelasan',
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
                      hintText: 'Penjelasan',
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
                    'Tambahan Permintaan Hardware & Software Lainnya',
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
                      hintText:
                          'Tambahan Permintaan Hardware & Software Lainnya',
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
                    'Keterangan',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckboxHardware(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isDesktop = label == 'Desktop' ? newValue : false;
              _isPrinter = label == 'Printer' ? newValue : false;
              _isMonitor = label == 'Monitor' ? newValue : false;
              _isKeyboard = label == 'Keyboard' ? newValue : false;
              _isLaptop = label == 'Laptop' ? newValue : false;
              _isMouse = label == 'Mouse' ? newValue : false;
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

  Widget buildCheckboxSoftware(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isMsVisio = label == 'MS Visio 2007' ? newValue : false;
              _isAutocad = label == 'Autocad' ? newValue : false;
              _isMsProject = label == 'Ms Project 2007' ? newValue : false;
              _isAdobeAcrobat = label == 'Adobe Acrobat' ? newValue : false;
              _isMsPublisher = label == 'Ms Publisher 2007' ? newValue : false;
              _isMsAccess = label == 'Ms Access' ? newValue : false;
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
