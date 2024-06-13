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
    Size size = MediaQuery.of(context).size;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

    return AlertDialog(
      title: const Text(
        'Peringatan',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500),
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
          padding: EdgeInsets.symmetric(horizontal: padding5),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(primaryYellow))),
            child: Padding(
              padding: EdgeInsets.all(padding10),
              child: const Text('OK',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Color(primaryBlack))),
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
