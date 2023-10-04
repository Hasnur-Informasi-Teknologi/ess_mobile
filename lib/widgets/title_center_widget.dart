import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class TitleCenterWidget extends StatelessWidget {
  final String? textLeft, textRight;
  final FontWeight? fontWeightLeft, fontWeightRight;
  final double? fontSizeLeft, fontSizeRight;

  const TitleCenterWidget(
      {super.key,
      required this.textLeft,
      required this.textRight,
      this.fontWeightLeft,
      this.fontWeightRight,
      this.fontSizeLeft,
      this.fontSizeRight});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;

    return Row(
      children: [
        SizedBox(
          width: size.width * 0.43,
          child: Text(
            textLeft!,
            style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: fontSizeLeft ?? textSmall,
              fontFamily: 'Poppins',
              fontWeight: fontWeightLeft ?? FontWeight.w300,
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.43,
          child: Text(
            textRight!,
            style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: fontSizeRight ?? textSmall,
              fontFamily: 'Poppins',
              fontWeight: fontWeightRight ?? FontWeight.w300,
            ),
          ),
        )
      ],
    );
  }
}
