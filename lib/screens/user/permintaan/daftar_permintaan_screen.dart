// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/pdf_screen.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarPermintaanScreen extends StatefulWidget {
  const DaftarPermintaanScreen({super.key});

  @override
  State<DaftarPermintaanScreen> createState() => _DaftarPermintaanScreenState();
}

class _DaftarPermintaanScreenState extends State<DaftarPermintaanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _apiUrl = API_URL;
  String rawatInapPDFpath = "";

  List<Map<String, dynamic>> selectedDaftarPermintaan = [
    {'id': '1', 'opsi': 'Aplikasi Rekrutmen'},
    {'id': '2', 'opsi': 'Bantuan Komunikasi'},
    {'id': '3', 'opsi': 'Hard/Software'},
    {'id': '4', 'opsi': 'Lembur Karyawan'},
    {'id': '12', 'opsi': 'Summary Cuti'},
    {'id': '5', 'opsi': 'Pengajuan Cuti'},
    {'id': '8', 'opsi': 'Perpanjangan Cuti'},
    {'id': '6', 'opsi': 'Pengajuan Training'},
    {'id': '7', 'opsi': 'IM Perjalanan Dinas'},
    {'id': '13', 'opsi': 'LPJ Perjalanan Dinas'},
    {'id': '9', 'opsi': 'Rawat Inap'},
    {'id': '10', 'opsi': 'Rawat Jalan'},
    {'id': '14', 'opsi': 'Surat Izin Keluar'},
    {'id': '11', 'opsi': 'Surat Keterangan'},
  ];

  List<Map<String, dynamic>> masterDataPermintaan = [];
  List<Map<String, dynamic>> masterDataSummaryCuti = [];
  Map<String, dynamic> masterDataCuti = {};

  String? selectedValueDaftarPermintaan;
  bool _isLoading = false;
  bool isDataEmpty = true;

  String? page = '1';
  String? perPage = '10';
  String? search = '';
  String? statusFilter = 'ALL';
  String? statusFilterRawatInapJalan = 'ALL';
  String? type = 'permintaan';
  String? kodeEntitas = '';
  String? tahunPengajuan = '';
  bool _isLoadingContent = false;

  final double _maxHeightDaftarPermintaan = 60.0;

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
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataMasterCutiApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataBantuanKomunikasi(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/bantuan-komunikasi/get?page=$page&perPage=$perPage&search=$search&status=$statusFilter&type=$type"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterBantuanKomunikasiApi = responseData['dkomunikasi'];

        setState(() {
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataMasterBantuanKomunikasiApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataSuratIzinKeluar(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/izin-keluar/get?page=$page&perPage=$perPage&search=$search&status=$statusFilter&type=$type"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterSuratIzinKeluarApi = responseData['data'];

        setState(() {
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataMasterSuratIzinKeluarApi);
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
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataMasterCutiApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataPengajuanTraining(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/training/all?page=$page&entitas=&search=$search&status=$statusFilter&limit=$perPage&permintaan=1"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMasterPengajuanTrainingApi = responseData['data']['data'];

        setState(() {
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataMasterPengajuanTrainingApi);
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
          masterDataPermintaan =
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
          masterDataPermintaan =
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

  Future<void> getDataImPerjalananDinas(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/rencana-perdin/get?page=$page&perPage=$perPage&search=$search&status=$statusFilter&type=$type"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataImPerjalananDinasApi = responseData['dperdin'];

        setState(() {
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataImPerjalananDinasApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataLpjPerjalananDinas(String? statusFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/laporan-perdin/get?page=$page&perPage=$perPage&search=$search&status=$statusFilter&type=$type"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataLpjPerjalananDinasApi = responseData['dperdin'];

        setState(() {
          masterDataPermintaan =
              List<Map<String, dynamic>>.from(dataLpjPerjalananDinasApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<File> createPdfRawatInap(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(id);

    setState(() {
      _isLoadingContent = true;
    });

    Completer<File> completer = Completer();
    try {
      // var url =
      //     "http://ess-dev.hasnurgroup.com:8081/online-form/preview-pdf-cuti/ee55673b-be6f-4ed3-a6fc-848255dd2bf7/okee";
      var url =
          "http://192.168.89.21/online-form/approval-rawat-inap/${id}/pdf/inap${id}.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json;charset=UTF-8');
      request.headers.set('Authorization', 'Bearer $token');
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      // var dir = await getApplicationDocumentsDirectory();
      var dir = await getExternalStorageDirectory();

      var downloadDir = Directory('${dir!.path}/Download');
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }
      setState(() {
        _isLoadingContent = false;
      });
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);

      if (rawatInapPDFpath.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: rawatInapPDFpath),
          ),
        );
      }
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<void> _downloadRawatInap(int? id) async {
    createPdfRawatInap(id).then((f) {
      setState(() {
        rawatInapPDFpath = f.path;
      });
    });

    if (rawatInapPDFpath.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: rawatInapPDFpath),
        ),
      );
    } else {
      createPdfRawatInap(id).then((f) {
        setState(() {
          rawatInapPDFpath = f.path;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;

    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                child: const TitleWidget(title: 'Daftar Permintaan'),
              ),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              formSearchWidget(context),
              SizedBox(
                height: sizedBoxHeightShort,
              ),
              selectedValueDaftarPermintaan == '12'
                  ? summaryCutiWidget(context)
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
                              // await Future.delayed(Duration(seconds: 2));
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

                              if (selectedValueDaftarPermintaan == '2') {
                                getDataBantuanKomunikasi(statusFilter);
                              } else if (selectedValueDaftarPermintaan == '5') {
                                getDataPengajuanCuti(statusFilter);
                              } else if (selectedValueDaftarPermintaan == '6') {
                                getDataPengajuanTraining(
                                    statusFilterRawatInapJalan);
                              } else if (selectedValueDaftarPermintaan == '7') {
                                getDataImPerjalananDinas(statusFilter);
                              } else if (selectedValueDaftarPermintaan == '8') {
                                getDataPerpanjanganCuti(statusFilter);
                              } else if (selectedValueDaftarPermintaan ==
                                  '13') {
                                getDataLpjPerjalananDinas(statusFilter);
                              } else if (selectedValueDaftarPermintaan == '9') {
                                getDataRawatInap(statusFilterRawatInapJalan);
                              } else if (selectedValueDaftarPermintaan ==
                                  '10') {
                                getDataRawatJalan(statusFilterRawatInapJalan);
                              } else if (selectedValueDaftarPermintaan ==
                                  '14') {
                                getDataSuratIzinKeluar(statusFilter);
                              } else {
                                setState(() {
                                  masterDataPermintaan = [];
                                });
                              }
                            },
                          ),
                          //Main Body
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                allTabWidget(context),
                                approvedTabWidget(context),
                                prossesTabWidget(context),
                                rejectedTabWidget(context),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 75,
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget formSearchWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalWide = size.width * 0.0585;
    double sizedBoxHeightTall = size.height * 0.0163;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        key: _formKey,
        children: [
          SizedBox(
            height: sizedBoxHeightTall,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: TitleWidget(
              title: 'Pilih Daftar Permintaan : ',
              fontWeight: FontWeight.w300,
              fontSize: textMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: DropdownButtonFormField<String>(
              value: selectedValueDaftarPermintaan,
              icon: selectedDaftarPermintaan.isEmpty
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueDaftarPermintaan = newValue ?? '';
                  if (selectedValueDaftarPermintaan == '2') {
                    getDataBantuanKomunikasi(statusFilter);
                  } else if (selectedValueDaftarPermintaan == '5') {
                    getDataPengajuanCuti(statusFilter);
                  } else if (selectedValueDaftarPermintaan == '6') {
                    getDataPengajuanTraining(statusFilterRawatInapJalan);
                  } else if (selectedValueDaftarPermintaan == '7') {
                    getDataImPerjalananDinas(statusFilter);
                  } else if (selectedValueDaftarPermintaan == '13') {
                    getDataLpjPerjalananDinas(statusFilter);
                  } else if (selectedValueDaftarPermintaan == '8') {
                    getDataPerpanjanganCuti(statusFilter);
                  } else if (selectedValueDaftarPermintaan == '9') {
                    getDataRawatInap(statusFilterRawatInapJalan);
                  } else if (selectedValueDaftarPermintaan == '10') {
                    getDataRawatJalan(statusFilterRawatInapJalan);
                  } else if (selectedValueDaftarPermintaan == '12') {
                    getDataSummaryCuti();
                  } else if (selectedValueDaftarPermintaan == '14') {
                    getDataSuratIzinKeluar(statusFilter);
                  } else {
                    setState(() {
                      masterDataPermintaan = [];
                    });
                  }
                });
              },
              items: selectedDaftarPermintaan.map((Map<String, dynamic> value) {
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
                constraints:
                    BoxConstraints(maxHeight: _maxHeightDaftarPermintaan),
                labelStyle: TextStyle(fontSize: textMedium),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueDaftarPermintaan != null
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
        ],
      ),
    );
  }

  Widget summaryCutiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const LineWidget(),
          ),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          SizedBox(
            height: 20,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
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
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const LineWidget(),
          ),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: ListView.builder(
                itemCount: masterDataSummaryCuti.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: sizedBoxHeightShort,
                      horizontal: paddingHorizontalNarrow,
                    ),
                    child: buildSummaryCuti(masterDataSummaryCuti[index]),
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
    );
  }

  Widget allTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    return _isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: ListView.builder(
              itemCount: masterDataPermintaan.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizedBoxHeightShort,
                    horizontal: paddingHorizontalNarrow,
                  ),
                  child: selectedValueDaftarPermintaan == '2'
                      ? buildBantuanKomunikasi(masterDataPermintaan[index])
                      : selectedValueDaftarPermintaan == '5'
                          ? buildCuti(masterDataPermintaan[index])
                          : selectedValueDaftarPermintaan == '6'
                              ? buildPengajuanTraining(
                                  masterDataPermintaan[index])
                              : selectedValueDaftarPermintaan == '7'
                                  ? buildImPerjalananDinas(
                                      masterDataPermintaan[index])
                                  : selectedValueDaftarPermintaan == '13'
                                      ? buildLpjPerjalananDinas(
                                          masterDataPermintaan[index])
                                      : selectedValueDaftarPermintaan == '14'
                                          ? buildSuratIzinKeluar(
                                              masterDataPermintaan[index])
                                          : selectedValueDaftarPermintaan == '8'
                                              ? buildPerpanjanganCuti(
                                                  masterDataPermintaan[index])
                                              : selectedValueDaftarPermintaan ==
                                                      '9'
                                                  ? buildRawatInap(
                                                      masterDataPermintaan[
                                                          index])
                                                  : selectedValueDaftarPermintaan ==
                                                          '10'
                                                      ? buildRawatJalan(
                                                          masterDataPermintaan[
                                                              index])
                                                      : const Text('Kosong'),
                );
              },
            ),
          );
  }

  Widget approvedTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    return _isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: ListView.builder(
              itemCount: masterDataPermintaan.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizedBoxHeightShort,
                    horizontal: paddingHorizontalNarrow,
                  ),
                  child: selectedValueDaftarPermintaan == '2'
                      ? buildBantuanKomunikasi(masterDataPermintaan[index])
                      : selectedValueDaftarPermintaan == '5'
                          ? buildCuti(masterDataPermintaan[index])
                          : selectedValueDaftarPermintaan == '6'
                              ? buildPengajuanTraining(
                                  masterDataPermintaan[index])
                              : selectedValueDaftarPermintaan == '7'
                                  ? buildImPerjalananDinas(
                                      masterDataPermintaan[index])
                                  : selectedValueDaftarPermintaan == '13'
                                      ? buildLpjPerjalananDinas(
                                          masterDataPermintaan[index])
                                      : selectedValueDaftarPermintaan == '14'
                                          ? buildSuratIzinKeluar(
                                              masterDataPermintaan[index])
                                          : selectedValueDaftarPermintaan == '8'
                                              ? buildPerpanjanganCuti(
                                                  masterDataPermintaan[index])
                                              : selectedValueDaftarPermintaan ==
                                                      '9'
                                                  ? buildRawatInap(
                                                      masterDataPermintaan[
                                                          index])
                                                  : selectedValueDaftarPermintaan ==
                                                          '10'
                                                      ? buildRawatJalan(
                                                          masterDataPermintaan[
                                                              index])
                                                      : const Text('Kosong'),
                );
              },
            ),
          );
  }

  Widget prossesTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    return _isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: ListView.builder(
              itemCount: masterDataPermintaan.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizedBoxHeightShort,
                    horizontal: paddingHorizontalNarrow,
                  ),
                  child: selectedValueDaftarPermintaan == '2'
                      ? buildBantuanKomunikasi(masterDataPermintaan[index])
                      : selectedValueDaftarPermintaan == '5'
                          ? buildCuti(masterDataPermintaan[index])
                          : selectedValueDaftarPermintaan == '6'
                              ? buildPengajuanTraining(
                                  masterDataPermintaan[index])
                              : selectedValueDaftarPermintaan == '7'
                                  ? buildImPerjalananDinas(
                                      masterDataPermintaan[index])
                                  : selectedValueDaftarPermintaan == '13'
                                      ? buildLpjPerjalananDinas(
                                          masterDataPermintaan[index])
                                      : selectedValueDaftarPermintaan == '14'
                                          ? buildSuratIzinKeluar(
                                              masterDataPermintaan[index])
                                          : selectedValueDaftarPermintaan == '8'
                                              ? buildPerpanjanganCuti(
                                                  masterDataPermintaan[index])
                                              : selectedValueDaftarPermintaan ==
                                                      '9'
                                                  ? buildRawatInap(
                                                      masterDataPermintaan[
                                                          index])
                                                  : selectedValueDaftarPermintaan ==
                                                          '10'
                                                      ? buildRawatJalan(
                                                          masterDataPermintaan[
                                                              index])
                                                      : const Text('Kosong'),
                );
              },
            ),
          );
  }

  Widget rejectedTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    return _isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Center(child: CircularProgressIndicator()),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: ListView.builder(
              itemCount: masterDataPermintaan.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizedBoxHeightShort,
                    horizontal: paddingHorizontalNarrow,
                  ),
                  child: selectedValueDaftarPermintaan == '2'
                      ? buildBantuanKomunikasi(masterDataPermintaan[index])
                      : selectedValueDaftarPermintaan == '5'
                          ? buildCuti(masterDataPermintaan[index])
                          : selectedValueDaftarPermintaan == '6'
                              ? buildPengajuanTraining(
                                  masterDataPermintaan[index])
                              : selectedValueDaftarPermintaan == '7'
                                  ? buildImPerjalananDinas(
                                      masterDataPermintaan[index])
                                  : selectedValueDaftarPermintaan == '13'
                                      ? buildLpjPerjalananDinas(
                                          masterDataPermintaan[index])
                                      : selectedValueDaftarPermintaan == '14'
                                          ? buildSuratIzinKeluar(
                                              masterDataPermintaan[index])
                                          : selectedValueDaftarPermintaan == '8'
                                              ? buildPerpanjanganCuti(
                                                  masterDataPermintaan[index])
                                              : selectedValueDaftarPermintaan ==
                                                      '9'
                                                  ? buildRawatInap(
                                                      masterDataPermintaan[
                                                          index])
                                                  : selectedValueDaftarPermintaan ==
                                                          '10'
                                                      ? buildRawatJalan(
                                                          masterDataPermintaan[
                                                              index])
                                                      : const Text('Kosong'),
                );
              },
            ),
          );
  }

  Widget buildBantuanKomunikasi(Map<String, dynamic> data) {
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
                  textLeft: 'Diajukan Oleh',
                  textRight: '${data['nrp_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: '',
                  textRight: '${data['nama_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Diberikan Kepada (penerima)',
                  textRight: '${data['nrp_penerima']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: '',
                  textRight: '${data['nama_penerima']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Jabatan (penerima)',
                  textRight: '${data['pangkat_penerima']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Entitas (penerima)',
                  textRight: '${data['entitas_penerima']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Jenis Fasilitas',
                  textRight: data['id_jenis_fasilitas'] == 1
                      ? 'Mobile Phone'
                      : data['id_jenis_fasilitas'] == 2
                          ? 'Biaya Pulsa'
                          : 'Kouta Internet',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Prioritas',
                  textRight: data['prioritas'] == '0'
                      ? 'Rendah'
                      : data['prioritas'] == '1'
                          ? 'Sedang'
                          : 'Tinggi',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: '${data['tgl_pengajuan']}',
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
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          '/user/main/daftar_permintaan/detail_bantuan_komunikasi',
                          arguments: {'id': data['id']},
                        );
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
                              const Icon(Icons.details_sharp),
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
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          '/user/main/daftar_permintaan/detail_pengajuan_cuti',
                          arguments: {'id': data['uuid']},
                        );
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

  Widget buildPengajuanTraining(Map<String, dynamic> data) {
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
                  textLeft: 'No Dokumen',
                  textRight: '${data['no_doc']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Pemohon',
                  textRight: '${data['nrp']} - ${data['nama']}',
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
                  textLeft: 'Tanggal Training',
                  textRight: '${data['tgl_training']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Judul Training',
                  textRight: '${data['judul_training']}',
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
                          '/user/main/daftar_permintaan/detail_pengajuan_training',
                          arguments: {'id': data['id']},
                        );
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

  Widget buildSuratIzinKeluar(Map<String, dynamic> data) {
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
          height: size.height * 0.35,
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
                  textLeft: 'No Dokumen',
                  textRight: '${data['no_doc'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nrp (Pemohon)',
                  textRight: '${data['nrp_user'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama (Pemohon)',
                  textRight: '${data['nama_user'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama Atasan',
                  textRight: '${data['nama_atasan'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama HRGS',
                  textRight: '${data['nama_hrgs'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Izin',
                  textRight: '${data['tgl_izin'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Jam Keluar',
                  textRight: '${data['tgl_izin'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Jam Kembali',
                  textRight: '${data['tgl_izin'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Keperluan',
                  textRight: '${data['tgl_izin'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Pengajuan',
                  textRight: '${data['tgl_izin'] ?? '-'}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Status',
                  textRight: '${data['status_approve'] ?? '-'}',
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
                          '/user/main/daftar_permintaan/detail_surat_izin_keluar',
                          arguments: {'id': data['id']},
                        );
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
                  textRight: '${data['jth_extend']}',
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
                RowWidget(
                  textLeft: 'Tanggal Mulai',
                  textRight: '${data['tgl_mulai']}',
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
                          '/user/main/daftar_permintaan/detail_rawat_inap',
                          arguments: {'id': data['id_rawat_inap']},
                        );
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
                              const Icon(Icons.details_sharp),
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
                        _downloadRawatInap(data['id_rawat_inap']);
                      },
                      child: Container(
                        width: size.width * 0.38,
                        height: size.height * 0.04,
                        padding: EdgeInsets.all(padding5),
                        decoration: BoxDecoration(
                          color: const Color(primaryYellow),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: _isLoadingContent
                            ? Center(
                                child: SizedBox(
                                  width: size.height * 0.025,
                                  height: size.height * 0.025,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.download_rounded),
                                    Text(
                                      'Unduhan',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
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

  Widget buildImPerjalananDinas(Map<String, dynamic> data) {
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
                  textRight: '${data['nrp_user']} - ${data['nama_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama Atasan',
                  textRight: '${data['nama_atasan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama HRGS',
                  textRight: '${data['nama_hrgs']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tempat Tujuan',
                  textRight: '${data['tempat_tujuan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Perihal',
                  textRight: '${data['catatan_atasan']}',
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
                  textLeft: 'Tanggal Posting',
                  textRight: data['status_sap'] ?? '',
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
                          '/user/main/daftar_permintaan/detail_im_perjalanan_dinas',
                          arguments: {'id': data['id']},
                        );
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
                              const Icon(Icons.details_sharp),
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
                        // _downloadRawatInap(data['id_rawat_inap']);
                      },
                      child: Container(
                        width: size.width * 0.38,
                        height: size.height * 0.04,
                        padding: EdgeInsets.all(padding5),
                        decoration: BoxDecoration(
                          color: const Color(primaryYellow),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: _isLoadingContent
                            ? Center(
                                child: SizedBox(
                                  width: size.height * 0.025,
                                  height: size.height * 0.025,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.download_rounded),
                                    Text(
                                      'Unduhan',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
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

  Widget buildLpjPerjalananDinas(Map<String, dynamic> data) {
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
                  textRight: '${data['nrp_user']} - ${data['nama_user']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama Atasan',
                  textRight: '${data['nama_atasan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Nama HRGS',
                  textRight: '${data['nama_hrgs']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tempat Tujuan',
                  textRight: '${data['tempat_tujuan']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Kembali',
                  textRight: '${data['tgl_aktual_kembali']}',
                  fontWeightLeft: FontWeight.w300,
                  fontWeightRight: FontWeight.w300,
                ),
                RowWidget(
                  textLeft: 'Tanggal Pengajuan LPJ',
                  textRight: data['tgl_pengajuan_lpj'] ?? '',
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
                          '/user/main/daftar_permintaan/detail_lpj_perjalanan_dinas',
                          arguments: {'id': data['id']},
                        );
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
                              const Icon(Icons.details_sharp),
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
                        // _downloadRawatInap(data['id_rawat_inap']);
                      },
                      child: Container(
                        width: size.width * 0.38,
                        height: size.height * 0.04,
                        padding: EdgeInsets.all(padding5),
                        decoration: BoxDecoration(
                          color: const Color(primaryYellow),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: _isLoadingContent
                            ? Center(
                                child: SizedBox(
                                  width: size.height * 0.025,
                                  height: size.height * 0.025,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.download_rounded),
                                    Text(
                                      'Unduhan',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
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
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
