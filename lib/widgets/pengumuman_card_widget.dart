import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/home/detail_pengumuman/detail_pengumuman_screen.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class PengumumanCardWidget extends StatelessWidget {
  const PengumumanCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            LineWidget(),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            RowWidget(
              textLeft: 'Undangan Pengajian Hasnur Group',
              textRight: 'Kamis, 22 Juni 2023',
              fontWeightLeft: FontWeight.w700,
              fontWeightRight: FontWeight.w300,
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Text(
              '10 April 2023 08.00 WITA',
              style: TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textSmall,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Text(
              'Zoom Meeting',
              style: TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textSmall,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
