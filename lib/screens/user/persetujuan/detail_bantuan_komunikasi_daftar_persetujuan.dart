import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataUserBantuanKomunikasiController extends GetxController {
  var data = {}.obs;
}

class DetailBantuanKomunikasiDaftarPersetujuan extends StatefulWidget {
  const DetailBantuanKomunikasiDaftarPersetujuan({super.key});

  @override
  State<DetailBantuanKomunikasiDaftarPersetujuan> createState() =>
      _DetailBantuanKomunikasiDaftarPersetujuanState();
}

class _DetailBantuanKomunikasiDaftarPersetujuanState
    extends State<DetailBantuanKomunikasiDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailBantuanKomunikasi = {};
  String? nominalFormated;
  bool _isLoading = false;
  final Map<String, dynamic> arguments = Get.arguments;

  DataUserBantuanKomunikasiController x =
      Get.put(DataUserBantuanKomunikasiController());

  @override
  void initState() {
    super.initState();
    getDataDetailBantuanKomunikasi();
    getData();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
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

  Future<void> approve(int? id) async {
    final token = await _getToken();
    if (token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _sendApprovalRequest(token, id);
      _handleApprovalResponse(response);
    } catch (e) {
      print('Error approving request: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<http.Response> _sendApprovalRequest(String token, int? id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse('$_apiUrl/bantuan-komunikasi/approve');

    return ioClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': id.toString()}),
    );
  }

  void _handleApprovalResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    if (responseData['status'] == 'success') {
      Get.offAllNamed('/user/main');

      Get.snackbar('Information', 'Approved',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
    } else {
      Get.snackbar('Information', 'Gagal',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> reject(int? id) async {
    final token = await _getToken();
    if (token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _sendRejectionRequest(token, id);
      _handleRejectionResponse(response);
    } catch (e) {
      print('Error rejecting request: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<http.Response> _sendRejectionRequest(String token, int? id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse('$_apiUrl/bantuan-komunikasi/reject');

    return ioClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': id.toString()}),
    );
  }

  void _handleRejectionResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    if (responseData['status'] == 'success') {
      Get.offAllNamed('/user/main');

      Get.snackbar('Information', 'Rejected',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
    } else {
      Get.snackbar('Information', 'Gagal',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightExtraTall = 20;

    bool shouldShowApprovalAndRejectButton() {
      final level = masterDataDetailBantuanKomunikasi['level'];
      final pernr = x.data['pernr'];

      return (level == '1' &&
              pernr == masterDataDetailBantuanKomunikasi['nrp_atasan']) ||
          (level == '2' &&
              pernr == masterDataDetailBantuanKomunikasi['nrp_hrgs']) ||
          (level == '3' &&
              pernr == masterDataDetailBantuanKomunikasi['nrp_direktur']) ||
          (level == '4' &&
              pernr == masterDataDetailBantuanKomunikasi['nrp_keuangan']) ||
          (level == '5' &&
              pernr == masterDataDetailBantuanKomunikasi['nrp_presiden']);
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
                'Approval - Bantuan Komunikasi',
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
                    shouldShowApprovalAndRejectButton()
                        ? approvalAndRejectButton(context)
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: sizedBoxHeightExtraTall,
                    ),
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

  Widget approvalAndRejectButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0115;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showRejectModal(context, masterDataDetailBantuanKomunikasi['id']);
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
            showApproveModal(context, masterDataDetailBantuanKomunikasi['id']);
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
                  'Apakah Anda yakin ingin menyetujui data ini?',
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
                        'No',
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
                    print(id);
                    approve(id);
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
                        'Yes',
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
              Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Konfirmasi Penolakan',
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
                'Apakah Anda yakin ingin menolak data ini?',
                style: TextStyle(
                  color: Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
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
                        'No',
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
                    reject(id);
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
                        'Yes',
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
