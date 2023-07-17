import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';

class RequestAttendanceTableWidget extends StatelessWidget {
  const RequestAttendanceTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(
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
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: const Text(
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
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: const Text(
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
