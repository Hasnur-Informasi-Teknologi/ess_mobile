import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class RowWithButtonWidget extends StatelessWidget {
  final String? textLeft, textRight;
  final FontWeight? fontWeightLeft, fontWeightRight;
  final double? fontSizeLeft, fontSizeRight;
  final VoidCallback? onTab;

  const RowWithButtonWidget({
    super.key,
    required this.textLeft,
    required this.textRight,
    this.fontWeightLeft,
    this.fontWeightRight,
    this.onTab,
    this.fontSizeLeft,
    this.fontSizeRight,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontalWide, vertical: padding10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            textLeft!,
            style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: fontSizeLeft ?? textSmall,
              fontFamily: 'Poppins',
              fontWeight: fontWeightLeft ?? FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: onTab,
            child: Container(
              padding: EdgeInsets.all(padding5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                textRight!,
                style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: fontSizeRight ?? textSmall,
                  fontFamily: 'Poppins',
                  fontWeight: fontWeightRight ?? FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
