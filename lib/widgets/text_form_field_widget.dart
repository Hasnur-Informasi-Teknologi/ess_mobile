import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ess/themes/constant.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function? validator;
  final String hintText;
  final double maxHeightConstraints;
  final bool? enable;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  // onChanged
  final Function(String)? onChanged;

  const TextFormFieldWidget(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
      this.maxHeightConstraints = 60.0,
      this.enable,
      this.keyboardType,
      this.inputFormatters,
      this.onChanged});

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
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enable ?? true,
      decoration: InputDecoration(
        hintStyle: TextStyle(
            color: const Color(textPlaceholder),
            fontSize: textMedium,
            fontFamily: 'Poppins',
            letterSpacing: 0.6,
            fontWeight: FontWeight.w300),
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
        filled: widget.enable ?? true,
        fillColor: Colors.white,
        hintText: widget.hintText,
      ),
    );
  }
}
