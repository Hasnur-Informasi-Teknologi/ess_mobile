import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

class DetailPengajuanTrainingDaftarPermintaan extends StatefulWidget {
  const DetailPengajuanTrainingDaftarPermintaan({super.key});

  @override
  State<DetailPengajuanTrainingDaftarPermintaan> createState() =>
      _DetailPengajuanTrainingDaftarPermintaanState();
}

class _DetailPengajuanTrainingDaftarPermintaanState
    extends State<DetailPengajuanTrainingDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailPengajuanTraining = {};
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoading = false;
  final _postTestController = TextEditingController();
  bool _isFileNull = false;
  List<PlatformFile>? _files;

  @override
  void initState() {
    super.initState();
    getDataDetailPengajuanTraining();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _files = result.files;
        _isFileNull = false;
      });
    }
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
        final response = await http.get(
            Uri.parse("$_apiUrl/training/$id/detail"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailPengajuanTrainingApi = responseData['data'];

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

  Future<void> submit(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    String? filePath;

    setState(() {
      _isLoading = true;
    });

    if (_files != null) {
      filePath = _files!.single.path;
      setState(() {
        _isFileNull = false;
      });
    } else {
      setState(() {
        _isFileNull = true;
        _isLoading = false;
      });
      return;
    }

    File file = File(filePath!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/training/${id}/process'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
        'materi_training', file.readAsBytesSync(),
        filename: file.path.split('/').last));
    request.fields['evaluasi_pasca_training'] = _postTestController.text;

    var response = await request.send();
    final responseData = await response.stream.bytesToString();
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
                'Online Form - Form Aplikasi Training',
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
                    (masterDataDetailPengajuanTraining['approved_at3'] !=
                                null) &&
                            (masterDataDetailPengajuanTraining[
                                    'evaluasi_pasca_training'] ==
                                null)
                        ? evaluasiPascaTrainingForm(context)
                        : const SizedBox(
                            height: 0,
                          ),
                    (masterDataDetailPengajuanTraining[
                                'evaluasi_pasca_training'] !=
                            null)
                        ? evaluasiPascaTrainingWidget(context)
                        : const SizedBox(
                            height: 0,
                          ),
                    keteranganWidget(context),
                    footerWidget(context),
                    (masterDataDetailPengajuanTraining['approved_at3'] !=
                                null) &&
                            (masterDataDetailPengajuanTraining[
                                    'evaluasi_pasca_training'] ==
                                null)
                        ? submitButton(context)
                        : const SizedBox(
                            height: 0,
                          ),
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
        (masterDataDetailPengajuanTraining['approved_at1'] != null)
            ? RowWithSemicolonWidget(
                textLeft: 'Institusi Training',
                textRight:
                    '${masterDataDetailPengajuanTraining['institusi_training'] ?? '-'}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
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

  Widget evaluasiPascaTrainingForm(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double padding5 = size.width * 0.0115;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Evaluasi Pasca Training'),
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
              title: 'Post Test',
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
          controller: _postTestController,
          maxHeightConstraints: 100,
          hintText: '-',
        ),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        Row(
          children: [
            TitleWidget(
              title: 'Softfile Materi Training',
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
          height: sizedBoxHeightTall,
        ),
        Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: pickFiles,
                child: Text('Pilih File'),
              ),
            ),
            if (_files != null)
              Column(
                children: _files!.map((file) {
                  return ListTile(
                    title: Text(file.name),
                    // subtitle: Text('${file.size} bytes'),
                  );
                }).toList(),
              ),
          ],
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        _isFileNull
            ? Center(
                child: Text(
                'File Kosong',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: textMedium),
              ))
            : const Text(''),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget evaluasiPascaTrainingWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Evaluasi Pasca Training'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Post Test',
          textRight:
              '${masterDataDetailPengajuanTraining['evaluasi_pasca_training'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        // SizedBox(
        //   height: sizedBoxHeightShort,
        // ),
        // RowWithSemicolonWidget(
        //   textLeft: 'Softfile Materi Training',
        //   textRight: '-',
        //   fontSizeLeft: textMedium,
        //   fontSizeRight: textMedium,
        // ),
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

  Widget submitButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0115;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: () {
              showSubmitModal(context, masterDataDetailPengajuanTraining['id']);
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
                      'Submit',
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
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  void showSubmitModal(BuildContext context, int? id) {
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
                  'Konfirmasi Submit',
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
                  'Apakah Anda yakin ingin mensubmit data ini?',
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
            Center(
              child: Row(
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
                      submit(id);
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
            ),
          ],
        );
      },
    );
  }
}
