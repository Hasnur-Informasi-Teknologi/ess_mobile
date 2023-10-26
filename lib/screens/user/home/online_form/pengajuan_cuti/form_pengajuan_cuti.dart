import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';

import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/button_two_row_widget.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _alamatCutiController = TextEditingController();
  final _noTeleponController = TextEditingController();
  DateTime tanggalMulai = DateTime.now();
  DateTime tanggalBerakhir = DateTime.now();
  DateTime tanggalKembaliKerja = DateTime.now();
  bool _isLoading = false;

  final String _apiUrl = API_URL;
  String? cutiYangDiambil,
      sisaCuti,
      keperluanCuti,
      alamatCuti,
      noTelepon,
      jenis_cuti;

  int? sisaCutiMaster, jatahCutiTahunan;
  double maxHeightEntitas = 60.0;
  double maxHeightAtasan = 60.0;
  double maxHeightAtasanDariAtasan = 60.0;
  double maxHeightEntitasKaryawanPengganti = 60.0;
  double maxHeightKaryawanPengganti = 60.0;
  double maxHeightKeperluanCuti = 40.0;
  double maxHeightCutiYangDiambil = 40.0;
  double maxHeightAlamatCuti = 40.0;
  double maxHeightNoTelepon = 40.0;

  bool? _isDiBayar = false;
  bool? _isTidakDiBayar = false;
  bool? _isIzinLainnya = false;
  String? selectedValueEntitas1;
  List<String> selectedEntitas1 = [];
  String? selectedValueEntitas2;
  List<String> selectedEntitas2 = [];
  String? selectedValueAtasan1;
  List<Map<String, dynamic>> selectedAtasan1 = [];
  String? selectedValueAtasanDariAtasan1;
  List<Map<String, dynamic>> selectedAtasanDariAtasan1 = [];
  String? selectedValuePengganti;
  List<Map<String, dynamic>> selectedPengganti = [];

  @override
  void initState() {
    super.initState();
    getDataEntitas();
    getDataAtasan();
    getDataAtasanDariAtasan();
    getDataPengganti();
    getMasterDataCuti();
  }

  Future<void> getMasterDataCuti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    String? nrpString = prefs.getString('nrp');
    int? nrp = int.tryParse(nrpString ?? '');

    if (token != null) {
      try {
        final response = await http.get(Uri.parse("$_apiUrl/get_master_cuti"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final masterDataCutiApi = responseData['data_cuti'] as List<dynamic>;

        final List<int> masterSisaCuti = masterDataCutiApi
            .map<int>((entityData) => entityData['sisacuti'] as int)
            .toList();
        final List<int> masterJatahCutiTahunan = masterDataCutiApi
            .map<int>((entityData) => entityData['jatahcuti'] as int)
            .toList();

        setState(() {
          sisaCutiMaster = masterSisaCuti[0];
          jatahCutiTahunan = masterJatahCutiTahunan[0];
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataEntitas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    String? nrpString = prefs.getString('nrp');
    int? nrp = int.tryParse(nrpString ?? '');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/get_data_entitas_cuti"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        print(responseData);
        final dataEntitasApi = responseData['data_entitas'] as List<dynamic>;

        final List<String> dataEntities = dataEntitasApi
            .map<String>((entityData) => entityData['entitas'] as String)
            .toList();

        setState(() {
          selectedEntitas1 = dataEntities;
          selectedEntitas2 = dataEntities;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataAtasan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? nrpString = prefs.getString('nrp');
    int? nrp = int.tryParse(nrpString ?? '');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/get_data_atasan_cuti?entitas=$selectedValueEntitas1"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataAtasanApi = responseData['list_karyawan'];

        setState(() {
          selectedAtasan1 = List<Map<String, dynamic>>.from(dataAtasanApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataAtasanDariAtasan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? nrpString = prefs.getString('nrp');
    int? nrp = int.tryParse(nrpString ?? '');

    if (token != null) {
      final response = await http.get(
          Uri.parse(
              "$_apiUrl/get_data_atasan_atasan_cuti?entitas=$selectedValueEntitas1"),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token'
          });
      final responseData = jsonDecode(response.body);
      final dataAtasanDariAtasanApi = responseData['list_karyawan'];

      setState(() {
        selectedAtasanDariAtasan1 =
            List<Map<String, dynamic>>.from(dataAtasanDariAtasanApi);
      });
    }
  }

  Future<void> getDataPengganti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? nrpString = prefs.getString('nrp');
    int? nrp = int.tryParse(nrpString ?? '');

    if (token != null) {
      try {
        final response = await http.get(
            // Uri.parse(
            //     "$_apiUrl/get_data_pengganti_cuti?nrp=$nrp&entitas=$selectedValueEntitas2"),
            Uri.parse(
                "$_apiUrl/get_data_pengganti_cuti?&entitas=$selectedValueEntitas2"),
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

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? nrpString = prefs.getString('nrp');
    int? nrp = int.tryParse(nrpString ?? '');

    String? nrpAtasan = selectedValueAtasan1;
    String? nrpAtasanDariAtasan = selectedValueAtasanDariAtasan1;
    String? nrpPengganti = selectedValuePengganti;

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

    cutiYangDiambil = _cutiYangDiambilController.text;
    sisaCuti = _sisaCutiController.text;
    keperluanCuti = _keperluanCutiController.text;
    alamatCuti = _alamatCutiController.text;
    noTelepon = _noTeleponController.text;
    String tanggalMulaiFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalMulai);
    String tanggalBerakhirFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalBerakhir);
    String tanggalKembaliKerjaFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalKembaliKerja);

    if (_isDiBayar == true) {
      jenis_cuti = '1';
    } else if (_isTidakDiBayar == true) {
      jenis_cuti = '2';
    } else {
      jenis_cuti = '3';
    }

    try {
      final response = await http.post(Uri.parse('$_apiUrl/add_cuti'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'nrp_user': nrpString,
            'pernr': nrpString,
            'nrp_atasan': nrpAtasan,
            'atasan_dari_atasan': nrpAtasanDariAtasan,
            'jumlah_cuti': cutiYangDiambil,
            'keperluan_cuti': keperluanCuti,
            'alamat_cuti': alamatCuti,
            'no_telp': noTelepon,
            'jenis_cuti': jenis_cuti,
            'nrp_pengganti': nrpPengganti,
            'tanggal_mulai': tanggalMulaiFormatted,
            'tanggal_berakhir': tanggalBerakhirFormatted,
            'tanggal_masuk_kerja': tanggalKembaliKerjaFormatted,
            'jatah_cuti_tahunan': jatahCutiTahunan,
            'cuti_awal': sisaCutiMaster
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

      if (responseData['message'] == 'Pengajuan Cuti Sukses') {
        Get.offAllNamed('/user/main');
      }

      // print(responseData);
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
              title: const Text(
                'Pengajuan Cuti',
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
                          title: 'Entitas : ',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorEntitas,
                          value: selectedValueEntitas1,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueEntitas1 = newValue ?? '';
                              selectedValueAtasan1 = null;
                              getDataAtasan();
                              getDataAtasanDariAtasan();
                            });
                          },
                          items: selectedEntitas1
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value,
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
                                color: selectedValueEntitas1 != null
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
                          title: 'Atasan :',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorAtasan,
                          value: selectedValueAtasan1,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueAtasan1 = newValue ?? '';
                            });
                          },
                          items: selectedAtasan1.map((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"] as String,
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
                                color: selectedValueAtasan1 != null
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
                          title: 'Atasan dari Atasan :',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          // validator: _validatorAtasanDariAtasan,
                          value: selectedValueAtasanDariAtasan1,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueAtasanDariAtasan1 = newValue ?? '';
                            });
                          },
                          items: selectedAtasanDariAtasan1.map((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"] as String,
                              child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: TitleWidget(
                                    title: value["pernr"] as String,
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  )),
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
                                color: selectedValueAtasanDariAtasan1 != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Karyawan Pengganti ',
                          fontWeight: FontWeight.w300,
                          fontSize: textLarge,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Entitas : ',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: DropdownButtonFormField<String>(
                          validator: _validatorEntitasKaryawanPengganti,
                          value: selectedValueEntitas2,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueEntitas2 = newValue ?? '';
                              selectedValuePengganti = null;
                              getDataPengganti();
                            });
                          },
                          items: selectedEntitas2
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                  ),
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
                                color: selectedValueEntitas2 != null
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
                          title: 'Pengganti : ',
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
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValuePengganti = newValue ?? '';
                            });
                          },
                          items: selectedPengganti.map((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"] as String,
                              child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: TitleWidget(
                                    title: value["nama"] as String,
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
                            buildCheckboxKeterangan(
                                'Cuti Tahunan Dibayar', _isDiBayar),
                            buildCheckboxKeterangan(
                                'Cuti Tahunan Tidak Dibayar', _isTidakDiBayar),
                            buildCheckboxKeterangan(
                                'Izin Lainnya', _isIzinLainnya),
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Catatan Cuti',
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
                                  child: TextFormFieldWidget(
                                    validator: validatorCutiYangDiambil,
                                    controller: _cutiYangDiambilController,
                                    maxHeightConstraints:
                                        maxHeightCutiYangDiambil,
                                    hintText: '4 Hari',
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
                                    title: 'Sisa Cuti',
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
                                      fillColor: Colors.white,
                                      hintText: '$sisaCutiMaster',
                                      hintStyle: TextStyle(
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                    enabled: false,
                                  ),
                                  // TextFormFieldWidget(
                                  //   controller: _sisaCutiController,
                                  //   maxHeightConstraints: _maxHeightNama,
                                  //   hintText: '12 Hari',
                                  // ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: TitleWidget(
                          title: 'Tanggal Pengajuan Cuti',
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
                                          '${tanggalMulai.day}-${tanggalMulai.month}-${tanggalMulai.year}',
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
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SizedBox(
                                        height: 250,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.white,
                                          initialDateTime: tanggalMulai,
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(
                                                () => tanggalMulai = newTime);
                                          },
                                          use24hFormat: false,
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ),
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
                                          '${tanggalBerakhir.day}-${tanggalBerakhir.month}-${tanggalBerakhir.year}',
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
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SizedBox(
                                        height: 250,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.white,
                                          initialDateTime: tanggalBerakhir,
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() =>
                                                tanggalBerakhir = newTime);
                                          },
                                          use24hFormat: false,
                                          mode: CupertinoDatePickerMode.date,
                                        ),
                                      ),
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
                                  '${tanggalKembaliKerja.day}-${tanggalKembaliKerja.month}-${tanggalKembaliKerja.year}',
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
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => SizedBox(
                                height: 250,
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.white,
                                  initialDateTime: tanggalKembaliKerja,
                                  onDateTimeChanged: (DateTime newTime) {
                                    setState(
                                        () => tanggalKembaliKerja = newTime);
                                  },
                                  use24hFormat: false,
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              ),
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
                        child: TextFormFieldWidget(
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
                            onPressed: _submit,
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
                          // ButtonTwoRowWidget(
                          //   textLeft: 'Draft',
                          //   textRight: 'Submit',
                          //   onTabLeft: () {
                          //     print('Draft');
                          //   },
                          //   onTabRight: _submit,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildCheckboxKeterangan(String label, bool? value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isDiBayar = label == 'Cuti Tahunan Dibayar' ? newValue : false;
              _isTidakDiBayar =
                  label == 'Cuti Tahunan Tidak Dibayar' ? newValue : false;
              _isIzinLainnya = label == 'Izin Lainnya' ? newValue : false;
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
    );
  }
}
