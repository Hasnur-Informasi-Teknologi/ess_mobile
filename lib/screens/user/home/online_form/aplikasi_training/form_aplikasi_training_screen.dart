import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  String? selectecCheckboxPrioritas;

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
  String? selectedValueJenisTraining = 'training';
  final TextEditingController _ikatanDinasController = TextEditingController();
  double? _ikatanDinasInYears = 0;

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
  Timer? _debounceTimer;

  Future<String?> validateField(String? value, String fieldName) async {
    if (value == null || value.isEmpty) {
      validationMessages[fieldName] = 'Field $fieldName wajib diisi!';
      return validationMessages[fieldName];
    }
    validationMessages[fieldName] = null;
    return null;
  }

  Future<void> getDataPengajuan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
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
        final response = await http.get(
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
        final response = await http.get(
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
        final response = await http.get(
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

  Future<void> onCheckboxChangedKeperluan(String label, bool? newValue) async {
    setState(() {
      if (newValue == true) {
        selectecCheckboxPrioritas = label;
      } else {
        selectecCheckboxPrioritas = null;
      }
    });
  }

  Future<void> _onBiayaTrainingChanged() async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final biayaTraining = double.tryParse(_biayaTrainingController.text) ?? 0;
      if (biayaTraining >= 10000000) {
        final ikatanDinasInYears = (biayaTraining / 10000000);
        final years = ikatanDinasInYears.floor();
        final months = ((ikatanDinasInYears - years) * 12).round();
        setState(() {
          _ikatanDinasInYears = ikatanDinasInYears;
          _ikatanDinasController.text = '$years Tahun $months Bulan';
        });
      } else {
        if (selectedValueJenisTraining == 'training') {
          setState(() {
            _ikatanDinasController.text = '0 Tahun 0 Bulan';
          });
        } else if (selectedValueJenisTraining == 'sertifikasi' ||
            selectedValueJenisTraining == 'training dan sertifikasi') {
          setState(() {
            _ikatanDinasController.text = '1 Tahun 0 Bulan';
          });
        }
      }
    });
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
    setState(() {
      validateField(selectecCheckboxPrioritas, 'Prioritas');
      validateField(selectedValueEntitasHCGS, 'Entitas HCGS');
      validateField(selectedValueEntitasAtasan, 'Entitas Atasan');
      validateField(selectedValueEntitasDirektur, 'Entitas Direktur');
      validateField(selectedValueHCGS, 'Nama HCGS');
      validateField(selectedValueAtasan, 'Nama Atasan');
      validateField(selectedValueDirektur, 'Nama Direktur');
      validateField(_judulTrainingController.text, 'Judul Training');
      validateField(_institusiTrainingController.text, 'Institusi Training');
      validateField(_biayaTrainingController.text, 'Biaya Training');
      validateField(_lokasiTrainingController.text, 'Lokasi Training');
    });

    if (validationMessages.values.any((msg) => msg != null)) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

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
      'periode_ikatan_dinas': _ikatanDinasInYears.toString(),
      'prioritas': selectecCheckboxPrioritas.toString(),
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
      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      final responseDataMessage = json.decode(responseData);

      if (response.statusCode == 200) {
        Get.snackbar('Information', responseDataMessage['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        if (mounted) Navigator.pop(context);
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
  void initState() {
    super.initState();
    initializeData();
    getDataPengajuan();
    getDataJenisTraining();
    _ikatanDinasController.text = '0 Tahun 0 Bulan';
    _biayaTrainingController.addListener(_onBiayaTrainingChanged);
    String formattedDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _tglPengajuanController = TextEditingController(text: formattedDateTime);
  }

  void initializeData() async {
    await getDataUser();
    await getDataEntitas();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _biayaTrainingController.removeListener(_onBiayaTrainingChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

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
            validateContainer('Entitas Atasan')
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
            validateContainer('Entitas HCGS')
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
          if (validationMessages['Entitas Direktur'] != null)
            validateContainer('Entitas Direktur')
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
          if (validationMessages['Nama Atasan'] != null)
            validateContainer('Nama Atasan')
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
          if (validationMessages['Nama HCGS'] != null)
            validateContainer('Nama HCGS')
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
          if (validationMessages['Nama Direktur'] != null)
            validateContainer('Nama Direktur')
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
                  getDataAtasan(selectedValueJenisTraining!);
                  _onBiayaTrainingChanged();
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
                title: const Text(
                  'Form Aplikasi Training',
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
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildCheckbox('Tinggi',
                                    selectecCheckboxPrioritas == 'Tinggi'),
                                buildCheckbox('Normal',
                                    selectecCheckboxPrioritas == 'Normal'),
                                buildCheckbox('Rendah',
                                    selectecCheckboxPrioritas == 'Rendah'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: validationMessages['Prioritas'] != null
                                      ? validateContainer('Prioritas')
                                      : null,
                                ),
                              ],
                            ),
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
                                              ),
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

  Widget validateContainer(String field) {
    return validationMessages[field] != null
        ? Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              validationMessages[field]!,
              style: TextStyle(color: Colors.red.shade900, fontSize: 12),
            ),
          )
        : const SizedBox.shrink();
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
      if (validationMessages[title] != null) validateContainer(title)
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
              onCheckboxChangedKeperluan(label, newValue);
            });
            debugPrint('selectecCheckboxPrioritas, $selectecCheckboxPrioritas');
          },
        ),
        Text(label),
      ],
    );
  }
}
