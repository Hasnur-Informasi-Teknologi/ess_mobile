import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class ErrorDialogWidget extends StatelessWidget {
  const ErrorDialogWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'errorDialogTitle',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            message,
            textAlign: TextAlign.center,
          )),
      actions: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(primaryYellow))),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text('OK',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color(primaryBlack))),
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
