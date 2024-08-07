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
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DataUserRawatJalanController extends GetxController {
  var data = {}.obs;
}

class DetailRawatJalanDaftarPersetujuan extends StatefulWidget {
  const DetailRawatJalanDaftarPersetujuan({super.key});

  @override
  State<DetailRawatJalanDaftarPersetujuan> createState() =>
      _DetailRawatJalanDaftarPersetujuanState();
}

class _DetailRawatJalanDaftarPersetujuanState
    extends State<DetailRawatJalanDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> masterDataDetailRawatJalan = {};
  List<Map<String, dynamic>> masterDataDetailRincianRawatJalan = [];
  List<Map<String, dynamic>> masterDataDetailApprovedRawatJalan = [];
  List<Map<String, dynamic>> masterDataDetailPlafonFiltered = [];
  List<Map<String, dynamic>> approveDetail = [];
  List<Map<String, dynamic>> masterDataDetailPlafon = [];
  final Map<String, dynamic> arguments = Get.arguments;
  final DateRangePickerController _tanggalTerimaController =
      DateRangePickerController();
  DateTime? tanggalTerima;
  final DateRangePickerController _tanggalPaymentController =
      DateRangePickerController();
  DateTime? tanggalPayment;
  final _keteranganController = TextEditingController();
  final _sisaPlafonController = TextEditingController();
  final _plafonDisetujuiController = TextEditingController();
  final _catatanController = TextEditingController();
  bool _isLoadingScreen = false;
  String? selectedValueDetailPlafon;
  int? nominalDisetujui;

  List<Map<String, dynamic>> selectedJenisDokumen = [
    {'jenis': 'Dokumen Lengkap'},
    {'jenis': 'Dokumen Tidak Lengkap / Dikembalikan'},
  ];

  List daftarPengajuanHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Nama Pasien',
    'Hubungan',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List daftarPengajuanKey = [
    'index',
    'jenis_penggantian',
    'detail_penggantian',
    'nm_pasien',
    'hub_karyawan',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah_rp',
  ];

  List daftarPengajuanHeaderWithButton = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Nama Pasien',
    'Hubungan',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
    'Aksi'
  ];

  List daftarPengajuanKeyWithButton = [
    'index',
    'jenis_penggantian',
    'detail_penggantian',
    'nm_pasien',
    'hub_karyawan',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah_rp',
    'submit'
  ];

  List approvalCompensationHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Nama Pasien',
    'Hubungan',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List approvalCompensationKey = [
    'index',
    'jenis_penggantian',
    'detail_penggantian',
    'nm_pasien',
    'hub_karyawan',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah',
  ];

  List approvalCompensationHeaderWithButton = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Nama Pasien',
    'Hubungan',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
    'Aksi'
  ];

  List approvalCompensationKeyWithButton = [
    'index',
    'jenis_penggantian',
    'detail_penggantian',
    'nm_pasien',
    'hub_karyawan',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah',
    'delete'
  ];

  String? selectedValueJenisDokumen;

  DataUserRawatJalanController x = Get.put(DataUserRawatJalanController());

  @override
  void initState() {
    super.initState();
    getData();
    getDataDetailRawatJalan();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  String _formatRupiah(dynamic amount) {
    double parsedAmount = 0.0;

    if (amount is String) {
      parsedAmount = double.tryParse(amount) ?? 0.0;
    } else if (amount is int) {
      parsedAmount = amount.toDouble();
    }

    String formattedAmount =
        NumberFormat.decimalPattern('id-ID').format(parsedAmount);
    if (parsedAmount < 0) {
      formattedAmount = '(${formattedAmount.substring(1)})';
    }
    return formattedAmount;
  }

  int calculateTotalJumlahDisetujui(
      List<Map<String, dynamic>> masterDataDetailApprovedRawatJalan) {
    return masterDataDetailApprovedRawatJalan.fold(0, (sum, item) {
      int jumlah = item['jumlah'];
      return sum + jumlah;
    });
  }

  Future<void> getDataDetailRawatJalan() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final response = await _fetchDataDetailRawatJalan(token, id);
      if (response.statusCode == 200) {
        _handleSuccessResponseDetailRawatJalan(response);
        await getDataDetailPlafon();
      } else {
        _handleErrorResponseDetailRawatJalan(response);
      }
    } catch (e) {
      print('Error fetching data rawat jalan: $e');
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

  Future<http.Response> _fetchDataDetailRawatJalan(String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/rawat/jalan/$id/detail");
    return ioClient.get(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  void _handleSuccessResponseDetailRawatJalan(http.Response response) {
    final responseData = jsonDecode(response.body);
    final dataDetailRawatJalanApi = responseData['data'];
    final dataDetailRincianRawatJalanApi = responseData['data']['detail'];
    final dataDetailApprovedRawatJalanApi =
        responseData['data']['approved_detail'];

    setState(() {
      masterDataDetailRawatJalan =
          Map<String, dynamic>.from(dataDetailRawatJalanApi);
      masterDataDetailRincianRawatJalan =
          List<Map<String, dynamic>>.from(dataDetailRincianRawatJalanApi);
      masterDataDetailApprovedRawatJalan =
          List<Map<String, dynamic>>.from(dataDetailApprovedRawatJalanApi);
    });
  }

  void _handleErrorResponseDetailRawatJalan(http.Response response) {
    print('Failed to fetch data detail rawat jalan: ${response.statusCode}');
  }

  Future<void> getDataDetailPlafon() async {
    var nrp = masterDataDetailRawatJalan['pernr'];
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await _fetchDataDetailPlafon(token, nrp);
      if (response.statusCode == 200) {
        _handleSuccessResponseDetailPlafon(response);
      } else {
        _handleErrorResponseDetailPlafon(response);
      }
    } catch (e) {
      print('Error fetching data plafon: $e');
    }
  }

  Future<http.Response> _fetchDataDetailPlafon(String token, var nrp) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/rawat/jalan/plafon?nrp=$nrp");
    return ioClient.get(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  void _handleSuccessResponseDetailPlafon(http.Response response) {
    final responseData = jsonDecode(response.body);
    final dataDetailPlafonApi = responseData['data'];

    setState(() {
      masterDataDetailPlafon =
          List<Map<String, dynamic>>.from(dataDetailPlafonApi);
    });
  }

  void _handleErrorResponseDetailPlafon(http.Response response) {
    print('Failed to fetch data detail plafon: ${response.statusCode}');
  }

  Future<void> rejectAndApprove(int? id, String? status) async {
    final token = await _getToken();
    if (token == null) return;

    final keterangan = _keteranganController.text;
    final catatan = _catatanController.text;
    final tglPayment = tanggalPayment.toString();
    final jumlahSetuju =
        calculateTotalJumlahDisetujui(masterDataDetailApprovedRawatJalan);

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final response = await _sendRejectApproveRequest(
          token, id, status, keterangan, catatan, tglPayment, jumlahSetuju);
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
    String token,
    int? id,
    String? status,
    String keterangan,
    String catatan,
    String tglPayment,
    int jumlahSetuju,
  ) async {
    final ioClient = createIOClientWithInsecureConnection();

    final response = await ioClient.post(
      Uri.parse('$_apiUrl/rawat/jalan/$id/process'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
        {
          'status': status,
          'keterangan': keterangan,
          'catatan': catatan,
          'ket_doc': selectedValueJenisDokumen,
          'tgl_payment': tglPayment,
          'approve_detail': approveDetail,
          'jumlah_setuju': jumlahSetuju,
          'sisa_plafon': 0
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

  Future<void> handleButtonAdd(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightShort = 8;
    double padding5 = size.width * 0.0115;
    const double sizedBoxHeightExtraTall = 20;

    setState(() {
      _plafonDisetujuiController.text =
          masterDataDetailRincianRawatJalan[index]['jumlah'].toString();
      selectedValueDetailPlafon =
          masterDataDetailRincianRawatJalan[index]['md_rw_jalan']['ket'];

      masterDataDetailPlafonFiltered = masterDataDetailPlafon
          .where((item) => item['ket'] == selectedValueDetailPlafon)
          .toList();
      _sisaPlafonController.text =
          _formatRupiah(masterDataDetailPlafonFiltered[0]['sisa'].toString());
    });

    void submitDaftarPengajuan() {
      final idExists = approveDetail.any((element) =>
          element['id_jp_rawat_jalan'] ==
          masterDataDetailRincianRawatJalan[index]['id_jp_rawat_jalan']);

      if (idExists) {
        Get.snackbar('Information', 'Data Tersebut Tidak Boleh Lagi!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        return;
      }

      final newDetail = {
        'id_jp_rawat_jalan': masterDataDetailRincianRawatJalan[index]
            ['id_jp_rawat_jalan'],
        'benefit_type': masterDataDetailRincianRawatJalan[index]
            ['benefit_type'],
        'created_at': masterDataDetailRincianRawatJalan[index]['created_at'],
        'detail_penggantian': masterDataDetailRincianRawatJalan[index]
            ['detail_penggantian'],
        'hub_karyawan': masterDataDetailRincianRawatJalan[index]
            ['hub_karyawan'],
        'id_diagnosa': masterDataDetailRincianRawatJalan[index]['id_diagnosa'],
        'id_md_jp_rawat_jalan': masterDataDetailRincianRawatJalan[index]
            ['id_md_jp_rawat_jalan'],
        'jenis_penggantian': null,
        'jumlah': masterDataDetailRincianRawatJalan[index]['jumlah'],
        'jumlah_rp': masterDataDetailRincianRawatJalan[index]['jumlah_rp'],
        'keterangan': masterDataDetailRincianRawatJalan[index]['keterangan'],
        'message': masterDataDetailRincianRawatJalan[index]['message'],
        'nm_pasien': masterDataDetailRincianRawatJalan[index]['nm_pasien'],
        'no_doc': masterDataDetailRincianRawatJalan[index]['no_doc'],
        'no_kuitansi': masterDataDetailRincianRawatJalan[index]['no_kuitansi'],
        'plafon_type': masterDataDetailPlafonFiltered.isNotEmpty
            ? masterDataDetailPlafonFiltered[0]['type_plafon'].toString()
            : '',
        'sap_sync_state': masterDataDetailRincianRawatJalan[index]
            ['sap_sync_state'],
        'status': masterDataDetailRincianRawatJalan[index]['status'],
        'tgl_kuitansi': masterDataDetailRincianRawatJalan[index]
            ['tgl_kuitansi'],
        'updated_at': masterDataDetailRincianRawatJalan[index]['updated_at'],
        'md_rw_jalan': {
          'created_at': masterDataDetailRincianRawatJalan[index]['md_rw_jalan']
              ['created_at'],
          'id': masterDataDetailRincianRawatJalan[index]['md_rw_jalan']['id'],
          'kd_rw_jalan': masterDataDetailRincianRawatJalan[index]['md_rw_jalan']
              ['kd_rw_jalan'],
          'ket': masterDataDetailRincianRawatJalan[index]['md_rw_jalan']['ket'],
          'updated_at': masterDataDetailRincianRawatJalan[index]['md_rw_jalan']
              ['updated_at'],
        },
      };

      setState(() {
        approveDetail.add(newDetail);

        masterDataDetailApprovedRawatJalan.add({
          'plafon_type': masterDataDetailPlafonFiltered.isNotEmpty
              ? masterDataDetailPlafonFiltered[0]['type_plafon'].toString()
              : '',
          'plafon_name': masterDataDetailPlafonFiltered.isNotEmpty
              ? masterDataDetailPlafonFiltered[0]['ket']
              : '',
          'detail_penggantian': newDetail['detail_penggantian'],
          'nm_pasien': newDetail['nm_pasien'],
          'hub_karyawan': newDetail['hub_karyawan'],
          'no_kuitansi': newDetail['no_kuitansi'],
          'tgl_kuitansi': newDetail['tgl_kuitansi'],
          'jumlah': int.parse(_plafonDisetujuiController.text),
        });

        nominalDisetujui =
            calculateTotalJumlahDisetujui(masterDataDetailApprovedRawatJalan);
      });
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Jenis Pengganti',
                  textRight:
                      '${masterDataDetailRincianRawatJalan[index]['md_rw_jalan']['kd_rw_jalan']} - ${masterDataDetailRincianRawatJalan[index]['md_rw_jalan']['ket']}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Pasien',
                  textRight:
                      '${masterDataDetailRincianRawatJalan[index]['nm_pasien'] ?? '-'}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Tanggal Kuitansi',
                  textRight:
                      '${masterDataDetailRincianRawatJalan[index]['tgl_kuitansi'] ?? '-'}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Detail Penggantian',
                  textRight:
                      '${masterDataDetailRincianRawatJalan[index]['detail_penggantian'] ?? '-'}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'No Kuitansi',
                  textRight:
                      '${masterDataDetailRincianRawatJalan[index]['no_kuitansi'] ?? '-'}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Nominal',
                  textRight:
                      '${masterDataDetailRincianRawatJalan[index]['jumlah_rp'] ?? '-'}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TitleWidget(
                  title: 'Detail Plafon ',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                DropdownButtonFormField<String>(
                  menuMaxHeight: size.height * 0.5,
                  // validator: ,
                  value: selectedValueDetailPlafon,
                  icon: masterDataDetailPlafon.isEmpty
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      : const Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueDetailPlafon = newValue ?? '';
                      masterDataDetailPlafonFiltered = masterDataDetailPlafon
                          .where((item) =>
                              item['ket'] == selectedValueDetailPlafon)
                          .toList();
                      _sisaPlafonController.text = _formatRupiah(
                          masterDataDetailPlafonFiltered[0]['sisa'].toString());
                    });
                  },
                  items:
                      masterDataDetailPlafon.map((Map<String, dynamic> value) {
                    return DropdownMenuItem<String>(
                      value: value["ket"].toString(),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TitleWidget(
                          title: value["ket"] as String,
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxHeight: 60),
                    labelStyle: TextStyle(fontSize: textMedium),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: selectedValueDetailPlafon != null
                            ? Colors.black54
                            : Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TitleWidget(
                  title: 'Sisa Plafon ',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TextFormFielDisableWidget(
                  // validator: validatorAlamatCuti,
                  controller: _sisaPlafonController,
                  maxHeightConstraints: 40,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TitleWidget(
                  title: 'Plafon yang disetujui',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TextFormFieldWidget(
                  // validator: validatorAlamatCuti,
                  controller: _plafonDisetujuiController,
                  maxHeightConstraints: 40,
                  hintText: 'Detail Plafon',
                ),
                const SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pop(context);
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
                        // approvePerpanjanganCuti(id);
                        submitDaftarPengajuan();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: size.width * 0.3,
                        height: size.height * 0.04,
                        padding: EdgeInsets.all(padding5),
                        decoration: BoxDecoration(
                          color: Colors.green[500],
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
                const SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                const SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightExtraTall = 20;

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
                'Detail Persetujuan Rawat Jalan',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textLarge,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalWide, vertical: padding20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        diajukanOlehWidget(context),
                        buildDaftarPengajuanTable(context),
                        buildApprovalCompensationTable(context),
                        buildHasilVerifikasiPicHrgsWidget(context),
                      ],
                    ),
                  ),
                  buildSecondApprovalForm(context),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                    child: Column(
                      children: [
                        footerWidget(context),
                        buildApprovalAndRejectButton(context),
                        const SizedBox(
                          height: sizedBoxHeightExtraTall,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget buildDaftarPengajuanTable(BuildContext context) {
    if (x.data['pernr'] == masterDataDetailRawatJalan['approved_by2'] &&
        masterDataDetailRawatJalan['approved_at2'] == null) {
      return daftarPengajuanTableWithButton(context);
    } else {
      return daftarPengajuanTable(context);
    }
  }

  Widget buildApprovalCompensationTable(BuildContext context) {
    if (x.data['pernr'] == masterDataDetailRawatJalan['approved_by2'] &&
        masterDataDetailRawatJalan['approved_at2'] == null) {
      return approvalCompensationTableWithButton(context);
    } else {
      return approvalCompensationTable(context);
    }
  }

  Widget buildHasilVerifikasiPicHrgsWidget(BuildContext context) {
    if (x.data['pernr'] == masterDataDetailRawatJalan['approved_by2'] ||
        x.data['pernr'] == masterDataDetailRawatJalan['approved_by3']) {
      return hasilVerivikasiPicHrgsWidget(context);
    } else {
      return const SizedBox(height: 0);
    }
  }

  Widget buildSecondApprovalForm(BuildContext context) {
    if (x.data['pernr'] == masterDataDetailRawatJalan['approved_by2'] &&
        masterDataDetailRawatJalan['approved_at2'] == null) {
      return secondApprovalForm(context);
    } else {
      return const SizedBox(height: 0);
    }
  }

  Widget buildApprovalAndRejectButton(BuildContext context) {
    if ((masterDataDetailRawatJalan['approved_at1'] == null &&
            x.data['pernr'] == masterDataDetailRawatJalan['approved_by1']) ||
        (masterDataDetailRawatJalan['approved_at2'] == null &&
            x.data['pernr'] == masterDataDetailRawatJalan['approved_by2']) ||
        (masterDataDetailRawatJalan['approved_at3'] == null &&
            x.data['pernr'] == masterDataDetailRawatJalan['approved_by3'])) {
      return approvalAndRejectButton(context);
    } else {
      return const SizedBox(height: 0);
    }
  }

  Widget daftarPengajuanTableWithButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailRincianRawatJalan.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontalNarrow, vertical: padding7),
              child: SizedBox(
                height: 200,
                child: ScrollableTableView(
                  headers: daftarPengajuanHeaderWithButton.map((column) {
                    return TableViewHeader(
                      label: column,
                    );
                  }).toList(),
                  rows: masterDataDetailRincianRawatJalan
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return TableViewRow(
                      height: 60,
                      cells: daftarPengajuanKeyWithButton.map((column) {
                        if (column == 'jenis_penggantian') {
                          return TableViewCell(
                            child: Text(
                              data['md_rw_jalan'] != null
                                  ? '${data['md_rw_jalan']['kd_rw_jalan']} - ${data['md_rw_jalan']['ket']}'
                                  : '-',
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else if (column == 'index') {
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
                        } else if (column == 'submit') {
                          return TableViewCell(
                            child: InkWell(
                              onTap: () {
                                handleButtonAdd(context, index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                child: const Center(child: Icon(Icons.add)),
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
    );
  }

  Widget daftarPengajuanTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailRincianRawatJalan.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontalNarrow, vertical: padding7),
              child: SizedBox(
                height: 200,
                child: ScrollableTableView(
                  headers: daftarPengajuanHeader.map((column) {
                    return TableViewHeader(
                      label: column,
                    );
                  }).toList(),
                  rows: masterDataDetailRincianRawatJalan
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return TableViewRow(
                      height: 60,
                      cells: daftarPengajuanKey.map((column) {
                        if (column == 'jenis_penggantian') {
                          return TableViewCell(
                            child: Text(
                              data['md_rw_jalan'] != null
                                  ? '${data['md_rw_jalan']['kd_rw_jalan']} - ${data['md_rw_jalan']['ket']}'
                                  : '-',
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else if (column == 'index') {
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
    );
  }

  Widget approvalCompensationTableWithButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    print(masterDataDetailApprovedRawatJalan);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailApprovedRawatJalan.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                const TitleWidget(title: 'Approval Compensation & Benefit'),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const LineWidget(),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers:
                          approvalCompensationHeaderWithButton.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataDetailApprovedRawatJalan
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells:
                              approvalCompensationKeyWithButton.map((column) {
                            if (column == 'jenis_penggantian') {
                              return TableViewCell(
                                child: Text(
                                  '${data['plafon_type']} - ${data['plafon_name']}',
                                  style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            } else if (column == 'index') {
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
                            } else if (column == 'delete') {
                              return TableViewCell(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      masterDataDetailApprovedRawatJalan
                                          .removeAt(entry.key);

                                      approveDetail.removeAt(entry.key);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child:
                                        const Center(child: Icon(Icons.remove)),
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
                ),
              ],
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  Widget approvalCompensationTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailApprovedRawatJalan.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                const TitleWidget(title: 'Approval Compensation & Benefit'),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const LineWidget(),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: approvalCompensationHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataDetailApprovedRawatJalan
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: approvalCompensationKey.map((column) {
                            if (column == 'jenis_penggantian') {
                              return TableViewCell(
                                child: Text(
                                  '${data['plafon_type']} - ${data['plafon_name']}',
                                  style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            } else if (column == 'index') {
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
                ),
              ],
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  Widget secondApprovalForm(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double padding5 = size.width * 0.0115;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: TitleWidget(
            title: 'Tanggal Terima',
            fontWeight: FontWeight.w300,
            fontSize: textMedium,
          ),
        ),
        CupertinoButton(
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalNarrow, vertical: padding5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                ),
                Text(
                  tanggalTerima != null
                      ? DateFormat('dd-MM-yyyy').format(
                          _tanggalTerimaController.selectedDate ??
                              DateTime.now())
                      : 'dd/mm/yyyy',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 350,
                    width: 350,
                    child: SfDateRangePicker(
                      controller: _tanggalTerimaController,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          tanggalTerima = args.value;
                        });
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: TitleWidget(
            title: 'Tanggal Payment',
            fontWeight: FontWeight.w300,
            fontSize: textMedium,
          ),
        ),
        CupertinoButton(
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalNarrow, vertical: padding5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                ),
                Text(
                  tanggalPayment != null
                      ? DateFormat('dd-MM-yyyy').format(
                          _tanggalPaymentController.selectedDate ??
                              DateTime.now())
                      : 'dd/mm/yyyy',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 350,
                    width: 350,
                    child: SfDateRangePicker(
                      controller: _tanggalPaymentController,
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          tanggalPayment = args.value;
                        });
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: Row(
            children: [
              TitleWidget(
                title: 'Dokumen',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              Text(
                '*',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValueJenisDokumen,
            // validator: _validatorJenisDokumen,
            icon: selectedJenisDokumen.isEmpty
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
                selectedValueJenisDokumen = newValue ?? '';
              });
            },
            items: selectedJenisDokumen.map((Map<String, dynamic> value) {
              return DropdownMenuItem<String>(
                value: value["jenis"].toString(),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TitleWidget(
                    title: '${value["jenis"]}',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 60),
              labelStyle: TextStyle(fontSize: textMedium),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: selectedValueJenisDokumen != null
                      ? Colors.black54
                      : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: Row(
            children: [
              TitleWidget(
                title: 'Catatan',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              Text(
                '*',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: TextFormFieldWidget(
            // validator: validatorAlamatCuti,
            controller: _catatanController,
            maxHeightConstraints: 40,
            hintText: '-',
          ),
        ),
        SizedBox(
          height: sizedBoxHeightTall,
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
            showRejectModal(context, masterDataDetailRawatJalan['id']);
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
            showApproveModal(context, masterDataDetailRawatJalan['id']);
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

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Nomor',
        'value': '${masterDataDetailRawatJalan['no_doc'] ?? '-'}',
      },
      {
        'label': 'NRP',
        'value': '${masterDataDetailRawatJalan['pernr'] ?? '-'}',
      },
      {
        'label': 'Nama Karyawan',
        'value': '${masterDataDetailRawatJalan['nama'] ?? '-'}',
      },
      {
        'label': 'Perusahaan',
        'value': '${masterDataDetailRawatJalan['pt'] ?? '-'}',
      },
      {
        'label': 'Lokasi Kerja',
        'value': '${masterDataDetailRawatJalan['lokasi'] ?? '-'}',
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': '${masterDataDetailRawatJalan['tgl_pengajuan'] ?? '-'}',
      },
      {
        'label': 'Pangkat Karyawan',
        'value': '${masterDataDetailRawatJalan['pangkat'] ?? '-'}',
      },
      {
        'label': 'Tanggal Masuk',
        'value': '${masterDataDetailRawatJalan['hire_date'] ?? '-'}',
      },
      {
        'label': 'Periode Rawat',
        'value': '${masterDataDetailRawatJalan['prd_rawat'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowWithSemicolonWidget(
                  textLeft: item['label'],
                  textRight: item['value'].toString(),
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                SizedBox(height: sizedBoxHeightShort),
              ],
            )),
        SizedBox(height: sizedBoxHeightShort),
        const TitleWidget(
          title:
              'Daftar Pengajuan Jenis Penggantian Biaya Kesehatan Rawat Jalan',
        ),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget hasilVerivikasiPicHrgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, String>> data = [
      {
        'label': 'Tanggal Terima',
        'value': masterDataDetailRawatJalan['tgl_pengajuan'] ?? '-',
      },
      {
        'label': 'Nominal Disetujui',
        'value': masterDataDetailRawatJalan['approved_at2'] == null
            ? 'Rp. ${_formatRupiah(nominalDisetujui)}'
            : 'Rp. ${masterDataDetailRawatJalan['jumlah_setuju'] ?? '-'}',
      },
      {
        'label': 'Catatan',
        'value': masterDataDetailRawatJalan['catatan'] ?? '-',
      },
      {
        'label': 'Dokumen',
        'value': masterDataDetailRawatJalan['ket_doc'] ?? '-',
      },
      {
        'label': 'Tanggal Payment',
        'value': masterDataDetailRawatJalan['tgl_payment'] ?? '-',
      },
      {
        'label': 'Keterangan Atasan',
        'value': masterDataDetailRawatJalan['keterangan_atasan'] ?? '-',
      },
      {
        'label': 'Keterangan PIC HCGS',
        'value': masterDataDetailRawatJalan['keterangan_pic_hcgs'] ?? '-',
      },
      {
        'label': 'Keterangan Direksi',
        'value': masterDataDetailRawatJalan['keterangan_direksi'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightTall),
        const TitleWidget(title: 'Hasil Verifikasi PIC HRGS'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
        ...data.map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowWithSemicolonWidget(
                  textLeft: item['label'],
                  textRight: item['value']!,
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                SizedBox(height: sizedBoxHeightShort),
              ],
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
          textRight: '${masterDataDetailRawatJalan['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailRawatJalan['created_at'] != null ? formatDate(masterDataDetailRawatJalan['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
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
