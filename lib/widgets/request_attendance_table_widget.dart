import 'package:flutter/material.dart';

class RequestAttendanceTableWidget extends StatelessWidget {
  const RequestAttendanceTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double sizedBoxHeightTall = size.height * 0.0163;
    double padding5 = size.width * 0.0115;

    return Column(
      children: [
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '01 Jul 2023',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: textSmall,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            Container(
              width: size.width * 1 / 7,
              padding: EdgeInsets.all(padding5),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                '08.00',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSmall,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              width: size.width * 1 / 7,
              padding: EdgeInsets.all(padding5),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                '17.00',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSmall,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {},
              icon: const Icon(Icons.add_box),
            )
          ],
        ),
      ],
    );
  }
}
