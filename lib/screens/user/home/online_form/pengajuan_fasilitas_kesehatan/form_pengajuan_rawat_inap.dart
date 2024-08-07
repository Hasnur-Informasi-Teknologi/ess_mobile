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
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
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
  double maxHeightKode = 40.0;
  double maxHeightNrp = 40.0;
  double maxHeightNama = 40.0;
  double maxHeightPerusahaan = 40.0;
  double maxHeightLokasiKerja = 40.0;
  double maxHeightPangkat = 40.0;
  double maxHeightHubunganDenganKaryawan = 60.0;
  double maxHeightJenisPengganti = 60.0;
  double maxHeightNamaPasien = 40.0;
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

  List<Map<String, dynamic>> dataDetail = [];
  List<Map<String, dynamic>> allData = [];
  String? jumlahTotal,
      selectedValueHubunganDenganKarwayan,
      selectedValueEntitas,
      selectedValueEntitasHrgs,
      selectedValueEntitasKeuangan,
      selectedValueAtasan,
      selectedValueHrgs,
      selectedValueKeuangan;

  List<Map<String, dynamic>> selectedHubunganDenganKarwayan = [
    {'opsi': 'Diri Sendiri'},
  ];

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
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

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
        maxHeightNamaPasien = 60.0;
      });
      return 'Field Nama Pasien Kosong';
    }

    setState(() {
      maxHeightNamaPasien = 40.0;
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
                        onPressed: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       content: Container(
                          //         height: 350,
                          //         width: 350,
                          //         child: SfDateRangePicker(
                          //           controller: _tanggalPengajuanController,
                          //           onSelectionChanged:
                          //               (DateRangePickerSelectionChangedArgs
                          //                   args) {
                          //             setState(() {
                          //               tanggalPengajuan = args.value;
                          //             });
                          //           },
                          //           selectionMode:
                          //               DateRangePickerSelectionMode.single,
                          //         ),
                          //       ),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: () => Navigator.pop(context),
                          //           child: Text('OK'),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'NRP *',
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
                          title: 'Perusahaan',
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
                          controller: _perusahaanController,
                          maxHeightConstraints: maxHeightPerusahaan,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Lokasi Kerja',
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
                          controller: _lokasiKerjaController,
                          maxHeightConstraints: maxHeightLokasiKerja,
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
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Periode Rawat',
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
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Hubungan Dengan Karyawan ',
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
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorHubunganDenganKaryawan,
                          value: selectedValueHubunganDenganKarwayan,
                          icon: selectedHubunganDenganKarwayan.isEmpty
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
                              selectedValueHubunganDenganKarwayan =
                                  newValue ?? '';
                              if (selectedValueHubunganDenganKarwayan ==
                                  'Diri Sendiri') {
                                _namaPasienController.text =
                                    dataEmployee['nama'];
                              }
                            });
                          },
                          items: selectedHubunganDenganKarwayan
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["opsi"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["opsi"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            constraints: BoxConstraints(
                                maxHeight: maxHeightHubunganDenganKaryawan),
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
                                    selectedValueHubunganDenganKarwayan != null
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
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Nama Pasien ',
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
                          validator: _validatorNamaPasien,
                          controller: _namaPasienController,
                          maxHeightConstraints: maxHeightNamaPasien,
                          hintText: 'Nama Pasien',
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
                              selectedValueAtasan = null;
                              getDataAtasan();
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
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding10),
                        child: RowWithButtonWidget(
                          textLeft: 'Daftar Pengajuan Rawat Inap',
                          textRight: 'Tambah Pengajuan',
                          fontSizeLeft: textMedium,
                          fontSizeRight: textSmall,
                          onTab: () {
                            // Get.toNamed(
                            //     '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_inap/detail_pengajuan_rawat_inap');
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide,
                            vertical: padding10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LineWidget(),
                            dataDetail.isNotEmpty
                                ? ListView.builder(
                                    itemCount: dataDetail.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                              textRight: ': ${data['id']}',
                                              fontSizeLeft: textMedium,
                                              fontSizeRight: textMedium,
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            TitleCenterWidget(
                                              textLeft: 'Detail Penggantian',
                                              textRight:
                                                  ': ${data['detail_penggantian']}',
                                              fontSizeLeft: textMedium,
                                              fontSizeRight: textMedium,
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            TitleCenterWidget(
                                              textLeft: 'No Kuitansi',
                                              textRight:
                                                  ': ${data['no_kuitansi']}',
                                              fontSizeLeft: textMedium,
                                              fontSizeRight: textMedium,
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            TitleCenterWidget(
                                              textLeft: 'Jumlah',
                                              textRight:
                                                  ': Rp ${_formatAmount(data['jumlah'])}',
                                              fontSizeLeft: textMedium,
                                              fontSizeRight: textMedium,
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            InkWell(
                                              onTap: () {
                                                _hapusData(index);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: padding5,
                                                    horizontal:
                                                        paddingHorizontalWide),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                ),
                                                child: Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                    color: const Color(
                                                        primaryBlack),
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
                      ),
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
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Diajukan Kepada',
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
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Entitas HRGS : ',
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
                          validator: _validatorEntitasHrgs,
                          value: selectedValueEntitasHrgs,
                          icon: selectedEntitasHrgs.isEmpty
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
                              selectedValueEntitasHrgs = newValue ?? '';
                              // selectedValueHrgs = null;
                              getDataHrgs();
                            });
                          },
                          items: selectedEntitasHrgs
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
                                BoxConstraints(maxHeight: maxHeightEntitasHrgs),
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
                              title: 'HRGS : ',
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
                          validator: _validatorHrgs,
                          value: selectedValueHrgs,
                          icon: selectedHrgs.isEmpty
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
                              selectedValueHrgs = newValue ?? '';
                            });
                          },
                          items: selectedHrgs.map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["pernr"]} - ${value["nama"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints:
                                BoxConstraints(maxHeight: maxHeightHrgs),
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
                          validator: _validatorEntitasKeuangan,
                          value: selectedValueEntitasKeuangan,
                          icon: selectedEntitasKeuangan.isEmpty
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
                              selectedValueEntitasKeuangan = newValue ?? '';
                              // selectedValueKeuangan = null;
                              getDataKeuangan();
                            });
                          },
                          items: selectedEntitasKeuangan
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
                                maxHeight: maxHeightEntitasKeuangan),
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
                          validator: _validatorKeuangan,
                          value: selectedValueKeuangan,
                          icon: selectedKeuangan.isEmpty
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
                              selectedValueKeuangan = newValue ?? '';
                            });
                          },
                          items: selectedKeuangan
                              .map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["pernr"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: '${value["pernr"]} - ${value["nama"]}',
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: textMedium),
                            constraints:
                                BoxConstraints(maxHeight: maxHeightKeuangan),
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
}
