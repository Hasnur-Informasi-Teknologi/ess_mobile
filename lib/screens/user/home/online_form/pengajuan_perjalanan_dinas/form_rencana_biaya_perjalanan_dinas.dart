import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormRencanaBiayaPerjalananDinas extends StatefulWidget {
  const FormRencanaBiayaPerjalananDinas({super.key});

  @override
  State<FormRencanaBiayaPerjalananDinas> createState() =>
      _FormRencanaBiayaPerjalananDinasState();
}

class _FormRencanaBiayaPerjalananDinasState
    extends State<FormRencanaBiayaPerjalananDinas> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> selectedEntitasHCGS = [];
  String? selectedValueEntitasHCGS;
  List<Map<String, dynamic>> selectedNrpHCGS = [];
  String? selectedValueNrpHCGS;
  String? namaHCGS;
  String? departemenHCGS;
  String? positionHCGS;
  final _namaHCGSController = TextEditingController();
  final _jabatanHCGSController = TextEditingController();

  List<Map<String, dynamic>> selectedEntitasAtasan = [];
  String? selectedValueEntitasAtasan;
  List<Map<String, dynamic>> selectedNrpAtasan = [];
  String? selectedValueNrpAtasan;
  String? namaAtasan;
  String? departemenAtasan;
  String? positionAtasan;
  final _namaAtasanController = TextEditingController();
  final _jabatanAtasanController = TextEditingController();
  final _perihalController = TextEditingController();

  // Sesi 2
  List<Map<String, dynamic>> selectedTrip = [];
  String? selectedValueTrip;
  String? entitasUser;
  final _namaController = TextEditingController();
  final _nrpNamaController = TextEditingController();
  final _departemenController = TextEditingController();
  final _positionController = TextEditingController();
  final _tempatTujuanController = TextEditingController();
  List<Map<String, dynamic>> selectedNegara = [];
  String? selectedValueNegara;
  late DateTime selectedDateBerangkat;
  late TimeOfDay selectedTimeBerangkat;
  late DateTime selectedDateKembali;
  late TimeOfDay selectedTimeKembali;
  bool? _isKasbon = false;
  bool? _isNonKasbon = false;

  // Sesi 3
  List<Map<String, dynamic>> formDataList = [];
  List<String?> selectedValueKategori = [];
  List<Map<String, dynamic>> selectedKategori = [];
  List<String?> selectedValueAkomodasi = [];
  List<Map<String, dynamic>> selectedAkomodasi = [];
  List<DateRangePickerController> dateTglMulaiControllers = [];
  List<DateRangePickerController> dateTglSelesaiControllers = [];
  List<String?> selectedValueTipe = [];
  List<Map<String, dynamic>> selectedTipe = [];
  final _nilaiController = TextEditingController();

  final double _maxHeightNama = 40.0;
  final String apiUrl = API_URL;
  bool _isLoading = false;
  bool _isLoadingNrpHCGS = false;
  bool _isLoadingNrpAtasan = false;
  Timer? _debounce;

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

  String formatDate(DateTime? date, TimeOfDay? time, {bool isoFormat = false}) {
    if (date == null) return '';
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    if (isoFormat && time != null) {
      String hour = time.hour.toString().padLeft(2, '0');
      String minute = time.minute.toString().padLeft(2, '0');
      return '${date.year}-$month-$day' 'T$hour:$minute';
    } else {
      return '${date.year}-$month-$day';
    }
  }

  void debounceVoidCallback(VoidCallback callback, {int milliseconds = 500}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: milliseconds), callback);
  }

  void updateTotalNilai() {
    int total = 0;
    for (int i = 0; i < formDataList.length; i++) {
      if (selectedValueTipe[i] == "1") {
        String nilaiText = formDataList[i]["nilai"].text;
        int nilai = int.tryParse(nilaiText) ?? 0;
        total += nilai;
      }
    }
    _nilaiController.text = total.toStringAsFixed(0);
  }

  Future<void> _updateActivityDates({required String keyField}) async {
    for (var report in formDataList) {
      DateTime tanggal = DateTime.parse(report[keyField]);
      if (tanggal.isBefore(selectedDateBerangkat) ||
          tanggal.isAfter(selectedDateKembali)) {
        report[keyField] = selectedDateBerangkat.toString();
      }
    }
  }

  Future<void> _selectDateTimeBerangkat(BuildContext context) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateBerangkat,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null && mounted) {
      if (pickedDate.isAfter(selectedDateKembali)) {
        Get.snackbar(
          "Waktu Tidak Valid",
          "Tanggal berangkat tidak boleh setelah tanggal kembali",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
        return;
      }

      pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeBerangkat,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateBerangkat = pickedDate!;
          selectedTimeBerangkat = pickedTime!;
          _updateActivityDates(keyField: "tglMulai");
        });
      }
    }
  }

  Future<void> _selectDateTimeKembali(BuildContext context) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateKembali,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null && mounted) {
      if (pickedDate.isBefore(selectedDateBerangkat)) {
        Get.snackbar(
          "Waktu Tidak Valid",
          "Tanggal kembali tidak boleh sebelum tanggal berangkat",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
        return;
      }

      pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeKembali,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateKembali = pickedDate!;
          selectedTimeKembali = pickedTime!;
          _updateActivityDates(keyField: "tglSelesai");
        });
      }
    }
  }

  Future<void> getDataMaster() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse("$apiUrl/rencana-perdin/master_data"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final dataEntitasHCGS = responseData['entitas'];
        final dataEntitasAtasan = responseData['entitas'];
        final dataTipe = responseData['tipe'];
        final dataNegara = responseData['negara'];
        final dataKategori = responseData['kategori'];
        final dataAkomodasi = responseData['akomodasi'];
        final dataTrip = responseData['trip_activity'];
        setState(() {
          selectedEntitasHCGS = List<Map<String, dynamic>>.from(
            dataEntitasHCGS,
          );
          selectedEntitasAtasan = List<Map<String, dynamic>>.from(
            dataEntitasAtasan,
          );
          selectedTrip = List<Map<String, dynamic>>.from(
            dataTrip,
          );
          selectedNegara = List<Map<String, dynamic>>.from(
            dataNegara,
          );
          selectedKategori = List<Map<String, dynamic>>.from(
            dataKategori,
          );
          selectedAkomodasi = List<Map<String, dynamic>>.from(
            dataAkomodasi,
          );
          selectedTipe = List<Map<String, dynamic>>.from(
            dataTipe,
          );
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse("$apiUrl/master/profile/get_employee"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          entitasUser = data['cocd'] ?? '';
          _namaController.text = data['pt'] ?? '';
          _nrpNamaController.text = data['pernr'] + ' - ' + data['nama'];
          _positionController.text = data['position'] ?? '';
          _departemenController.text = data['organizational_unit'] ?? '';
        });
      } catch (e) {
        rethrow;
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
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
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
          _isLoadingNrpHCGS = false;
        });
      } catch (e) {
        setState(() {
          _isLoadingNrpHCGS = false;
        });
        rethrow;
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
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
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
          _isLoadingNrpAtasan = false;
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> words = extractWords(_nrpNamaController.text);

    setState(() {
      _isLoading = true;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/rencana-perdin/add'),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['departement_atasan'] = departemenAtasan.toString();
    request.fields['departement_hrgs'] = departemenHCGS.toString();
    request.fields['department_user'] = _departemenController.text;
    request.fields['entitas_atasan'] = selectedValueEntitasAtasan.toString();
    request.fields['entitas_hrgs'] = selectedValueEntitasHCGS.toString();
    request.fields['entitas_name_user'] = _namaController.text;
    request.fields['entitas_user'] = entitasUser.toString();
    request.fields['id_negara'] = selectedValueNegara.toString();
    request.fields['jabatan_atasan'] = _jabatanAtasanController.text;
    request.fields['jabatan_hrgs'] = _jabatanHCGSController.text;
    request.fields['jabatan_user'] = _positionController.text;
    request.fields['jenis_biaya'] = _isKasbon == true ? '0' : '1';
    request.fields['nama_atasan'] = _namaAtasanController.text;
    request.fields['nama_hrgs'] = _namaHCGSController.text;
    request.fields['nama_user'] = words['secondWord']!;
    request.fields['nrp_atasan'] = selectedValueNrpAtasan.toString();
    request.fields['nrp_hrgs'] = selectedValueNrpHCGS.toString();
    request.fields['nrp_user'] = words['firstWord']!;
    request.fields['perihal'] = _perihalController.text;
    request.fields['tempat_tujuan'] = _tempatTujuanController.text;
    request.fields['tgl_berangkat'] = formatDate(
        selectedDateBerangkat, selectedTimeBerangkat,
        isoFormat: true);
    request.fields['tgl_kembali'] = formatDate(
      selectedDateKembali,
      selectedTimeKembali,
      isoFormat: true,
    );
    request.fields['total_nilai'] = _nilaiController.text.toString();
    request.fields['vtable'] = jsonEncode(formDataList
        .asMap()
        .map((index, formData) {
          return MapEntry(index, {
            "id_kategori": selectedValueKategori[index],
            "id_akomodasi": selectedValueAkomodasi[index],
            "tgl_mulai":
                formatDate(dateTglMulaiControllers[index].selectedDate, null),
            "tgl_berakhir":
                formatDate(dateTglSelesaiControllers[index].selectedDate, null),
            "id_tipe": selectedValueTipe[index],
            "keterangan": formData["keterangan"].text,
            "nilai": formData["nilai"].text,
            "selected": false,
          });
        })
        .values
        .toList());

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
        Get.offAllNamed(
            '/user/main/home/online_form/pengajuan_perjalanan_dinas');
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
    setState(() {
      formDataList.add({
        "nilai": TextEditingController(),
        "keterangan": TextEditingController(),
      });
      dateTglMulaiControllers.add(DateRangePickerController());
      dateTglSelesaiControllers.add(DateRangePickerController());
      selectedValueKategori.add(null);
      selectedValueAkomodasi.add(null);
      selectedValueTipe.add(null);
    });
  }

  void removeFormData(int index) {
    setState(() {
      formDataList.removeAt(index);
      dateTglMulaiControllers.removeAt(index);
      dateTglSelesaiControllers.removeAt(index);
      selectedValueKategori[index] = null;
      selectedValueAkomodasi[index] = null;
      selectedValueTipe[index] = null;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataMaster();
    getDataUser();
    selectedDateBerangkat = DateTime.now();
    selectedTimeBerangkat = TimeOfDay.now();
    selectedDateKembali = DateTime.now();
    selectedTimeKembali = TimeOfDay.now();
  }

  @override
  void dispose() {
    for (var element in formDataList) {
      element['nilai'].dispose();
      element['keterangan'].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdownlistEntitasHCGS() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Entitas HCGS',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueEntitasHCGS,
          icon: selectedEntitasHCGS.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueEntitasHCGS = newValue!;
              debugPrint('selectedValueEntitasHCGS $selectedValueEntitasHCGS');
              getDataNrpHCGS(selectedValueEntitasHCGS!);
            });
          },
          items: selectedEntitasHCGS.map((value) {
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
          }).toList(),
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
      );
    }

    Widget dropdownlistEntitasAtasan() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Entitas Atasan',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueEntitasAtasan,
          icon: selectedEntitasAtasan.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueEntitasAtasan = newValue!;
              debugPrint(
                  'selectedValueEntitasAtasan $selectedValueEntitasAtasan');
              getDataNrpAtasan(selectedValueEntitasAtasan!);
            });
          },
          items: selectedEntitasAtasan.map((value) {
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
          }).toList(),
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
      );
    }

    Widget dropdownlistNrpHCGS() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Nama - NRP HCGS',
              style: TextStyle(fontSize: 11),
            ),
          ),
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
                        value['nama'] + ' - ' + value['pernr'].toString() ?? '',
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
                    namaHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                        dataUser['pernr'] == selectedValueNrpHCGS)['nama'];
                    positionHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                        dataUser['pernr'] == selectedValueNrpHCGS)['position'];
                    _namaHCGSController.text = namaHCGS.toString();
                    departemenHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                        dataUser['pernr'] ==
                        selectedValueNrpHCGS)['organizational_unit'];
                    _jabatanHCGSController.text = positionHCGS.toString();
                    debugPrint('selectedValueNrpHCGS $selectedValueNrpHCGS');
                    debugPrint('_namaHCGSController $namaHCGS');
                    debugPrint('departemenHCGS $departemenHCGS');
                    debugPrint('_jabatanHCGSController $positionHCGS');
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
      );
    }

    Widget dropdownlistNrpAtasan() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Nama - NRP Atasan',
              style: TextStyle(fontSize: 11),
            ),
          ),
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
                        value['nama'] + ' - ' + value['pernr'].toString() ?? '',
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
                    namaAtasan = selectedNrpAtasan.firstWhere((dataUser) =>
                        dataUser['pernr'] == selectedValueNrpAtasan)['nama'];
                    departemenAtasan = selectedNrpAtasan.firstWhere(
                        (dataUser) =>
                            dataUser['pernr'] ==
                            selectedValueNrpAtasan)['organizational_unit'];
                    positionAtasan = selectedNrpAtasan.firstWhere((dataUser) =>
                        dataUser['pernr'] ==
                        selectedValueNrpAtasan)['position'];
                    _jabatanAtasanController.text = positionAtasan.toString();
                    _namaAtasanController.text = namaAtasan.toString();
                    debugPrint(
                        'selectedValueNrpAtasan $selectedValueNrpAtasan');
                    debugPrint('_namaAtasanController $namaAtasan');
                    debugPrint('departemenAtasan $departemenAtasan');
                    debugPrint('_jabatanAtasanController $positionAtasan');
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
      );
    }

    Widget dropdownlistTrip() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Trip Activity',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueTrip,
          icon: selectedTrip.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueTrip = newValue;
              debugPrint('selectedValueTrip $selectedValueTrip');
            });
          },
          items: selectedTrip.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["id"].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama"] as String,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
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
                color: selectedValueTrip != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget dropdownlistNegara() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Negara',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueNegara,
          icon: selectedNegara.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueNegara = newValue;
              debugPrint('selectedValueNegara $selectedValueNegara');
            });
          },
          items: selectedNegara.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["kode_negara"].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama_negara"] as String,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
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
                color: selectedValueNegara != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget dropdownlistKategori(int index) {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Kategori',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueKategori[index],
          icon: selectedKategori.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueKategori[index] = newValue!;
              debugPrint('selectedValueKategori $selectedValueKategori');
              selectedValueAkomodasi[index] = null;
            });
          },
          items: selectedKategori.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["id"].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama"] as String,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
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
                color: selectedValueKategori[index] != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget dropdownlistAkomodasi(int index) {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
      List<Map<String, dynamic>> filteredAkomodasi = [];
      filteredAkomodasi = selectedAkomodasi
          .where((akomodasi) =>
              akomodasi['kategori_id'].toString() ==
              selectedValueKategori[index])
          .toList();

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
              'Pilih Akomodasi',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueAkomodasi[index],
          icon: selectedAkomodasi.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueAkomodasi[index] = newValue!;
              debugPrint('selectedValueAkomodasi $selectedValueAkomodasi');
            });
          },
          items: filteredAkomodasi.map((akomodasi) {
            return DropdownMenuItem<String>(
              value: akomodasi["id"].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  akomodasi["nama"] as String,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
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
                color: selectedValueAkomodasi[index] != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget dropdownTglMulai(int index) {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
      double textMedium = size.width * 0.0329;

      return CupertinoButton(
        child: Container(
          height: 50,
          width: 250,
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontalNarrow,
          ),
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
                dateTglMulaiControllers[index].selectedDate != null
                    ? DateFormat('dd-MM-yyyy')
                        .format(dateTglMulaiControllers[index].selectedDate!)
                    : 'Pilih Tanggal',
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
                content: SizedBox(
                  height: 350,
                  width: 350,
                  child: SfDateRangePicker(
                    minDate: selectedDateBerangkat,
                    maxDate: selectedDateKembali,
                    controller: dateTglMulaiControllers[index],
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      setState(() {
                        dateTglMulaiControllers[index].selectedDate =
                            args.value;
                        debugPrint(
                            'dateTglMulaiControllers[index].selectedDate ${args.value}');
                      });
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    Widget dropdownTglSelesai(int index) {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
      double textMedium = size.width * 0.0329;

      return CupertinoButton(
        child: Container(
          height: 50,
          width: 250,
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontalNarrow,
          ),
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
                dateTglSelesaiControllers[index].selectedDate != null
                    ? DateFormat('dd-MM-yyyy')
                        .format(dateTglSelesaiControllers[index].selectedDate!)
                    : 'Pilih Tanggal',
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
                content: SizedBox(
                  height: 350,
                  width: 350,
                  child: SfDateRangePicker(
                    minDate: selectedDateBerangkat,
                    maxDate: selectedDateKembali,
                    controller: dateTglSelesaiControllers[index],
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      setState(() {
                        dateTglSelesaiControllers[index].selectedDate =
                            args.value;
                        debugPrint(
                            'dateTglSelesaiControllers[index].selectedDate ${args.value}');
                      });
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    Widget dropdownlistTipe(int index) {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
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
              'Pilih Tipe',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueTipe[index],
          icon: selectedTipe.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueTipe[index] = newValue!;
              updateTotalNilai();
              debugPrint('selectedValueTipe $selectedValueTipe');
            });
          },
          items: selectedTipe.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["id"].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama"] as String,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
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
                color: selectedValueTipe[index] != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget buildForm() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalWide = size.width * 0.0585;
      double textMedium = size.width * 0.0329;

      return SizedBox(
        height: formDataList.isEmpty ? 0 : size.width,
        child: ListView.builder(
          itemCount: formDataList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> form = formDataList[index];
            TextEditingController nilai = form["nilai"];
            TextEditingController keterangan = form["keterangan"];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 49),
                              child: TitleWidget(
                                title: 'Kategori',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: dropdownlistKategori(index),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: TitleWidget(
                                title: 'Akomodasi',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: dropdownlistAkomodasi(index),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: TitleWidget(
                                title: 'Tgl Mulai',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: dropdownTglMulai(index),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: TitleWidget(
                                title: 'Tgl Selesai',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: dropdownTglSelesai(index),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 80),
                              child: TitleWidget(
                                title: 'Tipe',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          Expanded(
                            child: dropdownlistTipe(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: TitleWidget(
                                title: 'Nilai',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, left: 70),
                              child: TextFormFieldWidget(
                                controller: nilai,
                                maxHeightConstraints: _maxHeightNama,
                                hintText: '',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[0-9]*$'))
                                ],
                                onChanged: (value) {
                                  debounceVoidCallback(() {
                                    updateTotalNilai();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: TitleWidget(
                                title: 'Keterangan',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              )),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, left: 25),
                              child: TextFormFieldWidget(
                                controller: keterangan,
                                maxHeightConstraints: _maxHeightNama,
                                hintText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => removeFormData(index),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

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
                'Form Internal Memo',
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
                        child: TitleWidget(
                          title: 'Entitas HCGS',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                        child: TitleWidget(
                          title: 'Entitas Atasan',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                        child: TitleWidget(
                          title: 'Nama - NRP HCGS',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                        child: TitleWidget(
                          title: 'Nama - NRP Atasan',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                        child: TitleWidget(
                          title: 'Jabatan HCGS',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                          controller: _jabatanHCGSController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Jabatan HCGS',
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
                        child: TitleWidget(
                          title: 'Jabatan Atasan',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                          controller: _jabatanAtasanController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Jabatan Atasan',
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
                        child: TitleWidget(
                          title: 'Perihal',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                          controller: _perihalController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            hintText: 'Perihal',
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
                        child: const TitleWidget(
                            title: 'Fasilitas Diberikan Kepada'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Trip Activity',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      dropdownlistTrip(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Entitas Penerima',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                          controller: _namaController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Pilih Nama HCGS',
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
                        child: TitleWidget(
                          title: 'NRP/Nama Penerima',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
                            hintText: 'Pilih Nama HCGS',
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
                        child: TitleWidget(
                          title: 'Department Penerima',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                          controller: _departemenController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
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
                        child: TitleWidget(
                          title: 'Jabatan Penerima',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                          controller: _positionController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabled: false,
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
                        child: TitleWidget(
                          title: 'Tempat Tujuan',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFieldWidget(
                          controller: _tempatTujuanController,
                          maxHeightConstraints: _maxHeightNama,
                          hintText: '',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Negara',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      dropdownlistNegara(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Tanggal Berangkat',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
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
                                '${selectedDateBerangkat.day}-${selectedDateBerangkat.month}-${selectedDateBerangkat.year}-${selectedTimeBerangkat.format(context)}',
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
                          _selectDateTimeBerangkat(context);
                        },
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Tanggal Kembali',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
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
                                '${selectedDateKembali.day}-${selectedDateKembali.month}-${selectedDateKembali.year}-${selectedTimeKembali.format(context)}',
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
                          _selectDateTimeKembali(context);
                        },
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Jenis Pangajuan Biaya',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCheckbox('Kasbon', _isKasbon),
                          buildCheckbox('Non Kasbon', _isNonKasbon),
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LineWidget(),
                            SizedBox(
                              height: sizedBoxHeightTall,
                            ),
                            RowWithButtonWidget(
                              textLeft: 'Biaya Perjalanan Dinas',
                              textRight: 'Tambah Biaya',
                              fontSizeLeft: textMedium,
                              fontSizeRight: textSmall,
                              onTab: () {
                                addFormData();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      buildForm(),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total'),
                            Text(
                              _nilaiController.text,
                            ),
                          ],
                        ),
                      ),
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
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildCheckbox(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isKasbon = label == 'Kasbon' ? newValue : false;
              _isNonKasbon = label == 'Non Kasbon' ? newValue : false;
            });
          },
        ),
        TitleWidget(
          title: label,
          fontWeight: FontWeight.w300,
          fontSize: textMedium,
        ),
      ],
    );
  }
}
