import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';

import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_two_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_text_field_widget.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
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
  double maxHeightKeperluanCuti = 50.0;
  double maxHeightIzinLainnya = 50.0;
  double maxHeightCutiYangDiambil = 50.0;
  double maxHeightAlamatCuti = 50.0;
  double maxHeightNoTelepon = 50.0;
  double maxHeightCutiTahunanDibayar = 50.0;
  double maxHeightCutiTahunanTidakDibayar = 50.0;

  bool? _isDiBayar = false;
  bool? _isTidakDiBayar = false;
  bool? _isIzinLainnya = false;

  String? selectedValueEntitas,
      selectedValueEntitasPengganti,
      selectedValueAtasan,
      selectedValueAtasanDariAtasan,
      selectedValueEntitasAtasanDariAtasan,
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
    _cutiTidakDibayarController.removeListener(updateTotalCuti);
    super.dispose();
  }

  void updateTotalCuti() {
    if (_isDiBayar == true && _isTidakDiBayar == false) {
      if (_cutiDibayarController.text.isNotEmpty) {
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
          _cutiTidakDibayarController.text.isNotEmpty) {
        setState(() {
          cutiDibayarTambahCutiTidakDibayar =
              int.parse(_cutiDibayarController.text) +
                  int.parse(_cutiTidakDibayarController.text);
          totalCutiYangDiambil = cutiDibayarTambahCutiTidakDibayar + totalLama;
        });
      }
    }

    if (_isDiBayar == false && _isTidakDiBayar == true) {
      if (_cutiTidakDibayarController.text.isNotEmpty) {
        if (int.tryParse(_cutiTidakDibayarController.text)! < 0) {
          _cutiTidakDibayarController.text = '0';
        }
        setState(() {
          cutiDibayarTambahCutiTidakDibayar =
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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchData(
    String endpoint,
    Function(Map<String, dynamic>) onSuccess, {
    Map<String, String>? queryParams,
  }) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final ioClient = createIOClientWithInsecureConnection();

      final url =
          Uri.parse("$_apiUrl/$endpoint").replace(queryParameters: queryParams);

      final response = await ioClient.get(
        url,
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      onSuccess(responseData);
    } catch (e) {
      print('Error fetching data from $endpoint: $e');
    }
  }

  Future<void> getMasterDataCuti() async {
    await _fetchData("master/cuti/get", (data) {
      final masterDataCutiApi = data['md_cuti'];
      setState(() {
        sisaCutiMaster = masterDataCutiApi['sisa_cuti'] ?? 0;
      });
    });
  }

  Future<void> getDataEntitas() async {
    await _fetchData("master/entitas", (data) {
      final dataEntitasApi = data['data'];
      setState(() {
        selectedEntitas = List<Map<String, dynamic>>.from(dataEntitasApi);
        selectedEntitasPengganti =
            List<Map<String, dynamic>>.from(dataEntitasApi);
      });
    });
  }

  Future<void> getDataAtasan() async {
    await _fetchData("master/cuti/atasan", (data) {
      final dataAtasanApi = data['list_karyawan'];
      setState(() {
        selectedAtasan = List<Map<String, dynamic>>.from(dataAtasanApi);
      });
    }, queryParams: {
      'entitas': selectedValueEntitas.toString(),
    });
  }

  Future<void> getDataAtasanDariAtasan() async {
    await _fetchData("master/cuti/atasan-atasan", (data) {
      final dataAtasanDariAtasanApi = data['list_karyawan'];
      setState(() {
        selectedAtasanDariAtasan =
            List<Map<String, dynamic>>.from(dataAtasanDariAtasanApi);
      });
    }, queryParams: {
      'entitas': selectedValueEntitas.toString(),
    });
  }

  Future<void> getDataPengganti() async {
    await _fetchData("master/cuti/pengganti", (data) {
      final dataPenggantiApi = data['list_karyawan'];
      setState(() {
        selectedPengganti = List<Map<String, dynamic>>.from(dataPenggantiApi);
      });
    }, queryParams: {
      'entitas': selectedValueEntitasPengganti.toString(),
    });
  }

  Future<void> getDataCutiLainnya() async {
    await _fetchData("master/cuti/lainnya", (data) {
      final dataCutiLainnyaApi = data['cuti_lainnya'];
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('cutiLainnya', jsonEncode(data));
      });

      setState(() {
        selectedCutiLainnya =
            List<Map<String, dynamic>>.from(dataCutiLainnyaApi);
      });
    });
  }

  Future<void> updateJumlahCutiLainnya(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cutiLainnya =
        jsonDecode(prefs.getString('cutiLainnya').toString())['cuti_lainnya'];

    var cuti = cutiLainnya.firstWhere(
        (element) => element['id'].toString() == value,
        orElse: () => {});

    if (cuti.isNotEmpty) {
      // int id = cuti['id'];
      // String jenis = cuti['jenis'];
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
      orElse: () => {},
    );

    var canMore = [17, 18, 19];

    if (cuti.isNotEmpty) {
      int id = cuti['id'];
      String jenis = cuti['jenis'];
      int lama = _izinLainnyaController.text.isNotEmpty
          ? int.tryParse(_izinLainnyaController.text)
          : cuti['lama'];

      if (lama > cuti['lama'] && !canMore.contains(cuti['id'])) {
        _showSnackbar('Infomation', 'Jumlah yang diambil terlalu banyak');
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
          _showSnackbar('Infomation', 'Data Tersebut Tidak Boleh Lagi!');
        }
      }
    } else {
      print('Data tidak ditemukan');
    }
  }

  Future<void> _submit() async {
    final token = await _getToken();

    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    int jmlCutiTahunan = int.tryParse(_cutiDibayarController.text) ?? 0;

    cutiYangDiambil = _cutiYangDiambilController.text;
    sisaCuti = _sisaCutiController.text;
    keperluanCuti = _keperluanCutiController.text;
    alamatCuti = _alamatCutiController.text;
    noTelepon = _noTeleponController.text;
    String kepLainnya =
        dataCutiLainnya.map((item) => item['jenis'].toString()).join(', ');

    try {
      final ioClient = createIOClientWithInsecureConnection();

      final response =
          await ioClient.post(Uri.parse('$_apiUrl/pengajuan-cuti/add'),
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
                'jml_cuti_tahunan': jmlCutiTahunan,
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
                'no_telp': noTelepon.toString(),
                'nrp_direktur': selectedValueAtasanDariAtasan,
                'entitas_direktur': selectedValueEntitasAtasanDariAtasan
              }));

      final responseData = jsonDecode(response.body);
      _showSnackbar('Infomation', responseData['message']);
      print(responseData);

      if (responseData['status'] == 'success') {
        Get.offAllNamed('/user/main');
      }
    } catch (e) {
      print(e);
      _showSnackbar('Error', 'Terjadi kesalahan saat mengajukan cuti.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateForm() {
    if (tanggalMulai == null ||
        tanggalBerakhir == null ||
        tanggalKembaliKerja == null) {
      _showSnackbar('Infomation', 'Tanggal Wajib Diisi');
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    if (tanggalMulai!.isAfter(tanggalBerakhir!) ||
        tanggalMulai!.isAfter(tanggalKembaliKerja!)) {
      _showSnackbar('Infomation', 'Tanggal tidak Valid');
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    if (tanggalKembaliKerja!.isBefore(tanggalMulai!) ||
        tanggalKembaliKerja!.isAtSameMomentAs(tanggalMulai!) ||
        tanggalKembaliKerja!.isBefore(tanggalBerakhir!) ||
        tanggalKembaliKerja!.isAtSameMomentAs(tanggalBerakhir!)) {
      _showSnackbar('Infomation', 'Tanggal Kembali tidak Valid');
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    int sisaCutiTahunan = sisaCutiMaster ?? 0;
    int jmlCutiTahunan = int.tryParse(_cutiDibayarController.text) ?? 0;

    if (jmlCutiTahunan > sisaCutiTahunan) {
      _showSnackbar('Infomation', 'Cuti Tahunan Dibayar Melebihi Batas');
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return false;
    }

    return true;
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      shouldIconPulse: false,
    );
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

    setState(() {
      maxHeightCutiYangDiambil = 50.0;
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
      maxHeightKeperluanCuti = 50.0;
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
      maxHeightAlamatCuti = 50.0;
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
      maxHeightNoTelepon = 50.0;
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
                      BuildDropdownWithTitleWidget(
                        title: 'Pilih Entitas : ',
                        selectedValue: selectedValueEntitas,
                        itemList: selectedEntitas,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitas = newValue ?? '';
                            selectedValueAtasan = null;
                            getDataAtasan();
                            getDataAtasanDariAtasan();
                          });
                        },
                        validator: _validatorEntitas,
                        maxHeight: maxHeightEntitas,
                        isLoading: selectedEntitas.isEmpty,
                        horizontalPadding: paddingHorizontalWide,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      BuildDropdownWithTwoTitleWidget(
                        title: 'Pilih Atasan : ',
                        selectedValue: selectedValueAtasan,
                        itemList: selectedAtasan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueAtasan = newValue ?? '';
                          });
                        },
                        validator: _validatorAtasan,
                        maxHeight: maxHeightAtasan,
                        isLoading: selectedAtasan.isEmpty,
                        horizontalPadding: paddingHorizontalWide,
                        valueKey: "nrp",
                        titleKey: "nama",
                        isRequired: true,
                      ),
                      BuildDropdownWithTwoTitleWidget(
                          title: 'Pilih Atasan dari Atasan :',
                          selectedValue: selectedValueAtasanDariAtasan,
                          itemList: selectedAtasanDariAtasan,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueAtasanDariAtasan = newValue ?? '';
                              var masterDataAtasanDariAtasan =
                                  selectedAtasanDariAtasan
                                      .where((item) =>
                                          item['nrp'] ==
                                          selectedValueAtasanDariAtasan)
                                      .toList();
                              selectedValueEntitasAtasanDariAtasan =
                                  masterDataAtasanDariAtasan.isNotEmpty
                                      ? masterDataAtasanDariAtasan[0]['cocd']
                                      : null;
                            });
                          },
                          maxHeight: maxHeightAtasanDariAtasan,
                          isLoading: selectedAtasanDariAtasan.isEmpty,
                          horizontalPadding: paddingHorizontalWide,
                          valueKey: "nrp",
                          titleKey: "nama",
                          isRequired: false),
                      _buildTitle(
                        title: 'Karyawan Pengganti ',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        horizontalPadding: paddingHorizontalWide,
                        isRequired: false,
                      ),
                      BuildDropdownWithTitleWidget(
                        title: 'Pilih Entitas :',
                        selectedValue: selectedValueEntitasPengganti,
                        itemList: selectedEntitasPengganti,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitasPengganti = newValue ?? '';
                            selectedValuePengganti = null;
                            getDataPengganti();
                          });
                        },
                        validator: _validatorEntitasKaryawanPengganti,
                        maxHeight: maxHeightEntitasKaryawanPengganti,
                        isLoading: selectedEntitasPengganti.isEmpty,
                        horizontalPadding: paddingHorizontalWide,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      BuildDropdownWithTwoTitleWidget(
                        title: 'Pilih Pengganti : ',
                        selectedValue: selectedValuePengganti,
                        itemList: selectedPengganti,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValuePengganti = newValue ?? '';
                          });
                        },
                        validator: _validatorKaryawanPengganti,
                        maxHeight: maxHeightKaryawanPengganti,
                        isLoading: selectedPengganti.isEmpty,
                        horizontalPadding: paddingHorizontalWide,
                        valueKey: "nrp",
                        titleKey: "nama",
                        isRequired: true,
                      ),
                      _buildTitle(
                        title: 'Keterangan Cuti',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        horizontalPadding: paddingHorizontalWide,
                        isRequired: true,
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
                                        child: TextFormFieldNumberWidget(
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
                                      _buildDropdownSection(
                                        width: size.width,
                                        height: size.height,
                                        horizontalPadding:
                                            paddingHorizontalNarrow,
                                        items: selectedCutiLainnya,
                                        selectedValue: selectedValueCutiLainnya,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedValueCutiLainnya =
                                                newValue ?? '';
                                            updateJumlahCutiLainnya(
                                                selectedValueCutiLainnya!);
                                          });
                                        },
                                        textSize: textMedium,
                                        maxHeight: maxHeightEntitas,
                                      ),
                                      SizedBox(height: sizedBoxHeightTall),
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
                                      SizedBox(height: sizedBoxHeightShort),
                                      Row(
                                        children: [
                                          _buildTextFormFieldNumberSection(
                                            width: size.width,
                                            horizontalPadding:
                                                paddingHorizontalNarrow,
                                            controller: _izinLainnyaController,
                                            hintText: '0',
                                            maxHeight: maxHeightIzinLainnya,
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
                                                  color:
                                                      const Color(primaryBlack),
                                                  fontSize: textMedium,
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.9,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: sizedBoxHeightTall),
                                      _buildTableSection(
                                        data: dataCutiLainnya,
                                        horizontalPadding:
                                            paddingHorizontalNarrow,
                                        verticalPadding: padding7,
                                        textSmall: textSmall,
                                        textMedium: textMedium,
                                        onDelete: (int rowIndex) {
                                          setState(() {
                                            dataCutiLainnya.removeAt(rowIndex);
                                            totalLama =
                                                dataCutiLainnya.fold<int>(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                          (element['lama'] ?? 0)
                                                      as int,
                                            );
                                            totalCutiYangDiambil =
                                                cutiDibayarTambahCutiTidakDibayar +
                                                    totalLama;
                                          });
                                        },
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
                      BuildTextFieldWidget(
                        title: 'Keperluan Cuti',
                        isMandatory: true,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalWide,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _keperluanCutiController,
                        hintText: 'Keperluan Cuti',
                        maxHeightConstraints: maxHeightKeperluanCuti,
                        validator: validatorKeperluanCuti,
                      ),
                      _buildTitle(
                        title: 'Catatan Cuti',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        horizontalPadding: paddingHorizontalWide,
                        isRequired: false,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildColumnSection(
                            width: size.width * 0.48,
                            horizontalPadding: paddingHorizontalNarrow,
                            title: 'Cuti Yang Diambil',
                            textMedium: textMedium,
                            sizedBoxHeightShort: sizedBoxHeightShort,
                            maxHeight: maxHeightCutiYangDiambil,
                            hintText: '$totalCutiYangDiambil',
                          ),
                          _buildColumnSection(
                            width: size.width * 0.48,
                            horizontalPadding: paddingHorizontalNarrow,
                            title: 'Sisa Cuti Tahunan',
                            textMedium: textMedium,
                            sizedBoxHeightShort: sizedBoxHeightShort,
                            maxHeight: 50.0,
                            hintText: '$sisaCutiMaster',
                          ),
                        ],
                      ),
                      _buildTitle(
                        title: 'Tanggal Pengajuan Cuti ',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        horizontalPadding: paddingHorizontalWide,
                        isRequired: true,
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
                                          tanggalMulai != null
                                              ? DateFormat('dd-MM-yyyy').format(
                                                  _tanggalMulaiController
                                                          .selectedDate ??
                                                      DateTime.now())
                                              : 'dd/mm/yyyy',
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

                                                  if (selectedValueCutiLainnya ==
                                                      '12') {
                                                    _tanggalBerakhirController
                                                            .selectedDate =
                                                        tanggalMulai!.add(
                                                            Duration(days: 90));

                                                    tanggalBerakhir =
                                                        tanggalMulai!.add(
                                                            Duration(days: 90));
                                                  }
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
                                          tanggalBerakhir != null
                                              ? DateFormat('dd-MM-yyyy').format(
                                                  _tanggalBerakhirController
                                                          .selectedDate ??
                                                      DateTime.now())
                                              : 'dd/mm/yyyy',
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
                                    if (selectedValueCutiLainnya != '12') {
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
                                                    tanggalBerakhir =
                                                        args.value;
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
                                    }
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
                                  tanggalKembaliKerja != null
                                      ? DateFormat('dd-MM-yyyy').format(
                                          _tanggalKembaliKerjaController
                                                  .selectedDate ??
                                              DateTime.now())
                                      : 'dd/mm/yyyy',
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
                      BuildTextFieldWidget(
                        title: 'Alamat Cuti',
                        isMandatory: true,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalWide,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _alamatCutiController,
                        hintText: 'Alamat Cuti',
                        maxHeightConstraints: maxHeightAlamatCuti,
                        validator: validatorAlamatCuti,
                      ),
                      BuildTextFieldWidget(
                        title: 'No Telepon',
                        isMandatory: true,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalWide,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _noTeleponController,
                        hintText: '089XXXX',
                        maxHeightConstraints: maxHeightNoTelepon,
                        validator: validatorNoTelepon,
                        isNumberField: true,
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
                        height: sizedBoxHeightTall,
                      )
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

  Widget _buildTitle({
    required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required double horizontalPadding,
    bool isRequired = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalWide = size.width * 0.0585;
    return Column(
      children: [
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
              if (isRequired)
                Text(
                  '*',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: fontSize,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
          child: const LineWidget(),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
      ],
    );
  }

  Widget _buildDropdownSection({
    required double width,
    required double height,
    required double horizontalPadding,
    required List<Map<String, dynamic>> items,
    required String? selectedValue,
    required Function(String?) onChanged,
    required double textSize,
    required double maxHeight,
  }) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.93,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: DropdownButtonFormField<String>(
              menuMaxHeight: height * 0.5,
              value: selectedValue,
              icon: items.isEmpty
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              onChanged: onChanged,
              items: items.map((Map<String, dynamic> value) {
                String title = value["jenis"] as String;
                return DropdownMenuItem<String>(
                  value: value["id"].toString(),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TitleWidget(
                      title: title.length > 40
                          ? '${title.substring(0, 40)}...'
                          : title,
                      fontWeight: FontWeight.w300,
                      fontSize: textSize,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                constraints: BoxConstraints(maxHeight: maxHeight),
                labelStyle: TextStyle(fontSize: textSize),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: selectedValue != null ? Colors.black54 : Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormFieldNumberSection({
    required double width,
    required double horizontalPadding,
    required TextEditingController controller,
    required String hintText,
    required double maxHeight,
  }) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.45,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: TextFormFieldNumberWidget(
              controller: controller,
              maxHeightConstraints: maxHeight,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableSection({
    required List<Map<String, dynamic>> data,
    required double horizontalPadding,
    required double verticalPadding,
    required double textSmall,
    required double textMedium,
    required Function(int) onDelete,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        child: data.isNotEmpty
            ? Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      _buildTableCell('Jenis Cuti', verticalPadding),
                      _buildTableCell('Jumlah', verticalPadding),
                      _buildTableCell('Aksi', verticalPadding),
                    ],
                  ),
                  ...data.asMap().entries.map((entry) {
                    final int rowIndex = entry.key;
                    final Map<String, dynamic> rowData = entry.value;
                    return TableRow(
                      children: [
                        _buildTableCell(rowData['jenis'], verticalPadding),
                        _buildTableCell(
                            rowData['lama'].toString(), verticalPadding),
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: verticalPadding),
                              child: InkWell(
                                onTap: () => onDelete(rowIndex),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: verticalPadding,
                                      horizontal: horizontalPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(
                                      color: const Color(primaryBlack),
                                      fontSize: textSmall,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
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
    );
  }

  TableCell _buildTableCell(String text, double padding) {
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(padding),
        child: Center(child: Text(text)),
      ),
    );
  }

  Widget _buildTextFormFieldDisableWithNoController({
    required double width,
    required double horizontalPadding,
    required double maxHeight,
    required String hintText,
    required double textSize,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 0,
                  ),
                ),
                constraints: BoxConstraints(maxHeight: maxHeight),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: textSize,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnSection({
    required double width,
    required double horizontalPadding,
    required String title,
    required double textMedium,
    required double sizedBoxHeightShort,
    required double maxHeight,
    required String hintText,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: TitleWidget(
              title: title,
              fontWeight: FontWeight.w300,
              fontSize: textMedium,
            ),
          ),
          SizedBox(height: sizedBoxHeightShort),
          _buildTextFormFieldDisableWithNoController(
            width: width,
            horizontalPadding: horizontalPadding,
            maxHeight: maxHeight,
            hintText: hintText,
            textSize: textMedium,
          ),
        ],
      ),
    );
  }
}
