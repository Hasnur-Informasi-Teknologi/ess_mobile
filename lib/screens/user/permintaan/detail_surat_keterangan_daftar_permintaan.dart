import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailSuratKeteranganDaftarPermintaan extends StatefulWidget {
  const DetailSuratKeteranganDaftarPermintaan({super.key});

  @override
  State<DetailSuratKeteranganDaftarPermintaan> createState() =>
      _DetailSuratKeteranganDaftarPermintaanState();
}

class _DetailSuratKeteranganDaftarPermintaanState
    extends State<DetailSuratKeteranganDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailSuratKeterangan = {};
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getDataDetailSuratKeterangan();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> getDataDetailSuratKeterangan() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response = await _fetchDataDetailSuratKeterangan(token, id);
      if (response.statusCode == 200) {
        _handleSuccessResponse(response);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<http.Response> _fetchDataDetailSuratKeterangan(String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();

    final url = Uri.parse("$_apiUrl/surat-keterangan/detail/$id");
    return ioClient.get(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  void _handleSuccessResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    final dataDetailSuratKeteranganApi = responseData['data'];

    setState(() {
      masterDataDetailSuratKeterangan =
          Map<String, dynamic>.from(dataDetailSuratKeteranganApi);
    });
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
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
          },
        ),
        title: Text(
          'Detail Permintaan Surat Keterangan',
          style: TextStyle(
            color: Colors.black,
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              suratDibuatUntukWidget(context),
              atasanWidget(context),
              hcgsWidget(context),
              footerWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget suratDibuatUntukWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailSuratKeterangan['nrp_user'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailSuratKeterangan['nama_user'] ?? '-'
      },
      {'label': 'NIK', 'value': masterDataDetailSuratKeterangan['nik'] ?? '-'},
      {
        'label': 'Posisi',
        'value': masterDataDetailSuratKeterangan['posisi'] ?? '-'
      },
      {
        'label': 'Lokasi Kerja',
        'value': masterDataDetailSuratKeterangan['lokasi_kerja'] ?? '-'
      },
      {
        'label': 'Entitas',
        'value': masterDataDetailSuratKeterangan['entitas_user'] ?? '-'
      },
      {
        'label': 'Tujuan Dikeluarkannya Surat',
        'value': masterDataDetailSuratKeterangan['tujuan_surat'] ?? '-'
      },
      {
        'label': 'Tanggal Bergabung',
        'value': masterDataDetailSuratKeterangan['hire_date'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Surat Dibuat Untuk'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP Atasan',
        'value': masterDataDetailSuratKeterangan['nrp_atasan'] ?? '-'
      },
      {
        'label': 'Nama Atasan',
        'value': masterDataDetailSuratKeterangan['nama_atasan'] ?? '-'
      },
      {
        'label': 'Entitas Atasan',
        'value': masterDataDetailSuratKeterangan['entitas_atasan'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget hcgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP HCGS',
        'value': masterDataDetailSuratKeterangan['nrp_hrgs'] ?? '-'
      },
      {
        'label': 'Nama HCGS',
        'value': masterDataDetailSuratKeterangan['nama_hrgs'] ?? '-'
      },
      {
        'label': 'Entitas HCGS',
        'value': masterDataDetailSuratKeterangan['entitas_hrgs'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'HCGS'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightExtraTall),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight:
              '${masterDataDetailSuratKeterangan['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailSuratKeterangan['created_at'] != null ? formatDate(masterDataDetailSuratKeterangan['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }
}
