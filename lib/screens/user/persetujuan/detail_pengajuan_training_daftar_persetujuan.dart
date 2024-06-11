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
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DataUserPengajuanTrainingController extends GetxController {
  var data = {}.obs;
}

class DetailPengajuanTrainingDaftarPersetujuan extends StatefulWidget {
  const DetailPengajuanTrainingDaftarPersetujuan({super.key});

  @override
  State<DetailPengajuanTrainingDaftarPersetujuan> createState() =>
      _DetailPengajuanTrainingDaftarPersetujuanState();
}

class _DetailPengajuanTrainingDaftarPersetujuanState
    extends State<DetailPengajuanTrainingDaftarPersetujuan> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> masterDataDetailPengajuanTraining = {};
  final _lainyaController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _institusiTrainingController = TextEditingController();
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoading = false;
  final DateRangePickerController _tanggalSharingController =
      DateRangePickerController();
  DateTime? tanggalSharing;

  DataUserPengajuanTrainingController x =
      Get.put(DataUserPengajuanTrainingController());

  List<Map<String, dynamic>> selectedFungsiTraining = [
    {'jenis': 'Sangat Direkomendasikan'},
    {'jenis': 'Disarankan'},
    {'jenis': 'Sebagai Pelengkap'},
  ];

  List<Map<String, dynamic>> selectedTujuanObjektif = [
    {'jenis': 'Pengembangan Untuk Kebutuhan Jabatan'},
    {'jenis': 'Pengembangan Karir'},
    {'jenis': 'Rencana Penugasan/Project'},
  ];

  List<Map<String, dynamic>> selectedPenugasanKaryawan = [
    {'jenis': 'Presentasi Isi Training'},
    {'jenis': 'Penugasan Kerja'},
    {'jenis': 'Lain-lain'},
  ];

  String? selectedValueFungsiTraining,
      selectedValueTujuanObjektif,
      selectedValuePenugasanKaryawan;

  @override
  void initState() {
    super.initState();
    getData();
    getDataDetailPengajuanTraining();
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

  Future<void> getDataDetailPengajuanTraining() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.get(
            Uri.parse("$_apiUrl/training/$id/detail"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailPengajuanTrainingApi = responseData['data'];
        print(dataDetailPengajuanTrainingApi);

        setState(() {
          masterDataDetailPengajuanTraining =
              Map<String, dynamic>.from(dataDetailPengajuanTrainingApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> rejectAndApprove(int? id, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    String keterangan =
        _keteranganController.text == '' ? '-' : _keteranganController.text;
    String lainnya =
        _lainyaController.text == '' ? '-' : _lainyaController.text;
    String institusiTraining = _institusiTrainingController.text == ''
        ? '-'
        : _institusiTrainingController.text;

    setState(() {
      _isLoading = true;
    });

    final ioClient = createIOClientWithInsecureConnection();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/training/$id/process'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['status'] = status;
    request.fields['institusi_training'] = institusiTraining;
    request.fields['keterangan'] = keterangan;
    request.fields['fungsi_training'] = selectedValueFungsiTraining.toString();
    request.fields['tujuan_objektif'] = selectedValueTujuanObjektif.toString();
    request.fields['penugasan_karyawan'] =
        selectedValuePenugasanKaryawan.toString();
    request.fields['penugasan_lainnya'] = lainnya;
    request.fields['tgl_sharing'] = tanggalSharing.toString();

    var streamedResponse = await ioClient.send(request);
    final responseData = await streamedResponse.stream.bytesToString();
    final responseDataMessage = json.decode(responseData);
    Get.snackbar('Infomation', responseDataMessage['message'],
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

    print('Message $responseDataMessage');

    if (responseDataMessage['status'] == 'success') {
      Get.offAllNamed('/user/main');
      Get.snackbar('Infomation', responseDataMessage['message'],
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;

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
                'Online Form - Form Aplikasi Trainingg',
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
                    informasiKegiatanTrainingWidget(context),
                    (masterDataDetailPengajuanTraining['approved_at1'] != null)
                        ? evaluasiPraTrainingWidget(context)
                        : const SizedBox(
                            height: 0,
                          ),
                    (masterDataDetailPengajuanTraining['approved_at1'] ==
                                null &&
                            x.data['pernr'] ==
                                masterDataDetailPengajuanTraining[
                                    'approved_by1'])
                        ? evaluasiPraTrainingForm(context)
                        : const SizedBox(
                            height: 0,
                          ),
                    keteranganWidget(context),
                    footerWidget(context),
                    (masterDataDetailPengajuanTraining['approved_at1'] ==
                                    null &&
                                x.data['pernr'] ==
                                    masterDataDetailPengajuanTraining[
                                        'approved_by1']) ||
                            (masterDataDetailPengajuanTraining[
                                        'approved_at2'] ==
                                    null &&
                                x.data['pernr'] ==
                                    masterDataDetailPengajuanTraining[
                                        'approved_by2']) ||
                            (masterDataDetailPengajuanTraining[
                                        'approved_at3'] ==
                                    null &&
                                x.data['pernr'] ==
                                    masterDataDetailPengajuanTraining[
                                        'approved_by3'])
                        ? approvalAndRejectButton(context)
                        : const SizedBox(
                            height: 0,
                          )
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
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowWithSemicolonWidget(
          textLeft: 'Prioritas',
          textRight: '${masterDataDetailPengajuanTraining['prioritas'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nomor Dokumen',
          textRight: '${masterDataDetailPengajuanTraining['no_doc'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Pengajuan',
          textRight:
              '${masterDataDetailPengajuanTraining['tgl_sharing'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
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
          textRight: '${masterDataDetailPengajuanTraining['nrp'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataDetailPengajuanTraining['nama'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jabatan',
          textRight:
              '${masterDataDetailPengajuanTraining['jabatan']?['nm_jabatan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Divisi/Departemen',
          textRight: '${masterDataDetailPengajuanTraining['divisi'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas',
          textRight:
              '${masterDataDetailPengajuanTraining['entitas']?['nama'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Mulai Kerja',
          textRight: '${masterDataDetailPengajuanTraining['hire_date'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Total Mengikuti Training',
          textRight:
              '${masterDataDetailPengajuanTraining['total_training']} Kali',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
      ],
    );
  }

  Widget informasiKegiatanTrainingWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Informasi Kegiatan Training'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Training',
          textRight:
              '${masterDataDetailPengajuanTraining['tgl_training'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        (masterDataDetailPengajuanTraining['approved_at1'] != null) &&
                (masterDataDetailPengajuanTraining['approved_at1'] != null)
            ? Column(
                children: [
                  RowWithSemicolonWidget(
                    textLeft: 'Institusi Training',
                    textRight:
                        '${masterDataDetailPengajuanTraining['institusi_training'] ?? '-'}',
                    fontSizeLeft: textMedium,
                    fontSizeRight: textMedium,
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        (masterDataDetailPengajuanTraining['approved_at1'] != null) &&
                (masterDataDetailPengajuanTraining['approved_at2'] == null) &&
                (masterDataDetailPengajuanTraining['approved_at3'] == null)
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.4,
                        child: TitleWidget(
                          title: 'Institusi Training',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.48,
                        child: TextFormFieldWidget(
                          controller: _institusiTrainingController,
                          maxHeightConstraints: 40,
                          hintText: 'Isi Institusi',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizedBoxHeightShort,
                  ),
                ],
              )
            : const SizedBox(
                height: 0,
              ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Biaya Training',
          textRight:
              '${masterDataDetailPengajuanTraining['biaya_training'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Lokasi Training',
          textRight:
              '${masterDataDetailPengajuanTraining['lokasi_training'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        // RowWithSemicolonWidget(
        //   textLeft: 'Lampiran',
        //   textRight: '${masterDataDetailPengajuanTraining['lampiran'] ?? '-'}',
        //   fontSizeLeft: textMedium,
        //   fontSizeRight: textMedium,
        // ),
        // SizedBox(
        //   height: sizedBoxHeightShort,
        // ),
        RowWithSemicolonWidget(
          textLeft: 'Ikatan Dinas',
          textRight:
              '${masterDataDetailPengajuanTraining['periode_ikatan_dinas'] ?? '-'} ${masterDataDetailPengajuanTraining['satuan_ikatan_dinas'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
      ],
    );
  }

  Widget keteranganWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Keterangan'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan Atasan',
          textRight:
              '${masterDataDetailPengajuanTraining['keterangan_atasan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan HCGS',
          textRight:
              '${masterDataDetailPengajuanTraining['keterangan_hcgs'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan Direksi',
          textRight:
              '${masterDataDetailPengajuanTraining['keterangan_direktur'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget evaluasiPraTrainingForm(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double padding5 = size.width * 0.0115;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(title: 'Evaluasi Pra Training'),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          const LineWidget(),
          SizedBox(
            height: sizedBoxHeightTall,
          ),
          Row(
            children: [
              TitleWidget(
                title: 'Fungsi Training',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              Text(
                ' *',
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
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValueFungsiTraining,
            // validator: _validatorJenisDokumen,
            icon: selectedFungsiTraining.isEmpty
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
                selectedValueFungsiTraining = newValue ?? '';
              });
            },
            items: selectedFungsiTraining.map((Map<String, dynamic> value) {
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
                  color: selectedValueFungsiTraining != null
                      ? Colors.black54
                      : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: sizedBoxHeightTall,
          ),
          Row(
            children: [
              TitleWidget(
                title: 'Tujuan Objektif',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              Text(
                ' *',
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
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValueTujuanObjektif,
            // validator: _validatorJenisDokumen,
            icon: selectedTujuanObjektif.isEmpty
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
                selectedValueTujuanObjektif = newValue ?? '';
              });
            },
            items: selectedTujuanObjektif.map((Map<String, dynamic> value) {
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
                  color: selectedValueTujuanObjektif != null
                      ? Colors.black54
                      : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: sizedBoxHeightTall,
          ),
          Row(
            children: [
              TitleWidget(
                title: 'Penugasan Karyawan',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              Text(
                ' *',
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
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValuePenugasanKaryawan,
            // validator: _validatorJenisDokumen,
            icon: selectedPenugasanKaryawan.isEmpty
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
                selectedValuePenugasanKaryawan = newValue ?? '';
              });
            },
            items: selectedPenugasanKaryawan.map((Map<String, dynamic> value) {
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
                  color: selectedValuePenugasanKaryawan != null
                      ? Colors.black54
                      : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: sizedBoxHeightTall,
          ),
          (selectedValuePenugasanKaryawan == 'Presentasi Isi Training')
              ? Column(
                  children: [
                    Row(
                      children: [
                        TitleWidget(
                          title: 'Tanggal Sharing Knowledge',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                        Text(
                          ' *',
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
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    CupertinoButton(
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding5),
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
                              tanggalSharing != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      _tanggalSharingController.selectedDate ??
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
                                  controller: _tanggalSharingController,
                                  onSelectionChanged:
                                      (DateRangePickerSelectionChangedArgs
                                          args) {
                                    setState(() {
                                      tanggalSharing = args.value;
                                    });
                                  },
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
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
                  ],
                )
              : const SizedBox(
                  height: 0,
                ),
          (selectedValuePenugasanKaryawan == 'Lain-lain')
              ? Column(
                  children: [
                    Row(
                      children: [
                        TitleWidget(
                          title: 'Lainnya',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                        Text(
                          ' *',
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
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    TextFormFieldWidget(
                      controller: _lainyaController,
                      maxHeightConstraints: 40,
                      hintText: 'Isi Lainnya',
                    ),
                  ],
                )
              : const SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: sizedBoxHeightTall,
          ),
        ],
      ),
    );
  }

  Widget evaluasiPraTrainingWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Evaluasi Pra Training'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Fungsi Training',
          textRight:
              '${masterDataDetailPengajuanTraining['fungsi_training'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tujuan Objektif',
          textRight:
              '${masterDataDetailPengajuanTraining['tujuan_objektif'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Penugasan Karyawan',
          textRight:
              '${masterDataDetailPengajuanTraining['penugasan_karyawan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Lainnya',
          textRight:
              '${masterDataDetailPengajuanTraining['penugasan_lainnya'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal sharing Knowledge',
          textRight:
              '${masterDataDetailPengajuanTraining['tgl_sharing'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
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
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight:
              '${masterDataDetailPengajuanTraining['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailPengajuanTraining['created_at'] != null ? formatDate(masterDataDetailPengajuanTraining['created_at']) : ''}',
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
        InkWell(
          onTap: () {
            showRejectModal(context, masterDataDetailPengajuanTraining['id']);
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
            showApproveModal(context, masterDataDetailPengajuanTraining['id']);
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
