import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailHardwareSoftwareDaftarPermintaan extends StatefulWidget {
  const DetailHardwareSoftwareDaftarPermintaan({super.key});

  @override
  State<DetailHardwareSoftwareDaftarPermintaan> createState() =>
      _DetailHardwareSoftwareDaftarPermintaanState();
}

class _DetailHardwareSoftwareDaftarPermintaanState
    extends State<DetailHardwareSoftwareDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailHardwareSoftware = {};
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getDataDetailHardwareSoftware();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> getDataDetailHardwareSoftware() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response = await _fetchDataDetailHardwareSoftware(token, id);
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

  Future<http.Response> _fetchDataDetailHardwareSoftware(String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();

    final url = Uri.parse("$_apiUrl/permintaan-hardware-software/$id/detail");
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
    final dataDetailHardwareSoftwareApi = responseData['data'];
    print(dataDetailHardwareSoftwareApi);
    setState(() {
      masterDataDetailHardwareSoftware =
          Map<String, dynamic>.from(dataDetailHardwareSoftwareApi);
    });
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightTall = 15;
    const double sizedBoxHeightShort = 8;
    const double sizedBoxHeightExtraTall = 20;

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
          'Detail Permintaan Hardware & Software',
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
              diajukanOlehWidget(context),
              hardwareSoftwareWidget(context),
              footerWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailHardwareSoftware['pernr'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailHardwareSoftware['nama'] ?? '-'
      },
      {
        'label': 'Departemen',
        'value': masterDataDetailHardwareSoftware['departemen'] ?? '-'
      },
      {
        'label': 'Entitas',
        'value': masterDataDetailHardwareSoftware['entitas'] ?? '-'
      },
      {
        'label': 'Nomor Telepon',
        'value': masterDataDetailHardwareSoftware['no_hp'] ?? '-'
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': masterDataDetailHardwareSoftware['created_at'] != null
            ? formatDate(masterDataDetailHardwareSoftware['created_at'])
            : ''
      },
      {
        'label': 'Estimasi Tanggal Dibutuhkan',
        'value': masterDataDetailHardwareSoftware['estimasi_tgl'] ?? '-'
      },
      {
        'label': 'Disediakan Untuk',
        'value': masterDataDetailHardwareSoftware['pernr_to'] ?? '-'
      },
      {
        'label': 'Lokasi Kerja',
        'value': masterDataDetailHardwareSoftware['lokasi_kerja'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
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

  Widget hardwareSoftwareWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Hardware',
        'value': masterDataDetailHardwareSoftware['permintaan_hardware'] ?? '-'
      },
      {
        'label': 'Software',
        'value': masterDataDetailHardwareSoftware['permintaan_software'] ?? '-'
      },
      {
        'label': 'Detail Permintaan',
        'value': masterDataDetailHardwareSoftware['detail_permintaan'] ?? '-'
      },
      {
        'label': 'Keterangan',
        'value': masterDataDetailHardwareSoftware['keterangan'] ?? '-'
      },
      {
        'label': 'Keterangan Atasan',
        'value': masterDataDetailHardwareSoftware['keterangan_atasan'] ?? '-'
      },
      {
        'label': 'Keterangan IT',
        'value': masterDataDetailHardwareSoftware['keterangan_it'] ?? '-'
      },
      {
        'label': 'Disediakan Untuk',
        'value': masterDataDetailHardwareSoftware['pernr_to'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
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
              '${masterDataDetailHardwareSoftware['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailHardwareSoftware['created_at'] != null ? formatDate(masterDataDetailHardwareSoftware['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }
}
