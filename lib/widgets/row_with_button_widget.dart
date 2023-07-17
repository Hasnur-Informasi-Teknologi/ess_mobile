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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            textLeft!,
            style: TextStyle(
              color: Color(primaryBlack),
              fontSize: fontSizeLeft ?? textSmall,
              fontFamily: 'Poppins',
              fontWeight: fontWeightLeft ?? FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: onTab,
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                textRight!,
                style: TextStyle(
                  color: Color(primaryBlack),
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
