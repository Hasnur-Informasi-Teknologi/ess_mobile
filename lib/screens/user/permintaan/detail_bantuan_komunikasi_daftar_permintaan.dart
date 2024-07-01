import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailBantuanKomunikasiDaftarPermintaan extends StatefulWidget {
  const DetailBantuanKomunikasiDaftarPermintaan({super.key});

  @override
  State<DetailBantuanKomunikasiDaftarPermintaan> createState() =>
      _DetailBantuanKomunikasiDaftarPermintaanState();
}

class _DetailBantuanKomunikasiDaftarPermintaanState
    extends State<DetailBantuanKomunikasiDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailBantuanKomunikasi = {};
  String? nominalFormated;
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getDataDetailBantuanKomunikasi();
  }

  Future<void> getDataDetailBantuanKomunikasi() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response = await _fetchDataDetailBantuanKomunikasi(token, id);
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

  Future<http.Response> _fetchDataDetailBantuanKomunikasi(
      String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();

    final url = Uri.parse("$_apiUrl/bantuan-komunikasi/detail/$id");
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
    final dataDetailBantuanKomunikasiApi = responseData['dkomunikasi'];
    setState(() {
      masterDataDetailBantuanKomunikasi =
          Map<String, dynamic>.from(dataDetailBantuanKomunikasiApi);
      final nominal = masterDataDetailBantuanKomunikasi['nominal'];
      nominalFormated = NumberFormat.decimalPattern('id-ID').format(nominal);
    });
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textMedium = size.width * 0.0329; // 14 px
    double textLarge = size.width * 0.04; // 18 px
    double padding20 = size.width * 0.047; // 20 px
    double paddingHorizontalWide = size.width * 0.0585; // 25 px
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
          'Detail Permintaan Bantuan Komunikasi',
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
              diberikanKepadaWidget(context),
              detailFasilitasKomunikasiWidget(context),
              keteranganWidget(context),
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
        'value': masterDataDetailBantuanKomunikasi['nrp_user'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailBantuanKomunikasi['nama_user'] ?? '-'
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': masterDataDetailBantuanKomunikasi['tgl_pengajuan'] ?? '-'
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

  Widget diberikanKepadaWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailBantuanKomunikasi['nrp_penerima'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailBantuanKomunikasi['nama_penerima'] ?? '-'
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailBantuanKomunikasi['jabatan_penerima'] ?? '-'
      },
      {
        'label': 'Entitas',
        'value': masterDataDetailBantuanKomunikasi['entitas_penerima'] ?? '-'
      },
      {
        'label': 'Pangkat',
        'value': masterDataDetailBantuanKomunikasi['pangkat_penerima'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diberikan Kepada'),
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

  Widget detailFasilitasKomunikasiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, String>> data = [
      {
        'label': 'Kelompok Jabatan',
        'value': masterDataDetailBantuanKomunikasi['pangkat_komunikasi'] ?? '-'
      },
      {'label': 'Nominal (IDR)', 'value': nominalFormated ?? '-'},
      {
        'label': 'Jenis Fasilitas',
        'value': masterDataDetailBantuanKomunikasi['nama_fasilitas'] ?? '-'
      },
      {
        'label': 'Jenis Mobile Phone',
        'value': masterDataDetailBantuanKomunikasi['jenis_phone_name'] ?? '-'
      },
      if (masterDataDetailBantuanKomunikasi['merek_phone'] != null)
        {
          'label': 'Merek Mobile Phone',
          'value': masterDataDetailBantuanKomunikasi['merek_phone'] ?? '-'
        },
      {
        'label': 'Prioritas',
        'value': getPrioritas(masterDataDetailBantuanKomunikasi['prioritas'])
      },
      {
        'label': 'Tujuan Komunikasi Internal',
        'value': masterDataDetailBantuanKomunikasi['tujuan_internal'] ?? '-'
      },
      {
        'label': 'Tujuan Komunikasi Eksternal',
        'value': masterDataDetailBantuanKomunikasi['tujuan_eksternal'] ?? '-'
      },
      {
        'label': 'Keterangan',
        'value': masterDataDetailBantuanKomunikasi['keterangan'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Fasilitas Komunikasi'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
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

  String getPrioritas(String? prioritas) {
    switch (prioritas) {
      case '0':
        return 'Rendah';
      case '1':
        return 'Sedang';
      case '2':
        return 'Tinggi';
      default:
        return '-';
    }
  }

  Widget keteranganWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, String>> data = [
      {
        'label': 'Tujuan Komunikasi Internal',
        'value': masterDataDetailBantuanKomunikasi['tujuan_internal'] ?? '-'
      },
      {
        'label': 'Tujuan Komunikasi Eksternal',
        'value': masterDataDetailBantuanKomunikasi['tujuan_eksternal'] ?? '-'
      },
      {
        'label': 'Keterangan',
        'value': masterDataDetailBantuanKomunikasi['keterangan'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Keterangan'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label']!,
                textRight: item['value'].toString()!,
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
    double sizedBoxHeightTall = 15;

    Map<String, String> data = {
      'Status Pengajuan':
          masterDataDetailBantuanKomunikasi['status_approve'] ?? '-',
      'Pada': ': ${masterDataDetailBantuanKomunikasi['created_at'] ?? '-'}',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightTall),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: data['Status Pengajuan']!,
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: data['Pada']!,
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightShort),
      ],
    );
  }
}
