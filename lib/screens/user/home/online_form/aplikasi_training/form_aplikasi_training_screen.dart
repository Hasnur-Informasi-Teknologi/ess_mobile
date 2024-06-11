import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormAplikasiTrainingScreen extends StatefulWidget {
  const FormAplikasiTrainingScreen({super.key});

  @override
  State<FormAplikasiTrainingScreen> createState() =>
      _FormAplikasiTrainingScreenState();
}

class _FormAplikasiTrainingScreenState
    extends State<FormAplikasiTrainingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool? _isTinggiChecked = false;
  bool? _isNormalChecked = false;
  bool? _isRendahChecked = false;

  late TextEditingController _tglPengajuanController;
  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  String? _jabatanKd;
  final _divisiController = TextEditingController();
  final _entitasController = TextEditingController();
  final _tglMulaiBekerjaController = TextEditingController();
  final _totalTrainingController = TextEditingController();

  List<Map<String, dynamic>> selectedEntitasAtasan = [];
  String? selectedValueEntitasAtasan;
  List<Map<String, dynamic>> selectedAtasan = [];
  String? selectedValueAtasan;

  List<Map<String, dynamic>> selectedEntitasHCGS = [];
  String? selectedValueEntitasHCGS;
  List<Map<String, dynamic>> selectedHCGS = [];
  String? selectedValueHCGS;

  List<Map<String, dynamic>> selectedEntitasDirektur = [];
  String? selectedValueEntitasDirektur;
  List<Map<String, dynamic>> selectedDirektur = [];
  String? selectedValueDirektur;

  final DateRangePickerController _tglTrainingController =
      DateRangePickerController();
  DateTime? tglTraining;
  final TextEditingController _judulTrainingController =
      TextEditingController();
  final TextEditingController _institusiTrainingController =
      TextEditingController();
  final TextEditingController _biayaTrainingController =
      TextEditingController();
  final TextEditingController _lokasiTrainingController =
      TextEditingController();
  PlatformFile? _files;
  List<Map<String, dynamic>> selectedJenisTraining = [];
  String? selectedValueJenisTraining;
  final TextEditingController _ikatanDinasController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingEntitas = false;
  bool _isLoadingAtasan = false;
  bool _isLoadingHCGS = false;
  bool _isLoadingDirektur = false;
  bool _isFileNull = false;
  Map<String, String?> validationMessages = {};

  double _sizeKbs = 0;
  final int maxSizeKbs = 1024;
  int current = 0;

  final String apiUrl = API_URL;

  @override
  void initState() {
    super.initState();
    initializeData();
    getDataPengajuan();
    getDataJenisTraining();
    _ikatanDinasController.text = '1';
    String formattedDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _tglPengajuanController = TextEditingController(text: formattedDateTime);
  }

  void initializeData() async {
    await getDataUser();
    await getDataEntitas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getDataPengajuan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse("$apiUrl/master/profile/get_all_pengajuan"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          _totalTrainingController.text = data['training'].toString();
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http
            .get(Uri.parse("$apiUrl/user-detail"), headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
        final responseData = jsonDecode(response.body);
        Map<String, dynamic> employeeData = responseData['employee'];
        setState(() {
          _nrpController.text = employeeData['pernr'];
          _namaController.text = employeeData['nama'];
          _jabatanController.text = employeeData['pangkat'];
          _jabatanKd = employeeData['kd_pangkat'];
          _divisiController.text = employeeData['organizational_unit'];
          _entitasController.text = employeeData['pt'];
          _tglMulaiBekerjaController.text = employeeData['hire_date'];
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> getDataEntitas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingEntitas = true;
      });

      try {
        final response = await http
            .get(Uri.parse("$apiUrl/master/entitas"), headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'] as List<dynamic>;

        Map<String, dynamic>? matchingEntitas = data.firstWhere(
            (value) => value['nama'] == _entitasController.text,
            orElse: () => null);

        if (matchingEntitas != null) {
          selectedEntitasHCGS = [matchingEntitas];
        } else {
          selectedEntitasHCGS = [];
        }

        setState(() {
          selectedEntitasAtasan = List<Map<String, dynamic>>.from(
            data,
          );
          selectedEntitasDirektur = List<Map<String, dynamic>>.from(
            data,
          );
          _isLoadingEntitas = false;
        });
      } catch (e) {
        setState(() {
          _isLoadingEntitas = false;
        });
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> getDataAtasan(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingAtasan = true;
      });

      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse(
                "$apiUrl/karyawan/dept-head?atasan=05&entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          selectedAtasan = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueAtasan = null;
          _isLoadingAtasan = false;
        });
      } catch (e) {
        setState(() {
          _isLoadingAtasan = false;
        });
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> getDataHCGS(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingHCGS = true;
      });

      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse("$apiUrl/master/hrgs/pic?entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          selectedHCGS = List<Map<String, dynamic>>.from(
            data,
          );
          _isLoadingHCGS = false;
        });
      } catch (e) {
        setState(() {
          _isLoadingHCGS = false;
        });
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> getDataDirektur(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingDirektur = true;
      });

      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse(
                "$apiUrl/karyawan/dept-head?atasan=11&entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          selectedDirektur = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueDirektur = null;
          _isLoadingDirektur = false;
        });
      } catch (e) {
        setState(() {
          _isLoadingDirektur = false;
        });
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> getDataJenisTraining() async {
    String jsonString = '''
    {
      "data": [
        {
          "id": "0",
          "kode": "training",
          "nama": "Training"
        },
        {
          "id": "1",
          "kode": "sertifikasi",
          "nama": "Sertifikasi"
        },
        {
          "id": "2",
          "kode": "training dan sertifikasi",
          "nama": "Training dan Sertifikasi"
        }
      ]
    }
    ''';

    try {
      final responseData = jsonDecode(jsonString);
      final dataJenisTraining = responseData['data'];
      setState(() {
        selectedJenisTraining =
            List<Map<String, dynamic>>.from(dataJenisTraining);
      });
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withReadStream: true,
    );

    if (result != null) {
      final size = result.files.first.size;
      _sizeKbs = size / 1024;
      if (_sizeKbs > maxSizeKbs) {
        _isFileNull = true;
        Get.snackbar(
          'File Tidak Valid',
          'Ukuran file melebihi batas maksimum yang diizinkan sebesar 5 MB.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      } else {
        setState(() {
          _files = result.files.single;
          _isFileNull = false;
        });
        Get.snackbar(
          'Success',
          'File berhasil diproses.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_files == null) {
      Get.snackbar(
        'Infomation',
        'File Wajib Diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/training/create'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'approved_by1': selectedValueAtasan.toString(),
      'approved_by2': selectedValueHCGS.toString(),
      'approved_by3': selectedValueDirektur.toString(),
      'biaya_training': _biayaTrainingController.text,
      'cocd': _entitasController.text,
      'divisi': _divisiController.text,
      'entitas_atasan': selectedValueEntitasAtasan.toString(),
      'entitas_direktur': selectedValueEntitasDirektur.toString(),
      'entitas_hcgs': selectedValueEntitasHCGS.toString(),
      'hire_date': _tglMulaiBekerjaController.text,
      'institusi_training': _institusiTrainingController.text,
      'jabatan': _jabatanKd.toString(),
      'jenis_training': selectedValueJenisTraining.toString(),
      'judul_training': _judulTrainingController.text,
      'lokasi_training': _lokasiTrainingController.text,
      'nama': _namaController.text,
      'nrp': _nrpController.text,
      'pangkat': _jabatanController.text,
      'periode_ikatan_dinas': _ikatanDinasController.text,
      'prioritas': _isTinggiChecked == true
          ? 'Tinggi'
          : _isNormalChecked == true
              ? 'Normal'
              : 'Rendah',
      'satuan_ikatan_dinas': 'Tahun',
      'status_pengajuan': 'submit',
      'tgl_training': tglTraining != null
          ? tglTraining.toString()
          : DateTime.now().toString(),
      'total_training': _totalTrainingController.text,
    });

    File file = File(_files!.path!);
    request.files.add(http.MultipartFile(
        'lampiran', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path.split('/').last));

    debugPrint('Request: ${request.fields}');
    debugPrint('Request: ${request.files}');

    try {
      final ioClient = createIOClientWithInsecureConnection();
      var streamedResponse = await ioClient.send(request);
      final responseData = await streamedResponse.stream.bytesToString();
      final responseDataMessage = json.decode(responseData);

      debugPrint('Response: $responseDataMessage');

      if (streamedResponse.statusCode == 200) {
        Get.snackbar('Information', responseDataMessage['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        Navigator.pop(context);
      } else {
        Get.snackbar(
          responseDataMessage['message'],
          responseDataMessage['error'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    String? validateField(String? value, String fieldName) {
      if (value == null || value.isEmpty) {
        return validationMessages[fieldName] = 'Field $fieldName wajib diisi!';
      }
      return null;
    }

    Widget validateContainer(String? field) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 5),
        child: Text(
          validationMessages[field]!,
          style: TextStyle(color: Colors.red.shade900, fontSize: 12),
        ),
      );
    }

    Widget dropdownlistEntitasAtasan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(title: 'Entitas Atasan', isRequired: true),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult =
                    validateField(value, 'Entitas Atasan');
                setState(() {
                  validationMessages['Entitas Atasan'] = validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Entitas Atasan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingEntitas
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueEntitasAtasan,
              items: selectedEntitasAtasan.isNotEmpty
                  ? selectedEntitasAtasan.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["kode"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueEntitasAtasan = newValue!;
                  debugPrint(
                      'selectedValueEntitasAtasan $selectedValueEntitasAtasan');
                  validationMessages['Entitas Atasan'] = null;
                  getDataAtasan(selectedValueEntitasAtasan!);
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueEntitasAtasan != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['Entitas Atasan'] != null)
            validateContainer('Entitas Atasan'),
        ],
      );
    }

    Widget dropdownlistAtasan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(
              title: 'Nama Atasan',
              isRequired: true,
              requireMessage: 'minimal setara dept head'),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult = validateField(value, 'Atasan');
                setState(() {
                  validationMessages['Atasan'] = validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Atasan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingAtasan
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueAtasan,
              items: selectedAtasan.isNotEmpty
                  ? selectedAtasan.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["pernr"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["pernr"] + ' - ' + value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueAtasan = newValue!;
                  debugPrint('selectedValueAtasan $selectedValueAtasan');
                  validationMessages['Atasan'] = null;
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueAtasan != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['Atasan'] != null) validateContainer('Atasan'),
        ],
      );
    }

    Widget dropdownlistEntitasHCGS() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(title: 'Entitas HCGS', isRequired: true),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult = validateField(value, 'Entitas HCGS');
                setState(() {
                  validationMessages['Entitas HCGS'] = validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Entitas HCGS',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingEntitas
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueEntitasHCGS,
              items: selectedEntitasHCGS.isNotEmpty
                  ? selectedEntitasHCGS.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["kode"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueEntitasHCGS = newValue!;
                  debugPrint(
                      'selectedValueEntitasHCGS $selectedValueEntitasHCGS');
                  validationMessages['Entitas HCGS'] = null;
                  getDataHCGS(selectedValueEntitasHCGS!);
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueEntitasHCGS != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['Entitas HCGS'] != null)
            validateContainer('Entitas HCGS'),
        ],
      );
    }

    Widget dropdownlistHCGS() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(title: 'Nama HCGS', isRequired: true),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult = validateField(value, 'HCGS');
                setState(() {
                  validationMessages['HCGS'] = validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih HCGS',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingHCGS
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueHCGS,
              items: selectedHCGS.isNotEmpty
                  ? selectedHCGS.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["pernr"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["pernr"] + ' - ' + value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueHCGS = newValue!;
                  validationMessages['HCGS'] = null;
                  debugPrint('selectedValueHCGS $selectedValueHCGS');
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueHCGS != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['HCGS'] != null) validateContainer('HCGS'),
        ],
      );
    }

    Widget dropdownlistEntitasDirektur() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(
              title: 'Entitas Direktur Keuangan', isRequired: true),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult =
                    validateField(value, 'Entitas Direktur Keuangan');
                setState(() {
                  validationMessages['Entitas Direktur Keuangan'] =
                      validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Entitas Direktur Keuangan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingEntitas
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueEntitasDirektur,
              items: selectedEntitasDirektur.isNotEmpty
                  ? selectedEntitasDirektur.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["kode"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["kode"] + ' - ' + value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueEntitasDirektur = newValue!;
                  debugPrint(
                      'selectedValueEntitasDirektur $selectedValueEntitasDirektur');
                  validationMessages['Entitas Direktur Keuangan'] = null;
                  getDataDirektur(selectedValueEntitasDirektur!);
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueEntitasDirektur != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['Entitas Direktur Keuangan'] != null)
            validateContainer('Entitas Direktur Keuangan'),
        ],
      );
    }

    Widget dropdownlistDirektur() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(title: 'Nama Direktur Keuangan', isRequired: true),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult =
                    validateField(value, 'Direktur Keuangan');
                setState(() {
                  validationMessages['Direktur Keuangan'] = validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Direktur Keuangan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingDirektur
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueDirektur,
              items: selectedDirektur.isNotEmpty
                  ? selectedDirektur.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["pernr"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["pernr"] + ' - ' + value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueDirektur = newValue!;
                  validationMessages['Direktur Keuangan'] = null;
                  debugPrint('selectedValueDirektur $selectedValueDirektur');
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueDirektur != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['Direktur Keuangan'] != null)
            validateContainer('Direktur Keuangan'),
        ],
      );
    }

    Widget dropdownlistJenisTraining() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabelRequired(title: 'Jenis Training', isRequired: true),
          SizedBox(
            height: sizedBoxHeightShort,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              validator: (value) {
                String? validationResult =
                    validateField(value, 'Jenis Training');
                setState(() {
                  validationMessages['Jenis Training'] = validationResult;
                });
                return null;
              },
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Jenis Training',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingEntitas
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueJenisTraining,
              items: selectedJenisTraining.isNotEmpty
                  ? selectedJenisTraining.map((value) {
                      return DropdownMenuItem<String>(
                        value: value["kode"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value["nama"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: "no-data",
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueJenisTraining = newValue!;
                  debugPrint(
                      'selectedValueJenisTraining $selectedValueJenisTraining');
                  validationMessages['Jenis Training'] = null;
                  getDataAtasan(selectedValueJenisTraining!);
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 12),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValueJenisTraining != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (validationMessages['Jenis Training'] != null)
            validateContainer('Jenis Training'),
        ],
      );
    }

    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : DefaultTabController(
            length: 2,
            child: Scaffold(
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
                  'Form Aplikasi Training',
                  style: TextStyle(
                      color: const Color(primaryBlack),
                      fontSize: textLarge,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500),
                ),
              ),
              body: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: buildLabelRequired(
                              title: 'Prioritas', isRequired: true),
                        ),
                        SizedBox(
                          height: sizedBoxHeightShort,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCheckbox('Tinggi', _isTinggiChecked),
                            buildCheckbox('Normal', _isNormalChecked),
                            buildCheckbox('Rendah', _isRendahChecked),
                          ],
                        ),
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: buildTextFormFieldField(
                              title: 'Tanggal Pengajuan',
                              controller: _tglPengajuanController,
                            )),
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow,
                                vertical: padding5),
                            width: double.infinity,
                            height: 550,
                            child: Column(
                              children: [
                                TabBar(
                                  isScrollable: true,
                                  // indicatorSize: TabBarIndicatorSize.label,
                                  // indicatorColor: Colors.black,
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey,
                                  labelPadding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  tabs: const [
                                    Tab(
                                      text: 'Diajukan Oleh',
                                    ),
                                    Tab(
                                      text: 'Informasi Training',
                                    ),
                                  ],
                                  onTap: (index) {
                                    setState(() {
                                      current = index;
                                    });
                                  },
                                ),
                                //Main Body
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: padding5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: sizedBoxHeightExtraTall,
                                              ),
                                              buildHeading(
                                                  title: 'Diajukan Oleh',
                                                  subtitle:
                                                      'Diisi oleh karyawan yang akan mengajukan training'),
                                              SizedBox(
                                                height: sizedBoxHeightExtraTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'NRP',
                                                  controller: _nrpController,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Nama',
                                                  controller: _namaController,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Jabatan',
                                                  controller:
                                                      _jabatanController,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Divisi / Departemen',
                                                  controller: _divisiController,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Entitas',
                                                  controller:
                                                      _entitasController,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title:
                                                      'Tanggal Mulai Bekerja',
                                                  controller:
                                                      _tglMulaiBekerjaController,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title:
                                                      'Total Mengikuti Kegiatan Training',
                                                  controller:
                                                      _totalTrainingController,
                                                  suffixText: 'Kali'),
                                              SizedBox(
                                                height: sizedBoxHeightExtraTall,
                                              ),
                                              buildHeading(
                                                  title: 'Diajukan Kepada'),
                                              SizedBox(
                                                height: sizedBoxHeightExtraTall,
                                              ),
                                              dropdownlistEntitasAtasan(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              dropdownlistEntitasHCGS(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              dropdownlistEntitasDirektur(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              dropdownlistAtasan(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              dropdownlistHCGS(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              dropdownlistDirektur(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: padding5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: sizedBoxHeightExtraTall,
                                              ),
                                              buildHeading(
                                                  title:
                                                      'Informasi Kegiatan Training',
                                                  subtitle:
                                                      'Mohon untuk dilampirkan brosur / pamflet / undangan kegiatan training'),
                                              SizedBox(
                                                height: sizedBoxHeightExtraTall,
                                              ),
                                              buildLabelRequired(
                                                title: 'Tanggal Training',
                                                isRequired: true,
                                              ),
                                              SizedBox(
                                                height: sizedBoxHeightShort,
                                              ),
                                              CupertinoButton(
                                                child: Container(
                                                  height: 50,
                                                  width: size.width,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          paddingHorizontalNarrow,
                                                      vertical: padding5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        color: Colors.grey,
                                                      ),
                                                      Text(
                                                        DateFormat('dd-MM-yyyy').format(
                                                            _tglTrainingController
                                                                    .selectedDate ??
                                                                DateTime.now()),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: textMedium,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: SizedBox(
                                                          height: 350,
                                                          width: 350,
                                                          child:
                                                              SfDateRangePicker(
                                                            controller:
                                                                _tglTrainingController,
                                                            onSelectionChanged:
                                                                (DateRangePickerSelectionChangedArgs
                                                                    args) {
                                                              setState(() {
                                                                tglTraining =
                                                                    args.value;
                                                                debugPrint(
                                                                    'Selected date ${args.value}');
                                                              });
                                                            },
                                                            selectionMode:
                                                                DateRangePickerSelectionMode
                                                                    .single,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Judul Training',
                                                  controller:
                                                      _judulTrainingController,
                                                  hintText: '---',
                                                  enabled: true,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                title: 'Institusi Training',
                                                controller:
                                                    _institusiTrainingController,
                                                hintText: '---',
                                                enabled: true,
                                              ),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Biaya Training',
                                                  controller:
                                                      _biayaTrainingController,
                                                  hintText: '---',
                                                  enabled: true,
                                                  isRequired: true,
                                                  prefixText: 'Rp',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'^[0-9]*$'))
                                                  ]),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Lokasi Training',
                                                  controller:
                                                      _lokasiTrainingController,
                                                  hintText: '---',
                                                  enabled: true,
                                                  isRequired: true),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              Row(
                                                children: [
                                                  buildLabelRequired(
                                                      title: 'Lampiran',
                                                      isRequired: true),
                                                ],
                                              ),
                                              SizedBox(
                                                height: sizedBoxHeightShort,
                                              ),
                                              Column(
                                                children: [
                                                  Center(
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          pickFiles(),
                                                      child: const Text(
                                                          'Pilih File'),
                                                    ),
                                                  ),
                                                  if (_files != null)
                                                    Column(children: [
                                                      ListTile(
                                                        title:
                                                            Text(_files!.name),
                                                      )
                                                    ]),
                                                ],
                                              ),
                                              SizedBox(
                                                height: sizedBoxHeightShort,
                                              ),
                                              if (_isFileNull) ...[
                                                Center(
                                                    child: Text(
                                                  'File Kosong',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: textMedium),
                                                ))
                                              ],
                                              dropdownlistJenisTraining(),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                              buildTextFormFieldField(
                                                  title: 'Periode Ikatan Dinas',
                                                  controller:
                                                      _ikatanDinasController,
                                                  hintText: '---',
                                                  enabled: true,
                                                  suffixText: 'Tahun'),
                                              SizedBox(
                                                height: sizedBoxHeightTall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: sizedBoxHeightTall,
                                ),
                                SizedBox(
                                  width: size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _submit();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(primaryYellow),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: const Color(primaryBlack),
                                          fontSize: textMedium,
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.9,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildHeading({required String title, String subtitle = ''}) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;

    return (Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
      if (subtitle.isNotEmpty) ...[
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        Text(
          subtitle,
          style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: textSmall,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300),
        ),
      ],
    ]));
  }

  Widget buildLabelRequired(
      {required String title, bool? isRequired, String? requireMessage}) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;

    return Row(
      children: [
        TitleWidget(
          title: title,
          fontWeight: FontWeight.w300,
          fontSize: textMedium,
        ),
        if (isRequired == true) ...[
          Text(
            ' * ${requireMessage ?? ''}',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.red,
                fontSize: textSmall,
                fontFamily: 'Poppins',
                letterSpacing: 0.6,
                fontWeight: FontWeight.w300),
          )
        ],
      ],
    );
  }

  Widget buildTextFormFieldField(
      {required String title,
      required dynamic controller,
      bool isRequired = false,
      String requireMessage = '',
      String hintText = '',
      String prefixText = '',
      String suffixText = '',
      bool enabled = false,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters}) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      buildLabelRequired(
          title: title, isRequired: isRequired, requireMessage: ''),
      SizedBox(
        height: sizedBoxHeightShort,
      ),
      TextFormField(
        style: const TextStyle(fontSize: 12),
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          enabled: enabled,
          prefixIcon: prefixText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: TitleWidget(
                    title: prefixText,
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                )
              : null,
          suffixIcon: suffixText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: TitleWidget(
                    title: suffixText,
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                )
              : null,
          hintText: hintText == '' ? '---' : hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    ]);
  }

  Widget buildCheckbox(String label, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isTinggiChecked = label == 'Tinggi' ? newValue : false;
              _isNormalChecked = label == 'Normal' ? newValue : false;
              _isRendahChecked = label == 'Rendah' ? newValue : false;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
