import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataUserImPerdinController extends GetxController {
  var data = {}.obs;
}

class DetailImPerjalananDinasDaftarPersetujuan extends StatefulWidget {
  const DetailImPerjalananDinasDaftarPersetujuan({super.key});

  @override
  State<DetailImPerjalananDinasDaftarPersetujuan> createState() =>
      _DetailImPerjalananDinasDaftarPersetujuanState();
}

class _DetailImPerjalananDinasDaftarPersetujuanState
    extends State<DetailImPerjalananDinasDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailImPerjalananDinas = {};
  List<Map<String, dynamic>> masterDataDetailRincianImPerjalananDinas = [];
  List<Map<String, dynamic>> masterDataCostAssigment = [];
  List<Map<String, dynamic>> masterDataCostAssigmentFiltered = [];
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoading = false;
  final _catatanController = TextEditingController();
  final _noCostAssignController = TextEditingController();
  final _typeCostIdController = TextEditingController();
  String? nrp_user, selectedValueCostAssigment;

  DataUserImPerdinController x = Get.put(DataUserImPerdinController());

  List biayaPerjalananDinasHeader = [
    'No',
    'Kategori',
    'Akomodasi',
    'Tanggal Mulai',
    'Tanggal Berakhir',
    'Tipe',
    'Keterangan',
    'Nilai (Rp)',
  ];

  List biayaPerjalananDinasKey = [
    'index',
    'kategori',
    'akomodasi',
    'tgl_mulai',
    'tgl_berakhir',
    'tipe',
    'keterangan',
    'nilai'
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailImPerjalananDinas();
    getData();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  Future<void> getDataDetailImPerjalananDinas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/rencana-perdin/detail/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailImPerjalananDinasApi = responseData['parent'];
        final dataDetailRincianImPerjalananDinasApi = responseData['child'];

        setState(() {
          masterDataDetailImPerjalananDinas =
              Map<String, dynamic>.from(dataDetailImPerjalananDinasApi);

          nrp_user = masterDataDetailImPerjalananDinas['nrp_user'];

          masterDataDetailRincianImPerjalananDinas =
              List<Map<String, dynamic>>.from(
                  dataDetailRincianImPerjalananDinasApi);
        });
        getDataCostAssigment();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataCostAssigment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/rencana-perdin/cost_assigment_karyawan?nrp_user=$nrp_user"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final masterDataCostAssigmentApi = responseData['data'];

        setState(() {
          masterDataCostAssigment =
              List<Map<String, dynamic>>.from(masterDataCostAssigmentApi);
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
            await http.post(Uri.parse('$_apiUrl/rencana-perdin/approve'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({
                  'id': id.toString(),
                  'catatan': _catatanController.text,
                  'type_cost_id': _typeCostIdController.text,
                  'type_cost_assign': selectedValueCostAssigment,
                  'no_cost_assign': _noCostAssignController.text
                }));

        final responseData = jsonDecode(response.body);
        print(responseData);
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
          Uri.parse('$_apiUrl/rencana-perdin/reject'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
            {
              'id': id.toString(),
              'catatan': _catatanController.text,
            },
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
    double sizedBoxHeightExtraTall = 20;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightTall = 15;

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
                'Approval - Rencana Biaya Perjalanan Dinas',
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
                    detailInternalMemoWidget(context),
                    atasanWidget(context),
                    hcgsWidget(context),
                    ((masterDataDetailImPerjalananDinas['level'] == '2' &&
                            x.data['pernr'] ==
                                masterDataDetailImPerjalananDinas['nrp_hrgs']))
                        ? costAssigmentWidget(context)
                        : const SizedBox(
                            height: 0,
                          ),
                    biayaPerjalananDinasTable(context),
                    footerWidget(context),
                    ((masterDataDetailImPerjalananDinas['level'] == '1' &&
                                x.data['pernr'] ==
                                    masterDataDetailImPerjalananDinas[
                                        'nrp_atasan']) ||
                            (masterDataDetailImPerjalananDinas['level'] ==
                                    '2' &&
                                x.data['pernr'] ==
                                    masterDataDetailImPerjalananDinas[
                                        'nrp_hrgs']))
                        ? approvalAndRejectButton(context)
                        : Text(''),
                    SizedBox(
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
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nrp',
          textRight: '${masterDataDetailImPerjalananDinas['nrp_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas',
          textRight: '${masterDataDetailImPerjalananDinas['entitas_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Perihal',
          textRight: '${masterDataDetailImPerjalananDinas['perihal']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataDetailImPerjalananDinas['nama_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jabatan',
          textRight: '${masterDataDetailImPerjalananDinas['jabatan_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget detailInternalMemoWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Internal Memo'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nomor Dokumen',
          textRight: '${masterDataDetailImPerjalananDinas['no_doc']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Trip Number',
          textRight: '${masterDataDetailImPerjalananDinas['trip_number']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Trip Activity',
          textRight: '${masterDataDetailImPerjalananDinas['trip_activity']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal/Jam Berangkat',
          textRight: '${masterDataDetailImPerjalananDinas['tgl_berangkat']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal/Jam Kembali',
          textRight: '${masterDataDetailImPerjalananDinas['tgl_kembali']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tempat Tujuan',
          textRight: '${masterDataDetailImPerjalananDinas['tempat_tujuan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jenis Biaya',
          textRight: '${masterDataDetailImPerjalananDinas['nama_jenis_biaya']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'NRP Atasan',
          textRight: '${masterDataDetailImPerjalananDinas['nrp_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama Atasan',
          textRight: '${masterDataDetailImPerjalananDinas['nama_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas Atasan',
          textRight: '${masterDataDetailImPerjalananDinas['entitas_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget hcgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'HCGS'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'NRP HCGS',
          textRight: '${masterDataDetailImPerjalananDinas['nrp_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama HCGS',
          textRight: '${masterDataDetailImPerjalananDinas['nama_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas HCGS',
          textRight: '${masterDataDetailImPerjalananDinas['entitas_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget biayaPerjalananDinasTable(BuildContext context) {
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
        const TitleWidget(title: 'Biaya Perjalanan Dinas'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataDetailRincianImPerjalananDinas.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: biayaPerjalananDinasHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataDetailRincianImPerjalananDinas
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: biayaPerjalananDinasKey.map((column) {
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
                                  data[column].toString(),
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

  Widget costAssigmentWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Cost Assigment'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        DropdownButtonFormField<String>(
          menuMaxHeight: size.height * 0.5,
          // validator: ,
          value: selectedValueCostAssigment,
          icon: masterDataCostAssigment.isEmpty
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueCostAssigment = newValue ?? '';
              masterDataCostAssigmentFiltered = masterDataCostAssigment
                  .where((item) =>
                      item['type_cost_assign'] == selectedValueCostAssigment)
                  .toList();

              _noCostAssignController.text = masterDataCostAssigmentFiltered[0]
                      ['no_cost_assign']
                  .toString();
              _typeCostIdController.text =
                  masterDataCostAssigmentFiltered[0]['type_cost_id'].toString();
            });
          },
          items: masterDataCostAssigment.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["type_cost_assign"].toString(),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: TitleWidget(
                  title: value["type_cost_assign"] as String,
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxHeight: 60),
            labelStyle: TextStyle(fontSize: textMedium),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: selectedValueCostAssigment != null
                    ? Colors.black54
                    : Colors.grey,
                width: 1.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        SizedBox(
          height: sizedBoxHeightTall,
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
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: '${masterDataDetailImPerjalananDinas['status_approve']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': ${masterDataDetailImPerjalananDinas['created_at']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
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
        InkWell(
          onTap: () {
            showRejectImPerdinModal(
                context, masterDataDetailImPerjalananDinas['id']);
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
            showApproveImPerdinModal(
                context, masterDataDetailImPerjalananDinas['id']);
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

  void showApproveImPerdinModal(BuildContext context, int? id) {
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
                  'Konfirmasi Approve',
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
                'Apakah Anda yakin ingin menyetujui data ini ?',
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
            controller: _catatanController,
            maxHeightConstraints: 40,
            hintText: 'Masukkan Catatan Disini',
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
                    approve(id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
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

  void showRejectImPerdinModal(BuildContext context, int? id) {
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
                'Apakah Anda yakin ingin menolak data ini ?',
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
            controller: _catatanController,
            maxHeightConstraints: 40,
            hintText: 'Masukkan Catatan Disini',
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
