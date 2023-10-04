import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: CupertinoButton(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalNarrow, vertical: padding5),
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
                style: TextStyle(
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
