import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _fetchDataDetailPengajuanTraining(token, id);
      if (response.statusCode == 200) {
        _handleSuccessResponse(response);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<http.Response> _fetchDataDetailPengajuanTraining(
      String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/training/$id/detail");
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
    final dataDetailPengajuanTrainingApi = responseData['data'];

    setState(() {
      masterDataDetailPengajuanTraining =
          Map<String, dynamic>.from(dataDetailPengajuanTrainingApi);
    });
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  Future<void> submit(int? id) async {
    final token = await _getToken();
    if (token == null) return;

    final filePath = _getFilePath();
    if (filePath == null) {
      setState(() {
        _isFileNull = true;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _sendRequest(token, id!, filePath);
      final responseDataMessage = json.decode(response);

      print(responseDataMessage);

      _showSnackbar(responseDataMessage['message']);

      if (responseDataMessage['status'] == 'success') {
        Get.offAllNamed('/user/main');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _getFilePath() {
    if (_files != null) {
      return _files!.single.path;
    }
    return null;
  }

  Future<String> _sendRequest(String token, int id, String filePath) async {
    final ioClient = createIOClientWithInsecureConnection();
    final file = File(filePath);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/training/$id/process'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
      'materi_training',
      file.readAsBytesSync(),
      filename: file.path.split('/').last,
    ));
    request.fields['evaluasi_pasca_training'] = _postTestController.text;

    var streamedResponse = await ioClient.send(request);
    return await streamedResponse.stream.bytesToString();
  }

  void _showSnackbar(String message) {
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
                    if (masterDataDetailPengajuanTraining['approved_at1'] !=
                        null)
                      evaluasiPraTrainingWidget(context),
                    if ((masterDataDetailPengajuanTraining['approved_at3'] !=
                            null) &&
                        (masterDataDetailPengajuanTraining[
                                'evaluasi_pasca_training'] ==
                            null))
                      evaluasiPascaTrainingForm(context),
                    if (masterDataDetailPengajuanTraining[
                            'evaluasi_pasca_training'] !=
                        null)
                      evaluasiPascaTrainingWidget(context),
                    keteranganWidget(context),
                    footerWidget(context),
                    if ((masterDataDetailPengajuanTraining['approved_at3'] !=
                            null) &&
                        (masterDataDetailPengajuanTraining[
                                'evaluasi_pasca_training'] ==
                            null))
                      submitButton(context),
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

    List<Map<String, dynamic>> data = [
      {
        'label': 'Prioritas',
        'value': '${masterDataDetailPengajuanTraining['prioritas'] ?? '-'}',
      },
      {
        'label': 'Nomor Dokumen',
        'value': '${masterDataDetailPengajuanTraining['no_doc'] ?? '-'}',
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': '${masterDataDetailPengajuanTraining['tgl_sharing'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Nrp',
        'value': '${masterDataDetailPengajuanTraining['nrp'] ?? '-'}',
      },
      {
        'label': 'Nama',
        'value': '${masterDataDetailPengajuanTraining['nama'] ?? '-'}',
      },
      {
        'label': 'Jabatan',
        'value':
            '${masterDataDetailPengajuanTraining['jabatan']?['nm_jabatan'] ?? '-'}',
      },
      {
        'label': 'Divisi/Departemen',
        'value': '${masterDataDetailPengajuanTraining['divisi'] ?? '-'}',
      },
      {
        'label': 'Entitas',
        'value':
            '${masterDataDetailPengajuanTraining['entitas']?['nama'] ?? '-'}',
      },
      {
        'label': 'Tanggal Mulai Kerja',
        'value': '${masterDataDetailPengajuanTraining['hire_date'] ?? '-'}',
      },
      {
        'label': 'Total Mengikuti Training',
        'value': '${masterDataDetailPengajuanTraining['total_training']} Kali',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
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
        SizedBox(height: sizedBoxHeightTall),
      ],
    );
  }

  Widget informasiKegiatanTrainingWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Tanggal Training',
        'value': '${masterDataDetailPengajuanTraining['tgl_training'] ?? '-'}',
      },
      {
        'label': 'Institusi Training',
        'value':
            '${masterDataDetailPengajuanTraining['institusi_training'] ?? '-'}',
        'visible': masterDataDetailPengajuanTraining['approved_at1'] != null,
      },
      {
        'label': 'Biaya Training',
        'value':
            '${masterDataDetailPengajuanTraining['biaya_training'] ?? '-'}',
      },
      {
        'label': 'Lokasi Training',
        'value':
            '${masterDataDetailPengajuanTraining['lokasi_training'] ?? '-'}',
      },
      {
        'label': 'Ikatan Dinas',
        'value':
            '${masterDataDetailPengajuanTraining['periode_ikatan_dinas'] ?? '-'} ${masterDataDetailPengajuanTraining['satuan_ikatan_dinas'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Informasi Kegiatan Training'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
        ...data.where((item) => item['visible'] ?? true).map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
        SizedBox(height: sizedBoxHeightTall),
      ],
    );
  }

  Widget evaluasiPraTrainingWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, String>> data = [
      {
        'label': 'Fungsi Training',
        'value':
            '${masterDataDetailPengajuanTraining['fungsi_training'] ?? '-'}',
      },
      {
        'label': 'Tujuan Objektif',
        'value':
            '${masterDataDetailPengajuanTraining['tujuan_objektif'] ?? '-'}',
      },
      {
        'label': 'Penugasan Karyawan',
        'value':
            '${masterDataDetailPengajuanTraining['penugasan_karyawan'] ?? '-'}',
      },
      {
        'label': 'Tanggal sharing Knowledge',
        'value': '${masterDataDetailPengajuanTraining['tgl_sharing'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Evaluasi Pra Training'),
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

  Widget keteranganWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, String>> data = [
      {
        'label': 'Keterangan Atasan',
        'value':
            '${masterDataDetailPengajuanTraining['keterangan_atasan'] ?? '-'}',
      },
      {
        'label': 'Keterangan HCGS',
        'value':
            '${masterDataDetailPengajuanTraining['keterangan_hcgs'] ?? '-'}',
      },
      {
        'label': 'Keterangan Direksi',
        'value':
            '${masterDataDetailPengajuanTraining['keterangan_direktur'] ?? '-'}',
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
              '${masterDataDetailPengajuanTraining['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailPengajuanTraining['created_at'] != null ? formatDate(masterDataDetailPengajuanTraining['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
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
