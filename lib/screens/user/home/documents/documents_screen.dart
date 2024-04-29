import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/row_with_three_icons_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';

class DocomentsScreen extends StatefulWidget {
  const DocomentsScreen({super.key});

  @override
  State<DocomentsScreen> createState() => _DocomentsScreenState();
}

class _DocomentsScreenState extends State<DocomentsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final double _maxHeightSearch = 40.0;

  int current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightTall = size.height * 0.0163;
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: Column(
                key: _formKey,
                children: [
                  TextFormFieldWidget(
                    controller: _searchController,
                    maxHeightConstraints: _maxHeightSearch,
                    hintText: 'Search',
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
