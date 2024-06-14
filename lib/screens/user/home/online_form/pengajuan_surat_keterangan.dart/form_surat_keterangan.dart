import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormSuratKeterangan extends StatefulWidget {
  const FormSuratKeterangan({super.key});

  @override
  State<FormSuratKeterangan> createState() => _FormSuratKeteranganState();
}

class _FormSuratKeteranganState extends State<FormSuratKeterangan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Sesi 1
  final _namaController = TextEditingController();
  final _nrpController = TextEditingController();
  final _nikController = TextEditingController();
  final _positionController = TextEditingController();
  final _entitasNameController = TextEditingController();
  String? entitasId;
  final _lokasiKerjaController = TextEditingController();
  final _tglBergabungController = TextEditingController();
  final _tujuanSuratController = TextEditingController();
  String? _departemenController;

  // Sesi 2
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

  bool _isLoading = false;
  bool _isLoadingEntitas = false;
  bool _isLoadingNrpHCGS = false;
  bool _isLoadingNrpAtasan = false;
  Map<String, String?> validationMessages = {};

  final String apiUrl = API_URL;

  String? validateField(String? value, {String fieldName = ''}) {
    if (value == null || value.isEmpty) {
      setState(() {
        validationMessages[fieldName] = '$fieldName wajib diisi!';
      });
    }
    return null;
  }

  Future<void> getDataMaster() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingEntitas = true;
      });

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
        setState(() {
          selectedEntitasHCGS = List<Map<String, dynamic>>.from(
            dataEntitasHCGS,
          );
          selectedEntitasAtasan = List<Map<String, dynamic>>.from(
            dataEntitasAtasan,
          );
          _isLoadingEntitas = false;
        });
      } catch (e) {
        setState(() {
          _isLoadingEntitas = false;
        });
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
          _nrpController.text = data['pernr'];
          _namaController.text = data['nama'];
          _nikController.text = data['nomor_ktp'];
          _positionController.text = data['position'];
          _entitasNameController.text = data['pt'];
          entitasId = data['cocd'];
          _lokasiKerjaController.text = data['lokasi'];
          _tglBergabungController.text = data['hire_date'];
          _departemenController = data['organizational_unit'];
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

    setState(() {
      _isLoading = true;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final ioClient = createIOClientWithInsecureConnection();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/surat-keterangan/add'),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['departement_atasan'] = departemenAtasan.toString();
    request.fields['departement_hrgs'] = departemenHCGS.toString();
    request.fields['department_user'] = _departemenController.toString();
    request.fields['entitas_atasan'] = selectedValueEntitasAtasan.toString();
    request.fields['entitas_hrgs'] = selectedValueEntitasHCGS.toString();
    request.fields['entitas_name_user'] = _entitasNameController.text;
    request.fields['entitas_user'] = entitasId.toString();
    request.fields['jabatan_atasan'] = _jabatanAtasanController.text;
    request.fields['jabatan_hrgs'] = _jabatanHCGSController.text;
    request.fields['jabatan_user'] = _positionController.text;
    request.fields['jabatan_penerima'] = _positionController.text;
    request.fields['nama_atasan'] = _namaAtasanController.text;
    request.fields['nama_hrgs'] = _namaHCGSController.text;
    request.fields['nama_user'] = _namaController.text;
    request.fields['nrp_atasan'] = selectedValueNrpAtasan.toString();
    request.fields['nrp_hrgs'] = selectedValueNrpHCGS.toString();
    request.fields['nrp_user'] = _nrpController.text;
    request.fields['tujuan_surat'] = _tujuanSuratController.text;

    debugPrint('Body: ${request.fields}');

    try {
      var streamedResponse = await ioClient.send(request);
      final responseData = await streamedResponse.stream.bytesToString();
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
    getDataMaster();
    getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;

    Widget dropdownlistEntitasHCGS() {
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
              debugPrint('selectedValueEntitasHCGS $selectedValueEntitasHCGS');
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
      );
    }

    Widget dropdownlistEntitasAtasan() {
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
      );
    }

    Widget dropdownlistNrpHCGS() {
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
                'Surat Keterangan',
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
                        child: const TitleWidget(title: 'Surat Dibuat Untuk:'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'NRP', controller: _nrpController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'Nama', controller: _namaController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'NIK', controller: _nikController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'Posisi', controller: _positionController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'Entitas', controller: _entitasNameController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'Lokasi Kerja',
                          controller: _lokasiKerjaController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                          title: 'Tanggal Bergabung',
                          controller: _tglBergabungController),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      buildTextFormFieldField(
                        title: 'Tujuan Dikeluarkannya Surat',
                        controller: _tujuanSuratController,
                        hintText: '---',
                        enabled: true,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: const TitleWidget(title: 'Diajukan Kepada:'),
                      ),
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

  Widget buildTextFormFieldField(
      {required String title,
      required TextEditingController controller,
      String hintText = '',
      bool enabled = false}) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        child: TitleWidget(
          title: title,
          fontWeight: FontWeight.w300,
          fontSize: textMedium,
        ),
      ),
      SizedBox(
        height: sizedBoxHeightShort,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        child: TextFormField(
          style: const TextStyle(fontSize: 12),
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            enabled: enabled,
            hintText: hintText == '' ? title : hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ]);
  }
}
