import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormPenilaianKinerjaKaryawan extends StatefulWidget {
  const FormPenilaianKinerjaKaryawan({super.key});

  @override
  State<FormPenilaianKinerjaKaryawan> createState() =>
      _FormPenilaianKinerjaKaryawanState();
}

class _FormPenilaianKinerjaKaryawanState
    extends State<FormPenilaianKinerjaKaryawan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormController form = Get.put(FormController());
  List<int?> dropdownValuesTipe1 = [];
  List<int?> dropdownValuesTipe2 = [];

  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _pangkatController = TextEditingController();
  String? department;
  String? entitasKd;
  String? entitasName;

  List<Map<String, dynamic>> selectedEntitasMaster = [];

  String? selectedValueEntitasKaryawan;
  String? selectedValueEntitasAtasan;
  String? selectedValueEntitasDirOps;
  String? selectedValueEntitasComBen;
  String? selectedValueEntitasDirHCA;
  String? selectedValueEntitasDirFin;

  List<Map<String, dynamic>> selectedNrpKaryawan = [];
  String? selectedValueNrpKaryawan;
  String? departmentKaryawan;
  final _jabatanKaryawanController = TextEditingController();
  final _pangkatKaryawanController = TextEditingController();
  final _statusKaryawanController = TextEditingController();
  String? namaKaryawan;
  String? nrpKaryawan;
  String? kdPangkatKaryawan;

  List<Map<String, dynamic>> selectedNrpAtasan = [];
  String? selectedValueNrpAtasan;
  String? departmentAtasan;
  String? jabatanAtasan;
  String? namaAtasan;
  String? nrpAtasan;

  List<Map<String, dynamic>> selectedNrpDirOps = [];
  String? selectedValueNrpDirOps;
  String? departmentDirOps;
  String? jabatanDirOps;
  String? namaDirOps;
  String? nrpDirOps;

  List<Map<String, dynamic>> selectedNrpComBen = [];
  String? selectedValueNrpComBen;
  String? departmentComBen;
  String? jabatanComBen;
  String? namaComBen;
  String? nrpComBen;

  List<Map<String, dynamic>> selectedNrpDirHCA = [];
  String? selectedValueNrpDirHCA;
  String? departmentDirHCA;
  String? jabatanDirHCA;
  String? namaDirHCA;
  String? nrpDirHCA;

  List<Map<String, dynamic>> selectedNrpDirFin = [];
  String? selectedValueNrpDirFin;
  String? departmentDirFin;
  String? jabatanDirFin;
  String? namaDirFin;
  String? nrpDirFin;

  List<Map<String, dynamic>> selectedAspekPenilaian = [];
  Map<String, int> vtable = {};
  int nilaiAkhir = 0;

  final _kelebihanController = TextEditingController();
  final _halDikembangkanController = TextEditingController();
  final _pengembanganController = TextEditingController();

  bool? _isTetap = false;
  bool? _isDiperpanjang = false;
  List<Map<String, dynamic>> selectedDurasi = [
    {'type': 'bulan', 'label': 'Bulan'},
    {'type': 'tahun', 'label': 'Tahun'},
  ];
  String? selectedValueDurasi;
  final _durasiController = TextEditingController();
  bool? _isPHK = false;
  bool? _isNaikGaji = false;
  List<Map<String, dynamic>> selectedTipe = [
    {'type': 'jumlah', 'label': 'Jumlah'},
    {'type': 'persentase', 'label': 'Persentase'},
  ];
  String? selectedValueTipe;
  final _gajiController = TextEditingController();
  bool? _isLainnya = false;
  final _lainnyaController = TextEditingController();

  final String apiUrl = API_URL;
  bool _isLoading = false;
  bool _isLoadingUser = false;
  bool _isLoadingEntitas = false;
  bool _isLoadingNrpKaryawan = false;
  bool _isLoadingNrpAtasan = false;
  bool _isLoadingNrpDirOps = false;
  bool _isLoadingNrpComBen = false;
  bool _isLoadingNrpDirHCA = false;
  bool _isLoadingNrpDirFin = false;
  Map<String, String?> validationMessages = {};

  String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return validationMessages[fieldName] = 'Field wajib diisi!';
    }
    validationMessages[fieldName] = null;
    return null;
  }

  Future<void> calculateNilaiAkhir() async {
    setState(() {
      nilaiAkhir = vtable.values.fold(0, (sum, item) => sum + item);
    });
  }

  Future<void> setLoadingState(String kategori, bool isLoading) async {
    switch (kategori) {
      case 'to':
        _isLoadingNrpKaryawan = isLoading;
        break;
      case 'atasan':
        _isLoadingNrpAtasan = isLoading;
        break;
      case 'dirops':
        _isLoadingNrpDirOps = isLoading;
        break;
      case 'comben':
        _isLoadingNrpComBen = isLoading;
        break;
      case 'hca':
        _isLoadingNrpDirHCA = isLoading;
        break;
      case 'finance':
        _isLoadingNrpDirFin = isLoading;
        break;
      default:
        break;
    }
  }

  Future<void> setSelectedNrp(
      String kategori, List<Map<String, dynamic>> data) async {
    switch (kategori) {
      case 'to':
        selectedNrpKaryawan = data;
        selectedValueNrpKaryawan = null;
        break;
      case 'atasan':
        selectedNrpAtasan = data;
        selectedValueNrpAtasan = null;
        break;
      case 'dirops':
        selectedNrpDirOps = data;
        selectedValueNrpDirOps = null;
        break;
      case 'comben':
        selectedNrpComBen = data;
        selectedValueNrpComBen = null;
        break;
      case 'hca':
        selectedNrpDirHCA = data;
        selectedValueNrpDirHCA = null;
        break;
      case 'finance':
        selectedNrpDirFin = data;
        selectedValueNrpDirFin = null;
        break;
      default:
        break;
    }
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
          _jabatanController.text = data['position'];
          _pangkatController.text = data['pangkat'];
          department = data['organizational_unit'];
          entitasKd = data['cocd'];
          entitasName = data['pt'];
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
            Uri.parse('$apiUrl/penilaian-kinerja/master_data'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataEntitas = responseData['entitas'];
        final dataAspekPenilaian = responseData['aspek_penilaian'];

        setState(() {
          selectedEntitasMaster = List<Map<String, dynamic>>.from(dataEntitas);
          selectedAspekPenilaian =
              List<Map<String, dynamic>>.from(dataAspekPenilaian);

          dropdownValuesTipe1 = List<int?>.filled(
              selectedAspekPenilaian
                  .where((aspek) => aspek['tipe_aspek'] == 1)
                  .length,
              null);
          dropdownValuesTipe2 = List<int?>.filled(
              selectedAspekPenilaian
                  .where((aspek) => aspek['tipe_aspek'] == 2)
                  .length,
              null);
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

  Future<void> getDataNrp(String entitasCode, String kategori) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        setLoadingState(kategori, true);
      });

      try {
        final response = await http.get(
            Uri.parse(
                '$apiUrl/master/daftar_karyawan?entitas=$entitasCode&kategori=$kategori'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['karyawan'];
        setState(() {
          setSelectedNrp(kategori, List<Map<String, dynamic>>.from(data));
          setLoadingState(kategori, false);
        });
      } catch (e) {
        setState(() {
          setLoadingState(kategori, false);
        });
        rethrow;
      }
    }
  }

  Future<void> _submit() async {
    setState(() {
      validateField(selectedValueEntitasKaryawan, 'Entitas Karyawan');
      validateField(selectedValueNrpKaryawan, 'Nama Karyawan');
      validateField(selectedValueEntitasAtasan, 'Entitas Atasan');
      validateField(selectedValueNrpAtasan, 'Nama Atasan');
      validateField(selectedValueEntitasDirOps, 'Entitas Direktur Operasional');
      validateField(selectedValueNrpDirOps, 'Nama Direktur Operasional');
      validateField(
          selectedValueEntitasComBen, 'Entitas Compensation & Benefit');
      validateField(selectedValueNrpComBen, 'Nama Compensation & Benefit');
      validateField(selectedValueEntitasDirHCA, 'Entitas HCA Direktur');
      validateField(selectedValueNrpDirHCA, 'Nama HCA Direktur');
      validateField(selectedValueEntitasDirFin, 'Entitas Finance Direktur');
      validateField(selectedValueNrpDirFin, 'Nama Finance Direktur');
      validateField(jsonEncode(vtable), 'Aspek Penilaian');
      validateField(_kelebihanController.text, 'Kelebihan');
      validateField(_halDikembangkanController.text, 'Hal Yang Dikembangkan');
      validateField(_pengembanganController.text, 'Pengembangan Karyawan');

      if (_isDiperpanjang == true) {
        validateField(selectedValueDurasi, 'Tipe Durasi');
        validateField(_durasiController.text, 'Durasi');
      }
      if (_isNaikGaji == true) {
        validateField(selectedValueTipe, 'Tipe Kenaikan');
        validateField(_gajiController.text, 'Gaji');
      }
      if (_isLainnya == true) {
        validateField(_lainnyaController.text, 'Lainnya');
      }
    });

    if (validationMessages.values.any((msg) => msg != null)) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/penilaian-kinerja/add'),
    );

    void addFieldIfTrue(String field, bool condition) {
      if (condition) {
        request.fields[field] = condition.toString();
      }
    }

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'currentYear': DateTime.now().year.toString(),
      'data_user': '${_nrpController.text} - ${_namaController.text}',
      'departement_atasan': departmentAtasan.toString(),
      'departement_comben': departmentComBen.toString(),
      'departement_dirops': departmentDirOps.toString(),
      'departement_finance': departmentDirFin.toString(),
      'departement_hca': departmentDirHCA.toString(),
      'departement_to': departmentKaryawan.toString(),
      'department_user': department.toString(),
      'emp_improve': _halDikembangkanController.text,
      'emp_kelebihan': _kelebihanController.text,
      'emp_training': _pengembanganController.text,
      'entitas_atasan': selectedValueEntitasAtasan.toString(),
      'entitas_comben': selectedValueEntitasComBen.toString(),
      'entitas_dirops': selectedValueEntitasDirOps.toString(),
      'entitas_finance': selectedValueEntitasDirFin.toString(),
      'entitas_hca': selectedValueEntitasDirHCA.toString(),
      'entitas_name_user': entitasName.toString(),
      'entitas_to': selectedValueEntitasKaryawan.toString(),
      'entitas_user': entitasKd.toString(),
      'jabatan_atasan': jabatanAtasan.toString(),
      'jabatan_comben': jabatanComBen.toString(),
      'jabatan_dirops': jabatanDirOps.toString(),
      'jabatan_finance': jabatanDirFin.toString(),
      'jabatan_hca': jabatanDirHCA.toString(),
      'jabatan_to': _jabatanKaryawanController.text,
      'jabatan_user': _jabatanController.text,
      'kd_pangkat_to': kdPangkatKaryawan.toString(),
      'nama_atasan': namaAtasan.toString(),
      'nama_comben': namaComBen.toString(),
      'nama_dirops': namaDirOps.toString(),
      'nama_finance': namaDirFin.toString(),
      'nama_hca': namaDirHCA.toString(),
      'nama_to': namaKaryawan.toString(),
      'nama_user': _namaController.text,
      'nilai_akhir': nilaiAkhir.toString(),
      'nrp_atasan': nrpAtasan.toString(),
      'nrp_comben': nrpComBen.toString(),
      'nrp_dirops': nrpDirOps.toString(),
      'nrp_finance': nrpDirFin.toString(),
      'nrp_hca': nrpDirHCA.toString(),
      'nrp_to': nrpKaryawan.toString(),
      'nrp_user': _nrpController.text,
      'pangkat_to': _pangkatKaryawanController.text,
      'pangkat_user': _pangkatController.text,
      'status_to': _statusKaryawanController.text,
      'vtable': jsonEncode(vtable),
    });

    addFieldIfTrue('usul_emp_ttp', _isTetap!);
    addFieldIfTrue('usul_lainnya', _isLainnya!);
    if (_isLainnya!) {
      request.fields['usul_lainnya_detail'] = _lainnyaController.text;
    }
    addFieldIfTrue('usul_pkwt', _isDiperpanjang!);
    if (_isDiperpanjang!) {
      request.fields['usul_pkwt_amount'] = _durasiController.text;
      request.fields['usul_pkwt_type'] =
          selectedValueDurasi == 'bulan' ? '1' : '2';
    }
    addFieldIfTrue('usul_rapel', _isNaikGaji!);
    if (_isNaikGaji!) {
      request.fields['usul_rapel_amount'] = _gajiController.text;
      request.fields['usul_rapel_percent'] =
          selectedValueTipe == 'persentase' ? _gajiController.text : 'null';
      request.fields['usul_rapel_type'] =
          selectedValueTipe == 'jumlah' ? '1' : '2';
    }
    addFieldIfTrue('usul_terminate', _isPHK!);

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
    getDataMaster();
  }

  @override
  void dispose() {
    _nrpController.dispose();
    _namaController.dispose();
    _jabatanController.dispose();
    _pangkatController.dispose();
    _jabatanKaryawanController.dispose();
    _pangkatKaryawanController.dispose();
    _statusKaryawanController.dispose();
    _kelebihanController.dispose();
    _halDikembangkanController.dispose();
    _pengembanganController.dispose();
    _durasiController.dispose();
    _gajiController.dispose();
    _lainnyaController.dispose();
    form.infoPenilaianUntuk.value = false;
    form.infoPengajuanKepada.value = false;
    form.infoAspekPenialaian.value = false;
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

    List<DropdownMenuItem<int>> getDropdownItems() {
      return List<DropdownMenuItem<int>>.generate(
        5,
        (int index) => DropdownMenuItem<int>(
          value: index + 1,
          child: Text((index + 1).toString()),
        ),
      );
    }

    List<Map<String, dynamic>> aspekTipe1 = selectedAspekPenilaian
        .where((aspek) => aspek['tipe_aspek'] == 1)
        .toList();
    List<Map<String, dynamic>> aspekTipe2 = selectedAspekPenilaian
        .where((aspek) => aspek['tipe_aspek'] == 2)
        .toList();

    Widget dropdownListEntitas({
      required String? value,
      required Function(String?) onChanged,
      required String? validationKey,
    }) {
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
                  'Pilih Entitas',
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
              value: value,
              menuMaxHeight: 400,
              items: selectedEntitasMaster.isNotEmpty
                  ? selectedEntitasMaster.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['kode'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['kode'] + ' - ' + value['nama'],
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
              onChanged: onChanged,
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
            child: validationMessages['Entitas $validationKey'] != null
                ? validateContainer('Entitas $validationKey')
                : null,
          ),
        ],
      );
    }

    Widget dropdownlistNrp({
      required bool isLoading,
      required String? value,
      required List<Map<String, dynamic>> items,
      required Function(String?) onChanged,
      String? validationKey,
    }) {
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
                  'Pilih Kepada',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: isLoading
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: value,
              items: items.isNotEmpty
                  ? items.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['pernr'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['nama'] + ' - ' + value['pernr'],
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
              onChanged: onChanged,
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
            child: validationMessages['Nama $validationKey'] != null
                ? validateContainer('Nama $validationKey')
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
                'Penilaian Kinerja Karyawan',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '* Minimal Setingkat Department Head / Setara',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: sizedBoxHeightTall,
                            ),
                            buildHeading('Diajukan Oleh'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(title: 'NRP'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTextFormField(controller: _nrpController),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(title: 'Nama'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTextFormField(controller: _namaController),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(title: 'Jabatan'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child:
                            buildTextFormField(controller: _jabatanController),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(title: 'Pangkat'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child:
                            buildTextFormField(controller: _pangkatController),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                form.infoPenilaianUntuk.value =
                                    !form.infoPenilaianUntuk.value;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                        title: buildHeading(
                                            'Penilaian Kinerja Untuk'));
                                  },
                                  body: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title: 'Entitas Karyawan'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownListEntitas(
                                        value: selectedValueEntitasKaryawan,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueEntitasKaryawan =
                                                newValue!;
                                            getDataNrp(
                                                selectedValueEntitasKaryawan!,
                                                'to');
                                          });
                                        },
                                        validationKey: 'Karyawan',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title: 'Nama - NRP Karyawan'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownlistNrp(
                                        isLoading: _isLoadingNrpKaryawan,
                                        value: selectedValueNrpKaryawan,
                                        items: selectedNrpKaryawan,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueNrpKaryawan =
                                                newValue!;
                                            final karyawan = selectedNrpKaryawan
                                                .firstWhere(
                                                    (element) =>
                                                        element['pernr'] ==
                                                        newValue, orElse: () {
                                              return {};
                                            });
                                            departmentKaryawan =
                                                karyawan['organizational_unit'];
                                            _jabatanKaryawanController.text =
                                                karyawan['position'];
                                            _pangkatKaryawanController.text =
                                                karyawan['pangkat'];
                                            _statusKaryawanController.text =
                                                karyawan['status_karyawan'];
                                            namaKaryawan = karyawan['nama'];
                                            nrpKaryawan = karyawan['pernr'];
                                            kdPangkatKaryawan =
                                                karyawan['kd_pangkat'];
                                            vtable.clear();
                                            calculateNilaiAkhir();
                                            dropdownValuesTipe1 =
                                                List<int?>.filled(
                                                    aspekTipe1.length, null);
                                            dropdownValuesTipe2 =
                                                List<int?>.filled(
                                                    aspekTipe2.length, null);
                                            debugPrint(
                                                'selectedValueNrpKaryawan $selectedValueNrpKaryawan');
                                          });
                                        },
                                        validationKey: 'Karyawan',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(title: 'Jabatan'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTextFormField(
                                            controller:
                                                _jabatanKaryawanController),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(title: 'Pangkat'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTextFormField(
                                            controller:
                                                _pangkatKaryawanController),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(title: 'Status'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTextFormField(
                                            controller:
                                                _statusKaryawanController),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightExtraTall,
                                      ),
                                    ],
                                  ),
                                  isExpanded: form.infoPenilaianUntuk.value),
                            ]),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                form.infoPengajuanKepada.value =
                                    !form.infoPengajuanKepada.value;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                        title: buildHeading('Diajukan Kepada'));
                                  },
                                  body: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child:
                                            buildTitle(title: 'Entitas Atasan'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownListEntitas(
                                        value: selectedValueEntitasAtasan,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueEntitasAtasan =
                                                newValue!;
                                            getDataNrp(
                                                selectedValueEntitasAtasan!,
                                                'atasan');
                                          });
                                        },
                                        validationKey: 'Atasan',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title: 'Nama - NRP Atasan'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownlistNrp(
                                        isLoading: _isLoadingNrpAtasan,
                                        value: selectedValueNrpAtasan,
                                        items: selectedNrpAtasan,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueNrpAtasan = newValue!;
                                            final atasan = selectedNrpAtasan
                                                .firstWhere(
                                                    (element) =>
                                                        element['pernr'] ==
                                                        newValue, orElse: () {
                                              return {};
                                            });
                                            departmentAtasan =
                                                atasan['organizational_unit'];
                                            jabatanAtasan = atasan['position'];
                                            namaAtasan = atasan['nama'];
                                            nrpAtasan = atasan['pernr'];
                                            debugPrint(
                                                'selectedValueNrpAtasan $selectedValueNrpAtasan');
                                          });
                                        },
                                        validationKey: 'Atasan',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title:
                                                'Entitas Direktur Operasional'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownListEntitas(
                                        value: selectedValueEntitasDirOps,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueEntitasDirOps =
                                                newValue!;
                                            getDataNrp(
                                                selectedValueEntitasDirOps!,
                                                'dirops');
                                          });
                                        },
                                        validationKey: 'Direktur Operasional',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title:
                                                'Nama - NRP Direktur Operasional'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownlistNrp(
                                        isLoading: _isLoadingNrpDirOps,
                                        value: selectedValueNrpDirOps,
                                        items: selectedNrpDirOps,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueNrpDirOps = newValue!;
                                            final dirOps = selectedNrpDirOps
                                                .firstWhere(
                                                    (element) =>
                                                        element['pernr'] ==
                                                        newValue, orElse: () {
                                              return {};
                                            });
                                            departmentDirOps =
                                                dirOps['organizational_unit'];
                                            jabatanDirOps = dirOps['position'];
                                            namaDirOps = dirOps['nama'];
                                            nrpDirOps = dirOps['pernr'];
                                            debugPrint(
                                                'selectedValueNrpDirOps $selectedValueNrpDirOps');
                                          });
                                        },
                                        validationKey: 'Direktur Operasional',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title:
                                                'Entitas Compensation & Benefit'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownListEntitas(
                                        value: selectedValueEntitasComBen,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueEntitasComBen =
                                                newValue!;
                                            getDataNrp(
                                                selectedValueEntitasComBen!,
                                                'comben');
                                          });
                                        },
                                        validationKey: 'Compensation & Benefit',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title:
                                                'Nama - NRP Compensation & Benefit'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownlistNrp(
                                        isLoading: _isLoadingNrpComBen,
                                        value: selectedValueNrpComBen,
                                        items: selectedNrpComBen,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueNrpComBen = newValue!;
                                            final comBen = selectedNrpComBen
                                                .firstWhere(
                                                    (element) =>
                                                        element['pernr'] ==
                                                        newValue, orElse: () {
                                              return {};
                                            });
                                            departmentComBen =
                                                comBen['organizational_unit'];
                                            jabatanComBen = comBen['position'];
                                            namaComBen = comBen['nama'];
                                            nrpComBen = comBen['pernr'];
                                            debugPrint(
                                                'selectedValueNrpComBen $selectedValueNrpComBen');
                                          });
                                        },
                                        validationKey: 'Compensation & Benefit',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title: 'Entitas HCA Direktur'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownListEntitas(
                                        value: selectedValueEntitasDirHCA,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueEntitasDirHCA =
                                                newValue!;
                                            getDataNrp(
                                                selectedValueEntitasDirHCA!,
                                                'hca');
                                          });
                                        },
                                        validationKey: 'HCA Direktur',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title: 'Nama - NRP HCA Direktur'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownlistNrp(
                                        isLoading: _isLoadingNrpDirHCA,
                                        value: selectedValueNrpDirHCA,
                                        items: selectedNrpDirHCA,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueNrpDirHCA = newValue!;
                                            final dirHCA = selectedNrpDirHCA
                                                .firstWhere(
                                                    (element) =>
                                                        element['pernr'] ==
                                                        newValue, orElse: () {
                                              return {};
                                            });
                                            departmentDirHCA =
                                                dirHCA['organizational_unit'];
                                            jabatanDirHCA = dirHCA['position'];
                                            namaDirHCA = dirHCA['nama'];
                                            nrpDirHCA = dirHCA['pernr'];
                                            debugPrint(
                                                'selectedValueNrpDirHCA $selectedValueNrpDirHCA');
                                          });
                                        },
                                        validationKey: 'HCA Direktur',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title: 'Entitas Finance Direktur'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownListEntitas(
                                        value: selectedValueEntitasDirFin,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueEntitasDirFin =
                                                newValue!;
                                            getDataNrp(
                                                selectedValueEntitasDirFin!,
                                                'finance');
                                          });
                                        },
                                        validationKey: 'Finance Direktur',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: buildTitle(
                                            title:
                                                'Nama - NRP Finance Direktur'),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      dropdownlistNrp(
                                        isLoading: _isLoadingNrpDirFin,
                                        value: selectedValueNrpDirFin,
                                        items: selectedNrpDirFin,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValueNrpDirFin = newValue!;
                                            final dirFin = selectedNrpDirFin
                                                .firstWhere(
                                                    (element) =>
                                                        element['pernr'] ==
                                                        newValue, orElse: () {
                                              return {};
                                            });
                                            departmentDirFin =
                                                dirFin['organizational_unit'];
                                            jabatanDirFin = dirFin['position'];
                                            namaDirFin = dirFin['nama'];
                                            nrpDirFin = dirFin['pernr'];
                                            debugPrint(
                                                'selectedValueNrpDirFin $selectedValueNrpDirFin');
                                          });
                                        },
                                        validationKey: 'Finance Direktur',
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightExtraTall,
                                      ),
                                    ],
                                  ),
                                  isExpanded: form.infoPengajuanKepada.value),
                            ]),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info,
                                size: 60.0,
                                color: Colors.green.shade700,
                              ),
                              SizedBox(height: sizedBoxHeightTall),
                              Text(
                                'Berikut ini, anda dihadapkan sejumlah aspek yang berkaitan dengan kompetensi umum. Pada setiap aspek, anda diminta untuk memberikan nilai yang anda rasa paling sesuai dengan keadaan individu yang dinilai. Adapun nilai yang diberikan memiliki ketentuan sebagai berikut:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green.shade700,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: sizedBoxHeightTall),
                              Text(
                                '(1) Kurang   (2) Cukup   (3) Baik',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: sizedBoxHeightTall),
                              Text(
                                '(4) Baik Sekali   (5) Istimewa',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                                textAlign: TextAlign.center,
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
                        child: ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                form.infoAspekPenialaian.value =
                                    !form.infoAspekPenialaian.value;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                  canTapOnHeader: true,
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                        title: buildHeading('Aspek Penilaian'));
                                  },
                                  body: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: validationMessages[
                                                    'Aspek Penilaian'] !=
                                                null
                                            ? validateContainer(
                                                'Aspek Penilaian')
                                            : null,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  paddingHorizontalNarrow),
                                          child: Table(
                                            border: TableBorder.all(),
                                            defaultColumnWidth:
                                                const FixedColumnWidth(200.0),
                                            columnWidths: const {
                                              1: FixedColumnWidth(80.0),
                                              3: FixedColumnWidth(80.0),
                                            },
                                            children: [
                                              TableRow(children: [
                                                buildTableHeader(
                                                    'A. Aspek Umum'),
                                                buildTableHeader('Nilai'),
                                                buildTableHeader(
                                                    'B. Aspek Manajerial (Khusus Level Section Head/ Setara Keatas)'),
                                                buildTableHeader('Nilai'),
                                              ]),
                                              ...List<TableRow>.generate(
                                                aspekTipe1.length,
                                                (index) => TableRow(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${aspekTipe1[index]['indeks_aspek']} ${aspekTipe1[index]['judul_aspek']}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                              aspekTipe1[index][
                                                                  'deskripsi_aspek'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          DropdownButtonFormField<
                                                              int>(
                                                        value:
                                                            dropdownValuesTipe1[
                                                                index],
                                                        items:
                                                            getDropdownItems(),
                                                        onChanged:
                                                            (int? value) {
                                                          setState(() {
                                                            dropdownValuesTipe1[
                                                                index] = value;
                                                            vtable['nilai_${aspekTipe1[index]['id']}'] =
                                                                value!;
                                                            calculateNilaiAkhir();
                                                          });
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    OutlineInputBorder()),
                                                      ),
                                                    ),
                                                    index < aspekTipe2.length
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${aspekTipe2[index]['indeks_aspek']} ${aspekTipe2[index]['judul_aspek']}',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                    aspekTipe2[
                                                                            index]
                                                                        [
                                                                        'deskripsi_aspek'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify),
                                                              ],
                                                            ),
                                                          )
                                                        : const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(''),
                                                          ),
                                                    index < aspekTipe2.length
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                IgnorePointer(
                                                              ignoring: (int.tryParse(
                                                                          kdPangkatKaryawan ??
                                                                              '0') ??
                                                                      0) <
                                                                  7,
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      int>(
                                                                value:
                                                                    dropdownValuesTipe2[
                                                                        index],
                                                                items:
                                                                    getDropdownItems(),
                                                                onChanged: (int?
                                                                    value) {
                                                                  setState(() {
                                                                    dropdownValuesTipe2[
                                                                            index] =
                                                                        value;
                                                                    vtable['nilai_${aspekTipe2[index]['id']}'] =
                                                                        value!;
                                                                    calculateNilaiAkhir();
                                                                  });
                                                                },
                                                                decoration:
                                                                    const InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder()),
                                                              ),
                                                            ),
                                                          )
                                                        : const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(''),
                                                          ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightExtraTall,
                                      ),
                                    ],
                                  ),
                                  isExpanded: form.infoAspekPenialaian.value),
                            ]),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Catatan Hasil Penilaian'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(title: 'Kelebihan Karyawan'),
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
                            buildTextFormField(
                              controller: _kelebihanController,
                              type: 'textarea',
                            ),
                            if (validationMessages['Kelebihan'] != null)
                              validateContainer('Kelebihan'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(
                            title: 'Hal Yang Harus Dikembangkan Dari Karyawan'),
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
                            buildTextFormField(
                              controller: _halDikembangkanController,
                              type: 'textarea',
                            ),
                            if (validationMessages['Hal Yang Dikembangkan'] !=
                                null)
                              validateContainer('Hal Yang Dikembangkan'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildTitle(
                            title:
                                'Pengembangan Karyawan (Training Jika Dibutuhkan)'),
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
                            buildTextFormField(
                              controller: _pengembanganController,
                              type: 'textarea',
                            ),
                            if (validationMessages['Pengembangan Karyawan'] !=
                                null)
                              validateContainer('Pengembangan Karyawan'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: buildHeading('Usulan Hasil Penilaian'),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width,
                            child: buildCheckbox(
                                'Diangkat Sebagai Karyawan Tetap', _isTetap!),
                          ),
                          SizedBox(
                              width: size.width,
                              child: buildCheckbox(
                                  'PKWT Diperpanjang', _isDiperpanjang!)),
                          SizedBox(
                            width: size.width,
                            child: buildCheckbox(
                                'Pemutusan Hubungan Kerja / Akhiri Masa Kontrak',
                                _isPHK!),
                          ),
                          SizedBox(
                              width: size.width,
                              child: buildCheckbox(
                                  'Kenaikan Gaji / Upah', _isNaikGaji!)),
                          SizedBox(
                              width: size.width,
                              child: buildCheckbox('Lainnya', _isLainnya!)),
                        ],
                      ),
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
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;

    return Row(
      children: [
        TitleWidget(
          title: title,
          fontWeight: FontWeight.w300,
          fontSize: textMedium,
        ),
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

  Widget buildTextFormField(
      {required TextEditingController controller, String type = 'general'}) {
    if (type == 'general') {
      return TextFormField(
        style: const TextStyle(fontSize: 12),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: _isLoadingUser
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                      height: 5,
                      width: 5,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )),
                )
              : const SizedBox(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          enabled: false,
          hintText: '---',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (type == 'textarea') {
      return TextFormField(
        style: const TextStyle(fontSize: 12),
        controller: controller,
        minLines: 3,
        maxLines: 3,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          hintText: '---',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildCheckbox(String label, bool value) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightShort = size.height * 0.0086;
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
                    case 'Diangkat Sebagai Karyawan Tetap':
                      _isTetap = newValue!;
                      break;
                    case 'PKWT Diperpanjang':
                      _isDiperpanjang = newValue!;
                      break;
                    case 'Pemutusan Hubungan Kerja / Akhiri Masa Kontrak':
                      _isPHK = newValue!;
                      break;
                    case 'Kenaikan Gaji / Upah':
                      _isNaikGaji = newValue!;
                      break;
                    case 'Lainnya':
                      if (newValue! == true) {
                        _isLainnya = newValue;
                      } else {
                        _isLainnya = newValue;
                        _lainnyaController.clear();
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
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        if (label == 'PKWT Diperpanjang' && _isDiperpanjang == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: dropdownlistDurasi(),
              ),
              SizedBox(
                height: sizedBoxHeightShort,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 15.0),
                child: TextFormField(
                  controller: _durasiController,
                  decoration: InputDecoration(
                    hintText: '---',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(15),
                      child: TitleWidget(
                        title: selectedValueDurasi == null
                            ? ''
                            : selectedValueDurasi![0].toUpperCase() +
                                selectedValueDurasi!.substring(1),
                        fontWeight: FontWeight.w300,
                        fontSize: textMedium,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: validationMessages['Durasi'] != null
                    ? validateContainer('Durasi')
                    : null,
              ),
            ],
          ),
        if (label == 'Kenaikan Gaji / Upah' && _isNaikGaji == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: dropdownlistTipeKenaikan(),
              ),
              SizedBox(
                height: sizedBoxHeightShort,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 15.0),
                child: TextFormField(
                  controller: _gajiController,
                  decoration: InputDecoration(
                    // akhir
                    suffixIcon: selectedValueTipe != 'jumlah'
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: TitleWidget(
                              title: selectedValueTipe == null ||
                                      selectedValueTipe == 'jumlah'
                                  ? ''
                                  : '%',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          )
                        : null,
                    // awal
                    prefixIcon: selectedValueTipe != 'persentase'
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: TitleWidget(
                              title: selectedValueTipe == null ||
                                      selectedValueTipe == 'persentase'
                                  ? ''
                                  : 'Rp. ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: validationMessages['Gaji'] != null
                    ? validateContainer('Gaji')
                    : null,
              ),
            ],
          ),
        if (label == 'Lainnya' && _isLainnya == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 15.0),
                child: TextFormField(
                  enabled: _isLainnya!,
                  controller: _lainnyaController,
                  decoration: const InputDecoration(
                    hintText: '---',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: validationMessages['Lainnya'] != null
                    ? validateContainer('Lainnya')
                    : null,
              ),
            ],
          ),
      ],
    );
  }

  Widget buildTableHeader(String title) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget dropdownlistDurasi() {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;

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
                'Pilih Durasi',
                style: TextStyle(fontSize: 12),
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            value: selectedValueDurasi,
            menuMaxHeight: 400,
            items: selectedDurasi.isNotEmpty
                ? selectedDurasi.map((value) {
                    return DropdownMenuItem<String>(
                      value: value['type'].toString(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          value['label'],
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
                selectedValueDurasi = newValue!;
                debugPrint('selectedValueDurasi $selectedValueDurasi');
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
          child: validationMessages['Tipe Durasi'] != null
              ? validateContainer('Tipe Durasi')
              : null,
        ),
      ],
    );
  }

  Widget dropdownlistTipeKenaikan() {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;

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
                'Pilih Tipe Kenaikan',
                style: TextStyle(fontSize: 12),
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            value: selectedValueTipe,
            menuMaxHeight: 400,
            items: selectedTipe.isNotEmpty
                ? selectedTipe.map((value) {
                    return DropdownMenuItem<String>(
                      value: value['type'].toString(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          value['label'],
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
                selectedValueTipe = newValue!;
                debugPrint('selectedValueTipe $selectedValueTipe');
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
          child: validationMessages['Tipe Kenaikan'] != null
              ? validateContainer('Tipe Kenaikan')
              : null,
        ),
      ],
    );
  }
}

class FormController extends GetxController {
  RxBool infoPenilaianUntuk = false.obs;
  RxBool infoPengajuanKepada = false.obs;
  RxBool infoAspekPenialaian = false.obs;
}
