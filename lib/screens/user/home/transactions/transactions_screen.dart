import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _trainingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final double _maxHeightTraining = 40.0;
  final double _maxHeightSearch = 40.0;

  int current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.047;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
              // Navigator.pop(context);
            },
          ),
          title: const Text(
            'Detail Transaksi Plafon',
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            Form(
              child: Column(
                key: _formKey,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: TextFormField(
                      controller: _trainingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints:
                            BoxConstraints(maxHeight: _maxHeightTraining),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Rawat Jalan',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 0)),
                        constraints:
                            BoxConstraints(maxHeight: _maxHeightSearch),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide,
                            vertical: padding10),
                        child: RowWithButtonWidget(
                          textLeft: 'Detail Transaksi Plafon',
                          textRight: 'Eksport',
                          fontSizeLeft: textMedium,
                          fontSizeRight: textMedium,
                          onTab: () {
                            // Get.toNamed('/user/main/home/request_attendance');
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: sizedBoxHeightShort),
                                height: size.height * 0.21,
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(paddingHorizontalNarrow),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: sizedBoxHeightShort),
                                height: size.height * 0.21,
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(paddingHorizontalNarrow),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: sizedBoxHeightShort),
                                height: size.height * 0.21,
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(paddingHorizontalNarrow),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
