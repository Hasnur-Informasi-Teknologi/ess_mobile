import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/row_with_three_icons_widget.dart';

class DocomentsScreen extends StatefulWidget {
  const DocomentsScreen({super.key});

  @override
  State<DocomentsScreen> createState() => _DocomentsScreenState();
}

class _DocomentsScreenState extends State<DocomentsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _trainingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  double _maxHeightTraining = 40.0;
  double _maxHeightSearch = 40.0;

  int current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double icon = size.width * 0.05;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double padding10 = size.width * 0.023;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.047;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;

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
            // Navigator.pop(context);
          },
        ),
        title: const Text(
          'Dokumen Perusahaan',
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0)),
                      constraints: BoxConstraints(maxHeight: _maxHeightSearch),
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
            height: sizedBoxHeightTall,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RowWithThreeIconsWidget(),
                    RowWithThreeIconsWidget(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
