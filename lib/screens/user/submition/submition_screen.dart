import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/button_two_row_widget.dart';
import 'package:mobile_ess/widgets/form_aplikasi_training_widget.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class SubmitionScreen extends StatefulWidget {
  const SubmitionScreen({super.key});

  @override
  State<SubmitionScreen> createState() => _SubmitionScreenState();
}

class _SubmitionScreenState extends State<SubmitionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _trainingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  double _maxHeightTraining = 40.0;
  double _maxHeightSearch = 40.0;

  int current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(title: 'Riwayat Persetujuan'),
            const SizedBox(
              height: sizedBoxHeightTall,
            ),
            Form(
              child: Column(
                key: _formKey,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontalWide),
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
                        hintText: 'Form Aplikasi Training',
                        hintStyle: const TextStyle(
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          color: Color(textPlaceholder),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontalWide),
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
                        hintStyle: const TextStyle(
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
            const SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    // indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                    tabs: const [
                      Tab(
                        text: 'Terkirim',
                      ),
                      Tab(
                        text: 'Disetujui',
                      ),
                      Tab(
                        text: 'Ditolak',
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        current = index;
                      });
                    },
                  ),
                  //Main Body
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: sizedBoxHeightExtraTall,
                                ),
                                const Text(
                                  'Persetujuan Form Aplikasi Training',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(primaryBlack),
                                      fontSize: textLarge,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w700),
                                ),
                                Column(
                                  children: List.generate(4, (index) {
                                    return const FormAplikasiTrainingWidget();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: sizedBoxHeightExtraTall,
                                ),
                                const Text(
                                  'Persetujuan Form Aplikasi Training',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(primaryBlack),
                                      fontSize: textLarge,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w700),
                                ),
                                Column(
                                  children: List.generate(4, (index) {
                                    return const FormAplikasiTrainingWidget();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: sizedBoxHeightExtraTall,
                                ),
                                const Text(
                                  'Persetujuan Form Aplikasi Training',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(primaryBlack),
                                      fontSize: textLarge,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w700),
                                ),
                                Column(
                                  children: List.generate(4, (index) {
                                    return const FormAplikasiTrainingWidget();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
