import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function? validator;
  final String hintText;
  final double maxHeightConstraints;
  const TextFormFieldWidget(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
      this.maxHeightConstraints = 60.0});

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(value);
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey, width: 0)),
        constraints: BoxConstraints(maxHeight: widget.maxHeightConstraints),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: textMedium,
          fontFamily: 'Poppins',
          color: const Color(textPlaceholder),
        ),
      ),
    );
  }
}
