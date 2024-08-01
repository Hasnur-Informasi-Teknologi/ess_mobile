import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
// import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_detail_pengajuan_rawat_inap.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_two_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_text_field_widget.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormPengajuanRawatInap extends StatefulWidget {
  const FormPengajuanRawatInap({super.key});

  @override
  State<FormPengajuanRawatInap> createState() => _FormPengajuanRawatInapState();
}

class _FormPengajuanRawatInapState extends State<FormPengajuanRawatInap> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _perusahaanController = TextEditingController();
  final _lokasiKerjaController = TextEditingController();
  final _pangkatController = TextEditingController();
  final _namaPasienController = TextEditingController();
  final _tanggalPengajuanRawatJalanController = TextEditingController();
  double maxHeightKode = 50.0;
  double maxHeightNrp = 50.0;
  double maxHeightNama = 50.0;
  double maxHeightPerusahaan = 50.0;
  double maxHeightLokasiKerja = 50.0;
  double maxHeightPangkat = 50.0;
  double maxHeightHubunganDenganKaryawan = 60.0;
  double maxHeightJenisPengganti = 60.0;
  double maxHeightNamaPasien = 50.0;
  double maxHeightEntitas = 60.0;
  double maxHeightAtasan = 60.0;
  double maxHeightEntitasHrgs = 60.0;
  double maxHeightHrgs = 60.0;
  double maxHeightEntitasKeuangan = 60.0;
  double maxHeightKeuangan = 60.0;
  DateTime tanggalMasuk = DateTime.now();
  final DateRangePickerController _tanggalPengajuanController =
      DateRangePickerController();
  DateTime? tanggalPengajuan;
  final DateRangePickerController _tanggalMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;
  final DateRangePickerController _tanggalBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;

  bool _isLoading = false;
  bool _isKelas3Checked = false;
  bool _isKelas2Checked = false;
  bool _isKelas1Checked = false;
  bool _isVipChecked = false;
  bool _isVvipChecked = false;
  bool _isEmptyKelas = false;

  List<Map<String, dynamic>> dataDetail = [];
  List<Map<String, dynamic>> allData = [];
  String? jumlahTotal,
      selectedValueHubunganDenganKarwayan,
      selectedValueEntitas,
      selectedValueEntitasHrgs,
      selectedValueEntitasKeuangan,
      selectedValueAtasan,
      selectedValueHrgs,
      selectedValueKeuangan,
      kelasKamar;

  List<Map<String, dynamic>> selectedHubunganDenganKarwayan = [];

  dynamic dataEmployee;

  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedEntitasHrgs = [];
  List<Map<String, dynamic>> selectedEntitasKeuangan = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedHrgs = [];
  List<Map<String, dynamic>> selectedKeuangan = [];

  @override
  void initState() {
    super.initState();
    getDetailPenganjuanRawatInap();
    getData();
    getDataEntitas();
    getDataAtasan();
    getDataHrgs();
    getDataKeuangan();
    getHubungan();
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString())['data'];
    setState(() {
      _nrpController.text = responseData['pernr'];
      _namaController.text = responseData['nama'];
      _perusahaanController.text = responseData['abr_org_id'];
      _lokasiKerjaController.text = responseData['lokasi'];
      _pangkatController.text = responseData['pangkat'];
      _tanggalPengajuanRawatJalanController.text = responseData['hire_date'];
      dataEmployee = responseData;
    });
  }

  void getDetailPenganjuanRawatInap() {
    Get.put(DataDetailPengajuanRawatInapController());
    DataDetailPengajuanRawatInapController
        dataDetailPengajuanRawatInapController = Get.find();
    allData = dataDetailPengajuanRawatInapController.getDataList();
    setState(() {
      dataDetail = allData;
    });

    // Hitung jumlah total
    int total = 0;
    for (var data in dataDetail) {
      final jumlah = int.tryParse(data['jumlah']) ?? 0;
      total += jumlah;
    }
    // Set jumlahTotal dengan total
    // jumlahTotal = total.toString();
    jumlahTotal = NumberFormat.decimalPattern('id-ID').format(total);
  }

  String _formatAmount(dynamic amount) {
    if (amount is String) {
      double parsedAmount = double.tryParse(amount) ?? 0.0;
      String formattedAmount =
          NumberFormat.decimalPattern('id-ID').format(parsedAmount);
      if (parsedAmount < 0) {
        formattedAmount = '(${formattedAmount.substring(1)})';
      }
      return formattedAmount;
    }
    return '0';
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

  Future<void> getHubungan() async {
    await _fetchData(
      "karyawan/hubungan",
      (data) {
        final dataApi = data['data'] as Map<String, dynamic>;

        final List<Map<String, dynamic>> transformedData =
            dataApi.entries.map((entry) {
          return {
            'jenis': entry.key,
            'nama': entry.value,
          };
        }).toList();

        setState(() {
          selectedHubunganDenganKarwayan =
              List<Map<String, dynamic>>.from(transformedData);
        });
      },
    );
  }

  Future<void> getDataEntitas() async {
    await _fetchData(
      "master/entitas",
      (data) {
        final dataEntitasApi = data['data'];

        setState(() {
          selectedEntitas = List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasHrgs = List<Map<String, dynamic>>.from(dataEntitasApi);
          selectedEntitasKeuangan =
              List<Map<String, dynamic>>.from(dataEntitasApi);
        });
      },
    );
  }

  Future<void> getDataAtasan() async {
    await _fetchData(
      "master/cuti/atasan",
      (data) {
        final dataAtasanApi = data['list_karyawan'];

        setState(() {
          selectedAtasan = List<Map<String, dynamic>>.from(dataAtasanApi);
        });
      },
      queryParams: {
        'entitas': selectedValueEntitas.toString(),
      },
    );
  }

  Future<void> getDataHrgs() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataHrgsApi = data['data'];

        setState(() {
          selectedHrgs = List<Map<String, dynamic>>.from(dataHrgsApi);
        });
      },
      queryParams: {
        'atasan': '06',
        'entitas': selectedValueEntitasHrgs.toString(),
      },
    );
  }

  Future<void> getDataKeuangan() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataKeuanganApi = data['data'];

        setState(() {
          selectedKeuangan = List<Map<String, dynamic>>.from(dataKeuanganApi);
        });
      },
      queryParams: {
        'atasan': '11',
        'entitas': selectedValueEntitasKeuangan.toString(),
      },
    );
  }

  void _hapusData(int index) {
    setState(() {
      dataDetail.removeAt(index);
    });
    getDetailPenganjuanRawatInap();
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (_isKelas3Checked) {
      kelasKamar = 'Kelas 3';
    } else if (_isKelas2Checked) {
      kelasKamar = 'Kelas 2';
    } else if (_isKelas1Checked) {
      kelasKamar = 'Kelas 1';
    } else if (_isVipChecked) {
      kelasKamar = 'VIP';
    } else if (_isVvipChecked) {
      kelasKamar = 'VVIP';
    } else {
      kelasKamar = '';
    }

    if (kelasKamar == '') {
      setState(() {
        _isEmptyKelas = true;
      });
      return;
    } else {
      setState(() {
        _isEmptyKelas = false;
      });
    }

    if (tanggalMulai == null || tanggalBerakhir == null) {
      Get.snackbar('Infomation', 'Tanggal Wajib Diisi',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final ioClient = createIOClientWithInsecureConnection();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/rawat/inap/create'),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nama'] = _namaController.text;
    request.fields['pernr'] = _nrpController.text;
    request.fields['pt'] = _perusahaanController.text;
    request.fields['lokasi'] = _lokasiKerjaController.text;
    request.fields['pangkat'] = _pangkatController.text;
    request.fields['hire_date'] = _tanggalPengajuanRawatJalanController.text;
    request.fields['entitas_atasan'] = selectedValueEntitas.toString();
    request.fields['entitas_hrgs'] = selectedValueEntitasHrgs.toString();
    request.fields['prd_rawat_mulai'] = tanggalMulai != null
        ? tanggalMulai.toString()
        : DateTime.now().toString();
    request.fields['prd_rawat_akhir'] = tanggalBerakhir != null
        ? tanggalBerakhir.toString()
        : DateTime.now().toString();
    request.fields['hub_karyawan'] =
        selectedValueHubunganDenganKarwayan.toString();
    request.fields['nm_pasien'] = _namaPasienController.text;
    request.fields['approved_by1'] = selectedValueAtasan.toString();
    request.fields['approved_by2'] = selectedValueHrgs.toString();
    request.fields['entitas_keuangan'] =
        selectedValueEntitasKeuangan.toString();
    request.fields['approved_by3'] = selectedValueKeuangan.toString();
    request.fields['kls_kamar_ajukan'] = kelasKamar!;

    for (int i = 0; i < allData.length; i++) {
      request.fields['detail[$i][id]'] = allData[i]['id'].toString();
      request.fields['detail[$i][benefit_type]'] = allData[i]['benefit_type'];
      request.fields['detail[$i][id_diagnosa]'] = allData[i]['id_diagnosa'];
      request.fields['detail[$i][no_kuitansi]'] = allData[i]['no_kuitansi'];
      request.fields['detail[$i][tgl_kuitansi]'] = allData[i]['tgl_kuitansi'];
      request.fields['detail[$i][detail_penggantian]'] =
          allData[i]['detail_penggantian'];
      request.fields['detail[$i][jumlah]'] = allData[i]['jumlah'].toString();
      request.fields['detail[$i][keterangan]'] = allData[i]['keterangan'];

      String filePath = allData[i]['lampiran_pembayaran'];
      File file = File(filePath);
      request.files.add(http.MultipartFile(
        'detail[$i][lampiran_pembayaran]',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
      ));
    }

    var streamedResponse = await ioClient.send(request);
    final responseData = await streamedResponse.stream.bytesToString();
    final responseDataMessage = json.decode(responseData);
    Get.snackbar('Infomation', responseDataMessage['message'],
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
    print('Message $responseDataMessage');
    if (responseDataMessage['status'] == 'success') {
      allData.clear();
      setState(() {
        dataDetail = [];
      });
      Get.offAllNamed('/user/main');
    }
  }

  String? _validatorHubunganDenganKaryawan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightHubunganDenganKaryawan = 80.0;
      });
      return 'Field Hubungan Dengan Karyawan Kosong';
    }

    setState(() {
      maxHeightHubunganDenganKaryawan = 60.0;
    });
    return null;
  }

  String? _validatorNamaPasien(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNamaPasien = 70.0;
      });
      return 'Field Nama Pasien Kosong';
    }

    setState(() {
      maxHeightNamaPasien = 50.0;
    });
    return null;
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

  String? _validatorEntitasHrgs(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasHrgs = 80.0;
      });
      return 'Field Entitas Hrgs Kosong';
    }

    setState(() {
      maxHeightEntitasHrgs = 60.0;
    });
    return null;
  }

  String? _validatorHrgs(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightHrgs = 80.0;
      });
      return 'Field Hrgs Kosong';
    }

    setState(() {
      maxHeightHrgs = 60.0;
    });
    return null;
  }

  String? _validatorEntitasKeuangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasKeuangan = 80.0;
      });
      return 'Field Entitas Direktur Keuangan Kosong';
    }

    setState(() {
      maxHeightEntitasKeuangan = 60.0;
    });
    return null;
  }

  String? _validatorKeuangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKeuangan = 80.0;
      });
      return 'Field Direktur Keuangan Kosong';
    }

    setState(() {
      maxHeightKeuangan = 60.0;
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
                  Get.offAllNamed(
                      '/user/main/home/online_form/pengajuan_fasilitas_kesehatan');
                  allData.clear();
                  setState(() {
                    dataDetail = [];
                  });
                },
              ),
              title: Text(
                'Pengajuan Rawat Inap',
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
                      BuildTextFieldWidget(
                        title: 'NRP',
                        isMandatory: false,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalNarrow,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _nrpController,
                        hintText: 'NRP',
                        maxHeightConstraints: maxHeightNrp,
                        isDisable: true,
                      ),
                      BuildTextFieldWidget(
                        title: 'Nama',
                        isMandatory: false,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalNarrow,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _namaController,
                        hintText: 'Nama',
                        maxHeightConstraints: maxHeightNama,
                        isDisable: true,
                      ),
                      BuildTextFieldWidget(
                        title: 'Perusahaan',
                        isMandatory: false,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalNarrow,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _perusahaanController,
                        hintText: 'Perusahaan',
                        maxHeightConstraints: maxHeightPerusahaan,
                        isDisable: true,
                      ),
                      BuildTextFieldWidget(
                        title: 'Lokasi Kerja',
                        isMandatory: false,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalNarrow,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _lokasiKerjaController,
                        hintText: 'Lokasi Kerja',
                        maxHeightConstraints: maxHeightLokasiKerja,
                        isDisable: true,
                      ),
                      BuildTextFieldWidget(
                        title: 'Pangkat',
                        isMandatory: false,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalNarrow,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _pangkatController,
                        hintText: 'Pangkat',
                        maxHeightConstraints: maxHeightPangkat,
                        isDisable: true,
                      ),
                      _buildTitle(
                        title: 'Periode Rawat',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w700,
                        horizontalPadding: paddingHorizontalNarrow,
                        isRequired: false,
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
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
                                  child: Row(
                                    children: [
                                      TitleWidget(
                                        title: 'Tanggal Mulai ',
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
                                              maxDate: DateTime.now(),
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
                                  child: Row(
                                    children: [
                                      TitleWidget(
                                        title: 'Tanggal Berakhir ',
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Container(
                                            height: 350,
                                            width: 350,
                                            child: SfDateRangePicker(
                                              maxDate: DateTime.now(),
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
                      BuildDropdownWithTitleWidget(
                        title: 'Pilih Hubungan Dengan Karyawan : ',
                        selectedValue: selectedValueHubunganDenganKarwayan,
                        itemList: selectedHubunganDenganKarwayan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueHubunganDenganKarwayan =
                                newValue ?? '';
                            List<Map<String, dynamic>> dataFiltered =
                                selectedHubunganDenganKarwayan
                                    .where((item) =>
                                        item['jenis'] ==
                                        selectedValueHubunganDenganKarwayan)
                                    .toList();
                            _namaPasienController.text =
                                dataFiltered[0]['nama'].toString();
                          });
                        },
                        validator: _validatorHubunganDenganKaryawan,
                        maxHeight: maxHeightHubunganDenganKaryawan,
                        isLoading: selectedHubunganDenganKarwayan.isEmpty,
                        horizontalPadding: paddingHorizontalNarrow,
                        valueKey: "jenis",
                        titleKey: "jenis",
                      ),
                      BuildTextFieldWidget(
                        title: 'Nama Pasien',
                        isMandatory: true,
                        textSize: textMedium,
                        horizontalPadding: paddingHorizontalNarrow,
                        verticalSpacing: sizedBoxHeightShort,
                        controller: _namaPasienController,
                        hintText: 'Nama Pasien',
                        maxHeightConstraints: maxHeightNamaPasien,
                        validator: _validatorNamaPasien,
                        isDisable: true,
                      ),
                      BuildDropdownWithTitleWidget(
                        title: 'Pilih Entitas : ',
                        selectedValue: selectedValueEntitas,
                        itemList: selectedEntitas,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitas = newValue ?? '';
                            selectedValueAtasan = null;
                            selectedAtasan = [];
                            getDataAtasan();
                          });
                        },
                        validator: _validatorEntitas,
                        maxHeight: maxHeightEntitas,
                        isLoading: selectedEntitas.isEmpty,
                        horizontalPadding: paddingHorizontalNarrow,
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
                        horizontalPadding: paddingHorizontalNarrow,
                        valueKey: "nrp",
                        titleKey: "nama",
                        isRequired: true,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding10),
                        child: RowWithButtonWidget(
                          textLeft: 'Daftar Pengajuan Rawat Inap',
                          textRight: 'Tambah Pengajuan',
                          fontSizeLeft: textMedium,
                          fontSizeRight: textSmall,
                          fontWeightLeft: FontWeight.w700,
                          onTab: () {
                            Get.to(
                              () => const FormDetailPengajuanRawatInap(),
                              arguments: {
                                'onClose': () {
                                  getDetailPenganjuanRawatInap();
                                },
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      daftarPengajuanWidget(context),
                      dataDetail.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalWide,
                                  vertical: padding10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleCenterWidget(
                                    textLeft: 'Total',
                                    textRight: ': Rp ${jumlahTotal}',
                                    fontSizeLeft: textMedium,
                                    fontSizeRight: textMedium,
                                    fontWeightLeft: FontWeight.w500,
                                    fontWeightRight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            )
                          : const Text(''),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Kelas Kamar yang Diajukan :',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildCheckbox('Kelas 3', _isKelas3Checked),
                          buildCheckbox('Kelas 2', _isKelas2Checked),
                          buildCheckbox('Kelas 1', _isKelas1Checked),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildCheckbox('VIP', _isVipChecked),
                          buildCheckbox('VVIP', _isVvipChecked),
                        ],
                      ),
                      _isEmptyKelas == true
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: Text(
                                'Field Kelas Kamar Kosong',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: textMedium,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.6,
                                    fontWeight: FontWeight.w300),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      _buildTitle(
                        title: 'Diajukan Kepada',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w700,
                        horizontalPadding: paddingHorizontalNarrow,
                        isRequired: false,
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      BuildDropdownWithTitleWidget(
                        title: 'Pilih Entitas HCGS : ',
                        selectedValue: selectedValueEntitasHrgs,
                        itemList: selectedEntitasHrgs,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitasHrgs = newValue ?? '';
                            selectedValueHrgs = null;
                            selectedHrgs = [];
                            getDataHrgs();
                          });
                        },
                        validator: _validatorEntitasHrgs,
                        maxHeight: maxHeightEntitasHrgs,
                        isLoading: selectedEntitasHrgs.isEmpty,
                        horizontalPadding: paddingHorizontalNarrow,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      BuildDropdownWithTwoTitleWidget(
                        title: 'HCGS : ',
                        selectedValue: selectedValueHrgs,
                        itemList: selectedHrgs,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueHrgs = newValue ?? '';
                          });
                        },
                        validator: _validatorHrgs,
                        maxHeight: maxHeightAtasan,
                        isLoading: selectedHrgs.isEmpty,
                        horizontalPadding: paddingHorizontalNarrow,
                        valueKey: "pernr",
                        titleKey: "nama",
                        isRequired: true,
                      ),
                      BuildDropdownWithTitleWidget(
                        title: 'Pilih Entitas Direktur HCGS : ',
                        selectedValue: selectedValueEntitasKeuangan,
                        itemList: selectedEntitasKeuangan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitasKeuangan = newValue ?? '';
                            selectedValueKeuangan = null;
                            selectedKeuangan = [];
                            getDataKeuangan();
                          });
                        },
                        validator: _validatorEntitasKeuangan,
                        maxHeight: maxHeightEntitasKeuangan,
                        isLoading: selectedEntitasKeuangan.isEmpty,
                        horizontalPadding: paddingHorizontalNarrow,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      BuildDropdownWithTwoTitleWidget(
                        title: 'Pilih Direktur HCGS : ',
                        selectedValue: selectedValueKeuangan,
                        itemList: selectedKeuangan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueKeuangan = newValue ?? '';
                          });
                        },
                        validator: _validatorKeuangan,
                        maxHeight: maxHeightKeuangan,
                        isLoading: selectedKeuangan.isEmpty,
                        horizontalPadding: paddingHorizontalNarrow,
                        valueKey: "pernr",
                        titleKey: "nama",
                        isRequired: true,
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

  Widget daftarPengajuanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontalWide, vertical: padding10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LineWidget(),
          dataDetail.isNotEmpty
              ? ListView.builder(
                  itemCount: dataDetail.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final data = dataDetail[index];
                    return InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Jenis Penggantian',
                            textRight:
                                ': ${data['selectedValueJenisPengganti']}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'Detail Penggantian',
                            textRight: ': ${data['detail_penggantian']}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'Diagnosa',
                            textRight: ': ${data['jenis_diagnosa']}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'No Kuitansi',
                            textRight: ': ${data['no_kuitansi']}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'Tanggal Kuitansi',
                            textRight: ': ${data['tgl_kuitansi']}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'Lampiran',
                            textRight: ': Dilampirkan',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'Keterangan',
                            textRight: ': ${data['keterangan']}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          TitleCenterWidget(
                            textLeft: 'Jumlah',
                            textRight: ': Rp ${_formatAmount(data['jumlah'])}',
                            fontSizeLeft: textMedium,
                            fontSizeRight: textMedium,
                          ),
                          SizedBox(height: sizedBoxHeightShort),
                          InkWell(
                            onTap: () {
                              _hapusData(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: padding5,
                                  horizontal: paddingHorizontalWide),
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
                          SizedBox(
                            height: sizedBoxHeightExtraTall,
                          ),
                          const LineWidget(),
                        ],
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    SizedBox(
                      height: sizedBoxHeightShort,
                    ),
                    Center(
                        child: Text(
                      'Data Masih Kosong',
                      style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    )),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildCheckbox(String label, bool value) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) {
            setState(() {
              _isKelas3Checked = (label == 'Kelas 3' ? newValue : false)!;
              _isKelas2Checked = (label == 'Kelas 2' ? newValue : false)!;
              _isKelas1Checked = (label == 'Kelas 1' ? newValue : false)!;
              _isVipChecked = (label == 'VIP' ? newValue : false)!;
              _isVvipChecked = (label == 'VVIP' ? newValue : false)!;
              _isEmptyKelas = false;
            });
          },
        ),
        Text(label,
            style: TextStyle(
                color: const Color(primaryBlack),
                fontSize: textMedium,
                fontFamily: 'Poppins',
                letterSpacing: 0.6,
                fontWeight: FontWeight.w500)),
      ],
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
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: const LineWidget(),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
      ],
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
}
