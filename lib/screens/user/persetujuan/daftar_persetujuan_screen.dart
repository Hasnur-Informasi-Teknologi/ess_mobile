// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/pdf_screen.dart';
import 'package:mobile_ess/widgets/row_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DataUserDaftarPersetujuanController extends GetxController {
  var data = {}.obs;
}

class DaftarPersetujuanScreen extends StatefulWidget {
  const DaftarPersetujuanScreen({super.key});

  @override
  State<DaftarPersetujuanScreen> createState() =>
      _DaftarPersetujuanScreenState();
}

class _DaftarPersetujuanScreenState extends State<DaftarPersetujuanScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _alasanRejectController = TextEditingController();
  String pdfpath = "";

  Map<String, bool> _isLoadingContent = {};

  final String _apiUrl = API_URL;
  final String _url = URL;
  DataUserDaftarPersetujuanController x =
      Get.put(DataUserDaftarPersetujuanController());

  List<Map<String, dynamic>> selectedDaftarPersetujuan = [
    {'id': '1', 'opsi': 'Aplikasi Rekrutmen'},
    {'id': '2', 'opsi': 'Bantuan Komunikasi'},
    {'id': '3', 'opsi': 'Hard/Software'},
    {'id': '4', 'opsi': 'Lembur Karyawan'},
    // {'id': '12', 'opsi': 'Summary Cuti'},
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
  int? idRawatInap;

  final double _maxHeightDaftarPermintaan = 60.0;
  final double _maxHeightSearch = 40.0;

  int current = 0;

  @override
  void initState() {
    super.initState();
    getMasterDataCuti();
    getData();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> fetchData(Uri uri, String token) async {
    final ioClient = createIOClientWithInsecureConnection();
    final response = await ioClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    return jsonDecode(response.body);
  }

  Future<void> getDataBantuanKomunikasi(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/bantuan-komunikasi/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['dkomunikasi']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataSuratIzinKeluar(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/izin-keluar/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['data']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataPengajuanCuti(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
        'entitas': kodeEntitas,
        'tahun': tahunPengajuan,
      };

      final uri = Uri.parse("$_apiUrl/pengajuan-cuti/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['dcuti']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataPerpanjanganCuti(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/perpanjangan-cuti/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['pcuti']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataPengajuanTraining(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'entitas': '',
        'search': search,
        'status': statusFilter ?? '',
        'limit': perPage.toString(),
        'permintaan': '0',
      };

      final uri = Uri.parse("$_apiUrl/training/all")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['data']['data']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataRawatInap(String? statusFilterRawatInapJalan) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': perPage.toString(),
        'search': search,
        'status': statusFilterRawatInapJalan ?? '',
        'permintaan': '0',
      };

      final uri = Uri.parse("$_apiUrl/rawat/inap/all")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['data']['data']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataRawatJalan(String? statusFilterRawatInapJalan) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': perPage.toString(),
        'search': search,
        'status': statusFilterRawatInapJalan ?? '',
        'permintaan': '0',
      };

      final uri = Uri.parse("$_apiUrl/rawat/jalan/all")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['data']['data']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataSummaryCuti() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
      };

      final uri = Uri.parse("$_apiUrl/pengajuan-cuti/summary")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataSummaryCuti =
            List<Map<String, dynamic>>.from(responseData['data']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getMasterDataCuti() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final uri = Uri.parse("$_apiUrl/master/cuti/get");

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataCuti = Map<String, dynamic>.from(responseData['md_cuti']);
      });
    } catch (e) {
      print('Error fetching master data cuti: $e');
    }
  }

  Future<void> getDataImPerjalananDinas(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/rencana-perdin/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['dperdin']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data perjalanan dinas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataLpjPerjalananDinas(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/laporan-perdin/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['dperdin']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data LPJ perjalanan dinas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataLembur(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/perintah-lembur/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['dlembur']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data Lembur : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataSuratKeterangan(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'perPage': perPage.toString(),
        'search': search,
        'status': statusFilter ?? '',
        'type': type,
      };

      final uri = Uri.parse("$_apiUrl/surat-keterangan/get")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['data']);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data Lembur : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataHardwareSoftware(String? statusFilter) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'entitas': '',
        'search': search,
        'status': statusFilter ?? '',
        'limit': perPage.toString(),
        'permintaan': '0'
      };

      final uri = Uri.parse("$_apiUrl/permintaan-hardware-software/all")
          .replace(queryParameters: queryParams);

      final responseData = await fetchData(uri, token);

      setState(() {
        masterDataPersetujuan =
            List<Map<String, dynamic>>.from(responseData['data']['data']);
        print(masterDataPersetujuan);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data Lembur : $e');
      setState(() {
        _isLoading = false;
      });
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
        final ioClient = createIOClientWithInsecureConnection();

        final response =
            await ioClient.post(Uri.parse('$_apiUrl/pengajuan-cuti/approve'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'id': id.toString()}));
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          Get.offAllNamed('/user/main');

          Get.snackbar('Infomation', 'Approved',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        } else {
          Get.snackbar('Infomation', 'Gagal',
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
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.post(
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
          Get.snackbar('Infomation', 'Rejected',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        } else {
          Get.snackbar('Infomation', 'Gagal',
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
        final ioClient = createIOClientWithInsecureConnection();

        final response =
            await ioClient.post(Uri.parse('$_apiUrl/perpanjangan-cuti/approve'),
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
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.post(
          Uri.parse('$_apiUrl/perpanjangan-cuti/reject'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
            {'id': id.toString()},
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

  Future<File> createPdf(String type, dynamic id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String endpoint = '';
    print(id);

    setState(() {
      _isLoadingContent[id] = true;
    });

    if (type == 'rawatInap') {
      endpoint = "$_url/online-form/approval-rawat-inap/$id/pdf/inap$id.pdf";
    } else if (type == 'rawatJalan') {
      endpoint = "$_url/online-form/approval-rawat-jalan/$id/pdf/jalan$id.pdf";
    } else if (type == 'suratIzinKeluar') {
      endpoint = "$_url/online-form/preview-pdf-izin-keluar/$id/pdf";
    } else if (type == 'bantuanKomunikasi') {
      endpoint = "$_url/online-form/preview-pdf-bantuan-komunikasi/$id/pdf";
    } else if (type == 'imPerjalananDinas') {
      endpoint = "$_url/online-form/preview-pdf-rencana-perdin/$id/pdf";
    } else if (type == 'lpjPerjalananDinas') {
      endpoint = "$_url/online-form/preview-pdf-laporan-perdin/$id/pdf";
    } else if (type == 'pengajuanTraining') {
      endpoint = "$_url/online-form/approval-pengajuan-training/$id/pdf";
    } else if (type == 'pengajuanCuti') {
      // 77db6a95-85ef-4728-b9e1-466afcce073e
      endpoint = "$_url/online-form/preview-pdf-cuti/$id/pdf";
    } else if (type == 'lemburKaryawan') {
      endpoint = "$_url/online-form/preview-pdf-perintah-lembur/$id/pdf";
    } else if (type == 'hardwareSoftware') {
      endpoint =
          "$_url/online-form/preview-pdf-permintaan-hardware-software/$id/pdf";
    } else if (type == 'suratKeterangan') {
      endpoint = "$_url/online-form/approval-surat-keterangan/$id";
    }

    Completer<File> completer = Completer();
    try {
      var url = endpoint;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json;charset=UTF-8');
      request.headers.set('Authorization', 'Bearer $token');
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      var dir = await getApplicationDocumentsDirectory();
      var downloadDir = Directory('${dir.path}/Download');
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }

      setState(() {
        _isLoadingContent[id] = false;
      });

      File file = File("${dir.path}/Download/$filename");
      print(file);
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      setState(() {
        _isLoadingContent[id] = false;
      });
      print('Error creating PDF: $e');
      throw Exception('Error creating PDF file!');
    }

    return completer.future;
  }

  void _downloadPdf(String type, dynamic id) {
    setState(() {
      _isLoadingContent[id] = true;
    });

    createPdf(type, id).then((file) {
      setState(() {
        _isLoadingContent[id] = false;
        pdfpath = file.path;
      });
      if (pdfpath.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: pdfpath),
          ),
        );
      }
    }).catchError((e) {
      setState(() {
        _isLoadingContent[id] = false;
      });
      print('Error downloading PDF: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;

    final tabTitles = ['Semua', 'Disetujui', 'Proses', 'Ditolak'];
    final statusFilters = ['ALL', 'V', 'P', 'X'];
    final statusFiltersRawatInapJalan = [
      'ALL',
      'APPROVED',
      'PROCESS',
      'REJECTED'
    ];

    void updateData(int index) {
      setState(() {
        current = index;
        statusFilter = statusFilters[index];
        statusFilterRawatInapJalan = statusFiltersRawatInapJalan[index];
      });

      final dataFetchers = {
        '2': () => getDataBantuanKomunikasi(statusFilter),
        '3': () => getDataHardwareSoftware(statusFilterRawatInapJalan),
        '4': () => getDataLembur(statusFilter),
        '5': () => getDataPengajuanCuti(statusFilter),
        '6': () => getDataPengajuanTraining(statusFilterRawatInapJalan),
        '7': () => getDataImPerjalananDinas(statusFilter),
        '8': () => getDataPerpanjanganCuti(statusFilter),
        '13': () => getDataLpjPerjalananDinas(statusFilter),
        '9': () => getDataRawatInap(statusFilterRawatInapJalan),
        '10': () => getDataRawatJalan(statusFilterRawatInapJalan),
        '11': () => getDataSuratKeterangan(statusFilter),
        '14': () => getDataSuratIzinKeluar(statusFilter),
      };

      dataFetchers[selectedValueDaftarPersetujuan]?.call() ??
          setState(() {
            masterDataPersetujuan = [];
          });
    }

    return DefaultTabController(
      length: tabTitles.length,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: sizedBoxHeightTall),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                child: const TitleWidget(title: 'Daftar Persetujuan'),
              ),
              SizedBox(height: sizedBoxHeightTall),
              formSearchWidget(context),
              SizedBox(height: sizedBoxHeightShort),
              selectedValueDaftarPersetujuan == '12'
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
                            tabs: tabTitles
                                .map((title) => Tab(text: title))
                                .toList(),
                            onTap: updateData,
                          ),
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
                          const SizedBox(height: 75),
                        ],
                      ),
                    ),
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

    void onDropdownChanged(String? newValue) {
      setState(() {
        selectedValueDaftarPersetujuan = newValue ?? '';

        final dataFetchers = {
          '2': () => getDataBantuanKomunikasi(statusFilter),
          '3': () => getDataHardwareSoftware(statusFilterRawatInapJalan),
          '4': () => getDataLembur(statusFilter),
          '5': () => getDataPengajuanCuti(statusFilter),
          '6': () => getDataPengajuanTraining(statusFilterRawatInapJalan),
          '7': () => getDataImPerjalananDinas(statusFilter),
          '8': () => getDataPerpanjanganCuti(statusFilter),
          '9': () => getDataRawatInap(statusFilterRawatInapJalan),
          '10': () => getDataRawatJalan(statusFilterRawatInapJalan),
          '11': () => getDataSuratKeterangan(statusFilter),
          '12': getDataSummaryCuti,
          '13': () => getDataLpjPerjalananDinas(statusFilter),
          '14': () => getDataSuratIzinKeluar(statusFilter),
        };

        dataFetchers[selectedValueDaftarPersetujuan]?.call() ??
            setState(() {
              masterDataPersetujuan = [];
            });
      });
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: sizedBoxHeightTall),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: TitleWidget(
              title: 'Pilih Daftar Persetujuan : ',
              fontWeight: FontWeight.w300,
              fontSize: textMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: DropdownButtonFormField<String>(
              value: selectedValueDaftarPersetujuan,
              icon: selectedDaftarPersetujuan.isEmpty
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              onChanged: onDropdownChanged,
              items:
                  selectedDaftarPersetujuan.map((Map<String, dynamic> value) {
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
                    color: selectedValueDaftarPersetujuan != null
                        ? Colors.black54
                        : Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: sizedBoxHeightTall),
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
          SizedBox(height: sizedBoxHeightShort),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const LineWidget(),
          ),
          SizedBox(height: sizedBoxHeightShort),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: TitleWidget(
              title: 'Periode Rawat',
              fontWeight: FontWeight.w500,
              fontSize: textMedium,
            ),
          ),
          SizedBox(height: sizedBoxHeightShort),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: const LineWidget(),
          ),
          SizedBox(height: sizedBoxHeightShort),
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
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  Widget allTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 200),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (masterDataPersetujuan.isEmpty) {
      return const Center(child: Text('Data Kosong ...'));
    }

    Widget buildItem(Map<String, dynamic> data) {
      switch (selectedValueDaftarPersetujuan) {
        case '2':
          return buildBantuanKomunikasi(data);
        case '3':
          return buildHardwareSoftware(data);
        case '4':
          return buildLemburKaryawan(data);
        case '5':
          return buildCuti(data);
        case '6':
          return buildPengajuanTraining(data);
        case '7':
          return buildImPerjalananDinas(data);
        case '13':
          return buildLpjPerjalananDinas(data);
        case '14':
          return buildSuratIzinKeluar(data);
        case '8':
          return buildPerpanjanganCuti(data);
        case '9':
          return buildRawatInap(data);
        case '10':
          return buildRawatJalan(data);
        case '11':
          return buildSuratKeterangan(data);
        default:
          return const Text('Kosong');
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
      child: ListView.builder(
        itemCount: masterDataPersetujuan.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: sizedBoxHeightShort,
              horizontal: paddingHorizontalNarrow,
            ),
            child: buildItem(masterDataPersetujuan[index]),
          );
        },
      ),
    );
  }

  Widget approvedTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 200),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (masterDataPersetujuan.isEmpty) {
      return const Center(child: Text('Data Kosong ...'));
    }

    Widget buildItem(Map<String, dynamic> data) {
      switch (selectedValueDaftarPersetujuan) {
        case '2':
          return buildBantuanKomunikasi(data);
        case '3':
          return buildHardwareSoftware(data);
        case '4':
          return buildLemburKaryawan(data);
        case '5':
          return buildCuti(data);
        case '6':
          return buildPengajuanTraining(data);
        case '7':
          return buildImPerjalananDinas(data);
        case '13':
          return buildLpjPerjalananDinas(data);
        case '14':
          return buildSuratIzinKeluar(data);
        case '8':
          return buildPerpanjanganCuti(data);
        case '9':
          return buildRawatInap(data);
        case '10':
          return buildRawatJalan(data);
        case '11':
          return buildSuratKeterangan(data);
        default:
          return const Text('Kosong');
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
      child: ListView.builder(
        itemCount: masterDataPersetujuan.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: sizedBoxHeightShort,
              horizontal: paddingHorizontalNarrow,
            ),
            child: buildItem(masterDataPersetujuan[index]),
          );
        },
      ),
    );
  }

  Widget prossesTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 200),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (masterDataPersetujuan.isEmpty) {
      return const Center(child: Text('Data Kosong ...'));
    }

    Widget buildItem(Map<String, dynamic> data) {
      switch (selectedValueDaftarPersetujuan) {
        case '2':
          return buildBantuanKomunikasi(data);
        case '3':
          return buildHardwareSoftware(data);
        case '4':
          return buildLemburKaryawan(data);
        case '5':
          return buildCuti(data);
        case '6':
          return buildPengajuanTraining(data);
        case '7':
          return buildImPerjalananDinas(data);
        case '13':
          return buildLpjPerjalananDinas(data);
        case '14':
          return buildSuratIzinKeluar(data);
        case '8':
          return buildPerpanjanganCuti(data);
        case '9':
          return buildRawatInap(data);
        case '10':
          return buildRawatJalan(data);
        case '11':
          return buildSuratKeterangan(data);
        default:
          return const Text('Kosong');
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
      child: ListView.builder(
        itemCount: masterDataPersetujuan.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: sizedBoxHeightShort,
              horizontal: paddingHorizontalNarrow,
            ),
            child: buildItem(masterDataPersetujuan[index]),
          );
        },
      ),
    );
  }

  Widget rejectedTabWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = 8;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 200),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (masterDataPersetujuan.isEmpty) {
      return const Center(child: Text('Data Kosong ...'));
    }

    Widget buildItem(Map<String, dynamic> data) {
      switch (selectedValueDaftarPersetujuan) {
        case '2':
          return buildBantuanKomunikasi(data);
        case '3':
          return buildHardwareSoftware(data);
        case '4':
          return buildLemburKaryawan(data);
        case '5':
          return buildCuti(data);
        case '6':
          return buildPengajuanTraining(data);
        case '7':
          return buildImPerjalananDinas(data);
        case '13':
          return buildLpjPerjalananDinas(data);
        case '14':
          return buildSuratIzinKeluar(data);
        case '8':
          return buildPerpanjanganCuti(data);
        case '9':
          return buildRawatInap(data);
        case '10':
          return buildRawatJalan(data);
        case '11':
          return buildSuratKeterangan(data);
        default:
          return const Text('Kosong');
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
      child: ListView.builder(
        itemCount: masterDataPersetujuan.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: sizedBoxHeightShort,
              horizontal: paddingHorizontalNarrow,
            ),
            child: buildItem(masterDataPersetujuan[index]),
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

    String id = data['id'].toString();

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
                _buildRowWidget(
                    'Diajukan Oleh',
                    '${data['nrp_user'] ?? '-'} - ',
                    '${data['nama_user'] ?? '-'}'),
                _buildRowWidget(
                    'Diberikan Kepada (penerima)',
                    '${data['nrp_penerima'] ?? '-'} - ',
                    '${data['nama_penerima'] ?? '-'}'),
                _buildRowWidget('Jabatan (penerima)',
                    '${data['pangkat_penerima'] ?? '-'}', ''),
                _buildRowWidget('Entitas (penerima)',
                    '${data['entitas_penerima'] ?? '-'}', ''),
                _buildRowWidget('Jenis Fasilitas',
                    _getJenisFasilitas(data['id_jenis_fasilitas']), ''),
                _buildRowWidget(
                    'Prioritas', _getPrioritas(data['prioritas']), ''),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildStatusWidget(data['full_approve']),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(
                  id,
                  () {
                    Get.toNamed(
                      '/user/main/daftar_persetujuan/detail_bantuan_komunikasi',
                      arguments: {'id': id},
                    );
                  },
                  () {
                    _downloadPdf('bantuanKomunikasi', id);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLemburKaryawan(Map<String, dynamic> data) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;

    String id = data['id'].toString();

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
                _buildRowWidget(
                  'Nomor Dokumen',
                  '${data['no_doc'] ?? '-'}',
                  '',
                ),
                _buildRowWidget(
                  'NRP (pemohon)',
                  '${data['nrp_user'] ?? '-'}',
                  '',
                ),
                _buildRowWidget(
                    'Nama (pemohon)', '${data['nama_user'] ?? '-'}', ''),
                _buildRowWidget(
                    'Nama Atasan', '${data['nama_atasan'] ?? '-'}', ''),
                _buildRowWidget('Nama HRGS', '${data['nama_hrgs'] ?? '-'}', ''),
                _buildRowWidget('Aktivitas', '${data['aktivitas'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(
                  id,
                  () {
                    Get.toNamed(
                      '/user/main/daftar_persetujuan/detail_bantuan_komunikasi',
                      arguments: {'id': id},
                    );
                  },
                  () {
                    _downloadPdf('lemburKaryawan', id);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSuratKeterangan(Map<String, dynamic> data) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0188;

    String id = data['id'].toString();

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
                _buildRowWidget(
                  'Nomor Dokumen',
                  '${data['no_doc'] ?? '-'}',
                  '',
                ),
                _buildRowWidget(
                  'NRP (pemohon)',
                  '${data['nrp_user'] ?? '-'}',
                  '',
                ),
                _buildRowWidget(
                    'Nama (pemohon)', '${data['nama_user'] ?? '-'}', ''),
                _buildRowWidget(
                    'Nama Atasan', '${data['nama_atasan'] ?? '-'}', ''),
                _buildRowWidget('Nama HRGS', '${data['nama_hrgs'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/user/main/daftar_persetujuan/detail_perpanjangan_cuti',
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
                )
                // _buildActionButtons(
                //   id,
                //   () {
                //     Get.toNamed(
                //       '/user/main/daftar_persetujuan/detail_bantuan_komunikasi',
                //       arguments: {'id': id},
                //     );
                //   },
                //   () {
                //     _downloadPdf('suratKeterangan', id);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHardwareSoftware(Map<String, dynamic> data) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;

    String id = data['id'].toString();

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
                _buildRowWidget(
                  'Nomor Dokumen',
                  '${data['no_doc'] ?? '-'}',
                  '',
                ),
                _buildRowWidget(
                  'Pemohon',
                  '${data['pernr'] ?? '-'} - ',
                  '${data['nama'] ?? '-'}',
                ),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['created_at'] ?? '-'}', ''),
                _buildRowWidget('Perusahaan', '${data['cocd'] ?? '-'}', ''),
                _buildRowWidget('Lokasi', '${data['lokasi_kerja'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(
                  id,
                  () {
                    Get.toNamed(
                      '/user/main/daftar_persetujuan/detail_bantuan_komunikasi',
                      arguments: {'id': id},
                    );
                  },
                  () {
                    _downloadPdf('hardwareSoftware', id);
                  },
                ),
              ],
            ),
          ),
        ),
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

    String id = data['uuid'].toString();

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
                _buildRowWidget('Pemohon', '${data['nama_user'] ?? '-'}', ''),
                _buildRowWidget('Entitas', '${data['pt_user'] ?? '-'}', ''),
                _buildRowWidget('Atasan', '${data['nama_atasan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Pengganti', '${data['nama_pengganti'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Mulai', '${data['tgl_mulai'] ?? '-'}', ''),
                _buildRowWidget(
                    'Jumlah Cuti', '${data['jml_cuti'] ?? '-'} Hari', ''),
                _buildRowWidget('Keperluan', '${data['keperluan'] ?? '-'}', ''),
                _buildStatusWidget(data['full_approve']),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_pengajuan_cuti',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('pengajuanCuti', id);
                }),
              ],
            ),
          ),
        ),
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

  Widget buildPengajuanTraining(Map<String, dynamic> data) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0188;

    String id = data['id'].toString();

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
                _buildRowWidget('No Dokumen', '${data['no_doc'] ?? '-'}', ''),
                _buildRowWidget(
                    'Pemohon', '${data['nrp']} - ', '${data['nama'] ?? '-'}'),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['created_at'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Training', '${data['tgl_training'] ?? '-'}', ''),
                _buildRowWidget(
                    'Judul Training', '${data['judul_training'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_pengajuan_training',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('pengajuanTraining', id);
                }),
              ],
            ),
          ),
        ),
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

    String id = data['id'].toString();

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
                _buildRowWidget('No Dokumen', '${data['no_doc'] ?? '-'}', ''),
                _buildRowWidget(
                    'Nrp (Pemohon)', '${data['nrp_user'] ?? '-'}', ''),
                _buildRowWidget(
                    'Nama (Pemohon)', '${data['nama_user'] ?? '-'}', ''),
                _buildRowWidget(
                    'Nama Atasan', '${data['nama_atasan'] ?? '-'}', ''),
                _buildRowWidget('Nama HRGS', '${data['nama_hrgs'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Izin', '${data['tgl_izin'] ?? '-'}', ''),
                _buildRowWidget(
                    'Jam Keluar', '${data['jam_keluar'] ?? '-'}', ''),
                _buildRowWidget(
                    'Jam Kembali', '${data['jam_kembali'] ?? '-'}', ''),
                _buildRowWidget(
                    'Keperluan', '${data['kep_pribadi'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_surat_izin_keluar',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('suratIzinKeluar', id);
                }),
              ],
            ),
          ),
        ),
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

    String id = data['id'].toString();

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
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Nama Penerima', '${data['nama_user'] ?? '-'}', ''),
                _buildRowWidget(
                    'Jumlah Extend', '${data['jth_extend'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Mulai', '${data['start_date'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Kadaluarsa', '${data['expired_date'] ?? '-'}', ''),
                _buildStatusWidget(data['full_approve']),
                SizedBox(height: sizedBoxHeightShort),
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/user/main/daftar_persetujuan/detail_perpanjangan_cuti',
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
                )
              ],
            ),
          ),
        ),
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

  Widget buildRawatInap(Map<String, dynamic> data) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0188;

    String id = data['id_rawat_inap'].toString();

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
                _buildRowWidget(
                    'No Dokumen', '${data['kode_rawat_inap'] ?? '-'}', ''),
                _buildRowWidget('Pemohon', '${data['pernr'] ?? '-'} - ',
                    '${data['nama'] ?? '-'}'),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['created_at'] ?? '-'}', ''),
                _buildRowWidget('Perusahaan', '${data['pt'] ?? '-'}', ''),
                _buildRowWidget('Lokasi', '${data['lokasi'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_rawat_inap',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('rawatInap', id);
                }),
              ],
            ),
          ),
        ),
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

    String id = data['id'].toString();

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
                _buildRowWidget(
                    'Nomor Dokumen', '${data['no_doc'] ?? '-'}', ''),
                _buildRowWidget('Pemohon', '${data['pernr'] ?? '-'} - ',
                    '${data['nama'] ?? '-'}'),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget('Perusahaan', '${data['pt'] ?? '-'}', ''),
                _buildRowWidget('Lokasi', '${data['lokasi'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_rawat_jalan',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('rawatJalan', id);
                }),
              ],
            ),
          ),
        ),
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

    String id = data['id'].toString();

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
                _buildRowWidget(
                    'Nomor Dokumen', '${data['no_doc'] ?? '-'}', ''),
                _buildRowWidget('Pemohon', '${data['nrp_user'] ?? '-'}',
                    '${data['nama_user'] ?? '-'}'),
                _buildRowWidget(
                    'Nama Atasan', '${data['nama_atasan'] ?? '-'}', ''),
                _buildRowWidget('Nama HRGS', '${data['nama_hrgs'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tempat Tujuan', '${data['tempat_tujuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Perihal', '${data['catatan_atasan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Pengajuan', '${data['tgl_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_im_perjalanan_dinas',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('imPerjalananDinas', id);
                }),
              ],
            ),
          ),
        ),
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

    String id = data['id'].toString();

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
                _buildRowWidget(
                    'Nomor Dokumen', '${data['no_doc'] ?? '-'}', ''),
                _buildRowWidget('Pemohon', '${data['nrp_user'] ?? '-'}',
                    '${data['nama_user'] ?? '-'}'),
                _buildRowWidget(
                    'Nama Atasan', '${data['nama_atasan'] ?? '-'}', ''),
                _buildRowWidget('Nama HRGS', '${data['nama_hrgs'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tempat Tujuan', '${data['tempat_tujuan'] ?? '-'}', ''),
                _buildRowWidget('Tanggal Kembali',
                    '${data['tgl_aktual_kembali'] ?? '-'}', ''),
                _buildRowWidget('Tanggal Pengajuan LPJ',
                    '${data['tgl_pengajuan_lpj'] ?? '-'}', ''),
                _buildRowWidget(
                    'Status', '${data['status_approve'] ?? '-'}', ''),
                SizedBox(height: sizedBoxHeightShort),
                _buildActionButtons(id, () {
                  Get.toNamed(
                    '/user/main/daftar_persetujuan/detail_lpj_perjalanan_dinas',
                    arguments: {'id': id},
                  );
                }, () {
                  _downloadPdf('lpjPerjalananDinas', id);
                }),
              ],
            ),
          ),
        ),
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

    String id = data['id'].toString();

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
                _buildRowWidget(
                    'Jenis Pengajuan', '${data['jenis_pengajuan'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Mulai', '${data['tgl_mulai'] ?? '-'}', ''),
                _buildRowWidget(
                    'Tanggal Berakhir', '${data['tgl_berakhir'] ?? '-'}', ''),
                _buildRowWidget(
                    'Keterangan', '${data['deskripsi'] ?? '-'}', ''),
                _buildRowWidget(
                    'Total Cuti Diambil', '${data['jml_hari'] ?? '-'}', ''),
                _buildRowWidget(
                    'Cuti Bersama', '${data['jml_cuti_bersama'] ?? '-'}', ''),
                _buildRowWidget(
                    'Cuti Dibayar', '${data['jml_cuti_tahunan'] ?? '-'}', ''),
                _buildRowWidget('Cuti Tidak Dibayar',
                    '${data['jml_cuti_tdkdibayar'] ?? '-'}', ''),
                _buildRowWidget(
                    'Cuti Lainnya', '${data['jml_cuti_lainnya'] ?? '-'}', ''),
                _buildRowWidget('Status', '${data['status'] ?? '-'}', ''),
                // SizedBox(height: sizedBoxHeightShort),
                // _buildActionButtons(id, () {
                //   Get.toNamed(
                //     '/user/main/daftar_permintaan/detail_rawat_jalan',
                //     arguments: {'id': id},
                //   );
                // }, () {
                //   _downloadPdf('rawatJalan', id);
                // }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRowWidget(
      String leftText, String rightText1, String rightText2) {
    return Column(
      children: [
        RowWidget(
          textLeft: leftText,
          textRight: rightText1,
          fontWeightLeft: FontWeight.w300,
          fontWeightRight: FontWeight.w300,
        ),
        if (rightText2.isNotEmpty)
          RowWidget(
            textLeft: '',
            textRight: rightText2,
            fontWeightLeft: FontWeight.w300,
            fontWeightRight: FontWeight.w300,
          ),
      ],
    );
  }

  Widget _buildStatusWidget(String? status) {
    Color? statusColor;
    String statusText = '';

    if (status == 'V') {
      statusColor = Colors.green;
      statusText = 'Disetujui';
    } else if (status == 'X') {
      statusColor = Colors.red[600];
      statusText = 'Ditolak';
    } else {
      statusColor = Colors.grey;
      statusText = 'Proses';
    }

    return TitleCenterWithBadgeWidget(
      textLeft: 'Status',
      textRight: statusText,
      fontWeightLeft: FontWeight.w300,
      fontWeightRight: FontWeight.w300,
      color: statusColor ?? Colors.grey,
    );
  }

  Widget _buildActionButtons(
      String id, Function() onTapDetail, Function() onTapPreview) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton('Detail', onTapDetail, false),
        _buildButton('Preview', onTapPreview, _isLoadingContent[id] ?? false),
      ],
    );
  }

  Widget _buildButton(String label, Function() onTap, bool isLoading) {
    Size size = MediaQuery.of(context).size;
    double padding5 = size.width * 0.0188;
    double textMedium = size.width * 0.0329;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width * 0.38,
        height: size.height * 0.04,
        padding: EdgeInsets.all(padding5),
        decoration: BoxDecoration(
          color: label == 'Preview' ? const Color(primaryYellow) : Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: size.height * 0.025,
                  height: size.height * 0.025,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(label == 'Preview'
                        ? Icons.download_rounded
                        : Icons.details_sharp),
                    Text(
                      label,
                      style: TextStyle(
                        color: label == 'Preview'
                            ? const Color(primaryBlack)
                            : Colors.black,
                        fontSize: textMedium,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String _getJenisFasilitas(int? idJenis) {
    if (idJenis == null) return '';

    switch (idJenis) {
      case 1:
        return 'Mobile Phone';
      case 2:
        return 'Biaya Pulsa';
      default:
        return 'Kouta Internet';
    }
  }

  String _getPrioritas(String? prioritas) {
    if (prioritas == null) return '';

    switch (prioritas) {
      case '0':
        return 'Rendah';
      case '1':
        return 'Sedang';
      default:
        return 'Tinggi';
    }
  }
}
