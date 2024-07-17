import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormPengajuanLembur extends StatefulWidget {
  const FormPengajuanLembur({super.key});

  @override
  State<FormPengajuanLembur> createState() => _FormPengajuanLemburState();
}

class _FormPengajuanLemburState extends State<FormPengajuanLembur> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _entitasController = TextEditingController();
  final _periodeController = TextEditingController();
  final _departmentController = TextEditingController();
  String? positionUser;
  String? cocdUser;

  List<Map<String, dynamic>> selectedEntitas = [];
  String? selectedValueEntitasAtasan;
  String? selectedValueEntitasHCGS;
  String? selectedValueEntitasKaryawan;
  // atasan
  List<Map<String, dynamic>> selectedAtasan = [];
  String? selectedValueAtasan;
  final _jabatanAtasanController = TextEditingController();
  String? nrpAtasan;
  String? departmentAtasan;
  String? jabatanAtasan;
  String? namaAtasan;
  // hcgs
  List<Map<String, dynamic>> selectedHCGS = [];
  String? selectedValueHCGS;
  final _jabatanHCGSController = TextEditingController();
  String? nrpHCGS;
  String? departmentHCGS;
  String? jabatanHCGS;
  String? namaHCGS;

  final _aktivitasController = TextEditingController();
  List<Map<String, dynamic>> selectedKaryawan = [];
  String? selectedValueKaryawan;
  late DateTime selectedDateMulai = DateTime.now();
  late TimeOfDay selectedTimeMulai = TimeOfDay.now();
  late DateTime selectedDateAkhir;
  late TimeOfDay selectedTimeAkhir;
  final _keteranganController = TextEditingController();
  List<Map<String, dynamic>> formDataList = [];

  final String apiUrl = API_URL;
  bool _isLoading = false;
  bool _isLoadingUser = false;
  bool _isLoadingEntitas = false;
  bool _isLoadingNrpAtasan = false;
  bool _isLoadingNrpHCGS = false;
  bool _isLoadingKaryawan = false;
  Map<String, String?> validationMessages = {};

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      validationMessages[fieldName] = 'Field $fieldName wajib diisi!';
      return validationMessages[fieldName];
    }
    validationMessages[fieldName] = null;
    return null;
  }

  bool isKaryawanInFormDataList(String pernr) {
    for (var formData in formDataList) {
      if (formData['karyawan']['pernr'] == pernr) {
        return true;
      }
    }
    return false;
  }

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String formattedYear = DateFormat('yyyy').format(DateTime.now());

    if (token != null) {
      setState(() {
        _isLoadingUser = true;
      });

      try {
        final response = await http.get(
            Uri.parse('$apiUrl/master/profile/get_employee'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];

        setState(() {
          _nrpController.text = data['pernr'];
          _namaController.text = data['nama'];
          _entitasController.text = data['pt'];
          _periodeController.text = formattedYear;
          _departmentController.text = data['organizational_unit'];
          positionUser = data['position'];
          cocdUser = data['cocd'];
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
        final response = await http.get(
            Uri.parse('$apiUrl/perintah-lembur/master_data'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataEntitasApi = responseData['entitas'];

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
                '$apiUrl/master/daftar_karyawan?entitas=$entitasCode&kategori=atasan'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        setState(() {
          selectedAtasan = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueAtasan = null;
          _jabatanAtasanController.text = '';
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

  Future<void> getDataNrpHCGS(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingNrpHCGS = true;
      });

      try {
        final response = await http.get(
            Uri.parse(
                '$apiUrl/master/daftar_karyawan?entitas=$entitasCode&kategori=hrgs'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        setState(() {
          selectedHCGS = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueHCGS = null;
          _jabatanHCGSController.text = '';
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingNrpHCGS = false;
        });
      }
    }
  }

  Future<void> getDataNrpKaryawan(String entitasUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingKaryawan = true;
      });

      try {
        final response = await http.get(
            Uri.parse(
                "$apiUrl/master/daftar_karyawan?entitas=$entitasUser&kategori=penerima"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        setState(() {
          selectedKaryawan = List<Map<String, dynamic>>.from(
            data,
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

  Future<void> _selectDateTimeMulai(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateMulai,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeMulai,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateMulai = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          selectedTimeMulai = pickedTime;
          selectedDateAkhir = selectedDateMulai.add(const Duration(hours: 1));
          selectedTimeAkhir = TimeOfDay(
            hour: selectedTimeMulai.hour + 1,
            minute: selectedTimeMulai.minute,
          );
        });
      }
    }
  }

  Future<void> _selectDateTimeAkhir(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateAkhir,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeAkhir,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        DateTime newDateAkhir = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (newDateAkhir.isBefore(selectedDateMulai)) {
          Get.snackbar(
            'Oops...',
            'Tanggal / Jam Akhir tidak boleh kurang dari Tanggal / Jam Mulai',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 20,
            margin: const EdgeInsets.all(15),
            duration: const Duration(seconds: 4),
            icon: const Icon(
              Icons.error,
              color: Colors.white,
            ),
          );
        } else {
          setState(() {
            selectedDateAkhir = newDateAkhir;
            selectedTimeAkhir = pickedTime;
          });
        }
      }
    }
  }

  Future<void> addFormData() async {
    if (_aktivitasController.text.isEmpty ||
        selectedValueEntitasKaryawan == null ||
        selectedValueKaryawan == null) {
      Get.snackbar(
        'Error',
        'Harap isi field karyawan yang ditugaskan.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      );
      return;
    }

    Map<String, dynamic> selectedEmployee = jsonDecode(selectedValueKaryawan!);
    debugPrint('Selected Employee: $selectedEmployee');
    Map<String, dynamic> filteredEmployee = {
      'nama': selectedEmployee['nama'],
      'pernr': selectedEmployee['pernr'],
      'department': selectedEmployee['organizational_unit'],
      'position': selectedEmployee['position'],
    };
    String formattedDateTimeMulai =
        '${DateFormat('dd-MM-yyyy').format(selectedDateMulai)} ${DateFormat('HH:mm').format(selectedDateMulai)}';
    String formattedDateTimeAkhir =
        '${DateFormat('dd-MM-yyyy').format(selectedDateAkhir)} ${DateFormat('HH:mm').format(selectedDateAkhir)}';

    final formData = {
      'karyawan': filteredEmployee,
      'entitas': selectedValueEntitasKaryawan,
      'waktu_mulai': formattedDateTimeMulai,
      'waktu_selesai': formattedDateTimeAkhir,
      'keterangan': _keteranganController.text
    };

    debugPrint('Form Data: $formData');

    setState(() {
      formDataList.add(formData);
      selectedValueKaryawan = null;
      _keteranganController.clear();
    });
  }

  Future<void> removeFormData(int index) async {
    setState(() {
      formDataList.removeAt(index);
    });
  }

  Future<void> _submit() async {
    setState(() {
      validateField(selectedValueEntitasAtasan, 'Entitas Atasan');
      validateField(selectedValueEntitasHCGS, 'Entitas HCGS');
      validateField(selectedValueAtasan, 'Nama - NRP Atasan');
      validateField(selectedValueHCGS, 'Nama - NRP HCGS');
    });

    if (validationMessages.values.any((msg) => msg != null)) {
      return;
    }

    if (formDataList.isEmpty) {
      Get.snackbar(
        'Oops...',
        'Silakan tambahkan data karyawan yang ditugaskan minimal 1.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/perintah-lembur/add'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'total_nilai': '0',
      'currentYear': DateTime.now().year.toString(),
      'data_user': '${_nrpController.text} - ${_namaController.text}',
      'nrp_user': _nrpController.text,
      'jabatan_user': positionUser.toString(),
      'department_user': _departmentController.text,
      'nama_user': _namaController.text,
      'entitas_user': cocdUser.toString(),
      'entitas_name_user': _entitasController.text,
      'entitas_atasan': selectedValueEntitasAtasan.toString(),
      'entitas_hrgs': selectedValueEntitasHCGS.toString(),
      'nrp_atasan': nrpAtasan.toString(),
      'departement_atasan': departmentAtasan.toString(),
      'jabatan_atasan': jabatanAtasan.toString(),
      'nama_atasan': namaAtasan.toString(),
      'nrp_hrgs': nrpAtasan.toString(),
      'departement_hrgs': departmentAtasan.toString(),
      'jabatan_hrgs': jabatanAtasan.toString(),
      'nama_hrgs': namaAtasan.toString(),
      'aktivitas': _aktivitasController.text,
      'entitas_penerima': selectedValueEntitasKaryawan.toString(),
      'nrp_penerima': 'null',
      'tgl_mulai': 'null',
      'tgl_berakhir': 'null',
      'keterangan': 'null',
      'departement_penerima': formDataList.last['karyawan']['department'],
      'jabatan_penerima': formDataList.last['karyawan']['position'],
      'nama_penerima': 'null',
      'nrp': 'null',
      'nama': 'null',
      'entitas': 'null',
      'vtable': jsonEncode(formDataList.map((form) {
        return {
          "nrp": form['karyawan']['pernr'],
          "nama": form['karyawan']['nama'],
          "entitas": form['entitas'],
          "tgl_mulai": form['waktu_mulai'],
          "tgl_berakhir": form['waktu_selesai'],
          "keterangan": form['keterangan'],
          "selected": false,
        };
      }).toList())
    });

    for (var i = 0; i < formDataList.length; i++) {
      request.fields['vtable_$i'] = jsonEncode({
        "nrp": formDataList[i]['karyawan']['pernr'],
        "nama": formDataList[i]['karyawan']['nama'],
        "entitas": formDataList[i]['entitas'],
        "tgl_mulai": formDataList[i]['waktu_mulai'],
        "tgl_berakhir": formDataList[i]['waktu_selesai'],
        "keterangan": formDataList[i]['keterangan'],
        "selected": false,
      });
    }

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
    getDataEntitas();

    selectedDateAkhir = selectedDateMulai.add(const Duration(hours: 1));
    selectedTimeAkhir = TimeOfDay(
      hour: selectedTimeMulai.hour + 1,
      minute: selectedTimeMulai.minute,
    );
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

    Widget dropdownlistEntitasHCGS() {
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
                  selectedValueEntitasHCGS = newValue!;
                  debugPrint(
                      'selectedValueEntitasHCGS $selectedValueEntitasHCGS');
                  getDataNrpHCGS(selectedValueEntitasHCGS!);
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
            child: validationMessages['Entitas HCGS'] != null
                ? validateContainer('Entitas HCGS')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistEntitasKaryawan() {
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
                  'Pilih Entitas Karyawan',
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
              value: selectedValueEntitasKaryawan,
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
                  selectedValueEntitasKaryawan = newValue!;
                  debugPrint(
                      'selectedValueEntitasKaryawan $selectedValueEntitasKaryawan');
                  getDataNrpKaryawan(selectedValueEntitasKaryawan!);
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
            child: validationMessages['Entitas Karyawan'] != null
                ? validateContainer('Entitas Karyawan')
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
                  'Pilih Nama - NRP Atasan',
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
                  final atasan = selectedAtasan.firstWhere(
                      (element) => element['pernr'] == newValue, orElse: () {
                    return {};
                  });
                  _jabatanAtasanController.text = atasan['position'];
                  nrpAtasan = atasan['pernr'];
                  departmentAtasan = atasan['organizational_unit'];
                  jabatanAtasan = atasan['position'];
                  namaAtasan = atasan['nama'];
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
            child: validationMessages['Nama - NRP Atasan'] != null
                ? validateContainer('Nama - NRP Atasan')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistHCGS() {
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
                  'Pilih Nama - NRP HCGS',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingNrpHCGS
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
                  selectedValueHCGS = newValue!;
                  final hcgs = selectedHCGS.firstWhere(
                      (element) => element['pernr'] == newValue, orElse: () {
                    return {};
                  });
                  _jabatanHCGSController.text = hcgs['position'];
                  nrpAtasan = hcgs['pernr'];
                  departmentAtasan = hcgs['organizational_unit'];
                  jabatanAtasan = hcgs['position'];
                  namaAtasan = hcgs['nama'];
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Nama - NRP HCGS'] != null
                ? validateContainer('Nama - NRP HCGS')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistKaryawan() {
      List<Map<String, dynamic>> filteredKaryawan =
          selectedKaryawan.where((karyawan) {
        return !isKaryawanInFormDataList(karyawan['pernr']);
      }).toList();

      return Container(
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
              style: TextStyle(fontSize: 11),
            ),
          ),
          menuMaxHeight: 500,
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
          items: filteredKaryawan.isNotEmpty
              ? filteredKaryawan.map((value) {
                  return DropdownMenuItem<String>(
                    value: jsonEncode(value),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '${value['nama']} - ${value['pernr']}',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
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
          onChanged: (String? newValue) {
            setState(() {
              selectedValueKaryawan = newValue;
              debugPrint('selectedValueKaryawan: $selectedValueKaryawan');
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
                color: selectedValueKaryawan != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
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
                'Perintah Lembur',
              ),
            ),
            body: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: sizedBoxHeightExtraTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Diajukan Oleh'),
                      ),
                      SizedBox(height: sizedBoxHeightExtraTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'NRP'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _nrpController,
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
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Nama'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _namaController,
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
                      SizedBox(height: sizedBoxHeightTall),
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
                      SizedBox(height: sizedBoxHeightShort),
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
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Periode'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _periodeController,
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
                      SizedBox(height: sizedBoxHeightTall),
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
                      SizedBox(height: sizedBoxHeightShort),
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
                      SizedBox(height: sizedBoxHeightExtraTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Diajukan Kepada'),
                      ),
                      SizedBox(height: sizedBoxHeightExtraTall),
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
                      SizedBox(height: sizedBoxHeightShort),
                      dropdownlistEntitasAtasan(),
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Nama - NRP Atasan'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      dropdownlistAtasan(),
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Jabatan Atasan'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _jabatanAtasanController,
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
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Entitas HCGS'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      dropdownlistEntitasHCGS(),
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Nama - NRP HCGS'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      dropdownlistHCGS(),
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Jabatan HCGS'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _jabatanHCGSController,
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
                      SizedBox(height: sizedBoxHeightExtraTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child:
                            buildHeading('Dengan ini menugaskan lembur kepada'),
                      ),
                      SizedBox(height: sizedBoxHeightExtraTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Aktivitas'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          controller: _aktivitasController,
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
                      SizedBox(height: sizedBoxHeightTall),
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
                      SizedBox(height: sizedBoxHeightShort),
                      IgnorePointer(
                          ignoring: formDataList.isNotEmpty,
                          child: dropdownlistEntitasKaryawan()),
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Nama - NRP Karyawan'),
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
                      SizedBox(height: sizedBoxHeightShort),
                      dropdownlistKaryawan(),
                      SizedBox(height: sizedBoxHeightTall),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Tanggal / Jam Mulai'),
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
                          _selectDateTimeMulai(context);
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
                                '${DateFormat('dd-MM-yyyy').format(selectedDateMulai)} ${DateFormat('HH:mm').format(selectedDateMulai)}',
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
                            buildTitle(title: 'Tanggal / Jam Berakhir'),
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
                          _selectDateTimeAkhir(context);
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
                                '${DateFormat('dd-MM-yyyy').format(selectedDateAkhir)} ${DateFormat('HH:mm').format(selectedDateAkhir)}',
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
                        child: buildTitle(title: 'Keterangan'),
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 12),
                          minLines: 3,
                          maxLines: 3,
                          controller: _keteranganController,
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
                      SizedBox(height: sizedBoxHeightExtraTall),
                      SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              addFormData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(buttonGreen),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Tambah',
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
                      SizedBox(height: sizedBoxHeightTall),
                      if (formDataList.isNotEmpty) ...[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      "No",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "NRP",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Nama",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Entitas",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tanggal / Jam Mulai",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tanggal / Jam Akhir",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Keterangan",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Action",
                                    ),
                                  ),
                                ],
                                columnSpacing: 20,
                                rows: formDataList.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, dynamic> data = entry.value;
                                  return DataRow(cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(Text(data['karyawan']['pernr'])),
                                    DataCell(Text(data['karyawan']['nama'])),
                                    DataCell(Text(data['entitas'])),
                                    DataCell(Text(data['waktu_mulai'])),
                                    DataCell(Text(data['waktu_selesai'])),
                                    DataCell(Text(data['keterangan'] ?? '')),
                                    DataCell(Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              removeFormData(index);
                                            },
                                            child: const Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ))
                                  ]);
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      SizedBox(height: sizedBoxHeightExtraTall),
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
}
