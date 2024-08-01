import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class PengumumanCardWidget extends StatelessWidget {
  const PengumumanCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;

    return InkWell(
      onTap: () {
        Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontalWide, vertical: padding10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LineWidget(),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            const RowWidget(
              textLeft: 'Undangan Pengajian Hasnur Group',
              textRight: 'Kamis, 22 Juni 2023',
              fontWeightLeft: FontWeight.w500,
              fontWeightRight: FontWeight.w300,
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Text(
              '10 April 2023 08.00 WITA',
              style: TextStyle(
                  color: const Color(primaryBlack),
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
                  color: const Color(primaryBlack),
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
