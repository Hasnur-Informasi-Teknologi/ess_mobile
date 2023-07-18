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
      child: CupertinoButton(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: Colors.grey,
              ),
              Text(
                '${dateTime.day}-${dateTime.month}-${dateTime.year}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
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
    );
  }
}
