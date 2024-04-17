import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class DetailPengumumanScreen extends StatelessWidget {
  const DetailPengumumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding10 = size.width * 0.023;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Detail Pengumuman',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontalWide, vertical: padding10),
        child: Column(
          children: [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            RowWidget(
              textLeft: 'To',
              textRight: ' Semua Karwayan Hasnur Group',
              fontSizeLeft: textMedium,
              fontSizeRight: textMedium,
              fontWeightLeft: FontWeight.w500,
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
              fontWeightLeft: FontWeight.w500,
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
              fontWeightLeft: FontWeight.w500,
              fontWeightRight: FontWeight.w300,
            ),
          ],
        ),
      ),
    );
  }
}
