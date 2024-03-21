import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final double? fontSize;

  const TitleWidget(
      {super.key, required this.title, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;

    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: const Color(primaryBlack),
          fontSize: fontSize ?? textLarge,
          fontFamily: 'Poppins',
          letterSpacing: 0.6,
          fontWeight: fontWeight ?? FontWeight.w500),
    );
  }
}
