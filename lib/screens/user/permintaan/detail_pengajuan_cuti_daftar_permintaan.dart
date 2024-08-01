import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailPengajuanCutiDaftarPermintaan extends StatefulWidget {
  const DetailPengajuanCutiDaftarPermintaan({super.key});

  @override
  State<DetailPengajuanCutiDaftarPermintaan> createState() =>
      _DetailPengajuanCutiDaftarPermintaanState();
}

class _DetailPengajuanCutiDaftarPermintaanState
    extends State<DetailPengajuanCutiDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailPengajuanCuti = {};
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoadingScreen = false;

  @override
  void initState() {
    super.initState();
    getDataDetailPengajuanCuti();
  }

  Future<void> getDataDetailPengajuanCuti() async {
    final token = await _getToken();
    if (token == null) return;

    final id = arguments['id'];

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final response = await _fetchDataDetailPengajuanCuti(token, id);
      if (response.statusCode == 200) {
        _handleSuccessResponse(response);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoadingScreen = false;
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<http.Response> _fetchDataDetailPengajuanCuti(String token, String id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/pengajuan-cuti/detail/$id");
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
    final dataDetailPengajuanCutiApi = responseData['dcuti'];

    setState(() {
      masterDataDetailPengajuanCuti =
          Map<String, dynamic>.from(dataDetailPengajuanCutiApi);
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

    return _isLoadingScreen
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
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
                'Detail Permintaan Pengajuan Cuti',
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
                    tanggalPengajuanCutiWidget(context),
                    keteranganCutiWidget(context),
                    atasanWidget(context),
                    catatanCutiWidget(context),
                    karyawanPenggantiWidget(context),
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
    double sizedBoxHeightTall = size.height * 0.015;

    List<Map<String, dynamic>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPengajuanCuti['nrp_user'] ?? '-',
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPengajuanCuti['nama_user'] ?? '-',
      },
      {
        'label': 'Perusahaan',
        'value': masterDataDetailPengajuanCuti['entitas_user'] ?? '-',
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailPengajuanCuti['posisi_user'] ?? '-',
      },
      {
        'label': 'Lokasi Kerja',
        'value': masterDataDetailPengajuanCuti['lokasi_user'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
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

  Widget tanggalPengajuanCutiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Tanggal Mulai',
        'value': masterDataDetailPengajuanCuti['tgl_mulai'] ?? '-',
      },
      {
        'label': 'Tanggal Berakhir',
        'value': masterDataDetailPengajuanCuti['tgl_berakhir'] ?? '-',
      },
      {
        'label': 'Tanggal Kembali Kerja',
        'value': masterDataDetailPengajuanCuti['tgl_kembali_kerja'] ?? '-',
      },
      {
        'label': 'Alamat',
        'value': masterDataDetailPengajuanCuti['alamat_cuti'] ?? '-',
      },
      {
        'label': 'No Telpon',
        'value': masterDataDetailPengajuanCuti['no_telp'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Tanggal Pengajuan Cuti'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
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

  Widget keteranganCutiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    String jenisCuti = _getJenisCutiLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Keterangan Cuti'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        RowWithSemicolonWidget(
          textLeft: 'Jenis Cuti',
          textRight: jenisCuti,
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  String _getJenisCutiLabel() {
    if (masterDataDetailPengajuanCuti['dibayar'] == 'X') {
      return 'Cuti Tahunan Dibayar';
    } else if (masterDataDetailPengajuanCuti['tdk_dibayar'] == 'X') {
      return 'Cuti Tahunan Tidak Dibayar';
    } else {
      return 'Cuti Lainnya';
    }
  }

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Atasan',
        'value': masterDataDetailPengajuanCuti['nama_atasan'] ?? '-',
      },
      {
        'label': 'Atasan Dari Atasan',
        'value': masterDataDetailPengajuanCuti['nama_direktur'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
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

  Widget catatanCutiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Nomor Dokumen',
        'value': masterDataDetailPengajuanCuti['no_doc'] ?? '-',
      },
      {
        'label': 'Keperluan Cuti',
        'value': masterDataDetailPengajuanCuti['keperluan'] ?? '-',
      },
      {
        'label': 'Total Cuti Yang Diambil',
        'value': masterDataDetailPengajuanCuti['jml_cuti'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Catatan Cuti'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString().toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget karyawanPenggantiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = size.height * 0.015;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Nama',
        'value': masterDataDetailPengajuanCuti['nama_pengganti'] ?? '-',
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailPengajuanCuti['posisi_pengganti'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Karyawan Pengganti'),
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

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    String statusApprove =
        masterDataDetailPengajuanCuti['status_approve'] ?? '-';
    String createdAt = masterDataDetailPengajuanCuti['created_at'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightExtraTall),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: statusApprove,
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': $createdAt',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightShort),
      ],
    );
  }
}
