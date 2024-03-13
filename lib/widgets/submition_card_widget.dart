import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';

class SubmitionCardWidget extends StatelessWidget {
  const SubmitionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0188;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: sizedBoxHeightExtraTall),
          height: size.height * 0.254,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingHorizontalNarrow),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RowWidget(
                  textLeft: 'Prioritas',
                  textRight: 'Normal',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: 'dd/mm/yyyy',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const RowWidget(
                  textLeft: 'Diajukan Oleh',
                  textRight: 'Nama',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const RowWidget(
                  textLeft: 'NRP',
                  textRight: 'HG78220012',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const RowWidget(
                  textLeft: 'Judul Training',
                  textRight: 'Basic Data',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const RowWidget(
                  textLeft: 'Fungsi Training',
                  textRight: 'Sangat Direkomendasikan',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                            '/user/main/submition/aplikasi_training/detail_aplikasi_training');
                      },
                      child: Container(
                        width: size.width * 0.4,
                        height: size.height * 0.04,
                        padding: EdgeInsets.all(padding5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.details_sharp),
                              Text(
                                'Detail',
                                style: TextStyle(
                                  color: Color(primaryBlack),
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: size.width * 0.4,
                        height: size.height * 0.04,
                        padding: EdgeInsets.all(padding5),
                        decoration: BoxDecoration(
                          color: const Color(primaryYellow),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.download_rounded),
                              Text(
                                'Unduhan',
                                style: TextStyle(
                                  color: Color(primaryBlack),
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
