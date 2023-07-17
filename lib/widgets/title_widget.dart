import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final FontWeight? fontWeight;
  final double? fontSize;

  const TitleWidget(
      {super.key, required this.title, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        title!,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: Color(primaryBlack),
            fontSize: fontSize ?? textLarge,
            fontFamily: 'Poppins',
            letterSpacing: 0.9,
            fontWeight: fontWeight ?? FontWeight.w700),
      ),
    );
  }
}
