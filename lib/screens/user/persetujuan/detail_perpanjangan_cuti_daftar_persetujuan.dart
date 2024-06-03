import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataUserPerpanjanganCutiController extends GetxController {
  var data = {}.obs;
}

class DetailPerpanjanganCutiDaftarPersetujuan extends StatefulWidget {
  const DetailPerpanjanganCutiDaftarPersetujuan({super.key});

  @override
  State<DetailPerpanjanganCutiDaftarPersetujuan> createState() =>
      _DetailPerpanjanganCutiDaftarPersetujuanState();
}

class _DetailPerpanjanganCutiDaftarPersetujuanState
    extends State<DetailPerpanjanganCutiDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailPerpanjanganCuti = {};
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoading = false;
  final _alasanRejectController = TextEditingController();

  DataUserPerpanjanganCutiController x =
      Get.put(DataUserPerpanjanganCutiController());

  @override
  void initState() {
    super.initState();
    getDataDetailPerpanjanganCuti();
    getData();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  Future<void> getDataDetailPerpanjanganCuti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/perpanjangan-cuti/detail/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailPerpanjanganCutiApi = responseData['pcuti'];

        setState(() {
          masterDataDetailPerpanjanganCuti =
              Map<String, dynamic>.from(dataDetailPerpanjanganCutiApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> approve(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse('$_apiUrl/perpanjangan-cuti/approve'),
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
            _isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> reject(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$_apiUrl/perpanjangan-cuti/reject'),
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
            _isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightExtraTall = 20;

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
                'Detail Persetujuan Perpanjangan Cuti',
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
                    approvalPerpanjanganCutiWidget(context),
                    footerWidget(context),
                    (masterDataDetailPerpanjanganCuti['full_approve'] == null &&
                            masterDataDetailPerpanjanganCuti['nrp_atasan'] ==
                                x.data['pernr'])
                        ? approvalAndRejectButton(context)
                        : const Text(''),
                    const SizedBox(
                      height: sizedBoxHeightExtraTall,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget approvalPerpanjanganCutiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Approval - Perpanjangan Cuti'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'NRP',
          textRight: '${masterDataDetailPerpanjanganCuti['nrp_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataDetailPerpanjanganCuti['nama_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Bergabung',
          textRight: '${masterDataDetailPerpanjanganCuti['tgl_masuk']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas',
          textRight: '${masterDataDetailPerpanjanganCuti['pt_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Atasan',
          textRight: '${masterDataDetailPerpanjanganCuti['nama_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Alasan Cuti Tidak Digunakan',
          textRight: '${masterDataDetailPerpanjanganCuti['alasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Total Perpanjangan Cuti',
          textRight: '${masterDataDetailPerpanjanganCuti['jth_extend']} Hari',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Mulai',
          textRight: '${masterDataDetailPerpanjanganCuti['start_date']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Kadaluwarsa',
          textRight: '${masterDataDetailPerpanjanganCuti['expired_date']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
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
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: '${masterDataDetailPerpanjanganCuti['status_approve']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': ${masterDataDetailPerpanjanganCuti['created_at']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showRejectPerpanjanganCutiModal(
                    context, masterDataDetailPerpanjanganCuti['id']);
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
                showApprovePerpanjanganCutiModal(
                    context, masterDataDetailPerpanjanganCuti['id']);
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
