import 'dart:convert';

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

class FormPermintaanHardwareSoftware extends StatefulWidget {
  const FormPermintaanHardwareSoftware({super.key});

  @override
  State<FormPermintaanHardwareSoftware> createState() =>
      _FormPermintaanHardwareSoftwareState();
}

class _FormPermintaanHardwareSoftwareState
    extends State<FormPermintaanHardwareSoftware> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nrpNamaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _departmentController = TextEditingController();
  final _entitasController = TextEditingController();
  final _noTelpController = TextEditingController();
  String? cocd;
  late DateTime selectedDateEstimasi = DateTime.now();
  List<Map<String, dynamic>> selectedKaryawan = [];
  String? selectedValueKaryawan;
  final _lokasiKerjaController = TextEditingController();
  final _penjelasanController = TextEditingController();
  final _tambahanController = TextEditingController();

  bool? _isDesktop = false;
  bool? _isPrinter = false;
  bool? _isMonitor = false;
  bool? _isKeyboard = false;
  bool? _isLaptop = false;
  bool? _isMouse = false;
  bool? _isHardwareLainnya = false;
  final _hardwareLainnyaController = TextEditingController();

  bool? _isMsVisio = false;
  bool? _isAutocad = false;
  bool? _isMsProject = false;
  bool? _isAdobeAcrobat = false;
  bool? _isMsPublisher = false;
  bool? _isMsAccess = false;
  bool? _isSoftwareLainnya = false;
  final _softwareLainnyaController = TextEditingController();

  List<Map<String, dynamic>> selectedEntitas = [];
  String? selectedValueEntitasAtasan;
  String? selectedValueEntitasIT;
  List<Map<String, dynamic>> selectedAtasan = [];
  String? selectedValueAtasan;
  List<Map<String, dynamic>> selectedIT = [];
  String? selectedValueIT;

  final String apiUrl = API_URL;
  bool _isLoading = false;
  bool _isLoadingUser = false;
  bool _isLoadingKaryawan = false;
  bool _isLoadingEntitas = false;
  bool _isLoadingNrpAtasan = false;
  bool _isLoadingNrpIT = false;
  Map<String, String?> validationMessages = {};

  Map<String, String> extractWords(String? input) {
    if (input == null) {
      return {'firstWord': '', 'secondWord': ''};
    }
    List<String> parts = input.split('-');
    if (parts.length >= 2) {
      return {'firstWord': parts[0].trim(), 'secondWord': parts[1].trim()};
    } else {
      return {'firstWord': '', 'secondWord': ''};
    }
  }

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      validationMessages[fieldName] = 'Field $fieldName wajib diisi!';
      return validationMessages[fieldName];
    }
    validationMessages[fieldName] = null;
    return null;
  }

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingUser = true;
      });

      try {
        final response = await http
            .get(Uri.parse('$apiUrl/user-detail'), headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
        final responseData = jsonDecode(response.body);
        Map<String, dynamic> employeeData = responseData['employee'];

        setState(() {
          _nrpNamaController.text =
              employeeData['pernr'] + ' - ' + employeeData['nama'];
          _jabatanController.text = employeeData['pangkat'] ?? '';
          _departmentController.text = employeeData['organizational_unit'];
          _entitasController.text = employeeData['pt'];
          cocd = employeeData['cocd'];
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingUser = false;
        });
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
            .get(Uri.parse('$apiUrl/master/entitas'), headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
        final responseData = jsonDecode(response.body);
        final dataEntitasApi = responseData['data'];

        setState(() {
          selectedEntitas = List<Map<String, dynamic>>.from(dataEntitasApi);
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingEntitas = false;
        });
      }
    }
  }

  Future<void> getDataKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingKaryawan = true;
      });

      try {
        final response = await http.get(Uri.parse('$apiUrl/karyawan/division'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final dataKaryawan = responseData['data'];
        setState(() {
          selectedKaryawan = List<Map<String, dynamic>>.from(
            dataKaryawan,
          );
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingKaryawan = false;
        });
      }
    }
  }

  Future<void> getDataNrpAtasan(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingNrpAtasan = true;
      });

      try {
        final response = await http.get(
            Uri.parse(
                '$apiUrl/karyawan/dept-head?atasan=05&entitas=$entitasCode'),
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
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingNrpAtasan = false;
        });
      }
    }
  }

  Future<void> getDataNrpIT(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingNrpIT = true;
      });

      try {
        final response = await http.get(
            Uri.parse(
                '$apiUrl/karyawan/dept-head?atasan=00&entitas=$entitasCode'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          selectedIT = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueIT = null;
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingNrpIT = false;
        });
      }
    }
  }

  Future<void> _selectDateEstimasi(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateEstimasi,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    setState(() {
      if (pickedDate != null) {
        selectedDateEstimasi = pickedDate;
      }
    });
  }

  Future<void> _submit() async {
    setState(() {
      validateField(_noTelpController.text, 'No Telp');
      validateField(selectedValueKaryawan, 'Karyawan');
      validateField(_penjelasanController.text, 'Penjelasan');
      validateField(selectedValueEntitasAtasan, 'Entitas Atasan');
      validateField(selectedValueEntitasIT, 'Entitas IT');
      validateField(selectedValueAtasan, 'Nama Atasan');
      validateField(selectedValueIT, 'Nama IT');
      if (_isHardwareLainnya == true) {
        validateField(_hardwareLainnyaController.text, 'Hardware Lainnya');
      }
      if (_isSoftwareLainnya == true) {
        validateField(_softwareLainnyaController.text, 'Software Lainnya');
      }
    });

    if (validationMessages.values.any((msg) => msg != null)) {
      Get.snackbar('Information', 'Harap mengisi inputan yang required',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> words = extractWords(_nrpNamaController.text);
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDateEstimasi);
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/permintaan-hardware-software/create'),
    );

    void addFieldIfTrue(String field, bool condition) {
      if (condition) {
        request.fields[field] = condition.toString();
      }
    }

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['approved_by1'] = selectedValueAtasan.toString();
    request.fields['approved_by2'] = selectedValueIT.toString();
    request.fields['cocd'] = cocd.toString();
    request.fields['departemen'] = _departmentController.text;
    request.fields['detail_permintaan'] = _penjelasanController.text;
    request.fields['entitas'] = _entitasController.text;
    request.fields['entitas_atasan'] = selectedValueEntitasAtasan.toString();
    request.fields['entitas_it'] = selectedValueEntitasIT.toString();
    request.fields['estimasi_tgl'] = formattedDate;

    addFieldIfTrue('hard_desktop', _isDesktop!);
    addFieldIfTrue('hard_printer', _isPrinter!);
    addFieldIfTrue('hard_monitor', _isMonitor!);
    addFieldIfTrue('hard_keyboard', _isKeyboard!);
    addFieldIfTrue('hard_laptop', _isLaptop!);
    addFieldIfTrue('hard_mouse', _isMouse!);
    addFieldIfTrue('hard_lainnya', _isHardwareLainnya!);
    if (_isHardwareLainnya!) {
      request.fields['hard_ket_lainnya'] = _hardwareLainnyaController.text;
    }
    addFieldIfTrue('soft_visio', _isMsVisio!);
    addFieldIfTrue('soft_autocad', _isAutocad!);
    addFieldIfTrue('soft_project', _isMsProject!);
    addFieldIfTrue('soft_acrobat', _isAdobeAcrobat!);
    addFieldIfTrue('soft_publisher', _isMsPublisher!);
    addFieldIfTrue('soft_access', _isMsAccess!);
    addFieldIfTrue('soft_lainnya', _isSoftwareLainnya!);
    if (_isSoftwareLainnya!) {
      request.fields['soft_ket_lainnya'] = _softwareLainnyaController.text;
    }

    request.fields['jabatan'] = _jabatanController.text;
    request.fields['keterangan'] = _tambahanController.text;
    request.fields['lokasi_kerja'] = _lokasiKerjaController.text;
    request.fields['nama'] = words['secondWord'].toString();
    request.fields['no_hp'] = _noTelpController.text;
    request.fields['pernr'] = words['firstWord'].toString();
    request.fields['pernr_to'] = selectedValueKaryawan.toString();

    debugPrint('Body: ${request.fields}');

    try {
      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      final responseDataMessage = json.decode(responseData);

      Get.snackbar('Information', responseDataMessage['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);

      if (responseDataMessage['status'] == 'success') {
        if (mounted) Navigator.pop(context);
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
    getDataUser();
    getDataKaryawan();
    getDataEntitas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    Widget dropdownlistKaryawan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Karyawan',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              icon: _isLoadingKaryawan
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueKaryawan,
              menuMaxHeight: 400,
              items: selectedKaryawan.isNotEmpty
                  ? selectedKaryawan.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['pernr'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['pernr'] + ' - ' + value['nama'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: 'no-data',
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
                  selectedValueKaryawan = newValue!;
                  final karyawan = selectedKaryawan.firstWhere(
                      (element) => element['pernr'] == newValue, orElse: () {
                    return {};
                  });
                  _lokasiKerjaController.text = karyawan['lokasi'];
                  debugPrint('selectedValueKaryawan $selectedValueKaryawan');
                });
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Karyawan'] != null
                ? validateContainer('Karyawan')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistEntitasAtasan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
              items: selectedEntitas.isNotEmpty
                  ? selectedEntitas.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['kode'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['nama'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: 'no-data',
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
                  getDataNrpAtasan(selectedValueEntitasAtasan!);
                });
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Entitas Atasan'] != null
                ? validateContainer('Entitas Atasan')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistEntitasIT() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Entitas IT',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              icon: _isLoadingEntitas
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueEntitasIT,
              items: selectedEntitas.isNotEmpty
                  ? selectedEntitas.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['kode'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['nama'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: 'no-data',
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
                  selectedValueEntitasIT = newValue!;
                  debugPrint('selectedValueEntitasIT $selectedValueEntitasIT');
                  getDataNrpIT(selectedValueEntitasIT!);
                });
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Entitas IT'] != null
                ? validateContainer('Entitas IT')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistAtasan() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
              icon: _isLoadingNrpAtasan
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
                        value: value['pernr'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['pernr'] + ' - ' + value['nama'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: 'no-data',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Nama Atasan'] != null
                ? validateContainer('Nama Atasan')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistIT() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Informasi Teknologi',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingNrpIT
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueIT,
              items: selectedIT.isNotEmpty
                  ? selectedIT.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['pernr'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['pernr'] + ' - ' + value['nama'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: 'no-data',
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
                  selectedValueIT = newValue!;
                  debugPrint('selectedValueIT $selectedValueIT');
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
                    color: selectedValueIT != null
                        ? Colors.transparent
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Nama IT'] != null
                ? validateContainer('Nama IT')
                : null,
          ),
        ],
      );
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
              title: const Text(
                'Permintaan Hardware & Software',
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
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Diajukan Oleh'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'NRP / Nama Penerima'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _nrpNamaController,
                          decoration: InputDecoration(
                            suffixIcon: _isLoadingUser
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                        height: 5,
                                        width: 5,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        )),
                                  )
                                : const SizedBox(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Jabatan'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _jabatanController,
                          decoration: InputDecoration(
                            suffixIcon: _isLoadingUser
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                        height: 5,
                                        width: 5,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        )),
                                  )
                                : const SizedBox(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Departemen'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _departmentController,
                          decoration: InputDecoration(
                            suffixIcon: _isLoadingUser
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                        height: 5,
                                        width: 5,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        )),
                                  )
                                : const SizedBox(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Entitas'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _entitasController,
                          decoration: InputDecoration(
                            suffixIcon: _isLoadingUser
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                        height: 5,
                                        width: 5,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        )),
                                  )
                                : const SizedBox(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'No Telp'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              style: const TextStyle(fontSize: 12),
                              controller: _noTelpController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                hintText: '---',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[0-9]*$')),
                              ],
                            ),
                            if (validationMessages['No Telp'] != null)
                              validateContainer('No Telp'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Estimasi Tanggal Dibutuhkan'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          _selectDateEstimasi(context);
                        },
                        child: Container(
                          height: 50,
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
                                DateFormat('dd-MM-yyyy')
                                    .format(selectedDateEstimasi),
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
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Disediakan Untuk'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                      dropdownlistKaryawan(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Lokasi Kerja'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _lokasiKerjaController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            hintText: '---',
                            enabled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child:
                            buildHeading('Hardware dan Software Yang Diminta'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Hardware',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child:
                                buildCheckboxHardware('Desktop', _isDesktop!),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child:
                                buildCheckboxHardware('Printer', _isPrinter!),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child:
                                buildCheckboxHardware('Monitor', _isMonitor!),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child:
                                buildCheckboxHardware('Keyboard', _isKeyboard!),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxHardware('Laptop', _isLaptop!),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxHardware('Mouse', _isMouse!),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxHardware(
                                'Lainnya', _isHardwareLainnya!),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Software',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxSoftware(
                                'MS Visio 2007', _isMsVisio!),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child:
                                buildCheckboxSoftware('Autocad', _isAutocad!),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxSoftware(
                                'Ms Project 2007', _isMsProject!),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxSoftware(
                                'Adobe Acrobat', _isAdobeAcrobat!),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxSoftware(
                                'Ms Publisher 2007', _isMsPublisher!),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxSoftware(
                                'Ms Access', _isMsAccess!),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: buildCheckboxSoftware(
                                'Lainnya', _isSoftwareLainnya!),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Penjelasan'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              style: const TextStyle(fontSize: 12),
                              controller: _penjelasanController,
                              minLines: 3,
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                hintText: '---',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            if (validationMessages['Penjelasan'] != null)
                              validateContainer('Penjelasan'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(
                                title:
                                    'Tambahan Permintaan Hardware dan Software Lainnya'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _tambahanController,
                          minLines: 3,
                          maxLines: 3,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            hintText: '---',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Diajukan Kepada'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Entitas Atasan'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                      dropdownlistEntitasAtasan(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Atasan'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                      dropdownlistAtasan(),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Diketahui Oleh'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Entitas IT'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                      dropdownlistEntitasIT(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Informasi Teknologi'),
                            Text(
                              ' *',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
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
                      dropdownlistIT(),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(primaryYellow),
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
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildHeading(String title) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;

    return (Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
            color: const Color(primaryBlack),
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    ]));
  }

  Widget buildTitle({required String title}) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return TitleWidget(
      title: title,
      fontWeight: FontWeight.w300,
      fontSize: textMedium,
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

  Widget buildCheckboxHardware(String label, bool value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case 'Desktop':
                      _isDesktop = newValue!;
                      break;
                    case 'Printer':
                      _isPrinter = newValue!;
                      break;
                    case 'Monitor':
                      _isMonitor = newValue!;
                      break;
                    case 'Keyboard':
                      _isKeyboard = newValue!;
                      break;
                    case 'Laptop':
                      _isLaptop = newValue!;
                      break;
                    case 'Mouse':
                      _isMouse = newValue!;
                      break;
                    case 'Lainnya':
                      if (newValue! == true) {
                        _isHardwareLainnya = newValue;
                      } else {
                        _isHardwareLainnya = newValue;
                        _hardwareLainnyaController.clear();
                      }
                      break;
                  }
                });
              },
            ),
            Text(
              label,
              style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        if (label == 'Lainnya')
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: TextFormField(
                  enabled: _isHardwareLainnya!,
                  controller: _hardwareLainnyaController,
                  decoration: const InputDecoration(
                    hintText: '---',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: validationMessages['Hardware Lainnya'] != null
                    ? validateContainer('Hardware Lainnya')
                    : null,
              ),
            ],
          ),
      ],
    );
  }

  Widget buildCheckboxSoftware(String label, bool value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case 'MS Visio 2007':
                      _isMsVisio = newValue!;
                      break;
                    case 'Autocad':
                      _isAutocad = newValue!;
                      break;
                    case 'Ms Project 2007':
                      _isMsProject = newValue!;
                      break;
                    case 'Adobe Acrobat':
                      _isAdobeAcrobat = newValue!;
                      break;
                    case 'Ms Publisher 2007':
                      _isMsPublisher = newValue!;
                      break;
                    case 'Ms Access':
                      _isMsAccess = newValue!;
                      break;
                    case 'Lainnya':
                      if (newValue! == true) {
                        _isSoftwareLainnya = newValue;
                      } else {
                        _isSoftwareLainnya = newValue;
                        _softwareLainnyaController.clear();
                      }
                      break;
                  }
                });
              },
            ),
            Text(
              label,
              style: TextStyle(
                  color: const Color(primaryBlack),
                  fontSize: textMedium,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        if (label == 'Lainnya')
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: TextFormField(
                  enabled: _isSoftwareLainnya!,
                  controller: _softwareLainnyaController,
                  decoration: const InputDecoration(
                    hintText: '---',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: validationMessages['Software Lainnya'] != null
                    ? validateContainer('Software Lainnya')
                    : null,
              ),
            ],
          ),
      ],
    );
  }
}
