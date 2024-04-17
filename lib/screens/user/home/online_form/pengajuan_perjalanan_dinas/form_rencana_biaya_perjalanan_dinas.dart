import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/models/form_rencana_biaya_model.dart';

class FormRencanaBiayaPerjalananDinas extends StatefulWidget {
  const FormRencanaBiayaPerjalananDinas({super.key});

  @override
  State<FormRencanaBiayaPerjalananDinas> createState() =>
      _FormRencanaBiayaPerjalananDinasState();
}

class _FormRencanaBiayaPerjalananDinasState
    extends State<FormRencanaBiayaPerjalananDinas> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _namaAtasanController = TextEditingController();
  final _namaHCGSController = TextEditingController();
  final _nrpNamaController = TextEditingController();
  final _positionController = TextEditingController();
  final _departemenController = TextEditingController();
  final _tempatTujuanController = TextEditingController();
  final _nilaiController = TextEditingController();
  final _jabatanHCGSController = TextEditingController();
  final _jabatanAtasanController = TextEditingController();
  final double _maxHeightNama = 40.0;
  final String apiUrl = API_URL;
  DateTime selectedDateMulai = DateTime.now();
  DateTime selectedDateSelesai = DateTime.now();
  late DateTime selectedDateBerangkat;
  late TimeOfDay selectedTimeBerangkat;
  late DateTime selectedDateKembali;
  late TimeOfDay selectedTimeKembali;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  List<FormDataBiaya> formDataList = [];
  List<Map<String, dynamic>> selectedAkomodasi = [];
  List<Map<String, dynamic>> selectedKategori = [];
  List<Map<String, dynamic>> selectedTipe = [];
  List<Map<String, dynamic>> selectedEntitasHCGS = [];
  List<Map<String, dynamic>> selectedNrpHCGS = [];
  List<Map<String, dynamic>> selectedEntitasAtasan = [];
  List<Map<String, dynamic>> selectedNrpAtasan = [];
  List<Map<String, dynamic>> selectedUnit = [];
  List<Map<String, dynamic>> selectedTrip = [];
  List<Map<String, dynamic>> selectedNegara = [];

  String? selectedValueAkomodasi,
      selectedValueKategori,
      selectedValueTipe,
      selectedValueEntitasHCGS,
      selectedValueEntitasAtasan,
      selectedValueUnit,
      selectedValueTrip,
      selectedValueNegara,
      selectedValueNrpHCGS,
      selectedValueNrpAtasan,
      positionHCGS,
      positionAtasan,
      namaAtasan,
      namaHCGS;

  Future<void> _selectDateTimeBerangkat(BuildContext context) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    // Step 1: Pilih tanggal
    pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateBerangkat,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null) {
      // Step 2: Pilih waktu jika tanggal dipilih
      pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeBerangkat,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateBerangkat = pickedDate!;
          selectedTimeBerangkat = pickedTime!;
        });
      }
    }
  }

  Future<void> _selectDateTimeKembali(BuildContext context) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    // Step 1: Pilih tanggal
    pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateKembali,
      firstDate: DateTime(2022),
      lastDate: DateTime(5022),
    );

    if (pickedDate != null) {
      // Step 2: Pilih waktu jika tanggal dipilih
      pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTimeKembali,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateKembali = pickedDate!;
          selectedTimeKembali = pickedTime!;
        });
      }
    }
  }

  Future<void> getDataMaster() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/rencana-perdin/master_data"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final dataKategori = responseData['kategori'];
        final dataAkomodasi = responseData['akomodasi'];
        final dataTrip = responseData['trip_activity'];
        final dataEntitasHCGS = responseData['entitas'];
        final dataEntitasAtasan = responseData['entitas'];
        final dataTipe = responseData['tipe'];
        final dataNegara = responseData['negara'];
        setState(() {
          selectedKategori = List<Map<String, dynamic>>.from(
            dataKategori,
          );
          selectedTrip = List<Map<String, dynamic>>.from(
            dataTrip,
          );
          selectedEntitasHCGS = List<Map<String, dynamic>>.from(
            dataEntitasHCGS,
          );
          selectedEntitasAtasan = List<Map<String, dynamic>>.from(
            dataEntitasAtasan,
          );
          selectedAkomodasi = List<Map<String, dynamic>>.from(
            dataAkomodasi,
          );
          selectedTipe = List<Map<String, dynamic>>.from(
            dataTipe,
          );
          selectedNegara = List<Map<String, dynamic>>.from(
            dataNegara,
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
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
          _namaController.text = data['pt'] ?? '';
          _nrpNamaController.text = data['pernr'] + ' - ' + data['nama'];
          _positionController.text = data['position'] ?? '';
          _departemenController.text = data['organizational_unit'] ?? '';
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataNrpHCGS(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/master/daftar_karyawan?entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        // print(data);
        setState(() {
          selectedNrpHCGS = List<Map<String, dynamic>>.from(
            data,
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataNrpAtasan(String entitasCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/master/daftar_karyawan?entitas=$entitasCode"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        // print(data);
        setState(() {
          selectedNrpAtasan = List<Map<String, dynamic>>.from(
            data,
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _selectDateMulai(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateMulai,
      firstDate: DateTime(2020),
      lastDate: DateTime(5301),
    );
    if (picked != null && picked != selectedDateMulai)
      setState(() {
        selectedDateMulai = picked;
      });
  }

  Future<void> _selectDateSelesai(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateSelesai,
      firstDate: DateTime(2020),
      lastDate: DateTime(5301),
    );
    if (picked != null && picked != selectedDateSelesai)
      setState(() {
        selectedDateSelesai = picked;
      });
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    bool _isLoading = false;
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState!.save();
    try {
      List<Map<String, dynamic>> jsonDataList = formDataList.map((formData) {
        return {
          'kategori': formData.kategori,
          'akomodasi': formData.akomodasi,
          'tglMulai': formData.tglMulai.toIso8601String(),
          'tglSelesai': formData.tglSelesai.toIso8601String(),
          'tipe': formData.tipe,
          'nilai': formData.nilai,
        };
      }).toList();

      final response = await http.post(
        Uri.parse('$apiUrl/rencana-perdin/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'vtable': jsonDataList,
          'departement_atasan': selectedValueEntitasAtasan.toString(),
          'departement_hrgs': selectedValueEntitasHCGS.toString(),
          'department_user': _departemenController.text,
          'entitas_atasan': selectedValueEntitasAtasan.toString(),
          'entitas_name_user': _nrpNamaController.text,
          'entitas_hrgs': selectedValueEntitasHCGS.toString(),
          'entitas_user': _namaController.text,
          'entitas_kode': selectedValueEntitasHCGS.toString(),
          'id_negara': selectedValueNegara.toString(),
          'jabatan_atasan': _jabatanAtasanController.text,
          'jabatan_hrgs': _jabatanHCGSController.text,
          'jabatan_user': _positionController.text,
          'jenis_biaya': _isKasbon == true ? '0' : '1',
          'nama_atasan': _namaAtasanController.text,
          'nama_hrgs': _namaHCGSController.text,
          'nama_user': _namaController.text,
          'nrp_atasan': selectedValueNrpAtasan.toString(),
          'nrp_hrgs': selectedValueNrpHCGS.toString(),
          'nrp_user': _nrpNamaController.text,
          'tempat_tujuan': _tempatTujuanController.text,
          'tgl_berangkat': selectedDateBerangkat != null
              ? selectedDateBerangkat.toString()
              : DateTime.now().toString(),
          'tgl_kembali': selectedDateKembali != null
              ? selectedDateKembali.toString()
              : DateTime.now().toString(),
          'total_nilai': _nilaiController.text.toString(),
        }),
      );
      final responseData = jsonDecode(response.body);
      Get.snackbar('Infomation', responseData['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      print(responseData);
      if (responseData['status'] == 'success') {
        Get.offAllNamed('/user/main');
      }
    } catch (e) {
      print(e);
      throw e;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addFormData() {
    setState(() {
      formDataList.add(FormDataBiaya(
        kategori: '',
        akomodasi: '',
        tglMulai: DateTime.now(),
        tglSelesai: DateTime.now(),
        tipe: '',
        nilai: '',
      ));
    });
  }

  void removeFormData(int index) {
    setState(() {
      formDataList.removeAt(index);
    });
  }

  void refreshPage() {
    setState(() {});
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

  bool? _isKasbon = false;
  bool? _isNonKasbon = false;

  @override
  Widget build(BuildContext context) {
    Widget dropdownlistKategori() {
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Kategori',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueKategori,
          icon: selectedKategori.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueKategori = newValue;
              selectedValueAkomodasi = null;
              print(selectedValueKategori);
            });
          },
          items: selectedKategori.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["id"].toString() as String,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama"] as String,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: const TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: selectedValueKategori != null
                    ? Colors.transparent
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget dropdownlistAkomodasi() {
      Size size = MediaQuery.of(context).size;
      double paddingHorizontalNarrow = size.width * 0.035;
      List<Map<String, dynamic>> filteredAkomodasi = [];
      if (selectedValueKategori != null) {
        filteredAkomodasi = selectedAkomodasi
            .where((akomodasi) =>
                akomodasi['kategori_id'].toString() == selectedValueKategori)
            .toList();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonFormField<String>(
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Akomodasi',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueAkomodasi,
          icon: selectedAkomodasi.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueAkomodasi = newValue;
              print(selectedValueAkomodasi);
            });
          },
          items: filteredAkomodasi.map((akomodasi) {
            return DropdownMenuItem<String>(
              value: akomodasi["id"].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  akomodasi["nama"] as String,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: selectedValueAkomodasi != null
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Trip',
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
              : Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueTrip = newValue;
              print(selectedValueTrip);
            });
          },
          items: selectedTrip.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["id"].toString() as String,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama"] as String,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
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
              : Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueEntitasHCGS = newValue!;
              print(selectedValueEntitasHCGS);
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
                  style: TextStyle(fontSize: 12),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Kepada',
              style: TextStyle(fontSize: 11),
            ),
          ),
          icon: selectedNrpHCGS.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: SizedBox(),
                )
              : Icon(Icons.arrow_drop_down),
          value: selectedValueNrpHCGS,
          items: selectedNrpHCGS.map((value) {
            return DropdownMenuItem<String>(
              value: value['pernr'].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value['nama'] + ' - ' + value['pernr'].toString() ?? '',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueNrpHCGS = newValue;
              positionHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                  dataUser['pernr'] == selectedValueNrpHCGS)['position'];
              namaHCGS = selectedNrpHCGS.firstWhere((dataUser) =>
                  dataUser['pernr'] == selectedValueNrpHCGS)['nama'];
              _namaHCGSController.text = namaHCGS.toString();
              _jabatanHCGSController.text = positionHCGS.toString();
              print(selectedValueNrpHCGS);
              print(_namaHCGSController.text);
              print(_jabatanHCGSController.text);
            });
          },
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Entitas HCGS',
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
              : Icon(Icons.arrow_drop_down),
          onChanged: (newValue) {
            setState(() {
              selectedValueEntitasAtasan = newValue!;
              print(selectedValueEntitasAtasan);
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
                  style: TextStyle(fontSize: 12),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
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

    Widget dropdownlistTipe() {
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Tipe',
              style: TextStyle(fontSize: 12),
            ),
          ),
          value: selectedValueTipe,
          icon: selectedTipe.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueTipe = newValue;
              print(selectedValueTipe);
            });
          },
          items: selectedTipe.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["id"].toString() as String,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama"] as String,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: selectedValueTipe != null
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Pilih Kepada',
              style: TextStyle(fontSize: 11),
            ),
          ),
          icon: selectedNrpAtasan.isEmpty
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: SizedBox(),
                )
              : Icon(Icons.arrow_drop_down),
          value: selectedValueNrpAtasan,
          items: selectedNrpAtasan.map((value) {
            return DropdownMenuItem<String>(
              value: value['pernr'].toString(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value['nama'] + ' - ' + value['pernr'].toString() ?? '',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueNrpAtasan = newValue;
              positionAtasan = selectedNrpAtasan.firstWhere((dataUser) =>
                  dataUser['pernr'] == selectedValueNrpAtasan)['position'];
              namaAtasan = selectedNrpAtasan.firstWhere((dataUser) =>
                  dataUser['pernr'] == selectedValueNrpAtasan)['nama'];
              _jabatanAtasanController.text = positionAtasan.toString();
              _namaAtasanController.text = namaAtasan.toString();
              print(_namaAtasanController.text);
              print(selectedValueNrpAtasan);
              print(_jabatanAtasanController.text);
            });
          },
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
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
          hint: Padding(
            padding: const EdgeInsets.only(left: 10),
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
              : Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            setState(() {
              selectedValueNegara = newValue;
              print(selectedValueNegara);
            });
          },
          items: selectedNegara.map((Map<String, dynamic> value) {
            return DropdownMenuItem<String>(
              value: value["kode_negara"].toString() as String,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value["nama_negara"] as String,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelStyle: TextStyle(fontSize: 12),
            focusedBorder: UnderlineInputBorder(
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

    Widget buildForm() {
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
      return Column(
        children: formDataList.asMap().entries.map((entry) {
          int index = entry.key;
          FormDataBiaya formData = entry.value;

          return Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: Text('Kategori'),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: dropdownlistKategori(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('Akomodasi'),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: dropdownlistAkomodasi(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      Row(
                        children: [
                          Text('Tgl Mulai'),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 40),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                                readOnly: true,
                                onTap: () => _selectDateMulai(context),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                controller: TextEditingController(
                                  text: dateFormat.format(formData.tglMulai),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      Row(
                        children: [
                          Text('Tgl Selesai'),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 30),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                                readOnly: true,
                                onTap: () => _selectDateSelesai(context),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                controller: TextEditingController(
                                  text: dateFormat.format(formData.tglSelesai),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 57),
                            child: Text('Tipe'),
                          ),
                          Expanded(
                            child: dropdownlistTipe(),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      Row(
                        children: [
                          Text('Nilai'),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 70),
                              child: TextFormFieldWidget(
                                controller: _nilaiController,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: addFormData,
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => removeFormData(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
    TimeOfDay selectedTime = TimeOfDay.now();
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Navigator.pop(context);
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Nama - NRP HCGS',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                selectedEntitasHCGS.isEmpty
                    ? TextFormField(
                        decoration: InputDecoration(enabled: false),
                      )
                    : dropdownlistNrpHCGS(),
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                //   child:
                //    TextFormFieldWidget(
                //     controller: _nrpHCGSController,
                //     maxHeightConstraints: _maxHeightNama,
                //     hintText: 'Nama',
                //   ),
                // ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Nama - NRP Atasan',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                selectedEntitasAtasan.isEmpty
                    ? TextFormField(
                        decoration: InputDecoration(enabled: false),
                      )
                    : dropdownlistNrpAtasan(),
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                //   child: TextFormFieldWidget(
                //     controller: _namaController,
                //     maxHeightConstraints: _maxHeightNama,
                //     hintText: 'Hasnur',
                //   ),
                // ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    controller: _jabatanHCGSController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    controller: _jabatanAtasanController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      enabled: false,
                      hintText: 'Pilih Nama Atasan',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: const TitleWidget(title: 'Fasilitas Diberikan Kepada'),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    controller: _namaController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    controller: _nrpNamaController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    controller: _departemenController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    style: TextStyle(fontSize: 12),
                    controller: _positionController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                      horizontal: paddingHorizontalNarrow, vertical: padding10),
                  child: RowWithButtonWidget(
                    textLeft: 'Biaya Perjalanan Dinas',
                    textRight: 'Tambah Biaya',
                    fontSizeLeft: textMedium,
                    fontSizeRight: textSmall,
                    onTab: () {
                      addFormData();
                      // Get.toNamed(
                      //     '/user/main/home/online_form/pengajuan_perjalanan_dinas/form_rencana_biaya_perjalanan_dinas/form_input_biaya_perjalanan_dinas');
                    },
                  ),
                ),
                buildForm(),
                InkWell(
                  onTap: () {
                    // Get.toNamed('/user/main/home/pengumuman/detail_pengumuman');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalWide, vertical: padding10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LineWidget(),
                        SizedBox(
                          height: sizedBoxHeightShort,
                        ),
                        // TitleCenterWidget(
                        //   textLeft: 'Kategori',
                        //   textRight: ': kategori',
                        //   fontSizeLeft: textMedium,
                        //   fontSizeRight: textMedium,
                        // ),
                        // SizedBox(
                        //   height: sizedBoxHeightShort,
                        // ),
                        // TitleCenterWidget(
                        //   textLeft: 'Akomodasi',
                        //   textRight: ': Tiket',
                        //   fontSizeLeft: textMedium,
                        //   fontSizeRight: textMedium,
                        // ),
                        // SizedBox(
                        //   height: sizedBoxHeightShort,
                        // ),
                        // TitleCenterWidget(
                        //   textLeft: 'Tanggal Mulai',
                        //   textRight: ': 12/05/2023',
                        //   fontSizeLeft: textMedium,
                        //   fontSizeRight: textMedium,
                        // ),
                        // SizedBox(
                        //   height: sizedBoxHeightShort,
                        // ),
                        // TitleCenterWidget(
                        //   textLeft: 'Tanggal Selesai',
                        //   textRight: ': 15/05/2023',
                        //   fontSizeLeft: textMedium,
                        //   fontSizeRight: textMedium,
                        // ),
                        // SizedBox(
                        //   height: sizedBoxHeightShort,
                        // ),
                        // TitleCenterWidget(
                        //   textLeft: 'Tipe',
                        //   textRight: ': Reimburse to Employee',
                        //   fontSizeLeft: textMedium,
                        //   fontSizeRight: textMedium,
                        // ),
                        // SizedBox(
                        //   height: sizedBoxHeightShort,
                        // ),
                        // TitleCenterWidget(
                        //   textLeft: 'Nilai',
                        //   textRight: ': Rp 500.000',
                        //   fontSizeLeft: textMedium,
                        //   fontSizeRight: textMedium,
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
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
