import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class CupertinoDatePickerWidget extends StatefulWidget {
  const CupertinoDatePickerWidget({super.key});

  @override
  State<CupertinoDatePickerWidget> createState() =>
      _CupertinoDatePickerWidgetState();
}

class _CupertinoDatePickerWidgetState extends State<CupertinoDatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Center(
        child: CupertinoButton(
          child: Text(
            '${dateTime.day}-${dateTime.month}-${dateTime.year}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: textMedium,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
            ),
          ),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white,
                  initialDateTime: dateTime,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() => dateTime = newTime);
                    print(dateTime);
                  },
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
