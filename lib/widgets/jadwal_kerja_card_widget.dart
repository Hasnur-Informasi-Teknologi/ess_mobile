import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class JadwalKerjaCardWidget extends StatelessWidget {
  const JadwalKerjaCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightShort = size.height * 0.01;

    double padding8 = size.width * 0.0188;
    double padding10 = size.width * 0.023;
    double padding20 = size.width * 0.047;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding20),
      child: Container(
        padding: EdgeInsets.all(padding10),
        height: size.height * 0.23,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const RowWidget(textLeft: 'Jadwal Kerja', textRight: 'April 2023'),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        width: size.width * 1 / 12,
                        color: const Color(primaryYellow),
                        padding: EdgeInsets.all(padding10),
                        child: Text(
                          '${index + 1}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: textSmall,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(textLeft: 'Jam Masuk', textRight: 'Jam Keluar'),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            const RowWidget(
              textLeft: '10 April 2023 08.00 WITA',
              textRight: '10 April 2023 17.00 WITA',
              fontWeightLeft: FontWeight.w300,
              fontWeightRight: FontWeight.w300,
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(textLeft: 'Sitem Kerja', textRight: 'Status'),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            const RowWidget(
              textLeft: '10 April 2023 08.00 WITA',
              textRight: '10 April 2023 17.00 WITA',
              fontWeightLeft: FontWeight.w300,
              fontWeightRight: FontWeight.w300,
            ),
          ],
        ),
      ),
    );
  }
}
