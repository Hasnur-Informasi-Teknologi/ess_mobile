import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class RowWithButtonWidget extends StatelessWidget {
  final String? textLeft, textRight;
  final FontWeight? fontWeightLeft, fontWeightRight;
  final double? fontSizeLeft, fontSizeRight;
  final VoidCallback? onTab;
  final bool isEnabled;

  const RowWithButtonWidget({
    super.key,
    required this.textLeft,
    required this.textRight,
    this.fontWeightLeft,
    this.fontWeightRight,
    this.onTab,
    this.fontSizeLeft,
    this.fontSizeRight,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double padding5 = size.width * 0.0115;

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
        InkWell(
          onTap: isEnabled ? onTab : null,
          child: Container(
            padding: EdgeInsets.all(padding5),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.grey[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Text(
              textRight!,
              style: TextStyle(
                color: isEnabled ? const Color(primaryBlack) : Colors.grey,
                fontSize: fontSizeRight ?? textSmall,
                fontFamily: 'Poppins',
                fontWeight: fontWeightRight ?? FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
