import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailAplikasiRekrutmenDaftarPermintaan extends StatefulWidget {
  const DetailAplikasiRekrutmenDaftarPermintaan({super.key});

  @override
  State<DetailAplikasiRekrutmenDaftarPermintaan> createState() =>
      _DetailAplikasiRekrutmenDaftarPermintaanState();
}

class _DetailAplikasiRekrutmenDaftarPermintaanState
    extends State<DetailAplikasiRekrutmenDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailAplikasiRekrutmen = {};
  final Map<String, dynamic> arguments = Get.arguments;
  String? jurusan;

  @override
  void initState() {
    super.initState();
    getDataDetailAplikasiRekrutmen();
  }

  Future<void> getDataDetailAplikasiRekrutmen() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response = await _fetchDataDetailAplikasiRekrutmen(token, id);
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

  Future<http.Response> _fetchDataDetailAplikasiRekrutmen(
      String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();

    final Map<String, dynamic> queryParams = {
      'permintaan': '1',
    };

    final url = Uri.parse("$_apiUrl/rekrutmen/detail/$id")
        .replace(queryParameters: queryParams);
    return ioClient.get(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  void _handleSuccessResponse(http.Response response) {
    String? jurusanString;
    final responseData = jsonDecode(response.body);
    final dataDetailAplikasiRekrutmenApi = responseData['data'];
    if (dataDetailAplikasiRekrutmenApi != null) {
      final farJurusan = dataDetailAplikasiRekrutmenApi['far_jurusan'] as List?;

      if (farJurusan != null && farJurusan.isNotEmpty) {
        jurusanString = farJurusan
            .map((item) => item['jurusan']['jurusan'] as String)
            .join(', ');
      }
    }
    setState(() {
      masterDataDetailAplikasiRekrutmen =
          Map<String, dynamic>.from(dataDetailAplikasiRekrutmenApi);
      jurusan = jurusanString;
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
          'Detail Permintaan Aplikasi Rekrutmen',
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
              headerWidget(context),
              diajukanOlehWidget(context),
              kualifikasiYangDibutuhkanWidget(context),
              permintaanRekrutmenKaryawanUntukWidget(context),
              pengalamanKerjaWidget(context),
              kepribadianDanKemampuanYangDibutuhkanWidget(context),
              statusKaryawanWidget(context),
              statusAplikasiRekrutmenWidget(context),
              uraianJabatanWidget(context),
              catatanWidget(context),
              footerWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Prioritas',
        'value': masterDataDetailAplikasiRekrutmen['prioritas'] ?? '-'
      },
      {
        'label': 'No',
        'value': masterDataDetailAplikasiRekrutmen['no_doc'] ?? '-'
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': masterDataDetailAplikasiRekrutmen['tgl_pengajuan'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailAplikasiRekrutmen['atasan_nrp'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailAplikasiRekrutmen['pengaju_nama'] ?? '-'
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailAplikasiRekrutmen['pengaju_jabatan'] ?? '-'
      },
      {
        'label': 'Entitas',
        'value': masterDataDetailAplikasiRekrutmen['departemen_tujuan'] ?? '-'
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

  Widget kualifikasiYangDibutuhkanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Pendidikan Minimal',
        'value': masterDataDetailAplikasiRekrutmen['pendidikan_min'] ?? '-'
      },
      {
        'label': 'Pendidikan Maksimal',
        'value': masterDataDetailAplikasiRekrutmen['pendidikan_max'] ?? '-'
      },
      {'label': 'Jurusan', 'value': jurusan ?? '-'},
      {
        'label': 'IPK / Nilai',
        'value': 'Minimal ${masterDataDetailAplikasiRekrutmen['ipk'] ?? '-'}'
      },
      {
        'label': 'Usia Minimal',
        'value': '${masterDataDetailAplikasiRekrutmen['usia_min'] ?? '-'} Tahun'
      },
      {
        'label': 'Usia Maksimal',
        'value': '${masterDataDetailAplikasiRekrutmen['usia_max'] ?? '-'} Tahun'
      },
      {
        'label': 'Jenis Kelamin',
        'value': masterDataDetailAplikasiRekrutmen['jenis_kelamin'] ?? '-'
      },
      {
        'label': 'Sertifikasi',
        'value': masterDataDetailAplikasiRekrutmen['sertifikasi']
                ['sertifikasi'] ??
            '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Kualifikasi Yang Dibutuhkan'),
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

  Widget permintaanRekrutmenKaryawanUntukWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Entitas',
        'value': masterDataDetailAplikasiRekrutmen['entitas']['nama'] ?? '-'
      },
      {
        'label': 'Divisi/Departemen',
        'value': masterDataDetailAplikasiRekrutmen['departemen_tujuan'] ?? '-'
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailAplikasiRekrutmen['jabatan_tujuan'] ?? '-'
      },
      {
        'label': 'Pangkat Minimal',
        'value': masterDataDetailAplikasiRekrutmen['min_pangkat']['nama'] ?? '-'
      },
      {
        'label': 'Pangkat Maksimal',
        'value': masterDataDetailAplikasiRekrutmen['max_pangkat']['nama'] ?? '-'
      },
      {
        'label': 'Atasan Langsung',
        'value': masterDataDetailAplikasiRekrutmen['atasan']['nama'] ?? '-'
      },
      {
        'label': 'Lokasi Kerja',
        'value': masterDataDetailAplikasiRekrutmen['lokasi_kerja_tujuan'] ?? '-'
      },
      {
        'label': 'Estimasi Mulai Bekerja',
        'value':
            masterDataDetailAplikasiRekrutmen['estimasi_mulai_kerja'] ?? '-'
      },
      {
        'label': 'Catatan',
        'value': masterDataDetailAplikasiRekrutmen['catatan'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Permintaan Rekrutmen Karyawan Untuk'),
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

  Widget pengalamanKerjaWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Pengalaman Kerja',
        'value': masterDataDetailAplikasiRekrutmen['pengalaman_kerja'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Pengalaman Kerja'),
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

  Widget kepribadianDanKemampuanYangDibutuhkanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Soft Skill',
        'value': masterDataDetailAplikasiRekrutmen['softskill'] ?? '-'
      },
      {
        'label': 'Hard Skill',
        'value': masterDataDetailAplikasiRekrutmen['hardskill'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Kepribadian & Kemampuan Yang Dibutuhkan'),
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

  Widget statusKaryawanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Kontrak',
        'value':
            '${masterDataDetailAplikasiRekrutmen['masa_kerja'] ?? '-'} ${masterDataDetailAplikasiRekrutmen['masa_kerja_satuan'] ?? '-'}'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Status Karyawan'),
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

  Widget statusAplikasiRekrutmenWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Status Rekrutmen',
        'value': masterDataDetailAplikasiRekrutmen['status_far'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Status Aplikasi Rekrutmen'),
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

  Widget uraianJabatanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Tugas & Tanggung Jawab',
        'value':
            masterDataDetailAplikasiRekrutmen['tugas_tanggung_jawab'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Uraian Jabatan'),
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

  Widget catatanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Catatan Atasan',
        'value': masterDataDetailAplikasiRekrutmen['keterangan_atasan'] ?? '-'
      },
      {
        'label': 'Catatan HCGS',
        'value': masterDataDetailAplikasiRekrutmen['keterangan_hcgs'] ?? '-'
      },
      {
        'label': 'Catatan Direksi Keuangan',
        'value': masterDataDetailAplikasiRekrutmen['keterangan_keuangan'] ?? '-'
      },
      {
        'label': 'Catatan Presiden Direktur',
        'value': masterDataDetailAplikasiRekrutmen['keterangan_direktur'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Catatan'),
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
    double sizedBoxHeightTall = 15;

    Map<String, String> data = {
      'Status Pengajuan':
          masterDataDetailAplikasiRekrutmen['status_permintaan'] ?? '-',
      'Pada': ': ${masterDataDetailAplikasiRekrutmen['created_at'] ?? '-'}',
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
