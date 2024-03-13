import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/cupertino_datepicker_widget.dart';
import 'package:mobile_ess/widgets/request_attendance_table_widget.dart';

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
    double sizedBoxHeightExtraTall = size.height * 0.0215;
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
          },
        ),
        title: const Text(
          'Kehadiran',
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalWide, vertical: padding10),
            child: Column(
              children: [
                const CupertinoDatePickerWidget(),
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                          '/user/main/home/request_attendance/ubah_data_kehadiran');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Request Attandance',
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tanggal',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Clock-In',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Clock-Out',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Aksi',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(40, (index) {
                    return const RequestAttendanceTableWidget();
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
