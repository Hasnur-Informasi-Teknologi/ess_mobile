import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUserHardwareSoftwareController extends GetxController {
  var data = {}.obs;
}

class DetailHardwareSoftwareDaftarPersetujuan extends StatefulWidget {
  const DetailHardwareSoftwareDaftarPersetujuan({super.key});

  @override
  State<DetailHardwareSoftwareDaftarPersetujuan> createState() =>
      _DetailHardwareSoftwareDaftarPersetujuanState();
}

class _DetailHardwareSoftwareDaftarPersetujuanState
    extends State<DetailHardwareSoftwareDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailHardwareSoftware = {};
  final Map<String, dynamic> arguments = Get.arguments;
  final _keteranganController = TextEditingController();
  bool _isLoadingScreen = false;

  DataUserHardwareSoftwareController x =
      Get.put(DataUserHardwareSoftwareController());

  @override
  void initState() {
    super.initState();
    getData();
    getDataDetailHardwareSoftware();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
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

  Future<void> rejectAndApprove(int? id, String? status) async {
    final token = await _getToken();
    if (token == null) return;

    final keterangan = _keteranganController.text;

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final response =
          await _sendRejectApproveRequest(token, id, status, keterangan);
      _handleResponse(response);
    } catch (e) {
      print('Error rejecting/approving: $e');
    } finally {
      setState(() {
        _isLoadingScreen = false;
      });
    }
  }

  Future<http.Response> _sendRejectApproveRequest(
      String token, int? id, String? status, String keterangan) async {
    final ioClient = createIOClientWithInsecureConnection();

    final response = await ioClient.post(
      Uri.parse('$_apiUrl/permintaan-hardware-software/$id/process'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
        {
          'status': status,
          'keterangan': keterangan,
        },
      ),
    );

    return response;
  }

  void _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      Get.offAllNamed('/user/main');
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
    } else {
      Get.snackbar(
        'Information',
        'Gagal',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;

    final approvedAt1 = masterDataDetailHardwareSoftware['approved_at1'];
    final approvedAt2 = masterDataDetailHardwareSoftware['approved_at2'];
    final approvedBy1 = masterDataDetailHardwareSoftware['approved_by1'];
    final approvedBy2 = masterDataDetailHardwareSoftware['approved_by2'];

    final pernr = x.data['pernr'];
    bool shouldShowApprovalAndRejectButton() {
      return (approvedAt1 == null && pernr == approvedBy1) ||
          (approvedAt2 == null && pernr == approvedBy2);
    }

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

  Widget approvalAndRejectButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0115;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showRejectModal(context, masterDataDetailHardwareSoftware['id']);
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
            showApproveModal(context, masterDataDetailHardwareSoftware['id']);
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
                  'Approve Pengajuan Rawat Jalan',
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
                  'Reject Pengajuan Rawat Jalan',
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
