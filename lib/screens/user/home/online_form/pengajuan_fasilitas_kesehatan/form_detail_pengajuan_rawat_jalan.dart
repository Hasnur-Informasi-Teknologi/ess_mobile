import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_two_title_two_value_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_two_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_two_value_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_text_field_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormDetailPengajuanRawatJalan extends StatefulWidget {
  const FormDetailPengajuanRawatJalan({super.key});

  @override
  State<FormDetailPengajuanRawatJalan> createState() =>
      _FormDetailPengajuanRawatJalanState();
}

class _FormDetailPengajuanRawatJalanState
    extends State<FormDetailPengajuanRawatJalan> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaPasientController = TextEditingController();
  final _hubunganDenganKaryawanController = TextEditingController();
  final _noKwitansiController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  double maxJenisPengganti = 60.0;
  double maxDetailPengganti = 60.0;
  double maxHubunganDenganKaryawan = 60.0;
  double maxDiagnosa = 60.0;
  double maxNamaPasien = 50.0;
  double maxNoKwitansi = 50.0;
  double maxJumlah = 50.0;
  double maxKeterangan = 50.0;
  final Function? onClose = Get.arguments['onClose'];

  String? jenisPengganti,
      idMdJpRawatJalan,
      detailPengganti,
      idDiagnosa,
      jenisDiagnosa,
      namaPasient,
      hubunganDenganKaryawan,
      noKwitansi,
      jumlah,
      keterangan;

  String? selectedValueJenisPengganti,
      selectedValueDetailPengganti,
      selectedValueHubunganDenganKarwayan,
      selectedValueDiagnosa;

  List<Map<String, dynamic>> selectedJenisPengganti = [
    {'id': '1000', 'jenis': 'Rawat Jalan'},
    {'id': '2000', 'jenis': 'Lensa'},
    {'id': '3000', 'jenis': 'Frame'},
  ];

  List<Map<String, String>> convertData(Map<String, String> data) {
    List<Map<String, String>> result = [];

    data.forEach((key, value) {
      result.add({'jenis': key, 'nama': value});
    });

    return result;
  }

  List<Map<String, dynamic>> selectedDetailPengganti = [];
  List<Map<String, dynamic>> selectedDiagnosa = [];
  dynamic dataEmployee;

  List<Map<String, dynamic>> selectedHubunganDenganKarwayan = [];

  final DateRangePickerController _tanggalKuitansiController =
      DateRangePickerController();
  DateTime? tanggalKuitansi;

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

  Future<void> getJenisPengganti() async {
    await _fetchData(
      "master/jenis/penggantian/jalan",
      (data) {
        final dataDetailPenggantiApi = data['data'];

        setState(() {
          selectedDetailPengganti =
              List<Map<String, dynamic>>.from(dataDetailPenggantiApi);
        });
      },
    );
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

  Future<void> getDiagnosa() async {
    await _fetchData(
      "master/diagnosa",
      (data) {
        final dataDiagnosaApi = data['data'];

        setState(() {
          selectedDiagnosa = List<Map<String, dynamic>>.from(dataDiagnosaApi);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    getJenisPengganti();
    getHubungan();
    getDiagnosa();
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString())['data'];
    setState(() {
      dataEmployee = responseData;
    });
  }

  Future<void> _tambah() async {
    if (tanggalKuitansi == null) {
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

    if (_formKey.currentState!.validate() == false) {
      return;
    }
    _formKey.currentState!.save();

    List<String> separatedJenisPenggantiValues =
        selectedValueJenisPengganti!.split('-');
    jenisPengganti = separatedJenisPenggantiValues[0].trim();
    List<String> separatedValues = selectedValueDetailPengganti!.split(',');
    idMdJpRawatJalan = separatedValues[0].trim();
    detailPengganti = separatedValues[1].trim();
    List<String> separatedDiagnosaValues = selectedValueDiagnosa!.split(',');
    idDiagnosa = separatedDiagnosaValues[0].trim();
    jenisDiagnosa = separatedDiagnosaValues[1].trim();
    namaPasient = _namaPasientController.text;
    hubunganDenganKaryawan = _hubunganDenganKaryawanController.text;
    noKwitansi = _noKwitansiController.text;
    jumlah = _jumlahController.text;
    keterangan = _keteranganController.text;

    Map<String, dynamic> newData = {
      "id_md_jp_rawat_jalan": idMdJpRawatJalan ?? '',
      "benefit_type": jenisPengganti ?? '',
      "selectedValueJenisPengganti": selectedValueJenisPengganti ?? '',
      "detail_penggantian": detailPengganti ?? '',
      "id_diagnosa": idDiagnosa ?? '',
      "jenis_diagnosa": jenisDiagnosa ?? '',
      "no_kuitansi": noKwitansi ?? '',
      "tgl_kuitansi": tanggalKuitansi != null
          ? tanggalKuitansi.toString()
          : DateTime.now().toString(),
      "nm_pasien": namaPasient ?? '',
      "hub_karyawan": selectedValueHubunganDenganKarwayan ?? '',
      "jumlah": jumlah ?? '',
      "keterangan": keterangan ?? '',
    };

    DataDetailPengajuanRawatJalanController
        dataDetailPengajuanRawatJalanController = Get.find();
    dataDetailPengajuanRawatJalanController.tambahData(newData);

    onClose?.call();
    Get.back();
  }

  String? _validatorJenisPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxJenisPengganti = 80.0;
      });
      return 'Field Jenis Pengganti Kosong';
    }

    setState(() {
      maxJenisPengganti = 60.0;
    });
    return null;
  }

  String? _validatorDetailPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxDetailPengganti = 80.0;
      });
      return 'Field Detail Pengganti Kosong';
    }

    setState(() {
      maxDetailPengganti = 60.0;
    });
    return null;
  }

  String? _validatorNamaPasien(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxNamaPasien = 60.0;
      });
      return 'Field Nama Pasien Kosong';
    }

    setState(() {
      maxNamaPasien = 40.0;
    });
    return null;
  }

  String? _validatorHubunganDenganKaryawan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHubunganDenganKaryawan = 80.0;
      });
      return 'Field Hubungan Dengan Karyawan Kosong';
    }

    setState(() {
      maxHubunganDenganKaryawan = 60.0;
    });
    return null;
  }

  String? _validatorDiagnosa(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxDiagnosa = 80.0;
      });
      return 'Field Diagnosa Kosong';
    }

    setState(() {
      maxDiagnosa = 60.0;
    });
    return null;
  }

  String? _validatorNoKwitansi(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxNoKwitansi = 60.0;
      });
      return 'Field No Kwitansi Kosong';
    }

    setState(() {
      maxNoKwitansi = 40.0;
    });
    return null;
  }

  String? _validatorJumlah(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxJumlah = 60.0;
      });
      return 'Field Jumlah Kosong';
    }

    setState(() {
      maxJumlah = 40.0;
    });
    return null;
  }

  String? _validatorKeterangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxKeterangan = 60.0;
      });
      return 'Field Keterangan Kosong';
    }

    setState(() {
      maxKeterangan = 40.0;
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
    double padding5 = size.width * 0.0115;

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
        title: Text(
          'Detail Pengajuan Rawat Jalan',
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
                BuildDropdownWithTwoTitleTwoValueWidget(
                  title: 'Pilih Jenis Pengganti : ',
                  selectedValue: selectedValueJenisPengganti,
                  itemList: selectedJenisPengganti,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueJenisPengganti = newValue ?? '';
                    });
                  },
                  validator: _validatorJenisPengganti,
                  maxHeight: maxJenisPengganti,
                  isLoading: selectedJenisPengganti.isEmpty,
                  horizontalPadding: paddingHorizontalNarrow,
                  valueKey: "id",
                  titleKey: "jenis",
                  isRequired: true,
                ),
                BuildDropdownWithTwoValueWidget(
                  title: 'Pilih Detail Pengganti : ',
                  selectedValue: selectedValueDetailPengganti,
                  itemList: selectedDetailPengganti,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueDetailPengganti = newValue ?? '';
                    });
                  },
                  validator: _validatorDetailPengganti,
                  maxHeight: maxDetailPengganti,
                  isLoading: selectedDetailPengganti.isEmpty,
                  horizontalPadding: paddingHorizontalNarrow,
                  valueKey: "id",
                  titleKey: "nama",
                  isRequired: true,
                ),
                BuildDropdownWithTitleWidget(
                  title: 'Pilih Hubungan Dengan Karyawan : ',
                  selectedValue: selectedValueHubunganDenganKarwayan,
                  itemList: selectedHubunganDenganKarwayan,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueHubunganDenganKarwayan = newValue ?? '';
                      List<Map<String, dynamic>> dataFiltered =
                          selectedHubunganDenganKarwayan
                              .where((item) =>
                                  item['jenis'] ==
                                  selectedValueHubunganDenganKarwayan)
                              .toList();
                      _namaPasientController.text =
                          dataFiltered[0]['nama'].toString();
                    });
                  },
                  validator: _validatorHubunganDenganKaryawan,
                  maxHeight: maxHubunganDenganKaryawan,
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
                  controller: _namaPasientController,
                  hintText: 'Nama Pasien',
                  maxHeightConstraints: maxNamaPasien,
                  isDisable: true,
                ),
                BuildTextFieldWidget(
                  title: 'No Kwitansi',
                  isMandatory: true,
                  textSize: textMedium,
                  horizontalPadding: paddingHorizontalNarrow,
                  verticalSpacing: sizedBoxHeightShort,
                  controller: _noKwitansiController,
                  validator: _validatorNoKwitansi,
                  hintText: 'No Kwitansi',
                  maxHeightConstraints: maxNoKwitansi,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Tanggal Kuitansi ',
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
                          tanggalKuitansi != null
                              ? DateFormat('dd-MM-yyyy').format(
                                  _tanggalKuitansiController.selectedDate ??
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
                              controller: _tanggalKuitansiController,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                setState(() {
                                  tanggalKuitansi = args.value;
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
                BuildTextFieldWidget(
                  title: 'Jumlah',
                  isMandatory: true,
                  textSize: textMedium,
                  horizontalPadding: paddingHorizontalNarrow,
                  verticalSpacing: sizedBoxHeightShort,
                  controller: _jumlahController,
                  validator: _validatorJumlah,
                  hintText: 'Masukkan Nominal',
                  maxHeightConstraints: maxJumlah,
                  isNumberField: true,
                ),
                BuildDropdownWithTwoValueWidget(
                  title: 'Pilih Diagnosa : ',
                  selectedValue: selectedValueDiagnosa,
                  itemList: selectedDiagnosa,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueDiagnosa = newValue ?? '';
                    });
                  },
                  validator: _validatorDiagnosa,
                  maxHeight: maxDiagnosa,
                  isLoading: selectedDiagnosa.isEmpty,
                  horizontalPadding: paddingHorizontalNarrow,
                  valueKey: "id",
                  titleKey: "nama",
                ),
                BuildTextFieldWidget(
                  title: 'Keterangan ',
                  isMandatory: true,
                  textSize: textMedium,
                  horizontalPadding: paddingHorizontalNarrow,
                  verticalSpacing: sizedBoxHeightShort,
                  controller: _keteranganController,
                  validator: _validatorKeterangan,
                  hintText: 'Keterangan',
                  maxHeightConstraints: maxKeterangan,
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: ElevatedButton(
                      onPressed: _tambah,
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
}

class DataDetailPengajuanRawatJalanController extends GetxController {
  var data = <Map<String, dynamic>>[].obs;

  void tambahData(Map<String, dynamic> newData) {
    data.add(newData);
  }

  List<Map<String, dynamic>> getDataList() {
    return data;
  }
}
