import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DaftarPersetujuanScreen extends StatefulWidget {
  const DaftarPersetujuanScreen({super.key});

  @override
  State<DaftarPersetujuanScreen> createState() =>
      _DaftarPersetujuanScreenState();
}

class _DaftarPersetujuanScreenState extends State<DaftarPersetujuanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _alasanRejectController = TextEditingController();

  final String _apiUrl = API_URL;

  final TextEditingController _trainingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> selectedDaftarPersetujuan = [
    {'id': '1', 'opsi': 'Aplikasi Rekrutmen'},
    {'id': '2', 'opsi': 'Bantuan Komunikasi'},
    {'id': '3', 'opsi': 'Hard/Software'},
    {'id': '4', 'opsi': 'Lembur Karyawan'},
    {'id': '12', 'opsi': 'Summary Cuti'},
    {'id': '5', 'opsi': 'Pengajuan Cuti'},
    {'id': '8', 'opsi': 'Perpanjangan Cuti'},
    {'id': '6', 'opsi': 'Pengajuan Training'},
    {'id': '7', 'opsi': 'Perjalanan Dinas'},
    {'id': '9', 'opsi': 'Rawat Inap'},
    {'id': '10', 'opsi': 'Rawat Jalan'},
    {'id': '11', 'opsi': 'Surat Keterangan'},
  ];

  List<Map<String, dynamic>> masterDataPersetujuan = [];
  List<Map<String, dynamic>> masterDataSummaryCuti = [];
  Map<String, dynamic> masterDataCuti = {};

  String? selectedValueDaftarPersetujuan;
  bool _isLoading = false;
  bool _isLoadingScreen = false;

  bool isDataEmpty = true;

  String? page = '1';
  String? perPage = '10';
  String? search = '';
  String? statusFilter = 'ALL';
  String? statusFilterRawatInapJalan = 'ALL';
  String? type = 'persetujuan';
  String? kodeEntitas = '';
  String? tahunPengajuan = '';

  final double _maxHeightDaftarPermintaan = 60.0;
  final double _maxHeightSearch = 40.0;

  int current = 0;

  @override
  void initState() {
    super.initState();
    getMasterDataCuti();
  }

  Future<void> getDataPengajuanCuti(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/pengajuan-cuti/get?page=$page&perPage=$perPage&search=$search&status=$statusFilter&type=$type&entitas=$kodeEntitas&tahun=$tahunPengajuan"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterCutiApi = responseData['dcuti'];

        setState(() {
          masterDataPersetujuan =
              List<Map<String, dynamic>>.from(dataMasterCutiApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataPerpanjanganCuti(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/perpanjangan-cuti/get?page=$page&perPage=$perPage&search=$search&status=$statusFilter&type=$type"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterCutiApi = responseData['pcuti'];

        setState(() {
          masterDataPersetujuan =
              List<Map<String, dynamic>>.from(dataMasterCutiApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataRawatInap(String? statusFilterRawatInapJalan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/rawat/inap/all?page=$page&limit=$perPage&search=$search&status=$statusFilterRawatInapJalan&permintaan=1"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterInapApi = responseData['data']['data'];

        setState(() {
          masterDataPersetujuan =
              List<Map<String, dynamic>>.from(dataMasterInapApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataRawatJalan(String? statusFilterRawatInapJalan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/rawat/jalan/all?page=$page&limit=$perPage&search=$search&status=$statusFilterRawatInapJalan&permintaan=1"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterJalanApi = responseData['data']['data'];

        setState(() {
          masterDataPersetujuan =
              List<Map<String, dynamic>>.from(dataMasterJalanApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataSummaryCuti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/pengajuan-cuti/summary?page=$page&perPage=$perPage&search=$search"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterSummaryCutiApi = responseData['data'];

        setState(() {
          masterDataSummaryCuti =
              List<Map<String, dynamic>>.from(dataMasterSummaryCutiApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getMasterDataCuti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(Uri.parse("$_apiUrl/master/cuti/get"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final masterDataCutiApi = responseData['md_cuti'];

        setState(() {
          masterDataCuti = Map<String, dynamic>.from(masterDataCutiApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> approveCuti(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    setState(() {
      _isLoadingScreen = true;
    });

    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse('$_apiUrl/pengajuan-cuti/approve'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'id': id.toString()}));
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Get.offAllNamed('/user/main');

          Get.snackbar('Infomation', 'Sukses Diapprove',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        } else {
          Get.snackbar('Infomation', 'Gagal Diapprove',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          setState(() {
            _isLoadingScreen = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> rejectCuti(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    setState(() {
      _isLoadingScreen = true;
    });

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$_apiUrl/pengajuan-cuti/reject'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
            {'id': id.toString(), 'alasan': _alasanRejectController.text},
          ),
        );
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Get.offAllNamed('/user/main');
          Get.snackbar('Infomation', 'Sukses Direject',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        } else {
          Get.snackbar('Infomation', 'Gagal Direject',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          setState(() {
            _isLoadingScreen = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> approvePerpanjanganCuti(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    setState(() {
      _isLoadingScreen = true;
    });

    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse('$_apiUrl/perpanjangan-cuti/approve'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'id': id.toString()}));
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Get.offAllNamed('/user/main');
          Get.snackbar('Infomation', 'Sukses Diapprove',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          setState(() {
            _isLoadingScreen = false;
          });
        } else {
          Get.snackbar('Infomation', 'Gagal Diapprove',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          setState(() {
            _isLoadingScreen = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> rejectPerpanjanganCuti(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    setState(() {
      _isLoadingScreen = true;
    });

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$_apiUrl/perpanjangan-cuti/reject'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
            {'id': id.toString(), 'alasan': _alasanRejectController.text},
          ),
        );
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Get.offAllNamed('/user/main');
          Get.snackbar('Infomation', 'Sukses Direject',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        } else {
          Get.snackbar('Infomation', 'Gagal Direject',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          setState(() {
            _isLoadingScreen = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

    return _isLoadingScreen
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: const TitleWidget(title: 'Daftar Persetujuan'),
                  ),
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      key: _formKey,
                      children: [
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalWide),
                          child: TitleWidget(
                            title: 'Pilih Daftar Persetujuan : ',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalWide),
                          child: DropdownButtonFormField<String>(
                            value: selectedValueDaftarPersetujuan,
                            icon: selectedDaftarPersetujuan.isEmpty
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                    ),
                                  )
                                : const Icon(Icons.arrow_drop_down),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValueDaftarPersetujuan = newValue ?? '';
                                if (selectedValueDaftarPersetujuan == '5') {
                                  getDataPengajuanCuti(statusFilter);
                                } else if (selectedValueDaftarPersetujuan ==
                                    '8') {
                                  getDataPerpanjanganCuti(statusFilter);
                                } else if (selectedValueDaftarPersetujuan ==
                                    '9') {
                                  getDataRawatInap(statusFilterRawatInapJalan);
                                } else if (selectedValueDaftarPersetujuan ==
                                    '10') {
                                  getDataRawatJalan(statusFilterRawatInapJalan);
                                } else if (selectedValueDaftarPersetujuan ==
                                    '12') {
                                  getDataSummaryCuti();
                                } else {
                                  setState(() {
                                    masterDataPersetujuan = [];
                                  });
                                }
                              });
                            },
                            items: selectedDaftarPersetujuan
                                .map((Map<String, dynamic> value) {
                              return DropdownMenuItem<String>(
                                value: value["id"].toString(),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: TitleWidget(
                                    title: value["opsi"] as String,
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              constraints: BoxConstraints(
                                  maxHeight: _maxHeightDaftarPermintaan),
                              labelStyle: TextStyle(fontSize: textMedium),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: selectedValueDaftarPersetujuan != null
                                      ? Colors.black54
                                      : Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: paddingHorizontalWide),
                        //   child: TextFormField(
                        //     controller: _searchController,
                        //     decoration: InputDecoration(
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(5),
                        //         borderSide: const BorderSide(
                        //           color: Colors.transparent,
                        //           width: 0,
                        //         ),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5),
                        //           borderSide: const BorderSide(
                        //               color: Colors.black, width: 1)),
                        //       enabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(5),
                        //           borderSide: const BorderSide(
                        //               color: Colors.grey, width: 0)),
                        //       constraints:
                        //           BoxConstraints(maxHeight: _maxHeightSearch),
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       hintText: 'Search',
                        //       hintStyle: TextStyle(
                        //         fontSize: textMedium,
                        //         fontFamily: 'Poppins',
                        //         color: Color(textPlaceholder),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                  selectedValueDaftarPersetujuan == '12'
                      ? Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: sizedBoxHeightShort,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingHorizontalWide),
                                child: const LineWidget(),
                              ),
                              SizedBox(
                                height: sizedBoxHeightShort,
                              ),
                              SizedBox(
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalWide),
                                  child: TitleWidget(
                                    title: 'Periode Rawat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: textMedium,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: sizedBoxHeightShort,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingHorizontalWide),
                                child: const LineWidget(),
                              ),
                              SizedBox(
                                height: sizedBoxHeightShort,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: ListView.builder(
                                    itemCount: masterDataSummaryCuti.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: sizedBoxHeightShort,
                                          horizontal: paddingHorizontalNarrow,
                                        ),
                                        child: buildSummaryCuti(
                                            masterDataSummaryCuti[index]),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 75,
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Column(
                            children: [
                              TabBar(
                                indicatorSize: TabBarIndicatorSize.label,
                                tabAlignment: TabAlignment.center,
                                isScrollable: true,
                                indicatorColor: Colors.black,
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                labelPadding: EdgeInsets.symmetric(
                                    horizontal: paddingHorizontalNarrow),
                                tabs: const [
                                  Tab(
                                    text: 'Semua',
                                  ),
                                  Tab(
                                    text: 'Disetujui',
                                  ),
                                  Tab(
                                    text: 'Proses',
                                  ),
                                  Tab(
                                    text: 'Ditolak',
                                  ),
                                ],
                                onTap: (index) {
                                  setState(() {
                                    current = index;
                                    if (index == 0) {
                                      statusFilter = 'ALL';
                                      statusFilterRawatInapJalan = 'ALL';
                                    } else if (index == 1) {
                                      statusFilter = 'V';
                                      statusFilterRawatInapJalan = 'APPROVED';
                                    } else if (index == 2) {
                                      statusFilter = 'P';
                                      statusFilterRawatInapJalan = 'PROCESS';
                                    } else {
                                      statusFilter = 'X';
                                      statusFilterRawatInapJalan = 'REJECTED';
                                    }
                                  });
                                  if (selectedValueDaftarPersetujuan == '5') {
                                    getDataPengajuanCuti(statusFilter);
                                  } else if (selectedValueDaftarPersetujuan ==
                                      '8') {
                                    getDataPerpanjanganCuti(statusFilter);
                                  } else if (selectedValueDaftarPersetujuan ==
                                      '9') {
                                    getDataRawatInap(
                                        statusFilterRawatInapJalan);
                                  } else if (selectedValueDaftarPersetujuan ==
                                      '10') {
                                    getDataRawatJalan(
                                        statusFilterRawatInapJalan);
                                  } else {
                                    setState(() {
                                      masterDataPersetujuan = [];
                                    });
                                  }
                                },
                              ),
                              //Main Body
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 200),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    paddingHorizontalNarrow),
                                            child: ListView.builder(
                                              itemCount:
                                                  masterDataPersetujuan.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        sizedBoxHeightShort,
                                                    horizontal:
                                                        paddingHorizontalNarrow,
                                                  ),
                                                  child: selectedValueDaftarPersetujuan ==
                                                          '5'
                                                      ? buildCuti(
                                                          masterDataPersetujuan[
                                                              index])
                                                      : selectedValueDaftarPersetujuan ==
                                                              '8'
                                                          ? buildPerpanjanganCuti(
                                                              masterDataPersetujuan[
                                                                  index])
                                                          : selectedValueDaftarPersetujuan ==
                                                                  '9'
                                                              ? buildRawatInap(
                                                                  masterDataPersetujuan[
                                                                      index])
                                                              : selectedValueDaftarPersetujuan ==
                                                                      '10'
                                                                  ? buildRawatJalan(
                                                                      masterDataPersetujuan[
                                                                          index])
                                                                  : const Text(
                                                                      'Kosong'),
                                                );
                                              },
                                            ),
                                          ),
                                    _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 200),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    paddingHorizontalNarrow),
                                            child: ListView.builder(
                                              itemCount:
                                                  masterDataPersetujuan.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        sizedBoxHeightShort,
                                                    horizontal:
                                                        paddingHorizontalNarrow,
                                                  ),
                                                  child: selectedValueDaftarPersetujuan ==
                                                          '5'
                                                      ? buildCuti(
                                                          masterDataPersetujuan[
                                                              index])
                                                      : selectedValueDaftarPersetujuan ==
                                                              '8'
                                                          ? buildPerpanjanganCuti(
                                                              masterDataPersetujuan[
                                                                  index])
                                                          : selectedValueDaftarPersetujuan ==
                                                                  '9'
                                                              ? buildRawatInap(
                                                                  masterDataPersetujuan[
                                                                      index])
                                                              : selectedValueDaftarPersetujuan ==
                                                                      '10'
                                                                  ? buildRawatJalan(
                                                                      masterDataPersetujuan[
                                                                          index])
                                                                  : const Text(
                                                                      'Kosong'),
                                                );
                                              },
                                            ),
                                          ),
                                    _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 200),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    paddingHorizontalNarrow),
                                            child: ListView.builder(
                                              itemCount:
                                                  masterDataPersetujuan.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        sizedBoxHeightShort,
                                                    horizontal:
                                                        paddingHorizontalNarrow,
                                                  ),
                                                  child: selectedValueDaftarPersetujuan ==
                                                          '5'
                                                      ? buildCuti(
                                                          masterDataPersetujuan[
                                                              index])
                                                      : selectedValueDaftarPersetujuan ==
                                                              '8'
                                                          ? buildPerpanjanganCuti(
                                                              masterDataPersetujuan[
                                                                  index])
                                                          : selectedValueDaftarPersetujuan ==
                                                                  '9'
                                                              ? buildRawatInap(
                                                                  masterDataPersetujuan[
                                                                      index])
                                                              : selectedValueDaftarPersetujuan ==
                                                                      '10'
                                                                  ? buildRawatJalan(
                                                                      masterDataPersetujuan[
                                                                          index])
                                                                  : const Text(
                                                                      'Kosong'),
                                                );
                                              },
                                            ),
                                          ),
                                    _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 200),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    paddingHorizontalNarrow),
                                            child: ListView.builder(
                                              itemCount:
                                                  masterDataPersetujuan.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        sizedBoxHeightShort,
                                                    horizontal:
                                                        paddingHorizontalNarrow,
                                                  ),
                                                  child: selectedValueDaftarPersetujuan ==
                                                          '5'
                                                      ? buildCuti(
                                                          masterDataPersetujuan[
                                                              index])
                                                      : selectedValueDaftarPersetujuan ==
                                                              '8'
                                                          ? buildPerpanjanganCuti(
                                                              masterDataPersetujuan[
                                                                  index])
                                                          : selectedValueDaftarPersetujuan ==
                                                                  '9'
                                                              ? buildRawatInap(
                                                                  masterDataPersetujuan[
                                                                      index])
                                                              : selectedValueDaftarPersetujuan ==
                                                                      '10'
                                                                  ? buildRawatJalan(
                                                                      masterDataPersetujuan[
                                                                          index])
                                                                  : const Text(
                                                                      'Kosong'),
                                                );
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 75,
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildCuti(Map<String, dynamic> data) {
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
          height: size.height * 0.3,
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
                RowWidget(
                  textLeft: 'Pemohon',
                  textRight: '${data['nama_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Entitas',
                  textRight: '${data['pt_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Atasan',
                  textRight: '${data['nama_atasan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Pengganti',
                  textRight: '${data['nama_pengganti']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: '${data['tgl_pengajuan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Mulai',
                  textRight: '${data['tgl_mulai']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Jumlah Cuti',
                  textRight: '${data['jml_cuti']} Hari',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Keperluan',
                  textRight: '${data['keperluan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                TitleCenterWithBadgeWidget(
                  textLeft: 'Status',
                  textRight: data['full_approve'] == 'V'
                      ? 'Disetujui'
                      : data['full_approve'] == 'X'
                          ? 'Ditolak'
                          : 'Proses',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                  color: data['full_approve'] == 'V'
                      ? Colors.green
                      : data['full_approve'] == 'X'
                          ? Colors.red[600]
                          : Colors.grey,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    data['full_approve'] == 'V' || data['full_approve'] == 'X'
                        ? InkWell(
                            onTap: () {
                              Get.toNamed(
                                  '/user/main/submition/aplikasi_training/detail_aplikasi_training');
                            },
                            child: Container(
                              width: size.width * 0.77,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                          )
                        : InkWell(
                            onTap: () {
                              Get.toNamed(
                                  '/user/main/submition/aplikasi_training/detail_aplikasi_training');
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                    data['full_approve'] == 'V' || data['full_approve'] == 'X'
                        ? Text('')
                        : InkWell(
                            onTap: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return modalRejectCuti(data['id']);
                              //   },
                              // );
                              showRejectPengajuanCutiModal(context, data['id']);
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.delete),
                                    Text(
                                      'Reject',
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
                    data['full_approve'] == 'V' || data['full_approve'] == 'X'
                        ? Text('')
                        : InkWell(
                            onTap: () {
                              // approveCuti(data['id']);
                              showApprovePengajuanCutiModal(
                                  context, data['id']);
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.approval),
                                    Text(
                                      'Approve',
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
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void showApprovePengajuanCutiModal(BuildContext context, int? id) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Konfirmasi Approve',
                  style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Center(
                child: Text(
                  'Apakah Anda Yakin ?',
                  style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: padding5,
                ),
                InkWell(
                  onTap: () {
                    approveCuti(id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: const Color(primaryYellow),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Approve',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showRejectPengajuanCutiModal(BuildContext context, int? id) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Modal Reject',
                  style: TextStyle(
                    color: Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Text(
                'Enter your rejection reason:',
                style: TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          content: TextFormFieldWidget(
            controller: _alasanRejectController,
            maxHeightConstraints: 40,
            hintText: 'Alasan Reject',
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: padding5,
                ),
                InkWell(
                  onTap: () {
                    rejectCuti(id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Reject',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildPerpanjanganCuti(Map<String, dynamic> data) {
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
          height: size.height * 0.25,
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
                RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: '${data['tgl_pengajuan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama Penerima',
                  textRight: '${data['nama_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Jumlah Extend',
                  textRight: '${data['jth_extend']} Hari',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Mulai',
                  textRight: '${data['start_date']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Kadaluarsa',
                  textRight: '${data['expired_date']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                TitleCenterWithBadgeWidget(
                  textLeft: 'Status',
                  textRight: data['full_approve'] == 'V'
                      ? 'Disetujui'
                      : data['full_approve'] == 'X'
                          ? 'Ditolak'
                          : 'Proses',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                  color: data['full_approve'] == 'V'
                      ? Colors.green
                      : data['full_approve'] == 'X'
                          ? Colors.red[600]
                          : Colors.grey,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    data['full_approve'] == 'V' || data['full_approve'] == 'X'
                        ? InkWell(
                            onTap: () {
                              Get.toNamed(
                                  '/user/main/submition/aplikasi_training/detail_aplikasi_training');
                            },
                            child: Container(
                              width: size.width * 0.77,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                          )
                        : InkWell(
                            onTap: () {
                              Get.toNamed(
                                  '/user/main/submition/aplikasi_training/detail_aplikasi_training');
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                    data['full_approve'] == 'V' || data['full_approve'] == 'X'
                        ? Text('')
                        : InkWell(
                            onTap: () {
                              showRejectPerpanjanganCutiModal(
                                  context, data['id']);
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.delete),
                                    Text(
                                      'Reject',
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
                    data['full_approve'] == 'V' || data['full_approve'] == 'X'
                        ? Text('')
                        : InkWell(
                            onTap: () {
                              // approvePerpanjanganCuti(data['id']);
                              showApprovePerpanjanganCutiModal(
                                  context, data['id']);
                            },
                            child: Container(
                              width: size.width * 0.25,
                              height: size.height * 0.04,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.approval),
                                    Text(
                                      'Approve',
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
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void showApprovePerpanjanganCutiModal(BuildContext context, int? id) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Konfirmasi Approve',
                  style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Center(
                child: Text(
                  'Apakah Anda Yakin ?',
                  style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: padding5,
                ),
                InkWell(
                  onTap: () {
                    approvePerpanjanganCuti(id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: const Color(primaryYellow),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Approve',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showRejectPerpanjanganCutiModal(BuildContext context, int? id) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Modal Reject',
                  style: TextStyle(
                    color: Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Text(
                'Enter your rejection reason:',
                style: TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          content: TextFormFieldWidget(
            controller: _alasanRejectController,
            maxHeightConstraints: 40,
            hintText: 'Alasan Reject',
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: padding5,
                ),
                InkWell(
                  onTap: () {
                    rejectPerpanjanganCuti(id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Reject',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget modalRejectPerpanjanganCuti(int? id) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0188;
    double padding10 = size.width * 0.023;
    double paddingHorizontalWide = size.width * 0.0585;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter your rejection reason:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: padding5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: TextFormFieldWidget(
              controller: _alasanRejectController,
              maxHeightConstraints: 40,
              hintText: 'Alasan Reject',
            ),
          ),
          SizedBox(height: padding10),
          InkWell(
            onTap: () {
              rejectPerpanjanganCuti(id);
            },
            child: Container(
              width: size.width * 0.25,
              height: size.height * 0.04,
              padding: EdgeInsets.all(padding5),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.delete),
                    Text(
                      'Reject',
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
          SizedBox(height: padding10),
        ],
      ),
    );
  }

  Widget buildRawatInap(Map<String, dynamic> data) {
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
          height: size.height * 0.3,
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
                RowWidget(
                  textLeft: 'Nomor Dokumen',
                  textRight: '${data['kode_rawat_inap']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Pemohon',
                  textRight: '${data['pernr']} - ${data['nama']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: '${data['created_at']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Perusahaan',
                  textRight: '${data['pt']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Lokasi',
                  textRight: '${data['lokasi']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Status',
                  textRight: '${data['status_approve']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
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
                        width: size.width * 0.38,
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
                      onTap: () {
                        Get.snackbar('Infomation', 'Coming Soon',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.amber,
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            shouldIconPulse: false);
                      },
                      child: Container(
                        width: size.width * 0.38,
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

  Widget buildRawatJalan(Map<String, dynamic> data) {
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
          height: size.height * 0.3,
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
                RowWidget(
                  textLeft: 'Nomor Dokumen',
                  textRight: '${data['no_doc']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Pemohon',
                  textRight: '${data['pernr']} - ${data['nama']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: '${data['tgl_pengajuan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Perusahaan',
                  textRight: '${data['pt']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Lokasi',
                  textRight: '${data['lokasi']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Status',
                  textRight: '${data['status_approve']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
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
                        width: size.width * 0.38,
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
                      onTap: () {
                        Get.snackbar('Infomation', 'Coming Soon',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.amber,
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            shouldIconPulse: false);
                      },
                      child: Container(
                        width: size.width * 0.38,
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

  Widget buildSummaryCuti(Map<String, dynamic> data) {
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
          height: size.height * 0.3,
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
                RowWidget(
                  textLeft: 'Jenis Pengajuan',
                  textRight: '${data['jenis_pengajuan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Mulai',
                  textRight: '${data['tgl_mulai']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Berakhir',
                  textRight: '${data['tgl_berakhir']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Keterangan',
                  textRight: '${data['deskripsi']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Total Cuti Diambil',
                  textRight: '${data['jml_hari']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Cuti Bersama',
                  textRight: '${data['jml_cuti_bersama']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Cuti Dibayar',
                  textRight: '${data['jml_cuti_tahunan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Cuti Tidak Dibayar',
                  textRight: '${data['jml_cuti_tdkdibayar']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Cuti Lainnya',
                  textRight: '${data['jml_cuti_lainnya']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Status',
                  textRight: '${data['status']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
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
                        width: size.width * 0.38,
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
                      onTap: () {
                        Get.snackbar('Infomation', 'Coming Soon',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.amber,
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            shouldIconPulse: false);
                      },
                      child: Container(
                        width: size.width * 0.38,
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
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
