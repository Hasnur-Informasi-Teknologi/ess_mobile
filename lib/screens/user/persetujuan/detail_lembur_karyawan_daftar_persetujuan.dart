import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUserLemburKaryawanController extends GetxController {
  var data = {}.obs;
}

class DetailLemburKaryawanDaftarPersetujuan extends StatefulWidget {
  const DetailLemburKaryawanDaftarPersetujuan({super.key});

  @override
  State<DetailLemburKaryawanDaftarPersetujuan> createState() =>
      _DetailLemburKaryawanDaftarPersetujuanState();
}

class _DetailLemburKaryawanDaftarPersetujuanState
    extends State<DetailLemburKaryawanDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailLemburKaryawan = {};
  List<Map<String, dynamic>> masterDataDetailPerintahLemburTable = [];
  final Map<String, dynamic> arguments = Get.arguments;
  final _alasanController = TextEditingController();
  bool _isLoading = false;

  DataUserLemburKaryawanController x =
      Get.put(DataUserLemburKaryawanController());

  List perintahLemburTableHeader = [
    'No',
    'NRP',
    'Nama',
    'Entitas',
    'Tanggal/Jam Mulai',
    'Tanggal/Jam Berakhir',
    'Keterangan',
  ];

  List perintahLemburTableKey = [
    'index',
    'nrp_karyawan',
    'nama_karyawan',
    'entitas_karyawan',
    'tgl_mulai',
    'tgl_berakhir',
    'keterangan',
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailLemburKaryawan();
    getData();
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

  Future<void> getDataDetailLemburKaryawan() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response = await _fetchDataDetailLemburKaryawan(token, id);
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

  Future<http.Response> _fetchDataDetailLemburKaryawan(String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();

    final url = Uri.parse("$_apiUrl/perintah-lembur/detail/$id");
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
    final dataDetailLemburKaryawanApi = responseData['parent'];
    final dataDetailPerintahLemburTableApi = responseData['child'];

    setState(() {
      masterDataDetailLemburKaryawan =
          Map<String, dynamic>.from(dataDetailLemburKaryawanApi);
      masterDataDetailPerintahLemburTable =
          List<Map<String, dynamic>>.from(dataDetailPerintahLemburTableApi);
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
      final response = await _sendApproveRequest(token, id);
      _handleApproveResponse(response);
    } catch (e) {
      print('Error approving cuti: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<http.Response> _sendApproveRequest(String token, int? id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse('$_apiUrl/perintah-lembur/approve');
    return ioClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body:
          jsonEncode({'id': id.toString(), 'catatan': _alasanController.text}),
    );
  }

  void _handleApproveResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      Get.offAllNamed('/user/main');
      _showSnackbar('Information', 'Approved', Colors.amber);
    } else {
      _showSnackbar('Information', 'Gagal', Colors.amber);
    }
  }

  void _showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      shouldIconPulse: false,
    );
  }

  Future<void> reject(int? id) async {
    final token = await _getToken();
    if (token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _sendRejectRequest(token, id);
      _handleRejectResponse(response);
    } catch (e) {
      print('Error rejecting cuti: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<http.Response> _sendRejectRequest(String token, int? id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse('$_apiUrl/perintah-lembur/reject');
    return ioClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body:
          jsonEncode({'id': id.toString(), 'catatan': _alasanController.text}),
    );
  }

  void _handleRejectResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      Get.offAllNamed('/user/main');
      _showSnackbar('Information', 'Rejected', Colors.amber);
    } else {
      _showSnackbar('Information', 'Gagal', Colors.amber);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;

    bool shouldShowApprovalAndRejectButton() {
      final level = masterDataDetailLemburKaryawan['level'];
      final pernr = x.data['pernr'];
      final nrpMapping = {
        '1': masterDataDetailLemburKaryawan['nrp_atasan'],
        '2': masterDataDetailLemburKaryawan['nrp_hrgs'],
      };

      return nrpMapping[level] == pernr;
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
                'Detail Permintaan Perintah Lembur',
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
                    atasanWidget(context),
                    hcgsWidget(context),
                    perintahLemburTable(context),
                    footerWidget(context),
                    shouldShowApprovalAndRejectButton()
                        ? approvalAndRejectButton(context)
                        : const SizedBox.shrink(),
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
        'label': 'NRP Pemohon',
        'value': masterDataDetailLemburKaryawan['nrp_user'] ?? '-'
      },
      {
        'label': 'Entitas Pemohon',
        'value': masterDataDetailLemburKaryawan['entitas_user'] ?? '-'
      },
      {
        'label': 'Nama Pemohon',
        'value': masterDataDetailLemburKaryawan['nama_user'] ?? '-'
      },
      {
        'label': 'Jabatan Pemohon',
        'value': masterDataDetailLemburKaryawan['jabatan_user'] ?? '-'
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

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP Atasan',
        'value': masterDataDetailLemburKaryawan['nrp_atasan'] ?? '-'
      },
      {
        'label': 'Nama Atasan',
        'value': masterDataDetailLemburKaryawan['nama_atasan'] ?? '-'
      },
      {
        'label': 'Entitas Atasan',
        'value': masterDataDetailLemburKaryawan['entitas_atasan'] ?? '-'
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
        'value': masterDataDetailLemburKaryawan['nrp_hrgs'] ?? '-'
      },
      {
        'label': 'Nama HCGS',
        'value': masterDataDetailLemburKaryawan['nama_hrgs'] ?? '-'
      },
      {
        'label': 'Entitas HCGS',
        'value': masterDataDetailLemburKaryawan['entitas_hrgs'] ?? '-'
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

  Widget perintahLemburTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Perintah Lembur'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataDetailPerintahLemburTable.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: perintahLemburTableHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataDetailPerintahLemburTable
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: perintahLemburTableKey.map((column) {
                            if (column == 'index') {
                              return TableViewCell(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            } else {
                              return TableViewCell(
                                child: Text(
                                  // data[column].toString(),
                                  data[column] ?? '-',
                                  style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
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
              '${masterDataDetailLemburKaryawan['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailLemburKaryawan['created_at'] != null ? formatDate(masterDataDetailLemburKaryawan['created_at']) : ''}',
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
            showRejectModal(context, masterDataDetailLemburKaryawan['id']);
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
            showApproveModal(context, masterDataDetailLemburKaryawan['id']);
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
              Text(
                'Apakah Anda Yakin ingin menyetujui data ini?',
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
            controller: _alasanController,
            maxHeightConstraints: 40,
            hintText: 'Masukkan Catatan disini',
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
                'Apakah Anda Yakin ingin menyetujui data ini?',
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
            controller: _alasanController,
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
