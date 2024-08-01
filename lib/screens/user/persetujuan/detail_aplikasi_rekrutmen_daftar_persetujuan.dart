import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUserAplikasiRekrutmenController extends GetxController {
  var data = {}.obs;
}

class DetailAplikasiRekrutmenDaftarPersetujuan extends StatefulWidget {
  const DetailAplikasiRekrutmenDaftarPersetujuan({super.key});

  @override
  State<DetailAplikasiRekrutmenDaftarPersetujuan> createState() =>
      _DetailAplikasiRekrutmenDaftarPersetujuanState();
}

class _DetailAplikasiRekrutmenDaftarPersetujuanState
    extends State<DetailAplikasiRekrutmenDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailAplikasiRekrutmen = {};
  final Map<String, dynamic> arguments = Get.arguments;
  final _keteranganController = TextEditingController();
  String? jurusan;
  bool _isLoading = false;

  DataUserAplikasiRekrutmenController x =
      Get.put(DataUserAplikasiRekrutmenController());

  @override
  void initState() {
    super.initState();
    getData();
    getDataDetailAplikasiRekrutmen();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  Future<void> getDataDetailAplikasiRekrutmen() async {
    setState(() {
      _isLoading = true;
    });
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
      _isLoading = false;
    });
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  Future<void> rejectAndApprove(int? id, String status) async {
    final token = await _getToken();
    if (token == null) return;

    String keterangan =
        _keteranganController.text.isEmpty ? '-' : _keteranganController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await _sendRejectAndApproveRequest(id, status, token, keterangan);
      final responseData = jsonDecode(response);

      Get.snackbar(
        'Information',
        responseData['message'],
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false,
      );

      if (responseData['status'] == 'success') {
        Get.offAllNamed('/user/main');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Information',
        'Failed to process the request',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<dynamic> _sendRejectAndApproveRequest(
      int? id, String status, String token, String keterangan) async {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse('$_apiUrl/rekrutmen/$id/process');

    final response = await ioClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'status': status,
        'keterangan': keterangan,
      },
    );

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;

    final approvedAt1 = masterDataDetailAplikasiRekrutmen['approved_at1'];
    final approvedAt2 = masterDataDetailAplikasiRekrutmen['approved_at2'];
    final approvedAt3 = masterDataDetailAplikasiRekrutmen['approved_at3'];
    final approvedAt4 = masterDataDetailAplikasiRekrutmen['approved_at4'];

    final pernr = x.data['pernr'];
    bool shouldShowApprovalAndRejectButton() {
      return (approvedAt1 == null &&
              pernr == masterDataDetailAplikasiRekrutmen['approved_by1']) ||
          (approvedAt2 == null &&
              pernr == masterDataDetailAplikasiRekrutmen['approved_by2']) ||
          (approvedAt3 == null &&
              pernr == masterDataDetailAplikasiRekrutmen['approved_by3']) ||
          (approvedAt4 == null &&
              pernr == masterDataDetailAplikasiRekrutmen['approved_by4']);
    }

    return _isLoading
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
                'Detail Persetujuan Aplikasi Rekrutmen',
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
                    footerWidget(context),
                    if (shouldShowApprovalAndRejectButton())
                      approvalAndRejectButton(context)
                    else
                      const SizedBox(height: 0),
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

  Widget approvalAndRejectButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0115;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showRejectModal(context, masterDataDetailAplikasiRekrutmen['id']);
          },
          child: Container(
            width: size.width * 0.25,
            height: size.height * 0.04,
            padding: EdgeInsets.all(padding5),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Icon(Icons.delete),
                  Text(
                    'Reject',
                    style: TextStyle(
                      color: Colors.white,
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
        const SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            showApproveModal(context, masterDataDetailAplikasiRekrutmen['id']);
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Icon(Icons.approval),
                  Text(
                    'Approve',
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }

  void showApproveModal(BuildContext context, int? id) {
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
                  'Approve Pengajuan Training',
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
                'Keterangan *',
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
            controller: _keteranganController,
            maxHeightConstraints: 40,
            hintText: '',
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _keteranganController.text = '';
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
                    rejectAndApprove(id, 'approve');
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
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

  void showRejectModal(BuildContext context, int? id) {
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
                  'Reject Pengajuan Training',
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
              Text(
                'Berikan Alasan: *',
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
            controller: _keteranganController,
            maxHeightConstraints: 40,
            hintText: 'Alasan Reject',
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _keteranganController.text = '';
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
                          color: const Color(primaryBlack),
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
                    rejectAndApprove(id, 'reject');
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
}
