import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/button_two_row_widget.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/three_row_widget.dart';

class UbahDataKehadiranScreen extends StatefulWidget {
  const UbahDataKehadiranScreen({super.key});

  @override
  State<UbahDataKehadiranScreen> createState() =>
      _UbahDataKehadiranScreenState();
}

class _UbahDataKehadiranScreenState extends State<UbahDataKehadiranScreen> {
  double _maxHeightKeterangan = 40.0;
  double _maxHeightFile = 40.0;

  final _keteranganController = TextEditingController();
  final _fileController = TextEditingController();

  void _openFilePicker() {
    print('File picker opened');
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime1 = DateTime(3000, 2, 1, 10, 20);
    DateTime dateTime2 = DateTime(3000, 2, 1, 8, 20);
    DateTime dateTime3 = DateTime(3000, 2, 1, 17, 10);

    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

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
          'Ubah Data Kehadiran',
          style: TextStyle(
            color: Colors.black,
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Tanggal',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Container(
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
                          '${dateTime1.day}-${dateTime1.month}-${dateTime1.year}',
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
                          initialDateTime: dateTime1,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => dateTime1 = newTime);
                            print(dateTime1);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: const ThreeRowWidget(
                      textLeft: 'Work System',
                      textRight: 'Schedule In',
                      textCenter: 'Schedule Out'),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: const ThreeRowWidget(
                    textLeft: 'Work System',
                    textRight: '08.00',
                    textCenter: '17.00',
                    fontWeightLeft: FontWeight.w300,
                    fontWeightCenter: FontWeight.w300,
                    fontWeightRight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: const LineWidget()),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Clock In',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Container(
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
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${dateTime2.hour}:${dateTime2.minute}',
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
                          initialDateTime: dateTime2,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => dateTime2 = newTime);
                            print(dateTime2);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.time,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Clock Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Container(
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
                          Icons.watch_later_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${dateTime3.hour}:${dateTime3.minute}',
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
                          initialDateTime: dateTime3,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => dateTime3 = newTime);
                            print(dateTime3);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.time,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Keterangan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _keteranganController,
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
                        constraints:
                            BoxConstraints(maxHeight: _maxHeightKeterangan),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Masukkan NRP Anda',
                        hintStyle: TextStyle(
                            fontSize: textMedium,
                            fontFamily: 'Poppins',
                            color: Color(textPlaceholder))),
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Text(
                    'Lampiran Bukti',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _fileController,
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
                      constraints: BoxConstraints(maxHeight: _maxHeightFile),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'File',
                      hintStyle: TextStyle(
                        fontSize: textMedium,
                        fontFamily: 'Poppins',
                        color: Color(textPlaceholder),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: ButtonTwoRowWidget(
                    textLeft: 'Cancel',
                    textRight: 'Requests',
                    onTabLeft: () {
                      print('Cancel');
                    },
                    onTabRight: () {
                      showCustomModal(context);
                    },
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showCustomModal(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _textController = TextEditingController();

        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.info)), // Ikon yang ingin ditampilkan
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Modal Dialog',
                  style: TextStyle(
                    color: Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Text(
                'Mohon Berikan Alasan',
                style: TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: _textController,
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
                  borderSide: const BorderSide(color: Colors.black, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey, width: 0)),
              constraints: const BoxConstraints(maxHeight: 50),
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(
                fontSize: textMedium,
                fontFamily: 'Poppins',
                color: Color(textPlaceholder),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                width: size.width * 0.3,
                height: size.height * 0.04,
                padding: EdgeInsets.all(padding5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: Color(primaryBlack),
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: size.width * 0.3,
                height: size.height * 0.04,
                padding: EdgeInsets.all(padding5),
                decoration: BoxDecoration(
                  color: const Color(primaryYellow),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Text(
                    'Kirim',
                    style: TextStyle(
                      color: Color(primaryBlack),
                      fontSize: textMedium,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
