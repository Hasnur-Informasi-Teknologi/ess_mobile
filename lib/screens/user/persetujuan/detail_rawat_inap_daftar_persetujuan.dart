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

class DataUserRawatInapController extends GetxController {
  var data = {}.obs;
}

class DetailRawatInapDaftarPersetujuan extends StatefulWidget {
  const DetailRawatInapDaftarPersetujuan({super.key});

  @override
  State<DetailRawatInapDaftarPersetujuan> createState() =>
      _DetailRawatInapDaftarPersetujuanState();
}

class _DetailRawatInapDaftarPersetujuanState
    extends State<DetailRawatInapDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> masterDataDetailRawatInap = {};
  List<Map<String, dynamic>> masterDataDetailRincianRawatInap = [];
  List<Map<String, dynamic>> masterDataDetailApprovedRawatInap = [];
  List<Map<String, dynamic>> approveDetail = [];
  List<Map<String, dynamic>> masterDataDetailPlafon = [];
  final Map<String, dynamic> arguments = Get.arguments;
  String? totalPengajuanFormated, selisihFormated, totalDigantiFormated;
  final _keteranganController = TextEditingController();
  bool _isLoadingScreen = false;
  final DateRangePickerController _tanggalTerimaController =
      DateRangePickerController();
  DateTime? tanggalTerima;
  final DateRangePickerController _tanggalPaymentController =
      DateRangePickerController();
  DateTime? tanggalPayment;
  final _kelasKamarController = TextEditingController();
  final _totalPengajuanController = TextEditingController();
  final _totalDigantiController = TextEditingController();
  final _selisihController = TextEditingController();
  final _catatanController = TextEditingController();
  final _detailPlafonController = TextEditingController();
  final _maksimalPlafonController = TextEditingController();
  final _plafonDisetujuiController = TextEditingController();

  List<Map<String, dynamic>> selectedJenisDokumen = [
    {'jenis': 'Dokumen Lengkap'},
    {'jenis': 'Dokumen Tidak Lengkap / Dikembalikan'},
  ];

  List daftarPengajuanHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Diagnosa',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List daftarPengajuanKey = [
    'index',
    'md_rw_inap',
    'detail_penggantian',
    'diagnosa',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah_rp',
  ];

  List daftarPengajuanHeaderWithButton = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Diagnosa',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
    'Aksi'
  ];

  List daftarPengajuanKeyWithButton = [
    'index',
    'md_rw_inap',
    'detail_penggantian',
    'diagnosa',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah_rp',
    'submit'
  ];

  List approvalCompensationHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Diagnosa',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List approvalCompensationKey = [
    'index',
    'md_rw_inap',
    'detail_penggantian',
    'diagnosa',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah',
  ];

  List approvalCompensationHeaderWithButton = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Diagnosa',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
    'Aksi'
  ];

  List approvalCompensationKeyWithButton = [
    'index',
    'md_rw_inap',
    'detail_penggantian',
    'diagnosa',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah',
    'delete'
  ];

  String? selectedValueJenisDokumen;

  DataUserRawatInapController x = Get.put(DataUserRawatInapController());

  @override
  void initState() {
    super.initState();
    getData();
    getDataDetailRawatInap();
    getDataDetailPlafon();
  }

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  int calculateTotalJumlah(
      List<Map<String, dynamic>> masterDataDetailRincianRawatInap) {
    return masterDataDetailRincianRawatInap.fold(0, (sum, item) {
      int jumlah = item['jumlah'] ?? 0;
      return sum + jumlah;
    });
  }

  int calculateTotalDigantiPerusahaan(
      List<Map<String, dynamic>> masterDataDetailApprovedRawatInap) {
    return masterDataDetailApprovedRawatInap.fold(0, (sum, item) {
      int jumlah = int.parse(item['jumlah_approve']);
      return sum + jumlah;
    });
  }

  Future<void> getDataDetailRawatInap() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final response = await _fetchDataDetailRawatInap(token, id);
      if (response.statusCode == 200) {
        _handleSuccessResponseDetailRawatJalan(response);
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

  Future<http.Response> _fetchDataDetailRawatInap(String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/rawat/inap/$id/detail");
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
    final dataDetailRawatInapApi = responseData['data'];
    final dataDetailRincianRawatInapApi = responseData['data']['detail'];
    final dataDetailApprovedRawatInapApi =
        responseData['data']['approved_detail'];

    setState(() {
      masterDataDetailRawatInap =
          Map<String, dynamic>.from(dataDetailRawatInapApi);
      masterDataDetailRincianRawatInap =
          List<Map<String, dynamic>>.from(dataDetailRincianRawatInapApi);
      masterDataDetailApprovedRawatInap =
          List<Map<String, dynamic>>.from(dataDetailApprovedRawatInapApi);

      _kelasKamarController.text =
          masterDataDetailRawatInap['kls_kamar_ajukan'].toString();
      _totalPengajuanController.text =
          calculateTotalJumlah(masterDataDetailRincianRawatInap).toString();
      _totalDigantiController.text = masterDataDetailRawatInap['total_diganti'];
      _selisihController.text = masterDataDetailRawatInap['selisih'];
    });
  }

  void _handleErrorResponseDetailRawatJalan(http.Response response) {
    print('Failed to fetch data detail rawat jalan: ${response.statusCode}');
  }

  Future<void> getDataDetailPlafon() async {
    final token = await _getToken();
    if (token == null) return;

    final nrp = x.data['pernr'];

    try {
      final response = await _fetchDataDetailPlafon(token, nrp);

      print(response.body);
      if (response.statusCode == 200) {
        print('success');
        _handleSuccessResponseDetailPlafon(response);
      } else {
        print('gagal');
        _handleErrorResponseDetailPlafon(response);
      }
    } catch (e) {
      print('Error fetching data plafon: $e');
    }
  }

  Future<http.Response> _fetchDataDetailPlafon(String token, String nrp) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/rawat/inap/plafon?nrp=$nrp");
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
    final dataDetailPlafonApi = responseData['data']['manfaat_setahun'];

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

    final requestBody = _createRequestBody(status);
    _setLoadingState(true);

    try {
      final response = await _sendRequest(id, token, requestBody);
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        _handleSuccess(responseData['message']);
      } else {
        _handleFailure();
      }
    } catch (e) {
      print('Error processing request: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  Map<String, dynamic> _createRequestBody(String? status) {
    return {
      'status': status,
      'keterangan': _keteranganController.text,
      'catatan': _catatanController.text,
      'dokumen': selectedValueJenisDokumen,
      'kls_kamar_ajukan': _kelasKamarController.text,
      'selisih': int.parse(_selisihController.text),
      'tgl_payment': tanggalPayment.toString(),
      'total_diganti': _totalDigantiController.text,
      'total_pengajuan': int.parse(_totalPengajuanController.text),
      'approve_detail': approveDetail,
    };
  }

  Future<http.Response> _sendRequest(
      int? id, String token, Map<String, dynamic> body) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse('$_apiUrl/rawat/inap/$id/process');

    return ioClient.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  void _handleSuccess(String message) {
    Get.offAllNamed('/user/main');
    Get.snackbar(
      'Information',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      shouldIconPulse: false,
    );
  }

  void _handleFailure() {
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

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoadingScreen = isLoading;
    });
  }

  Future<void> handleButtonAdd(BuildContext context, int? index) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightShort = 8;
    double padding5 = size.width * 0.0115;
    const double sizedBoxHeightExtraTall = 20;

    setState(() {
      _detailPlafonController.text =
          masterDataDetailRincianRawatInap[index!]['detail_penggantian'];
      var masterDataDetailPlafonFilted = masterDataDetailPlafon
          .where((item) =>
              item['ket'] ==
              masterDataDetailRincianRawatInap[index]['detail_penggantian'])
          .toList();

      _maksimalPlafonController.text =
          masterDataDetailPlafonFilted[0]['nominal'].toString();
    });

    bool isIdExists() {
      return approveDetail.any((element) =>
          element['id_jp_rawat_inap'] ==
          masterDataDetailRincianRawatInap[index!]['id_jp_rawat_inap']);
    }

    void showSnackbar(String title, String message) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false,
      );
    }

    void addApprovedDetail() {
      final detail = masterDataDetailRincianRawatInap[index!];
      final approvedDetail = {
        'id_jp_rawat_inap': detail['id_jp_rawat_inap'],
        'kode_rawat_inap': detail['kode_rawat_inap'],
        'id_md_jp_rawat_inap': detail['id_md_jp_rawat_inap'],
        'detail_penggantian': detail['detail_penggantian'],
        'no_kuitansi': detail['no_kuitansi'],
        'tgl_kuitansi': detail['tgl_kuitansi'],
        'keterangan': detail['keterangan'],
        'lampiran_pembayaran': detail['lampiran_pembayaran'],
        'created_at': detail['created_at'],
        'updated_at': detail['updated_at'],
        'jumlah': detail['jumlah'],
        'status': detail['status'],
        'file_type': detail['file_type'],
        'sap_sync_state': detail['sap_sync_state'],
        'benefit_type': detail['benefit_type'],
        'id_diagnosa': detail['id_diagnosa'],
        'jumlah_rp': detail['jumlah_rp'],
        'jumlah_approve': _plafonDisetujuiController.text,
        'ket': detail['md_rw_inap']['ket'],
        'md_kategori_inap': detail['md_kategori_inap'],
        'md_rw_inap': detail['md_rw_inap'],
        'diagnosa': detail['diagnosa'],
      };

      approveDetail.add(approvedDetail);

      final approvedSummary = {
        'detail_penggantian': detail['detail_penggantian'],
        'md_rw_inap': {
          'kd_rw_inap': detail['md_rw_inap']['kd_rw_inap'],
          'ket': detail['md_rw_inap']['ket'],
        },
        'diagnosa': {
          'nama': detail['diagnosa']['nama'],
        },
        'no_kuitansi': detail['no_kuitansi'],
        'tgl_kuitansi': detail['tgl_kuitansi'],
        'jumlah_approve': _plafonDisetujuiController.text,
      };

      masterDataDetailApprovedRawatInap.add(approvedSummary);
    }

    void updateControllers() {
      _plafonDisetujuiController.clear();
      _totalDigantiController.text =
          calculateTotalDigantiPerusahaan(masterDataDetailApprovedRawatInap)
              .toString();

      final int totalPengajuan = int.parse(_totalPengajuanController.text);
      final int totalDiganti = int.parse(_totalDigantiController.text);
      _selisihController.text = (totalPengajuan - totalDiganti).toString();
    }

    void submitDaftarPengajuan() {
      if (isIdExists()) {
        showSnackbar('Information', 'Data Tersebut Tidak Boleh Lagi!');
        return;
      }

      setState(() {
        addApprovedDetail();
        updateControllers();
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
                      '${masterDataDetailRincianRawatInap[index!]['detail_penggantian']}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'No Kuitansi',
                  textRight:
                      '${masterDataDetailRincianRawatInap[index]['no_kuitansi']}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Nominal Diajukan',
                  textRight:
                      'Rp. ${masterDataDetailRincianRawatInap[index]['jumlah_rp']}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Pasein',
                  textRight: '${masterDataDetailRawatInap['nm_pasien']}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Tanggal Kuitansi',
                  textRight:
                      '${masterDataDetailRincianRawatInap[index]['tgl_kuitansi']}',
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                RowWithSemicolonWidget(
                  textLeft: 'Benefit Type',
                  textRight:
                      '${masterDataDetailRincianRawatInap[index]['benefit_type']}',
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
                TextFormFielDisableWidget(
                  controller: _detailPlafonController,
                  maxHeightConstraints: 40,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TitleWidget(
                  title: 'Maksimal Plafon ',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
                const SizedBox(
                  height: sizedBoxHeightShort,
                ),
                TextFormFielDisableWidget(
                  // validator: validatorAlamatCuti,
                  controller: _maksimalPlafonController,
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
    const double sizedBoxHeightTall = 15;
    const double sizedBoxHeightShort = 8;
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
                'Detail Persetujuan Rawat Inap',
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
                        const TitleWidget(
                          title:
                              'Daftar Pengajuan Jenis Penggantian Biaya Kesehatan Rawat Inap',
                        ),
                        const SizedBox(height: sizedBoxHeightShort),
                        const LineWidget(),
                        const SizedBox(height: sizedBoxHeightTall),
                        _buildPengajuanTable(context),
                        _buildCompensationTable(context),
                        hasilVerivikasiPicHrgsWidget(context),
                      ],
                    ),
                  ),
                  _buildSecondApprovalForm(context),
                  footerWidget(context),
                  const SizedBox(height: sizedBoxHeightExtraTall),
                  _buildApprovalAndRejectButton(context),
                  const SizedBox(height: sizedBoxHeightExtraTall),
                ],
              ),
            ),
          );
  }

  Widget _buildPengajuanTable(BuildContext context) {
    return (x.data['pernr'] == masterDataDetailRawatInap['approved_by2'] &&
            masterDataDetailRawatInap['approved_date2'] == null)
        ? daftarPengajuanTableWithButton(context)
        : daftarPengajuanTable(context);
  }

  Widget _buildCompensationTable(BuildContext context) {
    return (x.data['pernr'] == masterDataDetailRawatInap['approved_by2'] &&
            masterDataDetailRawatInap['approved_date2'] == null)
        ? approvalCompensationTableWithButton(context)
        : approvalCompensationTable(context);
  }

  Widget _buildSecondApprovalForm(BuildContext context) {
    return (x.data['pernr'] == masterDataDetailRawatInap['approved_by2'] &&
            masterDataDetailRawatInap['approved_date2'] == null)
        ? secondApprovalForm(context)
        : const SizedBox(height: 0);
  }

  Widget _buildApprovalAndRejectButton(BuildContext context) {
    bool isPendingApproval =
        (masterDataDetailRawatInap['approved_date1'] == null &&
                x.data['pernr'] == masterDataDetailRawatInap['approved_by1']) ||
            (masterDataDetailRawatInap['approved_date2'] == null &&
                x.data['pernr'] == masterDataDetailRawatInap['approved_by2']) ||
            (masterDataDetailRawatInap['approved_date3'] == null &&
                x.data['pernr'] == masterDataDetailRawatInap['approved_by3']);
    return isPendingApproval
        ? approvalAndRejectButton(context)
        : const SizedBox(height: 0);
  }

  Widget daftarPengajuanTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailRincianRawatInap.isNotEmpty
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
                  rows: masterDataDetailRincianRawatInap
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return TableViewRow(
                      height: 60,
                      cells: daftarPengajuanKey.map((column) {
                        if (column == 'md_rw_inap') {
                          return TableViewCell(
                            child: Text(
                              data['md_rw_inap'] != null
                                  ? '${data['md_rw_inap']['kd_rw_inap']} - ${data['md_rw_inap']['ket']}'
                                  : '-',
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else if (column == 'diagnosa') {
                          return TableViewCell(
                            child: Text(
                              data['diagnosa'] != null
                                  ? '${data['diagnosa']['nama']}'
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

  Widget daftarPengajuanTableWithButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailRincianRawatInap.isNotEmpty
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
                  rows: masterDataDetailRincianRawatInap
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return TableViewRow(
                      height: 60,
                      cells: daftarPengajuanKeyWithButton.map((column) {
                        if (column == 'md_rw_inap') {
                          return TableViewCell(
                            child: Text(
                              data['md_rw_inap'] != null
                                  ? '${data['md_rw_inap']['kd_rw_inap']} - ${data['md_rw_inap']['ket']}'
                                  : '-',
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else if (column == 'diagnosa') {
                          return TableViewCell(
                            child: Text(
                              data['diagnosa'] != null
                                  ? '${data['diagnosa']['nama']}'
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
      child: masterDataDetailApprovedRawatInap.isNotEmpty
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
                      rows: masterDataDetailApprovedRawatInap
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: approvalCompensationKey.map((column) {
                            if (column == 'md_rw_inap') {
                              return TableViewCell(
                                child: Text(
                                  data['md_rw_inap'] != null
                                      ? '${data['md_rw_inap']['kd_rw_inap']} - ${data['md_rw_inap']['ket']}'
                                      : '-',
                                  style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            } else if (column == 'diagnosa') {
                              return TableViewCell(
                                child: Text(
                                  data['diagnosa'] != null
                                      ? '${data['diagnosa']['nama']}'
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
                ),
              ],
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

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailApprovedRawatInap.isNotEmpty
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
                      rows: masterDataDetailApprovedRawatInap
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells:
                              approvalCompensationKeyWithButton.map((column) {
                            if (column == 'md_rw_inap') {
                              return TableViewCell(
                                child: Text(
                                  data['md_rw_inap'] != null
                                      ? '${data['md_rw_inap']['kd_rw_inap']} - ${data['md_rw_inap']['ket']}'
                                      : '-',
                                  style: TextStyle(
                                    color: const Color(primaryBlack),
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            } else if (column == 'diagnosa') {
                              return TableViewCell(
                                child: Text(
                                  data['diagnosa'] != null
                                      ? '${data['diagnosa']['nama']}'
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
                            } else if (column == 'delete') {
                              return TableViewCell(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      masterDataDetailApprovedRawatInap
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

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Kode',
        'value': '${masterDataDetailRawatInap['kode_rawat_inap'] ?? '-'}',
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': '${masterDataDetailRawatInap['tgl_pengajuan'] ?? '-'}',
      },
      {
        'label': 'Nrp',
        'value': '${masterDataDetailRawatInap['pernr'] ?? '-'}',
      },
      {
        'label': 'Nama Karyawan',
        'value': '${masterDataDetailRawatInap['nama'] ?? '-'}',
      },
      {
        'label': 'Perusahaan',
        'value': '${masterDataDetailRawatInap['pt'] ?? '-'}',
      },
      {
        'label': 'Lokasi Kerja',
        'value': '${masterDataDetailRawatInap['lokasi'] ?? '-'}',
      },
      {
        'label': 'Pangkat Karyawan',
        'value': '${masterDataDetailRawatInap['pangkat'] ?? '-'}',
      },
      {
        'label': 'Tanggal Masuk',
        'value': '${masterDataDetailRawatInap['hire_date'] ?? '-'}',
      },
      {
        'label': 'Periode Rawat (Mulai)',
        'value': '${masterDataDetailRawatInap['prd_rawat_mulai'] ?? '-'}',
      },
      {
        'label': 'Periode Rawat (Berakhir)',
        'value': '${masterDataDetailRawatInap['prd_rawat_akhir'] ?? '-'}',
      },
      {
        'label': 'Nama Pasien',
        'value': '${masterDataDetailRawatInap['nm_pasien'] ?? '-'}',
      },
      {
        'label': 'Hubungan Dengan Karyawan',
        'value': '${masterDataDetailRawatInap['hub_karyawan'] ?? '-'}',
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
      ],
    );
  }

  Widget hasilVerivikasiPicHrgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        const TitleWidget(title: 'Hasil Verifikasi PIC HCGS'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Terima',
          textRight: masterDataDetailRawatInap['approved_date2'] ?? '-',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Total Pengajuan',
          textRight:
              'Rp. ${masterDataDetailRawatInap['total_pengajuan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Selisih',
          textRight: 'Rp. ${masterDataDetailRawatInap['selisih'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Catatan',
          textRight: masterDataDetailRawatInap['catatan'] ?? '-',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan Atasan',
          textRight: masterDataDetailRawatInap['keterangan_atasan'] ?? '-',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan PIC HCGS',
          textRight: masterDataDetailRawatInap['keterangan_pic_hcgs'] ?? '-',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan Direksi',
          textRight: masterDataDetailRawatInap['keterangan_direksi'] ?? '-',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Dokumen',
          textRight: masterDataDetailRawatInap['dokumen'] ?? '-',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Total Diganti Perusahaan',
          textRight: 'Rp. ${masterDataDetailRawatInap['total_diganti'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        )
      ],
    );
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: TitleCenterWithLongBadgeWidget(
            textLeft: 'Status Pengajuan',
            textRight: '${masterDataDetailRawatInap['status_approve'] ?? '-'}',
            fontSizeLeft: textMedium,
            fontSizeRight: textMedium,
            color: Colors.yellow,
          ),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: TitleCenterWidget(
            textLeft: 'Pada',
            textRight: ': ${masterDataDetailRawatInap['created_at'] ?? '-'}',
            fontSizeLeft: textMedium,
            fontSizeRight: textMedium,
          ),
        )
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
            showRejectModal(
                context, masterDataDetailRawatInap['id_rawat_inap']);
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
            showApproveModal(
                context, masterDataDetailRawatInap['id_rawat_inap']);
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: DropdownButtonFormField<String>(
                menuMaxHeight: size.height * 0.5,
                value: selectedValueJenisDokumen,
                // validator: _validatorJenisDokumen,
                icon: selectedJenisDokumen.isEmpty
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
              height: sizedBoxHeightTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: Row(
                children: [
                  TitleWidget(
                    title: 'Kelas Kamar Yang Diajukan',
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TextFormFielDisableWidget(
                controller: _kelasKamarController,
                maxHeightConstraints: 40,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: Row(
                children: [
                  TitleWidget(
                    title: 'Total Pengajuan',
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TextFormFielDisableWidget(
                controller: _totalPengajuanController,
                maxHeightConstraints: 40,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: Row(
                children: [
                  TitleWidget(
                    title: 'Total Diganti Perusahaan',
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TextFormFielDisableWidget(
                controller: _totalDigantiController,
                maxHeightConstraints: 40,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: Row(
                children: [
                  TitleWidget(
                    title: 'Selisih',
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TextFormFielDisableWidget(
                controller: _selisihController,
                maxHeightConstraints: 40,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  'Modal Approve',
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
