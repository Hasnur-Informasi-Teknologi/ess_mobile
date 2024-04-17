import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class ThreeRowWidget extends StatelessWidget {
  final String? textLeft, textCenter, textRight;
  final FontWeight? fontWeightLeft, fontWeightCenter, fontWeightRight;

  const ThreeRowWidget({
    super.key,
    required this.textLeft,
    required this.textRight,
    required this.textCenter,
    this.fontWeightLeft,
    this.fontWeightCenter,
    this.fontWeightRight,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textLeft!,
          style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: textMedium,
            fontFamily: 'Poppins',
            fontWeight: fontWeightLeft ?? FontWeight.w500,
          ),
        ),
        Text(
          textCenter!,
          style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: textMedium,
            fontFamily: 'Poppins',
            fontWeight: fontWeightCenter ?? FontWeight.w500,
          ),
        ),
        Text(
          textRight!,
          style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: textMedium,
            fontFamily: 'Poppins',
            fontWeight: fontWeightRight ?? FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
