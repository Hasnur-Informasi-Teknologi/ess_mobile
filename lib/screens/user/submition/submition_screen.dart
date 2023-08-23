import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/submition_card_widget.dart';
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
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.047;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: TitleWidget(title: 'Riwayat Persetujuan'),
            ),
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
                        hintText: 'Form Aplikasi Training',
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
              child: Column(
                children: [
                  TabBar(
                    // indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelPadding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: sizedBoxHeightExtraTall,
                                ),
                                Text(
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
                                    return const SubmitionCardWidget();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: sizedBoxHeightExtraTall,
                                ),
                                Text(
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
                                    return const SubmitionCardWidget();
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: sizedBoxHeightExtraTall,
                                ),
                                Text(
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
                                    return const SubmitionCardWidget();
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
