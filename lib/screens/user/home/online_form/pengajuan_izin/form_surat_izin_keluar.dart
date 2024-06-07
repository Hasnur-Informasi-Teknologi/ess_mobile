import 'dart:async';
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

class FormSuratIzinKeluar extends StatefulWidget {
  const FormSuratIzinKeluar({super.key});

  @override
  State<FormSuratIzinKeluar> createState() => _FormSuratIzinKeluarState();
}

class _FormSuratIzinKeluarState extends State<FormSuratIzinKeluar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nrpNamaController = TextEditingController();
  final _positionController = TextEditingController();
  String? departmentUser;
  String? entitasNameUser;
  String? entitasUser;
  String? jabatanUser;

  List<Map<String, dynamic>> selectedEntitasAtasan = [];
  String? selectedValueEntitasAtasan;
  List<Map<String, dynamic>> selectedEntitasHCGS = [];
  String? selectedValueEntitasHCGS;

  List<Map<String, dynamic>> selectedNrpAtasan = [];
  String? selectedValueNrpAtasan;
  String? departemenAtasan;
  String? jabatanAtasan;
  String? namaAtasan;
  List<Map<String, dynamic>> selectedNrpHCGS = [];
  String? selectedValueNrpHCGS;
  String? departemenHCGS;
  String? jabatanHCGS;
  String? namaHCGS;

  List<Map<String, dynamic>> selectedKaryawan = [];
  String? selectedValueKaryawan;

  late DateTime selectedDateIzinKeluar = DateTime.now();
  List<Map<String, dynamic>> selectedJenisIzin = [];
  String? selectedValueJenisIzin;

  List<Map<String, dynamic>> formDataList = [];
  late TimeOfDay selectedTimeJamKeluar;
  late TimeOfDay selectedTimeJamKembali;
  String? selectedCheckboxKembaliKeKantor;
  String? selectedCheckboxKeperluan;
  final _keteranganController = TextEditingController();

  final String apiUrl = API_URL;
  bool _isLoading = false;
  bool _isLoadingUser = false;
  bool _isLoadingEntitas = false;
  bool _isLoadingNrpHCGS = false;
  bool _isLoadingNrpAtasan = false;
  bool _isLoadingKaryawan = false;
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

  DateTime convertTimeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  String formatTimeOfDay(TimeOfDay time) {
    final dateTime = convertTimeOfDayToDateTime(time);
    final format = DateFormat.Hm();
    return format.format(dateTime);
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
        final response = await http.get(
            Uri.parse("$apiUrl/master/profile/get_employee"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          _nrpNamaController.text = data['pernr'] + ' - ' + data['nama'];
          _positionController.text = data['position'] ?? '';
          departmentUser = data['organizational_unit'] ?? '';
          entitasNameUser = data['pt'] ?? '';
          entitasUser = data['cocd'] ?? '';
          jabatanUser = data['position'] ?? '';
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

  Future<void> getDataMaster() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingEntitas = true;
      });

      try {
        final response = await http.get(
            Uri.parse("$apiUrl/izin-keluar/master_data"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final dataEntitasHCGS = responseData['entitas'];
        final dataEntitasAtasan = responseData['entitas'];
        final dataJenisIzin = responseData['jenis_izin_keluar'];
        setState(() {
          selectedEntitasAtasan = List<Map<String, dynamic>>.from(
            dataEntitasAtasan,
          );
          selectedEntitasHCGS = List<Map<String, dynamic>>.from(
            dataEntitasHCGS,
          );
          selectedJenisIzin = List<Map<String, dynamic>>.from(
            dataJenisIzin,
          );
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
            Uri.parse("$apiUrl/master/daftar_karyawan?entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        setState(() {
          selectedNrpAtasan = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueNrpAtasan = null;
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
            Uri.parse("$apiUrl/master/daftar_karyawan?entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        setState(() {
          selectedNrpHCGS = List<Map<String, dynamic>>.from(
            data,
          );
          selectedValueNrpHCGS = null;
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

  Future<void> getDataPenerima() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingKaryawan = true;
      });

      try {
        final response = await http.get(
            Uri.parse(
                "$apiUrl/master/daftar_karyawan?entitas=$entitasUser&kategori=pil_karyawan"),
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

  Future<void> _selectDateIzinKeluar(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateIzinKeluar,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    setState(() {
      if (pickedDate != null) {
        selectedDateIzinKeluar = pickedDate;
      }
    });
  }

  Future<void> _selectTimeKeluar(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimeJamKeluar,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTimeJamKeluar = pickedTime;
        if (selectedTimeJamKembali.hour <= pickedTime.hour &&
            selectedTimeJamKembali.minute <= pickedTime.minute) {
          selectedTimeJamKembali = TimeOfDay(
            hour: (pickedTime.hour + 1) % 24,
            minute: pickedTime.minute,
          );
        }
      });
    }
  }

  Future<void> _selectTimeKembali(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimeJamKembali,
    );

    if (pickedTime != null) {
      setState(() {
        if (pickedTime.hour > selectedTimeJamKeluar.hour ||
            (pickedTime.hour == selectedTimeJamKeluar.hour &&
                pickedTime.minute > selectedTimeJamKeluar.minute)) {
          selectedTimeJamKembali = pickedTime;
        } else {
          Get.snackbar(
            'Oops...',
            'Jam Kembali harus lebih dari jam keluar.',
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
        }
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      validateField(selectedValueEntitasHCGS, 'Entitas HCGS');
      validateField(selectedValueEntitasAtasan, 'Entitas Atasan');
      validateField(selectedValueNrpHCGS, 'Nama HCGS');
      validateField(selectedValueNrpAtasan, 'Nama Atasan');
      validateField(selectedValueJenisIzin, 'Jenis Izin');
      validateField(selectedCheckboxKeperluan, 'Keperluan');
      validateField(_keteranganController.text, 'Keterangan');
      if (selectedValueJenisIzin == '2' && formDataList.isEmpty) {
        validateField(selectedValueKaryawan, 'Karyawan');
      } else {
        validationMessages['Karyawan'] = null;
      }
    });

    if (validationMessages.values.any((msg) => msg != null)) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> words = extractWords(_nrpNamaController.text);
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedDateIzinKeluar);

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/izin-keluar/add'),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['departement_atasan'] = departemenAtasan.toString();
    request.fields['departement_hrgs'] = departemenHCGS.toString();
    request.fields['department_user'] = departmentUser.toString();
    request.fields['entitas_atasan'] = selectedValueEntitasAtasan.toString();
    request.fields['entitas_hrgs'] = selectedValueEntitasHCGS.toString();
    request.fields['entitas_name_user'] = entitasNameUser.toString();
    request.fields['entitas_user'] = entitasUser.toString();
    request.fields['jabatan_atasan'] = jabatanAtasan.toString();
    request.fields['jabatan_hrgs'] = jabatanHCGS.toString();
    request.fields['jabatan_user'] = jabatanUser.toString();
    request.fields['nama_atasan'] = namaAtasan.toString();
    request.fields['nama_hrgs'] = namaHCGS.toString();
    request.fields['nama_user'] = words['secondWord'].toString();
    request.fields['nrp_atasan'] = selectedValueNrpAtasan.toString();
    request.fields['nrp_hrgs'] = selectedValueNrpHCGS.toString();
    request.fields['nrp_user'] = words['firstWord'].toString();
    request.fields['vtable'] = selectedValueJenisIzin == '1'
        ? jsonEncode([
            {
              "nrp_karyawan": words['firstWord'],
              "nama_karyawan": words['secondWord'],
            }
          ])
        : jsonEncode(formDataList
            .asMap()
            .map((index, formData) {
              return MapEntry(index, {
                "nrp_karyawan": formData['karyawan']['pernr'],
                "nama_karyawan": formData['karyawan']['nama'],
              });
            })
            .values
            .toList());
    request.fields['tgl_izin'] = formattedDate;
    request.fields['kembalikekantor'] =
        selectedCheckboxKembaliKeKantor == 'Kembali' ? 'true' : 'null';
    request.fields['jam_keluar'] = formatTimeOfDay(selectedTimeJamKeluar);
    request.fields['jam_kembali'] = selectedValueJenisIzin == '2'
        ? formatTimeOfDay(selectedTimeJamKembali)
        : 'null';
    request.fields['keterangan'] = _keteranganController.text;
    request.fields['id_jenis_izin'] = selectedValueJenisIzin.toString();
    request.fields['kep_dinas'] =
        selectedCheckboxKeperluan == 'Dinas' ? 'true' : 'null';
    request.fields['kep_pribadi'] =
        selectedCheckboxKeperluan == 'Pribadi' ? 'true' : 'null';
    request.fields['kep_sakit'] =
        selectedCheckboxKeperluan == 'Sakit' ? 'true' : 'null';
    request.fields['kep_lainnya'] =
        selectedCheckboxKeperluan == 'Lainnya' ? 'true' : 'null';

    request.fields['lainnya'] = 'null';
    request.fields['entitas'] = entitasUser.toString();

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
        formDataList.clear();
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

  void addFormData() {
    if (selectedValueJenisIzin == null ||
        selectedCheckboxKeperluan == null ||
        selectedValueKaryawan == null) {
      Get.snackbar(
        'Error',
        'Harap isi semua field pada Detail izin keluar.',
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
    Map<String, dynamic> filteredEmployee = {
      'nama': selectedEmployee['nama'],
      'pernr': selectedEmployee['pernr']
    };

    final formData = {
      'tanggal': selectedDateIzinKeluar,
      'jam_keluar': formatTimeOfDay(selectedTimeJamKeluar),
      'jam_kembali': selectedCheckboxKembaliKeKantor == 'Kembali'
          ? formatTimeOfDay(selectedTimeJamKembali)
          : null,
      'jenis_izin': selectedValueJenisIzin,
      'keperluan': selectedCheckboxKeperluan,
      'karyawan': filteredEmployee,
      'keterangan': _keteranganController.text
    };

    setState(() {
      formDataList.add(formData);
      selectedValueKaryawan = null;
    });
  }

  void removeFormData(int index) {
    setState(() {
      formDataList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    getDataMaster().then((_) {
      getDataUser().then((_) {
        getDataPenerima();
      });
    });

    selectedTimeJamKeluar = TimeOfDay.now();
    selectedTimeJamKembali = TimeOfDay(
      hour: (TimeOfDay.now().hour + 1) % 24,
      minute: TimeOfDay.now().minute,
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
                  getDataNrpHCGS(selectedValueEntitasHCGS!);
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Entitas HCGS'] != null
                ? validateContainer('Entitas HCGS')
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
                  getDataNrpAtasan(selectedValueEntitasAtasan!);
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
            child: validationMessages['Entitas Atasan'] != null
                ? validateContainer('Entitas Atasan')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistNrpHCGS() {
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
                  style: TextStyle(fontSize: 11),
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
              value: selectedValueNrpHCGS,
              items: selectedNrpHCGS.isNotEmpty
                  ? selectedNrpHCGS.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['pernr'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['nama'] + ' - ' + value['pernr'].toString() ??
                                '',
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
                if (!_isLoadingNrpHCGS && selectedNrpHCGS.isEmpty) return;
                selectedValueEntitasHCGS != null
                    ? setState(() {
                        selectedValueNrpHCGS = newValue;
                        departemenHCGS = selectedNrpHCGS.firstWhere(
                            (dataUser) =>
                                dataUser['pernr'] ==
                                selectedValueNrpHCGS)['organizational_unit'];
                        jabatanHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                            dataUser['pernr'] ==
                            selectedValueNrpHCGS)['position'];
                        namaHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                            dataUser['pernr'] == selectedValueNrpHCGS)['nama'];
                        debugPrint(
                            'selectedValueNrpHCGS $selectedValueNrpHCGS');
                      })
                    : null;
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
                    color: selectedValueNrpHCGS != null
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
            child: validationMessages['Nama HCGS'] != null
                ? validateContainer('Nama HCGS')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistNrpAtasan() {
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
                  style: TextStyle(fontSize: 11),
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
              value: selectedValueNrpAtasan,
              items: selectedNrpAtasan.isNotEmpty
                  ? selectedNrpAtasan.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['pernr'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['nama'] + ' - ' + value['pernr'].toString() ??
                                '',
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
                if (!_isLoadingNrpAtasan && selectedNrpAtasan.isEmpty) return;
                selectedValueEntitasAtasan != null
                    ? setState(() {
                        selectedValueNrpAtasan = newValue;
                        departemenAtasan = selectedNrpAtasan.firstWhere(
                            (dataUser) =>
                                dataUser['pernr'] ==
                                selectedValueNrpAtasan)['organizational_unit'];
                        jabatanAtasan = selectedNrpAtasan.firstWhere(
                            (dataUser) =>
                                dataUser['pernr'] ==
                                selectedValueNrpAtasan)['position'];
                        namaAtasan = selectedNrpAtasan.firstWhere((dataUser) =>
                            dataUser['pernr'] ==
                            selectedValueNrpAtasan)['nama'];
                        debugPrint(
                            'selectedValueNrpAtasan $selectedValueNrpAtasan');
                      })
                    : null;
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
                    color: selectedValueNrpAtasan != null
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

    Widget dropdownlistJenisIzin() {
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
                  'Pilih Jenis Izin Keluar',
                  style: TextStyle(fontSize: 11),
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
              value: selectedValueJenisIzin,
              items: selectedJenisIzin.isNotEmpty
                  ? selectedJenisIzin.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['jenis_izin'].toString(),
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
                  if (newValue == '1') {
                    selectedValueJenisIzin = newValue;
                    selectedValueKaryawan = null;
                    formDataList.clear();
                  } else if (newValue == '2') {
                    selectedValueJenisIzin = newValue;
                  }
                  debugPrint('selectedValueJenisIzin: $selectedValueJenisIzin');
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
                    color: selectedValueJenisIzin != null
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
            child: validationMessages['Jenis Izin'] != null
                ? validateContainer('Jenis Izin')
                : null,
          ),
        ],
      );
    }

    bool isKaryawanInFormDataList(String pernr) {
      for (var formData in formDataList) {
        if (formData['karyawan']['pernr'] == pernr) {
          return true;
        }
      }
      return false;
    }

    Widget dropdownlistKaryawan() {
      List<Map<String, dynamic>> filteredKaryawan =
          selectedKaryawan.where((karyawan) {
        return !isKaryawanInFormDataList(karyawan['pernr']);
      }).toList();

      return Column(
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
                'Surat Izin Keluar',
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
                        child: buildHeading(title: 'Diajukan Oleh:'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
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
                        child: buildTextField(
                            controller: _nrpNamaController,
                            loading: _isLoadingUser),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Jabatan Penerima'),
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
                        child: buildTextField(
                            controller: _positionController,
                            loading: _isLoadingUser),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading(title: 'Diajukan Kepada:'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
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
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      dropdownlistEntitasHCGS(),
                      SizedBox(
                        height: sizedBoxHeightTall,
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
                          )),
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
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      dropdownlistNrpHCGS(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
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
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      dropdownlistNrpAtasan(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading(title: 'Detail Izin Keluar:'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Tanggal'),
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
                        onPressed: formDataList.isEmpty
                            ? () {
                                _selectDateIzinKeluar(context);
                              }
                            : null,
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
                                    .format(selectedDateIzinKeluar),
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
                      IgnorePointer(
                        ignoring: formDataList.isNotEmpty,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: buildCheckbox(
                                'Kembali Ke Kantor',
                                selectedCheckboxKembaliKeKantor == 'Kembali',
                                (newValue) => onCheckboxChangedKembaliKeKantor(
                                    'Kembali', newValue),
                                color: Colors.red)),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Jam Keluar'),
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
                        onPressed: formDataList.isEmpty
                            ? () {
                                _selectTimeKeluar(context);
                              }
                            : null,
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
                                selectedTimeJamKeluar.format(context),
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
                      if (selectedCheckboxKembaliKeKantor == 'Kembali') ...[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: Row(
                            children: [
                              buildTitle(title: 'Jam Kembali'),
                              if (selectedCheckboxKembaliKeKantor ==
                                  'Kembali') ...[
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
                              ]
                            ],
                          ),
                        ),
                        CupertinoButton(
                          onPressed: formDataList.isEmpty
                              ? () {
                                  _selectTimeKembali(context);
                                }
                              : null,
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
                                  selectedTimeJamKembali.format(context),
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
                      ],
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: Row(
                            children: [
                              buildTitle(title: 'Jenis Izin Keluar'),
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
                          )),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      IgnorePointer(
                        ignoring: formDataList.isNotEmpty,
                        child: dropdownlistJenisIzin(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            buildTitle(title: 'Keperluan'),
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
                      IgnorePointer(
                        ignoring: formDataList.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildCheckbox(
                                    'Dinas',
                                    selectedCheckboxKeperluan == 'Dinas',
                                    (newValue) => onCheckboxChangedKeperluan(
                                        'Dinas', newValue),
                                  ),
                                  buildCheckbox(
                                    'Pribadi',
                                    selectedCheckboxKeperluan == 'Pribadi',
                                    (newValue) => onCheckboxChangedKeperluan(
                                        'Pribadi', newValue),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildCheckbox(
                                    'Sakit',
                                    selectedCheckboxKeperluan == 'Sakit',
                                    (newValue) => onCheckboxChangedKeperluan(
                                        'Sakit', newValue),
                                  ),
                                  buildCheckbox(
                                    'Lainnya',
                                    selectedCheckboxKeperluan == 'Lainnya',
                                    (newValue) => onCheckboxChangedKeperluan(
                                        'Lainnya', newValue),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: paddingHorizontalNarrow),
                                    child:
                                        validationMessages['Keperluan'] != null
                                            ? validateContainer('Keperluan')
                                            : null,
                                  ),
                                ],
                              ),
                            ],
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
                              buildTitle(title: 'Keterangan'),
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
                          )),
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
                            if (validationMessages['Keterangan'] != null)
                              validateContainer('Keterangan'),
                          ],
                        ),
                      ),
                      if (selectedValueJenisIzin == '2') ...[
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: Row(
                              children: [
                                buildTitle(title: 'Karyawan'),
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
                            )),
                        SizedBox(
                          height: sizedBoxHeightShort,
                        ),
                        dropdownlistKaryawan(),
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
                      ],
                      if (selectedValueJenisIzin == '2' &&
                          formDataList.isNotEmpty) ...[
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
                                      "Karyawan",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Tanggal",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Jam Keluar",
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Jam Kembali",
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
                                    DataCell(Text(
                                        '${data['karyawan']['nama']} - ${data['karyawan']['pernr']}')),
                                    DataCell(Text(DateFormat('dd-MM-yyyy')
                                        .format(data['tanggal']))),
                                    DataCell(Text(data['jam_keluar'])),
                                    DataCell(Text(data['jam_kembali'] ?? '-')),
                                    DataCell(Text(data['keterangan'])),
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
                        height: sizedBoxHeightTall,
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

  Widget buildTitle({required String title}) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return TitleWidget(
      title: title,
      fontWeight: FontWeight.w300,
      fontSize: textMedium,
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      bool enabled = false,
      bool loading = false}) {
    return TextFormField(
      style: const TextStyle(fontSize: 12),
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: loading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                    height: 5,
                    width: 5,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        enabled: enabled,
        hintText: '---',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> onCheckboxChangedKembaliKeKantor(
      String label, bool? newValue) async {
    setState(() {
      if (newValue == true) {
        selectedCheckboxKembaliKeKantor = label;
      } else {
        selectedCheckboxKembaliKeKantor = null;
      }
    });
  }

  Future<void> onCheckboxChangedKeperluan(String label, bool? newValue) async {
    setState(() {
      if (newValue == true) {
        selectedCheckboxKeperluan = label;
      } else {
        selectedCheckboxKeperluan = null;
      }
    });
  }

  Widget buildCheckbox(String label, bool? value, Function(bool?) onChanged,
      {Color? color = Colors.black}) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: onChanged,
        ),
        TitleWidget(
            title: label,
            fontWeight: FontWeight.w300,
            fontSize: textMedium,
            fontColor: color),
      ],
    );
  }
}
