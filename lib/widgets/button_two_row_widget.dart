import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class ButtonTwoRowWidget extends StatelessWidget {
  final String? textLeft, textRight;
  final VoidCallback? onTabLeft, onTabRight;

  const ButtonTwoRowWidget(
      {super.key,
      required this.textLeft,
      required this.textRight,
      required this.onTabLeft,
      required this.onTabRight});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTabLeft,
          child: Container(
            width: size.width * 0.45,
            height: size.height * 0.04,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                textLeft!,
                style: const TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onTabRight,
          child: Container(
            width: size.width * 0.45,
            height: size.height * 0.04,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: const Color(primaryYellow),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                textRight!,
                style: const TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
