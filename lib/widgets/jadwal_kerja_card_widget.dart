import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class JadwalKerjaCardWidget extends StatelessWidget {
  const JadwalKerjaCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            const RowWidget(textLeft: 'Jadwal Kerja', textRight: 'April 2023'),
            const SizedBox(
              height: sizedBoxHeightTall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      width: size.width * 1 / 12,
                      color: const Color(primaryYellow),
                      padding: const EdgeInsets.all(10.0),
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
            const SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(textLeft: 'Jam Masuk', textRight: 'Jam Keluar'),
            const SizedBox(
              height: sizedBoxHeightShort,
            ),
            const RowWidget(
              textLeft: '10 April 2023 08.00 WITA',
              textRight: '10 April 2023 17.00 WITA',
              fontWeightLeft: FontWeight.w300,
              fontWeightRight: FontWeight.w300,
            ),
            const SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(textLeft: 'Sitem Kerja', textRight: 'Status'),
            const SizedBox(
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
