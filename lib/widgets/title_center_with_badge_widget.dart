import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_ess/themes/constant.dart';

class TitleCenterWithBadgeWidget extends StatelessWidget {
  final String? textLeft, textRight;
  final FontWeight? fontWeightLeft, fontWeightRight;
  final double? fontSizeLeft, fontSizeRight;
  final Color? color;
  const TitleCenterWithBadgeWidget(
      {super.key,
      required this.textLeft,
      required this.textRight,
      this.fontWeightLeft,
      this.fontWeightRight,
      this.fontSizeLeft,
      this.fontSizeRight,
      this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double padding5 = size.width * 0.0115;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Container(
          width: size.width * 0.2,
          padding: EdgeInsets.all(padding5),
          decoration: BoxDecoration(
            color: color ?? Colors.green,
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Center(
            child: Text(
              textRight!,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSizeRight ?? textSmall,
                fontFamily: 'Poppins',
                fontWeight: fontWeightRight ?? FontWeight.w300,
              ),
            ),
          ),
        )
      ],
    );
  }
}
