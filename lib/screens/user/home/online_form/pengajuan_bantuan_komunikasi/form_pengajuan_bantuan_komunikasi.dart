import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormPengajuanBantuanKomunikasi extends StatefulWidget {
  const FormPengajuanBantuanKomunikasi({super.key});

  @override
  State<FormPengajuanBantuanKomunikasi> createState() =>
      _FormPengajuanBantuanKomunikasiState();
}

class _FormPengajuanBantuanKomunikasiState
    extends State<FormPengajuanBantuanKomunikasi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _apiUrl = API_URL;
  final DateRangePickerController _tanggalPengajuanController =
      DateRangePickerController();
  DateTime? tanggalPengajuan;

  bool? _isTinggiChecked = false;
  bool? _isSedangChecked = false;
  bool? _isRendahChecked = false;
  bool? _isSmartphoneChecked = false;
  bool? _isLainnyaChecked = false;
  bool? _isMobilePhoneChecked = false;

  final _hireDateController = TextEditingController();
  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _pangkatController = TextEditingController();
  final _nominalController = TextEditingController();
  final _tujuanInternalController = TextEditingController();
  final _tujuanEksternalController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _jabatanPenerimaController = TextEditingController();
  final _pangkatPenerimaController = TextEditingController();
  final _namaPenerimaController = TextEditingController();
  final _idPangkatPenerimaController = TextEditingController();
  final _merekMobilePhoneController = TextEditingController();
  final _entitasUserController = TextEditingController();

  bool _isLoading = false;
  double maxHeightNrp = 40.0;
  double maxHeightNama = 40.0;
  double maxHeightPangkat = 40.0;
  double maxHeightEntitas = 60.0;
  double maxHeightPenerima = 60.0;
  double maxHeightJabatan = 60.0;
  double maxHeightFasilitas = 60.0;
  double maxHeightNominal = 40.0;
  double maxHeightTujuanKomunikasiInternal = 100.0;
  double maxHeightTujuanKomunikasiEksternal = 100.0;
  double maxHeightKeterangan = 100.0;
  double maxHeightEntitasAtasan = 60.0;
  double maxHeightEntitasDirektur = 60.0;
  double maxHeightEntitasHcgs = 60.0;
  double maxHeightEntitasDirekturKeuangan = 60.0;
  double maxHeightEntitasPresidenDirektur = 60.0;
  double maxHeightAtasan = 60.0;
  double maxHeightDirektur = 60.0;
  double maxHeightHcgs = 60.0;
  double maxHeightDirekturKeuangan = 60.0;
  double maxHeightPresidenDirektur = 60.0;
  double maxHeightJabatanPenerima = 40.0;
  double maxHeightPangkatPenerima = 40.0;
  double maxHeightMerekMobilePhone = 40.0;

  String? selectedValueEntitas,
      selectedValuePenerima,
      selectedValueEntitasAtasan,
      selectedValueAtasan,
      selectedValueEntitasDirektur,
      selectedValueDirektur,
      selectedValueEntitasHcgs,
      selectedValueHcgs,
      selectedValueEntitasDirekturKeuangan,
      selectedValueDirekturKeuangan,
      selectedValueEntitasPresidenDirektur,
      selectedValuePresidenDirektur,
      selectedValueMdBiayaKomunikasi,
      selectedValueJfKomunikas;

  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedPenerima = [];
  List<Map<String, dynamic>> selectedEntitasAtasan = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedEntitasDirektur = [];
  List<Map<String, dynamic>> selectedDirektur = [];
  List<Map<String, dynamic>> selectedEntitasHcgs = [];
  List<Map<String, dynamic>> selectedHcgs = [];
  List<Map<String, dynamic>> selectedEntitasDirekturKeuangan = [];
  List<Map<String, dynamic>> selectedDirekturKeuangan = [];
  List<Map<String, dynamic>> selectedEntitasPresidenDirektur = [];
  List<Map<String, dynamic>> selectedPresidenDirektur = [];
  List<Map<String, dynamic>> selectedMdBiayaKomunikasi = [];
  List<Map<String, dynamic>> selectedJfKomunikasi = [];

  @override
  void initState() {
    super.initState();
    getData();
    getDataEntitas();
    getMDBantuanKomunikasi();
    getDataAtasan();
    getDataDirektur();
    getDataHcgs();
    getDataDirekturKeuangan();
    getDataPresidenDirektur();
    getDataPenerima();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/master/profile/get_user"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final masterDataApi = responseData['data'];

        setState(() {
          _nrpController.text = masterDataApi['nrp'] ?? '';
          _namaController.text = masterDataApi['nama'] ?? '';
          _hireDateController.text = masterDataApi['tgl_masuk'] ?? '';
          _pangkatController.text = masterDataApi['nama_pangkat'] ?? '';
          _entitasUserController.text = masterDataApi['cocd'] ?? '';
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getMDBantuanKomunikasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/bantuan-komunikasi/master_data"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final mdBiayaKomunikasiApi = responseData['md_biaya_komunikasi'];
        final mdJfKomunikasiApi = responseData['md_jf_komunikasi'];

        setState(() {
          selectedMdBiayaKomunikasi =
              List<Map<String, dynamic>>.from(mdBiayaKomunikasiApi);
          selectedJfKomunikasi =
              List<Map<String, dynamic>>.from(mdJfKomunikasiApi);
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
          selectedEntitasAtasan =
              List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasDirektur =
              List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasHcgs = List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasDirekturKeuangan =
              List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasPresidenDirektur =
              List<Map<String, dynamic>>.from(dataEntitasApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataPenerima() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/bantuan-komunikasi/karyawan?entitas=$selectedValueEntitas&kategori=penerima"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataPenerimaApi = responseData['karyawan'];

        final filteredDataPenerimaApi = selectedValueMdBiayaKomunikasi == '5'
            ? dataPenerimaApi
                .where((data) =>
                    data["kd_pangkat"] != null &&
                    int.parse(data["kd_pangkat"]) < 10)
                .toList()
            : dataPenerimaApi
                .where((data) =>
                    data["kd_pangkat"] != null &&
                    int.parse(data["kd_pangkat"]) >= 10)
                .toList();

        setState(() {
          selectedPenerima =
              List<Map<String, dynamic>>.from(filteredDataPenerimaApi);
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
                "$_apiUrl/bantuan-komunikasi/karyawan?entitas=$selectedValueEntitasAtasan&kategori=atasan"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataAtasanApi = responseData['karyawan'];

        setState(() {
          selectedAtasan = List<Map<String, dynamic>>.from(dataAtasanApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataDirektur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/bantuan-komunikasi/karyawan?entitas=$selectedValueEntitasDirektur&kategori=direktur"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDirekturApi = responseData['karyawan'];

        setState(() {
          selectedDirektur = List<Map<String, dynamic>>.from(dataDirekturApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataHcgs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/bantuan-komunikasi/karyawan?entitas=$selectedValueEntitasHcgs&kategori=hrgs"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataHcgsApi = responseData['karyawan'];

        setState(() {
          selectedHcgs = List<Map<String, dynamic>>.from(dataHcgsApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataDirekturKeuangan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/bantuan-komunikasi/karyawan?entitas=$selectedValueEntitasDirekturKeuangan&kategori=keuangan"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDirekturKeuanganApi = responseData['karyawan'];

        setState(() {
          selectedDirekturKeuangan =
              List<Map<String, dynamic>>.from(dataDirekturKeuanganApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataPresidenDirektur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse(
                "$_apiUrl/bantuan-komunikasi/karyawan?entitas=$selectedValueEntitasPresidenDirektur&kategori=presiden"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataPresidenDirekturApi = responseData['karyawan'];

        setState(() {
          selectedPresidenDirektur =
              List<Map<String, dynamic>>.from(dataPresidenDirekturApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String? prioritas;
    String? jenisMobilePhone;

    if (_isRendahChecked!) {
      prioritas = '0';
    } else if (_isSedangChecked!) {
      prioritas = '1';
    } else if (_isTinggiChecked!) {
      prioritas = '2';
    } else {
      Get.snackbar('Infomation', 'Field Prioritas Required',
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

    if (_isSmartphoneChecked!) {
      jenisMobilePhone = '0';
    } else if (_isLainnyaChecked!) {
      jenisMobilePhone = '1';
    }

    String today = DateTime.now().toString();
    String justDate = today.substring(0, 10);

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
      final response =
          await http.post(Uri.parse('$_apiUrl/bantuan-komunikasi/add'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode({
                'tgl_pengajuan': justDate,
                'nrp_user': _nrpController.text,
                'pangkat_user': _pangkatController.text,
                'nama_user': _namaController.text,
                'entitas_user': _entitasUserController.text,
                'entitas_penerima': selectedValueEntitas,
                'id_biaya_komunikasi': selectedValueMdBiayaKomunikasi,
                'nrp_penerima': selectedValuePenerima,
                'nama_penerima': _namaPenerimaController.text,
                'jabatan_penerima': _jabatanPenerimaController.text,
                'pangkat_penerima': _idPangkatPenerimaController.text,
                'nama_pangkat_penerima': _pangkatPenerimaController.text,
                'id_jenis_fasilitas': selectedValueJfKomunikas,
                'nominal': _nominalController.text,
                'prioritas': prioritas,
                'merek_phone': _merekMobilePhoneController.text,
                'jenis_phone': jenisMobilePhone,
                'tujuan_internal': _tujuanInternalController.text,
                'tujuan_eksternal': _tujuanEksternalController.text,
                'keterangan': _keteranganController.text,
                'entitas_atasan': selectedValueEntitasAtasan,
                'nrp_atasan': selectedValueAtasan,
                'entitas_direktur': selectedValueEntitasDirektur,
                'nrp_direktur': selectedValueDirektur,
                'entitas_hrgs': selectedValueEntitasHcgs,
                'nrp_hrgs': selectedValueHcgs,
                'entitas_keuangan': selectedValueEntitasDirekturKeuangan,
                'nrp_keuangan': selectedValueDirekturKeuangan,
                'entitas_presiden': selectedValueEntitasPresidenDirektur,
                'nrp_presiden': selectedValuePresidenDirektur
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

      if (responseData['message'] == 'Pengajuan Berhasil') {
        Get.offAllNamed('/user/main');
      }
    } catch (e) {
      print(e);
      throw e;
    }

    setState(() {
      _isLoading = false;
    });

    // print(justDate);
    // print(_nrpController.text);
    // print(_pangkatController.text);
    // print(_namaController.text);
    // print(selectedValueEntitas);
    // print(selectedValuePenerima);
    // print(selectedValueMdBiayaKomunikasi);
    // print(selectedValuePenerima);
    // print(_namaPenerimaController.text);
    // print(_jabatanPenerimaController.text);
    // print(_idPangkatPenerimaController.text);
    // print(_pangkatPenerimaController.text);
    // print(selectedValueJfKomunikas);
    // print(_nominalController.text);
    // print(prioritas);
    // print(_merekMobilePhoneController.text);
    // print(jenisMobilePhone);
    // print(_tujuanEksternalController.text);
    // print(_tujuanInternalController.text);
    // print(_keteranganController.text);
    // print(selectedValueEntitasAtasan);
    // print(selectedValueAtasan);
    // print(selectedValueEntitasDirektur);
    // print(selectedValueDirektur);
    // print(selectedValueEntitasHcgs);
    // print(selectedValueHcgs);
    // print(selectedValueEntitasDirekturKeuangan);
    // print(selectedValueDirekturKeuangan);
    // print(selectedValueEntitasPresidenDirektur);
    // print(selectedValuePresidenDirektur);
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

  String? _validatorJabatan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightJabatan = 80.0;
      });
      return 'Field Jabatan & Pangkat Kosong';
    }

    setState(() {
      maxHeightJabatan = 60.0;
    });
    return null;
  }

  String? _validatorFasilitas(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightFasilitas = 80.0;
      });
      return 'Field Fasilitas Kosong';
    }

    setState(() {
      maxHeightFasilitas = 60.0;
    });
    return null;
  }

  String? _validatorNominal(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNominal = 80.0;
      });
      return 'Field Nominal Kosong';
    }

    setState(() {
      maxHeightNominal = 60.0;
    });
    return null;
  }

  String? _validatorEntitasAtasan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasAtasan = 80.0;
      });
      return 'Field Entitas Atasan Kosong';
    }

    setState(() {
      maxHeightEntitasAtasan = 60.0;
    });
    return null;
  }

  String? _validatorEntitasDirektur(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasDirektur = 80.0;
      });
      return 'Field Entitas Direktur Kosong';
    }

    setState(() {
      maxHeightEntitasDirektur = 60.0;
    });
    return null;
  }

  String? _validatorEntitasHcgs(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasHcgs = 80.0;
      });
      return 'Field Entitas HCGS Kosong';
    }

    setState(() {
      maxHeightEntitasHcgs = 60.0;
    });
    return null;
  }

  String? _validatorEntitasDirekturKeuangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasDirekturKeuangan = 80.0;
      });
      return 'Field Entitas Direktur Keuangan Kosong';
    }

    setState(() {
      maxHeightEntitasDirekturKeuangan = 60.0;
    });
    return null;
  }

  String? _validatorEntitasPresidenDirektur(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasPresidenDirektur = 80.0;
      });
      return 'Field Entitas Predisen Direktur Kosong';
    }

    setState(() {
      maxHeightEntitasPresidenDirektur = 60.0;
    });
    return null;
  }

  String? _validatorKomunikasi(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightTujuanKomunikasiInternal = 120.0;
      });
      return 'Field Komunikasi Internal Kosong';
    }

    setState(() {
      maxHeightTujuanKomunikasiInternal = 100.0;
    });
    return null;
  }

  String? _validatorKeterangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKeterangan = 120.0;
      });
      return 'Field Keterangan Kosong';
    }

    setState(() {
      maxHeightKeterangan = 100.0;
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

  String? _validatorDirektur(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightDirektur = 80.0;
      });
      return 'Field Direktur Kosong';
    }

    setState(() {
      maxHeightDirektur = 60.0;
    });
    return null;
  }

  String? _validatorHcgs(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightHcgs = 80.0;
      });
      return 'Field Hcgs Kosong';
    }

    setState(() {
      maxHeightHcgs = 60.0;
    });
    return null;
  }

  String? _validatorDirekturKeuangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightDirekturKeuangan = 80.0;
      });
      return 'Field Direktur Keuangan Kosong';
    }

    setState(() {
      maxHeightDirekturKeuangan = 60.0;
    });
    return null;
  }

  String? _validatorPresidenDirektur(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightPresidenDirektur = 80.0;
      });
      return 'Field Presiden Direktur Kosong';
    }

    setState(() {
      maxHeightPresidenDirektur = 60.0;
    });
    return null;
  }

  String? _validatorPenerima(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightPenerima = 80.0;
      });
      return 'Field Penerima Kosong';
    }

    setState(() {
      maxHeightPenerima = 60.0;
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
                  Get.toNamed('/user/main/home/online_form');
                },
              ),
              title: Text(
                'Pengajuan Bantuan Komunikasi',
                style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w500),
              ),
            ),
            body: ListView(children: [
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
                          title: 'Diajukan Oleh : ',
                          fontWeight: FontWeight.w500,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Tanggal Pengajuan',
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
                                DateFormat('dd-MM-yyyy').format(
                                    _tanggalPengajuanController.selectedDate ??
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
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'NRP',
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
                        child: TextFormFielDisableWidget(
                          controller: _nrpController,
                          maxHeightConstraints: maxHeightNrp,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Nama',
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
                        child: TextFormFielDisableWidget(
                          controller: _namaController,
                          maxHeightConstraints: maxHeightNama,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Pangkat',
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
                        child: TextFormFielDisableWidget(
                          controller: _pangkatController,
                          maxHeightConstraints: maxHeightPangkat,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Fasilitas Komunikasi Diberikan Kepada : ',
                          fontWeight: FontWeight.w500,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
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
                              selectedValuePenerima = null;
                              getDataPenerima();
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Kelompok Jabatan & Pangkat : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorJabatan,
                          value: selectedValueMdBiayaKomunikasi,
                          icon: selectedMdBiayaKomunikasi.isEmpty
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
                              selectedValueMdBiayaKomunikasi = newValue ?? '';
                              selectedValuePenerima = null;
                              getDataPenerima();
                            });
                          },
                          items: selectedMdBiayaKomunikasi
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["id"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["pangkat"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            constraints:
                                BoxConstraints(maxHeight: maxHeightJabatan),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueMdBiayaKomunikasi != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Penerima : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorPenerima,
                          value: selectedValuePenerima,
                          icon: selectedPenerima.isEmpty ||
                                  selectedValueMdBiayaKomunikasi == null
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
                              selectedValuePenerima = newValue ?? '';
                              // Filter selectedPenerima berdasarkan selectedValuePenerima
                              var filteredPenerima = selectedPenerima.where(
                                  (penerima) =>
                                      penerima["pernr"] ==
                                      selectedValuePenerima);
                              // Ambil nilai pangkat dan jabatan dari hasil filter
                              _jabatanPenerimaController.text = filteredPenerima
                                  .map((penerima) => penerima["position"])
                                  .first;
                              _pangkatPenerimaController.text = filteredPenerima
                                  .map((penerima) => penerima["pangkat"])
                                  .first;
                              _namaPenerimaController.text = filteredPenerima
                                  .map((penerima) => penerima["nama"])
                                  .first;
                              _idPangkatPenerimaController.text =
                                  filteredPenerima
                                      .map((penerima) => penerima["kd_pangkat"])
                                      .first;
                            });
                          },
                          items: selectedPenerima
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["pernr"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints:
                                BoxConstraints(maxHeight: maxHeightPenerima),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValuePenerima != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Jabatan',
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
                        child: TextFormFielDisableWidget(
                          controller: _jabatanPenerimaController,
                          maxHeightConstraints: maxHeightJabatanPenerima,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Pangkat',
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
                        child: TextFormFielDisableWidget(
                          controller: _pangkatPenerimaController,
                          maxHeightConstraints: maxHeightPangkatPenerima,
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
                            TitleWidget(
                              title: 'Pilih Fasilitas : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorFasilitas,
                          value: selectedValueJfKomunikas,
                          icon: selectedJfKomunikasi.isEmpty
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
                              selectedValueJfKomunikas = newValue ?? '';
                              if (selectedValueJfKomunikas == '1') {
                                _isMobilePhoneChecked = true;
                              } else {
                                _isMobilePhoneChecked = false;
                              }
                            });
                          },
                          items: selectedJfKomunikasi
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["id"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["nama_fasilitas"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            constraints:
                                BoxConstraints(maxHeight: maxHeightJabatan),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueJfKomunikas != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Prioritas ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCheckbox('Rendah', _isRendahChecked),
                          buildCheckbox('Sedang', _isSedangChecked),
                          buildCheckbox('Tinggi', _isTinggiChecked),
                        ],
                      ),
                      (_isMobilePhoneChecked!)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: sizedBoxHeightTall,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TitleWidget(
                                    title: 'Merek Mobile Phone ',
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
                                    controller: _merekMobilePhoneController,
                                    maxHeightConstraints:
                                        maxHeightMerekMobilePhone,
                                    hintText: 'masukkan merek',
                                  ),
                                ),
                                SizedBox(
                                  height: sizedBoxHeightTall,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontalNarrow),
                                  child: TitleWidget(
                                    title: 'Jenis Mobile Phone ',
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
                                    buildCheckboxMerekPhone(
                                        'Smartphone', _isSmartphoneChecked),
                                    buildCheckboxMerekPhone(
                                        'Lainnya', _isLainnyaChecked)
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Nominal (Rupiah) ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
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
                        child: TextFormFieldNumberWidget(
                          validator: _validatorNominal,
                          controller: _nominalController,
                          maxHeightConstraints: maxHeightNominal,
                          hintText: 'masukkan nominal',
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
                            TitleWidget(
                              title: 'Tujuan Komunikasi ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
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
                        child: TextFormFieldWidget(
                          validator: _validatorKomunikasi,
                          controller: _tujuanInternalController,
                          maxHeightConstraints:
                              maxHeightTujuanKomunikasiInternal,
                          hintText: 'Tujuan Internal',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFieldWidget(
                          controller: _tujuanEksternalController,
                          maxHeightConstraints:
                              maxHeightTujuanKomunikasiEksternal,
                          hintText: 'Tujuan Eksternal',
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
                            TitleWidget(
                              title: 'Keterangan ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
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
                        child: TextFormFieldWidget(
                          validator: _validatorKeterangan,
                          controller: _keteranganController,
                          maxHeightConstraints: maxHeightKeterangan,
                          hintText: 'Keterangan',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Diajukan Kepada : ',
                          fontWeight: FontWeight.w500,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: const LineWidget(),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas Atasan : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorEntitasAtasan,
                          value: selectedValueEntitasAtasan,
                          icon: selectedEntitasAtasan.isEmpty
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
                              selectedValueEntitasAtasan = newValue ?? '';
                              selectedValueAtasan = null;
                              getDataAtasan();
                            });
                          },
                          items: selectedEntitasAtasan
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
                            constraints: BoxConstraints(
                                maxHeight: maxHeightEntitasAtasan),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueEntitasAtasan != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Atasan : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
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
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["pernr"]}',
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas Direktur : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorEntitasDirektur,
                          value: selectedValueEntitasDirektur,
                          icon: selectedEntitasDirektur.isEmpty
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
                              selectedValueEntitasDirektur = newValue ?? '';
                              selectedValueDirektur = null;
                              getDataDirektur();
                            });
                          },
                          items: selectedEntitasDirektur
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
                            constraints: BoxConstraints(
                                maxHeight: maxHeightEntitasDirektur),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueEntitasDirektur != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Direktur : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorDirektur,
                          value: selectedValueDirektur,
                          icon: selectedDirektur.isEmpty
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
                              selectedValueDirektur = newValue ?? '';
                            });
                          },
                          items: selectedDirektur
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["pernr"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints:
                                BoxConstraints(maxHeight: maxHeightDirektur),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueDirektur != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas HCGS : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorEntitasHcgs,
                          value: selectedValueEntitasHcgs,
                          icon: selectedEntitasHcgs.isEmpty
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
                              selectedValueEntitasHcgs = newValue ?? '';
                              selectedValueHcgs = null;
                              getDataHcgs();
                            });
                          },
                          items: selectedEntitasHcgs
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
                            constraints:
                                BoxConstraints(maxHeight: maxHeightEntitasHcgs),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueEntitasHcgs != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih HCGS : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorHcgs,
                          value: selectedValueHcgs,
                          icon: selectedHcgs.isEmpty
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
                              selectedValueHcgs = newValue ?? '';
                            });
                          },
                          items: selectedHcgs.map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["pernr"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints:
                                BoxConstraints(maxHeight: maxHeightHcgs),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueHcgs != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas Direktur Keuangan : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorEntitasDirekturKeuangan,
                          value: selectedValueEntitasDirekturKeuangan,
                          icon: selectedEntitasDirekturKeuangan.isEmpty
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
                              selectedValueEntitasDirekturKeuangan =
                                  newValue ?? '';
                              selectedValueDirekturKeuangan = null;
                              getDataDirekturKeuangan();
                            });
                          },
                          items: selectedEntitasDirekturKeuangan
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
                            constraints: BoxConstraints(
                                maxHeight: maxHeightEntitasDirekturKeuangan),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    selectedValueEntitasDirekturKeuangan != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Direktur Keuangan : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorDirekturKeuangan,
                          value: selectedValueDirekturKeuangan,
                          icon: selectedDirekturKeuangan.isEmpty
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
                              selectedValueDirekturKeuangan = newValue ?? '';
                            });
                          },
                          items: selectedDirekturKeuangan
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["pernr"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints: BoxConstraints(
                                maxHeight: maxHeightDirekturKeuangan),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueDirekturKeuangan != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas Presiden Direktur : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorEntitasPresidenDirektur,
                          value: selectedValueEntitasPresidenDirektur,
                          icon: selectedEntitasPresidenDirektur.isEmpty
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
                              selectedValueEntitasPresidenDirektur =
                                  newValue ?? '';
                              selectedValuePresidenDirektur = null;
                              getDataPresidenDirektur();
                            });
                          },
                          items: selectedEntitasPresidenDirektur
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
                            constraints: BoxConstraints(
                                maxHeight: maxHeightEntitasPresidenDirektur),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    selectedValueEntitasPresidenDirektur != null
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Presiden Direktur : ',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: textMedium,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorPresidenDirektur,
                          value: selectedValuePresidenDirektur,
                          icon: selectedPresidenDirektur.isEmpty
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
                              selectedValuePresidenDirektur = newValue ?? '';
                            });
                          },
                          items: selectedPresidenDirektur
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["nama"]} - ${value["pernr"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints: BoxConstraints(
                                maxHeight: maxHeightPresidenDirektur),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValuePresidenDirektur != null
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
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: ElevatedButton(
                            onPressed: () {
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
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                    ],
                  ))
            ]),
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
                    fontWeight: FontWeight.w500,
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
                          fontWeight: FontWeight.w500,
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
                          fontWeight: FontWeight.w500,
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

  Widget buildCheckbox(String label, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isTinggiChecked = label == 'Tinggi' ? newValue : false;
              _isSedangChecked = label == 'Sedang' ? newValue : false;
              _isRendahChecked = label == 'Rendah' ? newValue : false;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget buildCheckboxMerekPhone(String label, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isSmartphoneChecked = label == 'Smartphone' ? newValue : false;
              _isLainnyaChecked = label == 'Lainnya' ? newValue : false;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
