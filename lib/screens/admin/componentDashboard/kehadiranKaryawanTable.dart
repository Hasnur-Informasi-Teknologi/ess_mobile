import 'package:flutter/material.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class KehadiranKaryawanTable extends StatefulWidget {
  const KehadiranKaryawanTable({super.key});

  @override
  State<KehadiranKaryawanTable> createState() => KehadiranKaryawanTableState();
}

class KehadiranKaryawanTableState extends State<KehadiranKaryawanTable> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightTall = size.height * 0.0163;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Karyawan',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Status',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Keluar',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Kembali',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Keperluan',
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
            return Column(
              children: [
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Budi Setiawan',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: textSmall,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'NRP : 78220001',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: textSmall,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Kembali',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '09.00',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '13.35',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Keperluan Pribadi',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: textSmall,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        )
      ],
    );
  }
}
