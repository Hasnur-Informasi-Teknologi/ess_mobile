import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:mobile_ess/themes/colors.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.red,
      title: const Text(
        'Warning',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )),
      actions: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white)),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text('OK',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
