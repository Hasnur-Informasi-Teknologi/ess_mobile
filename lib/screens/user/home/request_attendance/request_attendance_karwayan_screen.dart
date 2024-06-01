import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/cupertino_datepicker_widget.dart';
import 'package:mobile_ess/screens/attendance/request_attendance_table_widget.dart';

class RequestAttendanceKaryawanScreen extends StatefulWidget {
  const RequestAttendanceKaryawanScreen({super.key});

  @override
  State<RequestAttendanceKaryawanScreen> createState() =>
      _RequestAttendanceKaryawanScreenState();
}

class _RequestAttendanceKaryawanScreenState
    extends State<RequestAttendanceKaryawanScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
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
          },
        ),
        title: Text(
          'Laporan Absensi',
          style: TextStyle(
            color: Colors.black,
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontalWide, vertical: padding10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * 1 / 7,
                  padding: EdgeInsets.all(padding5),
                  child: Text(
                    'Tanggal',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 1 / 7,
                  padding: EdgeInsets.all(padding5),
                  child: Text(
                    'Clock In',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 1 / 7,
                  padding: EdgeInsets.all(padding5),
                  child: Text(
                    'Clock In Status',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 1 / 7,
                  padding: EdgeInsets.all(padding5),
                  child: Text(
                    'Clock Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 1 / 7,
                  padding: EdgeInsets.all(padding5),
                  child: Text(
                    'Clock Out Status',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textSmall,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: const RequestAttendanceTableWidget())
          ],
        ),
      ),
    );
  }
}
