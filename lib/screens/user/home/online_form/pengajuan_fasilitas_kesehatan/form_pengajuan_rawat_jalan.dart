import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_detail_pengajuan_rawat_jalan.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'dart:html' as html;

class FormPengajuanRawatJalan extends StatefulWidget {
  const FormPengajuanRawatJalan({super.key});

  @override
  State<FormPengajuanRawatJalan> createState() =>
      _FormPengajuanRawatJalanState();
}

class _FormPengajuanRawatJalanState extends State<FormPengajuanRawatJalan> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _perusahaanController = TextEditingController();
  final _lokasiKerjaController = TextEditingController();
  final _pangkatController = TextEditingController();
  final _tanggalPengajuanRawatJalanController = TextEditingController();
  double maxHeightKode = 40.0;
  double maxHeightNrp = 40.0;
  double maxHeightNama = 40.0;
  double maxHeightPerusahaan = 40.0;
  double maxHeightLokasiKerja = 40.0;
  double maxHeightPangkat = 40.0;
  double maxHeightEntitas = 60.0;
  double maxHeightAtasan = 60.0;
  double maxHeightEntitasHrgs = 60.0;
  double maxHeightHrgs = 60.0;
  double maxHeightEntitasDirekturKeuangan = 60.0;
  double maxHeightDirekturKeuangan = 60.0;
  String? selectedValueEntitas,
      selectedValueEntitasHrgs,
      selectedValueEntitasKeuangan,
      selectedValueAtasan,
      selectedValueHrgs,
      selectedValueKeuangan;

  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedEntitasHrgs = [];
  List<Map<String, dynamic>> selectedEntitasKeuangan = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedHrgs = [];
  List<Map<String, dynamic>> selectedKeuangan = [];

  final DateRangePickerController _tanggalPengajuanController =
      DateRangePickerController();
  DateTime? tanggalPengajuan;
  final DateRangePickerController _periodeRawatController =
      DateRangePickerController();
  DateTime? periodeRawat;

  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> dataDetail = [];

  String? jumlahTotal;

  bool _isLoading = false;
  bool _isFileNull = false;
  List<PlatformFile>? _files;

  @override
  void initState() {
    super.initState();
    getData();
    getDetailPenganjuanRawatJalan();
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
    });
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _files = result.files;
        _isFileNull = false;
      });
    }
  }

  // dataCutiLainnya.removeAt(rowIndex);

  void getDetailPenganjuanRawatJalan() {
    Get.put(DataDetailPengajuanRawatJalanController());
    DataDetailPengajuanRawatJalanController
        dataDetailPengajuanRawatJalanController = Get.find();
    allData = dataDetailPengajuanRawatJalanController.getDataList();
    setState(() {
      dataDetail = allData;
    });
    int total = 0;
    for (var data in dataDetail) {
      final jumlah = int.tryParse(data['jumlah']) ?? 0;
      total += jumlah;
    }
    jumlahTotal = NumberFormat.decimalPattern('id-ID').format(total);
    // jumlahTotal = total.toString();
    ;
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
    getDetailPenganjuanRawatJalan();
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (periodeRawat == null) {
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
    _formKey.currentState!.save();

    String? filePath;

    if (_files != null) {
      filePath = _files!.single.path;
      setState(() {
        _isFileNull = false;
      });
    } else {
      setState(() {
        _isFileNull = true;
        _isLoading = false;
      });
      return;
    }

    File file = File(filePath!);
    final ioClient = createIOClientWithInsecureConnection();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/rawat/jalan/create'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    // Add file lampiran
    request.files.add(http.MultipartFile.fromBytes(
        'lampiran', file.readAsBytesSync(),
        filename: file.path.split('/').last));
    // Add the JSON data as a field
    request.fields['nama'] = _namaController.text;
    request.fields['pernr'] = _nrpController.text;
    request.fields['pt'] = _perusahaanController.text;
    request.fields['lokasi'] = _lokasiKerjaController.text;
    request.fields['pangkat'] = _pangkatController.text;
    request.fields['hire_date'] = _tanggalPengajuanRawatJalanController.text;
    request.fields['tgl_pengajuan'] = DateTime.now().toString();
    request.fields['entitas_atasan'] = selectedValueEntitas.toString();
    request.fields['prd_rawat'] = periodeRawat != null
        ? periodeRawat.toString()
        : DateTime.now().toString();
    request.fields['approved_by1'] = selectedValueAtasan.toString();
    request.fields['entitas_hrgs'] = selectedValueEntitasHrgs.toString();
    request.fields['entitas_keuangan'] = selectedValueEntitasHrgs.toString();
    request.fields['approved_by2'] = selectedValueHrgs.toString();
    request.fields['approved_by3'] = selectedValueKeuangan.toString();
    for (int i = 0; i < allData.length; i++) {
      // final data = allData[i];
      request.fields['detail[$i][id_md_jp_rawat_jalan]'] =
          allData[i]['id_md_jp_rawat_jalan'].toString();
      request.fields['detail[$i][benefit_type]'] = allData[i]['benefit_type'];
      request.fields['detail[$i][detail_penggantian]'] =
          allData[i]['detail_penggantian'];
      request.fields['detail[$i][id_diagnosa]'] = allData[i]['id_diagnosa'];
      request.fields['detail[$i][no_kuitansi]'] = allData[i]['no_kuitansi'];
      request.fields['detail[$i][tgl_kuitansi]'] = allData[i]['tgl_kuitansi'];
      request.fields['detail[$i][nm_pasien]'] = allData[i]['nm_pasien'];
      request.fields['detail[$i][hub_karyawan]'] = allData[i]['hub_karyawan'];
      request.fields['detail[$i][jumlah]'] = allData[i]['jumlah'].toString();
      request.fields['detail[$i][keterangan]'] = allData[i]['keterangan'];
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

  void deleteFile(PlatformFile file) {
    setState(() {
      _files?.remove(file);
      _isFileNull = _files?.isEmpty ?? true;
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

  String? _validatorEntitasHrgs(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightEntitasHrgs = 80.0;
      });
      return 'Field Entitas HRGS Kosong';
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
      return 'Field HRGS Kosong';
    }

    setState(() {
      maxHeightHrgs = 60.0;
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
                'Pengajuan Rawat Jalan',
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
                      _buildTextFieldSection(
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
                      _buildTextFieldSection(
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
                      _buildTextFieldSection(
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
                      _buildTextFieldSection(
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
                      _buildTextFieldSection(
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Periode Rawat ',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                periodeRawat != null
                                    ? DateFormat('dd-MM-yyyy').format(
                                        _periodeRawatController.selectedDate ??
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
                                    controller: _periodeRawatController,
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      setState(() {
                                        periodeRawat = args.value;
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
                      _buildDropdownWithTitle(
                        title: 'Pilih Entitas : ',
                        selectedValue: selectedValueEntitas,
                        itemList: selectedEntitas,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitas = newValue ?? '';
                            selectedValueAtasan = null;
                            getDataAtasan();
                          });
                        },
                        validator: _validatorEntitas,
                        maxHeight: maxHeightEntitas,
                        isLoading: selectedEntitas.isEmpty,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      _buildDropdownWithTwoTitle(
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
                        valueKey: "nrp",
                        titleKey: "nama",
                        isRequired: true,
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow,
                            vertical: padding10),
                        child: RowWithButtonWidget(
                          textLeft: 'Daftar Pengajuan Rawat Jalan',
                          textRight: 'Tambah Pengajuan',
                          fontSizeLeft: textMedium,
                          fontSizeRight: textSmall,
                          onTab: () {
                            Get.to(
                              () => const FormDetailPengajuanRawatJalan(),
                              arguments: {
                                'onClose': () {
                                  getDetailPenganjuanRawatJalan();
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
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalWide),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Lampiran Dokumen : ',
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
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Column(
                          children: [
                            Center(
                              child: ElevatedButton(
                                onPressed: pickFiles,
                                child: Text('Pilih File'),
                              ),
                            ),
                            if (_files != null)
                              Column(
                                children: _files!.map((file) {
                                  return ListTile(
                                    title: Text(file.name),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => deleteFile(file),
                                    ),
                                    // subtitle: Text('${file.size} bytes'),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      _isFileNull
                          ? Center(
                              child: Text(
                              'File Kosong',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: textMedium),
                            ))
                          : const Text(''),
                      _buildTitle(
                        title: 'Diajukan Kepada',
                        fontSize: textMedium,
                        fontWeight: FontWeight.w700,
                        horizontalPadding: paddingHorizontalWide,
                        isRequired: false,
                      ),
                      _buildDropdownWithTitle(
                        title: 'Pilih Entitas HRGS : ',
                        selectedValue: selectedValueEntitasHrgs,
                        itemList: selectedEntitasHrgs,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitasHrgs = newValue ?? '';
                            getDataHrgs();
                          });
                        },
                        validator: _validatorEntitasHrgs,
                        maxHeight: maxHeightEntitasHrgs,
                        isLoading: selectedEntitasHrgs.isEmpty,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      _buildDropdownWithTwoTitle(
                        title: 'HRGS : ',
                        selectedValue: selectedValueHrgs,
                        itemList: selectedHrgs,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueHrgs = newValue ?? '';
                          });
                        },
                        validator: _validatorHrgs,
                        maxHeight: maxHeightHrgs,
                        isLoading: selectedHrgs.isEmpty,
                        valueKey: "pernr",
                        titleKey: "nama",
                        isRequired: true,
                      ),
                      _buildDropdownWithTitle(
                        title: 'Pilih Entitas Direktur Keuangan : ',
                        selectedValue: selectedValueEntitasKeuangan,
                        itemList: selectedEntitasKeuangan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueEntitasKeuangan = newValue ?? '';
                            getDataKeuangan();
                          });
                        },
                        validator: _validatorEntitasDirekturKeuangan,
                        maxHeight: maxHeightEntitasDirekturKeuangan,
                        isLoading: selectedEntitasKeuangan.isEmpty,
                        valueKey: "kode",
                        titleKey: "nama",
                      ),
                      _buildDropdownWithTwoTitle(
                        title: 'Pilih Direktur Keuangan : ',
                        selectedValue: selectedValueKeuangan,
                        itemList: selectedKeuangan,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueKeuangan = newValue ?? '';
                          });
                        },
                        validator: _validatorDirekturKeuangan,
                        maxHeight: maxHeightDirekturKeuangan,
                        isLoading: selectedKeuangan.isEmpty,
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
                    return SizedBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: sizedBoxHeightShort,
                          ),
                          TitleCenterWidget(
                            textLeft: 'Jenis Penggantian',
                            textRight: ': ${data['id_md_jp_rawat_jalan']}',
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
                            textLeft: 'No Kuitansi',
                            textRight: ': ${data['no_kuitansi']}',
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
                          SizedBox(
                            height: sizedBoxHeightExtraTall,
                          ),
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
                    const Center(
                      child: TitleWidget(
                        title: 'Data Belum Ada',
                      ),
                    ),
                  ],
                )
        ],
      ),
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

  Widget _buildTextFieldSection({
    required String title,
    required bool isMandatory,
    required double textSize,
    required double horizontalPadding,
    required double verticalSpacing,
    required TextEditingController controller,
    required String hintText,
    double? maxHeightConstraints,
    String? Function(String?)? validator,
    bool isNumberField = false,
    bool isDisable = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightTall = size.height * 0.0163;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: FontWeight.w300,
                fontSize: textSize,
              ),
              if (isMandatory)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: textSize,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          if (isNumberField && !isDisable)
            TextFormFieldNumberWidget(
              validator: validator,
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
              hintText: hintText,
            ),
          if (isDisable && !isNumberField)
            TextFormFielDisableWidget(
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
            ),
          if (!isDisable && !isNumberField)
            TextFormFieldWidget(
              validator: validator,
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
              hintText: hintText,
            ),
          SizedBox(height: sizedBoxHeightTall),
        ],
      ),
    );
  }

  Widget _buildDropdownWithTitle({
    required String title,
    required String? selectedValue,
    required List<Map<String, dynamic>> itemList,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    double? maxHeight,
    bool isLoading = false,
    String valueKey = "value",
    String titleKey = "title",
  }) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalWide = size.width * 0.0585;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleWidget(
                title: title,
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
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValue,
            onChanged: onChanged,
            items: itemList.map((value) {
              return DropdownMenuItem<String>(
                value: value[valueKey].toString(),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TitleWidget(
                    title: value[titleKey] as String,
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              constraints:
                  BoxConstraints(maxHeight: maxHeight ?? double.infinity),
              labelStyle: TextStyle(fontSize: textMedium),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: selectedValue != null ? Colors.black54 : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            validator: validator,
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
          SizedBox(height: sizedBoxHeightExtraTall)
        ],
      ),
    );
  }

  Widget _buildDropdownWithTwoTitle({
    required String title,
    required String? selectedValue,
    required List<Map<String, dynamic>> itemList,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    double? maxHeight,
    bool isLoading = false,
    String valueKey = "value",
    String titleKey = "title",
    bool isRequired = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalWide = size.width * 0.0585;
    double paddingHorizontalNarrow = size.width * 0.035;

    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              if (isRequired)
                Text(
                  '*',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValue,
            onChanged: onChanged,
            items: itemList.map((value) {
              return DropdownMenuItem<String>(
                value: value[valueKey].toString(),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TitleWidget(
                    title: '${value[titleKey]} - ${value[valueKey]}',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              constraints:
                  BoxConstraints(maxHeight: maxHeight ?? double.infinity),
              labelStyle: TextStyle(fontSize: textMedium),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: selectedValue != null ? Colors.black54 : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            validator: validator,
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
          SizedBox(height: sizedBoxHeightExtraTall)
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
