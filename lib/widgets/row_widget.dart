import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class RowWidget extends StatelessWidget {
  final String? textLeft, textRight;
  final FontWeight? fontWeightLeft, fontWeightRight;
  final double? fontSizeLeft, fontSizeRight;

  const RowWidget({
    super.key,
    required this.textLeft,
    required this.textRight,
    this.fontWeightLeft,
    this.fontWeightRight,
    this.fontSizeLeft,
    this.fontSizeRight,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          textLeft!,
          style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: fontSizeLeft ?? textSmall,
            fontFamily: 'Poppins',
            fontWeight: fontWeightLeft ?? FontWeight.w500,
          ),
        ),
        Text(
          textRight!,
          style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: fontSizeRight ?? textSmall,
            fontFamily: 'Poppins',
            fontWeight: fontWeightRight ?? FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
