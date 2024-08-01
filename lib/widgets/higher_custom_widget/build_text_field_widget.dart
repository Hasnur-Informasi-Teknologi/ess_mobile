import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class BuildTextFieldWidget extends StatelessWidget {
  final String title;
  final bool isMandatory;
  final bool isWithTitle;
  final double textSize;
  final double horizontalPadding;
  final double verticalSpacing;
  final TextEditingController controller;
  final String hintText;
  final double? maxHeightConstraints;
  final String? Function(String?)? validator;
  final bool isNumberField;
  final bool isDisable;

  const BuildTextFieldWidget({
    super.key,
    required this.title,
    required this.isMandatory,
    required this.textSize,
    required this.horizontalPadding,
    required this.verticalSpacing,
    required this.controller,
    required this.hintText,
    this.maxHeightConstraints,
    this.validator,
    this.isNumberField = false,
    this.isDisable = false,
    this.isWithTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightTall = size.height * 0.0163;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWithTitle)
            Row(
              children: [
                TitleWidget(
                  title: title,
                  fontWeight: FontWeight.w300,
                  fontSize: textSize,
                ),
                if (isMandatory)
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: textSize,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
              ],
            ),
          SizedBox(height: verticalSpacing),
          if (isNumberField && !isDisable)
            TextFormFieldNumberWidget(
              validator: validator,
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
              hintText: hintText,
            ),
          if (isDisable && !isNumberField)
            TextFormFielDisableWidget(
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
            ),
          if (!isDisable && !isNumberField)
            TextFormFieldWidget(
              validator: validator,
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
              hintText: hintText,
            ),
          SizedBox(height: sizedBoxHeightTall),
        ],
      ),
    );
  }
}
