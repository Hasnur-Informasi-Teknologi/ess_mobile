import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFielDisableWidget extends StatefulWidget {
  final TextEditingController controller;
  final double maxHeightConstraints;
  const TextFormFielDisableWidget(
      {super.key, required this.controller, this.maxHeightConstraints = 60.0});

  @override
  State<TextFormFielDisableWidget> createState() =>
      _TextFormFielDisableWidgetState();
}

class _TextFormFielDisableWidgetState extends State<TextFormFielDisableWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        fontSize: textMedium,
        color: Colors.black,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w400,
      ),
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
        fillColor: Colors.grey[200],
        hintStyle: TextStyle(
          fontSize: textMedium,
          fontFamily: 'Poppins',
          color: Colors.black,
        ),
      ),
      enabled: false,
    );
  }
}
