import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';

import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormPengajuanCuti extends StatefulWidget {
  const FormPengajuanCuti({super.key});

  @override
  State<FormPengajuanCuti> createState() => _FormPengajuanCutiState();
}

class _FormPengajuanCutiState extends State<FormPengajuanCuti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cutiYangDiambilController = TextEditingController();
  final _sisaCutiController = TextEditingController();
  final _keperluanCutiController = TextEditingController();
  final _cutiDibayarController = TextEditingController();
  final _izinLainnyaController = TextEditingController();
  final _cutiTidakDibayarController = TextEditingController();
  final _alamatCutiController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final DateRangePickerController _tanggalMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;
  final DateRangePickerController _tanggalBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;
  final DateRangePickerController _tanggalKembaliKerjaController =
      DateRangePickerController();
  DateTime? tanggalKembaliKerja;
  bool _isLoading = false;

  final String _apiUrl = API_URL;
  String? cutiYangDiambil,
      sisaCuti,
      keperluanCuti,
      alamatCuti,
      noTelepon,
      jenis_cuti;

  int? sisaCutiMaster, jatahCutiTahunan;
  int cutiDibayarTambahCutiTidakDibayar = 0;
  int totalCutiYangDiambil = 0;
  int totalLama = 0;
  double maxHeightEntitas = 60.0;
  double maxHeightAtasan = 60.0;
  double maxHeightAtasanDariAtasan = 60.0;
  double maxHeightEntitasKaryawanPengganti = 60.0;
  double maxHeightKaryawanPengganti = 60.0;
  double maxHeightKeperluanCuti = 40.0;
  double maxHeightIzinLainnya = 40.0;
  double maxHeightCutiYangDiambil = 40.0;
  double maxHeightAlamatCuti = 40.0;
  double maxHeightNoTelepon = 40.0;
  double maxHeightCutiTahunanDibayar = 40.0;
  double maxHeightCutiTahunanTidakDibayar = 40.0;

  bool? _isDiBayar = false;
  bool? _isTidakDiBayar = false;
  bool? _isIzinLainnya = false;

  String? selectedValueEntitas,
      selectedValueEntitasPengganti,
      selectedValueAtasan,
      selectedValueAtasanDariAtasan,
      selectedValuePengganti,
      selectedValueCutiLainnya;

  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedEntitasPengganti = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedAtasanDariAtasan = [];
  List<Map<String, dynamic>> selectedPengganti = [];
  List<Map<String, dynamic>> selectedCutiLainnya = [];
  List<Map<String, dynamic>> dataCutiLainnya = [];

  @override
  void initState() {
    super.initState();
    getDataEntitas();
    getDataAtasan();
    getDataAtasanDariAtasan();
    getDataPengganti();
    getMasterDataCuti();
    getDataCutiLainnya();
    _cutiDibayarController.addListener(updateTotalCuti);
    _cutiTidakDibayarController.addListener(updateTotalCuti);
  }

  @override
  void dispose() {
    _cutiDibayarController.removeListener(updateTotalCuti);
    _cutiTidakDibayarController.addListener(updateTotalCuti);
    super.dispose();
  }

  void updateTotalCuti() {
    if (_isDiBayar == true && _isTidakDiBayar == false) {
      if (_cutiDibayarController.text.isNotEmpty &&
          isNumeric(_cutiDibayarController.text)) {
        if (int.tryParse(_cutiDibayarController.text)! < 0) {
          _cutiDibayarController.text = '0';
        }
        setState(() {
          cutiDibayarTambahCutiTidakDibayar =
              int.parse(_cutiDibayarController.text);
          totalCutiYangDiambil = cutiDibayarTambahCutiTidakDibayar + totalLama;
        });
      }
    }

    if (_isDiBayar == true && _isTidakDiBayar == true) {
      if (_cutiDibayarController.text.isNotEmpty &&
          isNumeric(_cutiDibayarController.text) &&
          _cutiTidakDibayarController.text.isNotEmpty &&
          isNumeric(_cutiTidakDibayarController.text)) {
        setState(() {
          cutiDibayarTambahCutiTidakDibayar =
              int.parse(_cutiDibayarController.text) +
                  int.parse(_cutiTidakDibayarController.text);
          totalCutiYangDiambil = cutiDibayarTambahCutiTidakDibayar + totalLama;
        });
      }
    }
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  Future<void> getMasterDataCuti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(Uri.parse("$_apiUrl/master/cuti/get"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final masterDataCutiApi = responseData['md_cuti'];

        setState(() {
          sisaCutiMaster = masterDataCutiApi['sisa_cuti'] ?? 0;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataEntitas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(Uri.parse("$_apiUrl/master/entitas"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataEntitasApi = responseData['data'];

        setState(() {
          selectedEntitas = List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasPengganti =
              List<Map<String, dynamic>>.from(dataEntitasApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataAtasan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/master/cuti/atasan?entitas=$selectedValueEntitas"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataAtasanApi = responseData['list_karyawan'];

        setState(() {
          selectedAtasan = List<Map<String, dynamic>>.from(dataAtasanApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataAtasanDariAtasan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
          Uri.parse(
              "$_apiUrl/master/cuti/atasan-atasan?entitas=$selectedValueEntitas"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token'
          });
      final responseData = jsonDecode(response.body);
      final dataAtasanDariAtasanApi = responseData['list_karyawan'];

      setState(() {
        selectedAtasanDariAtasan =
            List<Map<String, dynamic>>.from(dataAtasanDariAtasanApi);
      });
    }
  }

  Future<void> getDataPengganti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/master/cuti/pengganti?&entitas=$selectedValueEntitasPengganti"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataPenggantiApi = responseData['list_karyawan'];

        setState(() {
          selectedPengganti = List<Map<String, dynamic>>.from(dataPenggantiApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataCutiLainnya() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/master/cuti/lainnya"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataCutiLainnyaApi = responseData['cuti_lainnya'];
        prefs.setString('cutiLainnya', response.body);

        setState(() {
          selectedCutiLainnya =
              List<Map<String, dynamic>>.from(dataCutiLainnyaApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateJumlahCutiLainnya(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cutiLainnya =
        jsonDecode(prefs.getString('cutiLainnya').toString())['cuti_lainnya'];

    var cuti = cutiLainnya.firstWhere(
        (element) => element['id'].toString() == value,
        orElse: () => {});

    if (cuti.isNotEmpty) {
      int id = cuti['id'];
      String jenis = cuti['jenis'];
      int lama = cuti['lama'];

      setState(() {
        _izinLainnyaController.text = lama.toString();
      });
    } else {
      print('Data tidak ditemukan');
    }
  }

  Future<void> _tambahCutiLainnya() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cutiLainnya =
        jsonDecode(prefs.getString('cutiLainnya').toString())['cuti_lainnya'];

    var cuti = cutiLainnya.firstWhere(
        (element) => element['id'].toString() == selectedValueCutiLainnya,
        orElse: () => {});

    var canMore = [17, 18, 19];

    if (cuti.isNotEmpty) {
      int id = cuti['id'];
      String jenis = cuti['jenis'];
      int lama = _izinLainnyaController.text.isNotEmpty
          ? int.tryParse(_izinLainnyaController.text)
          : cuti['lama'];

      if (lama > cuti['lama'] && !canMore.contains(cuti['id'])) {
        Get.snackbar('Infomation', 'Jumlah yang diambil terlalu banyak ',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
      } else {
        bool idExists = dataCutiLainnya.any((element) => element['id'] == id);

        if (!idExists) {
          Map<String, dynamic> newData = {
            'id': id,
            'jenis': jenis,
            'lama': lama,
          };

          setState(() {
            dataCutiLainnya.add(newData);
            totalLama = dataCutiLainnya.fold<int>(
                0,
                (previousValue, element) =>
                    previousValue + (element['lama'] ?? 0) as int);

            totalCutiYangDiambil =
                cutiDibayarTambahCutiTidakDibayar + totalLama;
          });
        } else {
          Get.snackbar('Infomation', 'Data Tersebut Tidak Boleh Lagi!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        }
      }
    } else {
      print('Data tidak ditemukan');
    }
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (tanggalMulai == null ||
        tanggalBerakhir == null ||
        tanggalKembaliKerja == null) {
      Get.snackbar('Infomation', 'Tanggal Wajib Diisi',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (tanggalMulai!.isAfter(tanggalBerakhir!) ||
        tanggalMulai!.isAfter(tanggalKembaliKerja!)) {
      Get.snackbar('Infomation', 'Tanggal tidak Valid',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _formKey.currentState!.save();

    cutiYangDiambil = _cutiYangDiambilController.text;
    sisaCuti = _sisaCutiController.text;
    keperluanCuti = _keperluanCutiController.text;
    alamatCuti = _alamatCutiController.text;
    noTelepon = _noTeleponController.text;
    String kepLainnya =
        dataCutiLainnya.map((item) => item['jenis'].toString()).join(', ');

    try {
      final response = await http.post(Uri.parse('$_apiUrl/pengajuan-cuti/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'tgl_mulai': tanggalMulai != null
                ? tanggalMulai.toString()
                : DateTime.now().toString(),
            'tgl_berakhir': tanggalBerakhir != null
                ? tanggalBerakhir.toString()
                : DateTime.now().toString(),
            'tgl_kembali_kerja': tanggalKembaliKerja != null
                ? tanggalKembaliKerja.toString()
                : DateTime.now().toString(),
            'dibayar': _isDiBayar,
            'tdk_dibayar': _isTidakDiBayar,
            'lainnya': _isIzinLainnya,
            'kep_lainnya': kepLainnya,
            'jml_cuti_tahunan': int.tryParse(_cutiDibayarController.text) ?? 0,
            'jml_cuti_tdkdibayar':
                int.tryParse(_cutiTidakDibayarController.text) ?? 0,
            'jml_cuti_lainnya': totalLama,
            'sisa_ext': 0,
            'entitas_atasan': selectedValueEntitas.toString(),
            'nrp_atasan': selectedValueAtasan.toString(),
            'entitas_pengganti': selectedValueEntitasPengganti.toString(),
            'nrp_pengganti': selectedValuePengganti.toString(),
            'jml_cuti': totalCutiYangDiambil,
            'keperluan': keperluanCuti.toString(),
            'alamat_cuti': alamatCuti.toString(),
            'no_telp': noTelepon.toString()
          }));

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

  String? _validatorEntitas(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitas = 80.0;
      });
      return 'Field Entitas Kosong';
    }

    setState(() {
      maxHeightEntitas = 60.0;
    });
    return null;
  }

  String? _validatorAtasan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightAtasan = 80.0;
      });
      return 'Field Atasan Kosong';
    }

    setState(() {
      maxHeightAtasan = 60.0;
    });
    return null;
  }

  String? _validatorAtasanDariAtasan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightAtasanDariAtasan = 80.0;
      });
      return 'Field Atasan Dari Atasan Kosong';
    }

    setState(() {
      maxHeightAtasanDariAtasan = 60.0;
    });
    return null;
  }

  String? _validatorEntitasKaryawanPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasKaryawanPengganti = 80.0;
      });
      return 'Field Entitas Kosong';
    }

    setState(() {
      maxHeightEntitasKaryawanPengganti = 60.0;
    });
    return null;
  }

  String? _validatorKaryawanPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKaryawanPengganti = 80.0;
      });
      return 'Field Pengganti Kosong';
    }

    setState(() {
      maxHeightKaryawanPengganti = 60.0;
    });
    return null;
  }

  String? validatorCutiYangDiambil(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightCutiYangDiambil = 60.0;
      });
      return 'Field Cuti Kosong';
    }

    // int? parsedValue = int.tryParse(value);
    // if (parsedValue == null) {
    //   setState(() {
    //     maxHeightCutiYangDiambil =
    //         60.0;
    //   });
    //   return 'Cuti harus berupa angka bulat';
    // }

    setState(() {
      maxHeightCutiYangDiambil = 40.0;
    });
    return null;
  }

  String? validatorKeperluanCuti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKeperluanCuti = 60.0;
      });
      return 'Field Keperluan Cuti Kosong';
    }

    setState(() {
      maxHeightKeperluanCuti = 40.0;
    });
    return null;
  }

  String? validatorAlamatCuti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightAlamatCuti = 60.0;
      });
      return 'Field Alamat Kosong';
    }

    setState(() {
      maxHeightAlamatCuti = 40.0;
    });
    return null;
  }

  String? validatorNoTelepon(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNoTelepon = 60.0;
      });
      return 'Field No Telepon Kosong';
    }

    setState(() {
      maxHeightNoTelepon = 40.0;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;

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
                  Get.toNamed('/user/main/home/online_form/pengajuan_cuti');
                },
              ),
              title: Text(
                'Pengajuan Cuti',
                style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700),
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
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Pilih Entitas : ',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorEntitas,
                          value: selectedValueEntitas,
                          icon: selectedEntitas.isEmpty
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueEntitas = newValue ?? '';
                              selectedValueAtasan = null;
                              getDataAtasan();
                              getDataAtasanDariAtasan();
                            });
                          },
                          items:
                              selectedEntitas.map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["kode"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["nama"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            constraints:
                                BoxConstraints(maxHeight: maxHeightEntitas),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueEntitas != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Pilih Atasan :',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorAtasan,
                          value: selectedValueAtasan,
                          icon: selectedAtasan.isEmpty
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueAtasan = newValue ?? '';
                            });
                          },
                          items:
                              selectedAtasan.map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["nrp"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["nrp"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints:
                                BoxConstraints(maxHeight: maxHeightAtasan),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueAtasan != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Pilih Atasan dari Atasan :',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          // validator: _validatorAtasanDariAtasan,
                          value: selectedValueAtasanDariAtasan,
                          icon: selectedAtasanDariAtasan.isEmpty
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueAtasanDariAtasan = newValue ?? '';
                            });
                          },
                          items: selectedAtasanDariAtasan
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["nrp"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["nama"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints: BoxConstraints(
                                maxHeight: maxHeightAtasanDariAtasan),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueAtasanDariAtasan != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Karyawan Pengganti ',
                          fontWeight: FontWeight.w700,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Pilih Entitas : ',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorEntitasKaryawanPengganti,
                          value: selectedValueEntitasPengganti,
                          icon: selectedEntitasPengganti.isEmpty
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueEntitasPengganti = newValue ?? '';
                              selectedValuePengganti = null;
                              getDataPengganti();
                            });
                          },
                          items: selectedEntitasPengganti
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["kode"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["nama"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints: BoxConstraints(
                                maxHeight: maxHeightEntitasKaryawanPengganti),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueEntitasPengganti != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Pilih Pengganti : ',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorKaryawanPengganti,
                          value: selectedValuePengganti,
                          icon: selectedPengganti.isEmpty
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValuePengganti = newValue ?? '';
                            });
                          },
                          items: selectedPengganti.map((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value["nrp"].toString(),
                              child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: TitleWidget(
                                    title: '${value["nama"]} - ${value["nrp"]}',
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  )),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints: BoxConstraints(
                                maxHeight: maxHeightKaryawanPengganti),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValuePengganti != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Keterangan Cuti',
                          fontWeight: FontWeight.w700,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _isDiBayar ?? false,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isDiBayar = newValue;
                                      _cutiDibayarController.text = '0';
                                    });
                                  },
                                ),
                                Text(
                                  'Cuti Tahunan Dibayar',
                                  style: TextStyle(
                                      color: const Color(primaryBlack),
                                      fontSize: textMedium,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            (_isDiBayar!)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: TextFormFieldNumberWidget(
                                          controller: _cutiDibayarController,
                                          maxHeightConstraints:
                                              maxHeightCutiTahunanDibayar,
                                          hintText: 'Cuti Tahunan Dibayar',
                                        ),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _isTidakDiBayar ?? false,
                                  onChanged: (newValue) {
                                    int cutiDibayar = int.tryParse(
                                            _cutiDibayarController.text) ??
                                        0;
                                    int sisaCuti = sisaCutiMaster ?? 0;
                                    cutiDibayar >= sisaCuti
                                        ? setState(() {
                                            _isTidakDiBayar = newValue;
                                            cutiDibayar =
                                                cutiDibayar + sisaCuti;
                                            _cutiTidakDibayarController.text =
                                                '0';
                                          })
                                        : Get.snackbar('Disable',
                                            'Akan Bisa Enable Apabila Jumlah Cuti Tahunan dibayar Harus dari sisa cuti',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.amber,
                                            icon: const Icon(
                                              Icons.info,
                                              color: Colors.white,
                                            ),
                                            shouldIconPulse: false);
                                    ;
                                  },
                                ),
                                Text(
                                  'Cuti Tahunan Tidak Dibayar',
                                  style: TextStyle(
                                      color: const Color(primaryBlack),
                                      fontSize: textMedium,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            (_isTidakDiBayar!)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: TextFormFieldWidget(
                                          controller:
                                              _cutiTidakDibayarController,
                                          maxHeightConstraints:
                                              maxHeightCutiTahunanTidakDibayar,
                                          hintText:
                                              'Cuti Tahunan Tidak Dibayar',
                                        ),
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightShort,
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _isIzinLainnya ?? false,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isIzinLainnya = newValue;
                                    });
                                  },
                                ),
                                Text(
                                  'Izin Lainnya',
                                  style: TextStyle(
                                      color: const Color(primaryBlack),
                                      fontSize: textMedium,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.9,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            (_isIzinLainnya!)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.93,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          paddingHorizontalNarrow),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value:
                                                        selectedValueCutiLainnya,
                                                    icon: selectedCutiLainnya
                                                            .isEmpty
                                                        ? const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          )
                                                        : const Icon(Icons
                                                            .arrow_drop_down),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedValueCutiLainnya =
                                                            newValue ?? '';
                                                        updateJumlahCutiLainnya(
                                                            selectedValueCutiLainnya!);
                                                      });
                                                    },
                                                    items: selectedCutiLainnya
                                                        .map((Map<String,
                                                                dynamic>
                                                            value) {
                                                      String title =
                                                          (value["jenis"]
                                                              as String);
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value["id"]
                                                            .toString(),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: TitleWidget(
                                                            title: title.length >
                                                                    40
                                                                ? '${title.substring(0, 40)}...'
                                                                : title,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize:
                                                                textMedium,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    decoration: InputDecoration(
                                                      constraints: BoxConstraints(
                                                          maxHeight:
                                                              maxHeightEntitas),
                                                      labelStyle: TextStyle(
                                                          fontSize: textMedium),
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              selectedValueEntitas !=
                                                                      null
                                                                  ? Colors
                                                                      .black54
                                                                  : Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: TitleWidget(
                                          title: 'Jumlah yang Diambil',
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
                                            width: size.width * 0.45,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      paddingHorizontalNarrow),
                                              child: TextFormFieldNumberWidget(
                                                controller:
                                                    _izinLainnyaController,
                                                maxHeightConstraints:
                                                    maxHeightIzinLainnya,
                                                hintText: '0',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.45,
                                            child: ElevatedButton(
                                              onPressed: _tambahCutiLainnya,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(primaryYellow),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Tambah',
                                                style: TextStyle(
                                                    color: const Color(
                                                        primaryBlack),
                                                    fontSize: textMedium,
                                                    fontFamily: 'Poppins',
                                                    letterSpacing: 0.9,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: sizedBoxHeightTall,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                paddingHorizontalNarrow),
                                        child: SizedBox(
                                          child: dataCutiLainnya.isNotEmpty
                                              ? Table(
                                                  border: TableBorder.all(),
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    padding7),
                                                            child: const Center(
                                                              child: Text(
                                                                  'Jenis Cuti'),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    padding7),
                                                            child: const Center(
                                                              child: Text(
                                                                  'Jumlah'),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    padding7),
                                                            child: const Center(
                                                                child: Text(
                                                                    'Aksi')),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Data Rows
                                                    ...dataCutiLainnya
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                      final int rowIndex =
                                                          entry.key;
                                                      final Map<String, dynamic>
                                                          data = entry.value;
                                                      return TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      padding7),
                                                              child: Center(
                                                                  child: Text(data[
                                                                      'jenis'])),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      padding7),
                                                              child: Center(
                                                                child: Text(data[
                                                                        'lama']
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Center(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            padding5),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      dataCutiLainnya
                                                                          .removeAt(
                                                                              rowIndex);
                                                                      totalLama = dataCutiLainnya.fold<
                                                                              int>(
                                                                          0,
                                                                          (previousValue, element) =>
                                                                              previousValue + (element['lama'] ?? 0) as int);
                                                                      totalCutiYangDiambil =
                                                                          cutiDibayarTambahCutiTidakDibayar +
                                                                              totalLama;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            padding5,
                                                                        horizontal:
                                                                            paddingHorizontalWide),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2.0),
                                                                    ),
                                                                    child: Text(
                                                                      'Hapus',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            primaryBlack),
                                                                        fontSize:
                                                                            textSmall,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ],
                                                )
                                              : Text(''),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Keperluan Cuti',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TextFormFieldWidget(
                          validator: validatorKeperluanCuti,
                          controller: _keperluanCutiController,
                          maxHeightConstraints: maxHeightKeperluanCuti,
                          hintText: 'Keperluan Cuti',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Catatan Cuti',
                          fontWeight: FontWeight.w700,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TitleWidget(
                                    title: 'Cuti Yang Diambil',
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 0)),
                                      constraints: BoxConstraints(
                                          maxHeight: maxHeightCutiYangDiambil),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintText: '$totalCutiYangDiambil',
                                      hintStyle: TextStyle(
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TitleWidget(
                                    title: 'Sisa Cuti Tahunan',
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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: const BorderSide(
                                              color: Colors.grey, width: 0)),
                                      constraints:
                                          const BoxConstraints(maxHeight: 40),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintText: '$sisaCutiMaster',
                                      hintStyle: TextStyle(
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Tanggal Pengajuan Cuti',
                          fontWeight: FontWeight.w700,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TitleWidget(
                                    title: 'Tanggal Mulai',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              _tanggalMulaiController
                                                      .selectedDate ??
                                                  DateTime.now()),
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
                                          content: Container(
                                            height: 350,
                                            width: 350,
                                            child: SfDateRangePicker(
                                              controller:
                                                  _tanggalMulaiController,
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs
                                                      args) {
                                                setState(() {
                                                  tanggalMulai = args.value;
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
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TitleWidget(
                                    title: 'Tanggal Berakhir',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              _tanggalBerakhirController
                                                      .selectedDate ??
                                                  DateTime.now()),
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
                                          content: Container(
                                            height: 350,
                                            width: 350,
                                            child: SfDateRangePicker(
                                              controller:
                                                  _tanggalBerakhirController,
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs
                                                      args) {
                                                setState(() {
                                                  tanggalBerakhir = args.value;
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
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Tanggal Kembali Kerja',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding7),
                        child: CupertinoButton(
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
                                  DateFormat('dd-MM-yyyy').format(
                                      _tanggalKembaliKerjaController
                                              .selectedDate ??
                                          DateTime.now()),
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
                                  content: Container(
                                    height: 350,
                                    width: 350,
                                    child: SfDateRangePicker(
                                      controller:
                                          _tanggalKembaliKerjaController,
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        setState(() {
                                          tanggalKembaliKerja = args.value;
                                        });
                                      },
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Alamat Cuti',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TextFormFieldWidget(
                          validator: validatorAlamatCuti,
                          controller: _alamatCutiController,
                          maxHeightConstraints: maxHeightAlamatCuti,
                          hintText: 'Alamat Cuti',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'No Telepon',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TextFormFieldNumberWidget(
                          validator: validatorNoTelepon,
                          controller: _noTeleponController,
                          maxHeightConstraints: maxHeightNoTelepon,
                          hintText: '089XXXX',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: ElevatedButton(
                            onPressed: () {
                              // _submit();
                              showSubmitModal(context);
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
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void showSubmitModal(BuildContext context) {
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
              const Center(child: Icon(Icons.info)),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Center(
                child: Text(
                  'Apakah Anda Yakin ?',
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
            Row(
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
                        'Cancel',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
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
                    _submit();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: const Color(primaryYellow),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
