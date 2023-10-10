import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/providers/auth_provider.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> dataKaryawan = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _trainingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final double _maxHeightTraining = 40.0;
  final double _maxHeightSearch = 40.0;

  final String _apiUrl = API_URL;

  @override
  void initState() {
    super.initState();
    getDataTransaksi();
    getDataKaryawan();
  }

  Future<void> getDataTransaksi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/get_data_detail_plafon?page=1&perPage=5&search=''"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
      } catch (e) {
        // print(e);
      }
    }
  }

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$_apiUrl/get_data_karyawan'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        final responseData = jsonDecode(response.body);
        print(responseData);

        final dataKaryawanApi = responseData['data']['data'];

        setState(() {
          dataKaryawan = List<Map<String, dynamic>>.from(dataKaryawanApi);
          print(dataKaryawan.length);
        });
      } catch (e) {}
    } else {
      print('tidak ada token home');
    }
  }

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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataKaryawan.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (dataKaryawan.isEmpty) {
                            return const Center(
                              child: Text('Data Karyawan Kosong'),
                            );
                          }
                          final karyawan = dataKaryawan[index];
                          return Column(
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
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: const Offset(1.1, 1.1),
                                        blurRadius: 10.0),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(paddingHorizontalNarrow),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RowWidget(
                                        textLeft: 'Nama Karyawan',
                                        textRight:
                                            '${karyawan['nama_karyawan']}',
                                        fontWeightLeft: FontWeight.w300,
                                        fontWeightRight: FontWeight.w300,
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      RowWidget(
                                        textLeft: 'NRP',
                                        textRight: '${karyawan['nrp']}',
                                        fontWeightLeft: FontWeight.w300,
                                        fontWeightRight: FontWeight.w300,
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      RowWidget(
                                        textLeft: 'Email',
                                        textRight: '${karyawan['email']}',
                                        fontWeightLeft: FontWeight.w300,
                                        fontWeightRight: FontWeight.w300,
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      RowWidget(
                                        textLeft: 'Tanggal Masuk',
                                        textRight: '${karyawan['tgl_masuk']}',
                                        fontWeightLeft: FontWeight.w300,
                                        fontWeightRight: FontWeight.w300,
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      RowWidget(
                                        textLeft: 'Entitas',
                                        textRight: '${karyawan['entitas']}',
                                        fontWeightLeft: FontWeight.w300,
                                        fontWeightRight: FontWeight.w300,
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      RowWidget(
                                        textLeft: 'Lokasi',
                                        textRight: '${karyawan['lokasi']}',
                                        fontWeightLeft: FontWeight.w300,
                                        fontWeightRight: FontWeight.w300,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
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
