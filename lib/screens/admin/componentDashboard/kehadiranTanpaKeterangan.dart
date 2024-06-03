import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/cupertino_datepicker_widget.dart';
import 'package:mobile_ess/screens/attendance/request_attendance_table_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class KehadiranTanpaKeterangan extends StatefulWidget {
  const KehadiranTanpaKeterangan({super.key});

  @override
  State<KehadiranTanpaKeterangan> createState() =>
      KehadiranTanpaKeteranganState();
}

class KehadiranTanpaKeteranganState extends State<KehadiranTanpaKeterangan> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightTall = size.height * 0.0163;
    double padding5 = size.width * 0.0115;

    return Column(
      children: [
        Text(
          'Kehadiran Tanpa Keterangan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: List.generate(40, (index) {
            return Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 1, right: 1),
                    child: Container(
                        padding: EdgeInsets.all(
                            12.0), // Adjust the padding as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 5, // Spread radius
                              blurRadius: 10, // Blur radius
                              offset: Offset(0, 3), // Offset in the y direction
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: sizedBoxHeightTall,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Budi Setiawan',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: textSmall,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'PT Hasnur Informasi Teknologi',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: textSmall,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Alasan',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: textSmall,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  'Lupa Absen',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: textSmall,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Aksi',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: textSmall,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Color.fromARGB(221, 0, 8, 3),
                                    elevation: 5,
                                    primary: Color.fromARGB(255, 2, 166, 13),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text('Approve'),
                                ),
                              ],
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }),
        )
      ],
    );
  }
}
