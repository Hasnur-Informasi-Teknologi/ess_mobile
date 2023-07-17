import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class DetailPengumumanScreen extends StatelessWidget {
  const DetailPengumumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Pengumuman',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: const [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            RowWidget(
              textLeft: 'To',
              textRight: ' Semua Karwayan Hasnur Group',
              fontSizeLeft: textMedium,
              fontSizeRight: textMedium,
              fontWeightLeft: FontWeight.w700,
              fontWeightRight: FontWeight.w300,
            ),
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            RowWidget(
              textLeft: 'Cc',
              textRight: ' Semua Karwayan Hasnur Group',
              fontSizeLeft: textMedium,
              fontSizeRight: textMedium,
              fontWeightLeft: FontWeight.w700,
              fontWeightRight: FontWeight.w300,
            ),
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            RowWidget(
              textLeft: 'Jenis Announcement',
              textRight: ' Announcement General',
              fontSizeLeft: textMedium,
              fontSizeRight: textMedium,
              fontWeightLeft: FontWeight.w700,
              fontWeightRight: FontWeight.w300,
            ),
          ],
        ),
      ),
    );
  }
}
