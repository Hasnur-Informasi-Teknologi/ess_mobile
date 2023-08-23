import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_ess/themes/constant.dart';

class RowWithThreeIconsWidget extends StatelessWidget {
  const RowWithThreeIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double icon = size.width * 0.05;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.047;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    return Container(
      margin: EdgeInsets.symmetric(vertical: sizedBoxHeightShort),
      height: size.height * 0.05,
      width: size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(paddingHorizontalNarrow),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Peraturan Perusahaan',
              style: TextStyle(
                color: const Color(primaryBlack),
                fontSize: textMedium,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.remove_red_eye, // Mendapatkan ikon berdasarkan indeks
                  color: Colors.grey[700],
                  size: icon,
                ),
                SizedBox(
                  width: padding10,
                ),
                Icon(
                  Icons.edit_calendar, // Mendapatkan ikon berdasarkan indeks
                  color: Colors.grey[700],
                  size: icon,
                ),
                SizedBox(
                  width: padding10,
                ),
                Icon(
                  Icons.delete, // Mendapatkan ikon berdasarkan indeks
                  color: Colors.grey[700],
                  size: icon,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
