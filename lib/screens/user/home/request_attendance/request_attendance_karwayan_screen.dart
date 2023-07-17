import 'package:flutter/material.dart';
import 'package:mobile_ess/screens/user/home/request_attendance/ubah_data_kehadiran_screen.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Kehadiran',
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                const CupertinoDatePickerWidget(),
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  const UbahDataKehadiranScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Request Attandance',
                      style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
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
