import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
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
  double maxNamaPasien = 40.0;
  double maxNoKwitansi = 40.0;
  double maxJumlah = 40.0;
  double maxKeterangan = 40.0;
  final Function? onClose = Get.arguments['onClose'];

  String? jenisPengganti,
      idMdJpRawatJalan,
      detailPengganti,
      idDiagnosa,
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

  List<Map<String, dynamic>> selectedDetailPengganti = [];
  List<Map<String, dynamic>> selectedDiagnosa = [];
  dynamic dataEmployee;

  List<Map<String, dynamic>> selectedHubunganDenganKarwayan = [
    {'opsi': 'Diri Sendiri'},
  ];

  final DateRangePickerController _tanggalKuitansiController =
      DateRangePickerController();
  DateTime? tanggalKuitansi;

  Future<void> getJenisPengganti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/master/jenis/penggantian/jalan"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailPenggantiApi = responseData['data'];

        setState(() {
          selectedDetailPengganti =
              List<Map<String, dynamic>>.from(dataDetailPenggantiApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDiagnosa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(Uri.parse("$_apiUrl/master/diagnosa"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDiagnosaApi = responseData['data'];

        setState(() {
          selectedDiagnosa = List<Map<String, dynamic>>.from(dataDiagnosaApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getJenisPengganti();
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

    jenisPengganti = selectedValueJenisPengganti;
    List<String> separatedValues = selectedValueDetailPengganti!.split(',');
    idMdJpRawatJalan = separatedValues[0].trim();
    detailPengganti = separatedValues[1].trim();
    idDiagnosa = selectedValueDiagnosa;
    namaPasient = _namaPasientController.text;
    hubunganDenganKaryawan = _hubunganDenganKaryawanController.text;
    noKwitansi = _noKwitansiController.text;
    jumlah = _jumlahController.text;
    keterangan = _keteranganController.text;

    Map<String, dynamic> newData = {
      "id_md_jp_rawat_jalan": idMdJpRawatJalan ?? '',
      "benefit_type": jenisPengganti ?? '',
      "detail_penggantian": detailPengganti ?? '',
      "id_diagnosa": idDiagnosa ?? '',
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

    // Get.offAllNamed(
    //     '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_jalan');
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
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Pilih Jenis Pengganti : ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: size.height * 0.5,
                    value: selectedValueJenisPengganti,
                    validator: _validatorJenisPengganti,
                    icon: selectedJenisPengganti.isEmpty
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValueJenisPengganti = newValue ?? '';
                      });
                    },
                    items: selectedJenisPengganti
                        .map((Map<String, dynamic> value) {
                      return DropdownMenuItem<String>(
                        value: value["id"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: TitleWidget(
                            title: '${value["id"]} - ${value["jenis"]}',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxHeight: maxJenisPengganti),
                      labelStyle: TextStyle(fontSize: textMedium),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: selectedValueJenisPengganti != null
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Pilih Detail Pengganti : ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: size.height * 0.5,
                    validator: _validatorDetailPengganti,
                    value: selectedValueDetailPengganti,
                    icon: selectedDetailPengganti.isEmpty
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValueDetailPengganti = newValue ?? '';
                      });
                    },
                    items: selectedDetailPengganti
                        .map((Map<String, dynamic> value) {
                      return DropdownMenuItem<String>(
                        value: '${value["id"]},${value["nama"]}',
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
                          BoxConstraints(maxHeight: maxDetailPengganti),
                      labelStyle: TextStyle(fontSize: textMedium),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: selectedValueDetailPengganti != null
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Pilih Hubungan Dengan Karyawan : ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: size.height * 0.5,
                    validator: _validatorHubunganDenganKaryawan,
                    value: selectedValueHubunganDenganKarwayan,
                    icon: selectedHubunganDenganKarwayan.isEmpty
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValueHubunganDenganKarwayan = newValue ?? '';
                        if (selectedValueHubunganDenganKarwayan ==
                            'Diri Sendiri') {
                          _namaPasientController.text = dataEmployee['nama'];
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
                      constraints:
                          BoxConstraints(maxHeight: maxHubunganDenganKaryawan),
                      labelStyle: TextStyle(
                        fontSize: textMedium,
                        fontFamily: 'Poppins',
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: selectedValueJenisPengganti != null
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFielDisableWidget(
                    // validator: _validatorNamaPasien,
                    controller: _namaPasientController,
                    maxHeightConstraints: maxNamaPasien,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'No Kwitansi ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    validator: _validatorNoKwitansi,
                    controller: _noKwitansiController,
                    maxHeightConstraints: maxNoKwitansi,
                    hintText: '323289',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
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
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Jumlah ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldNumberWidget(
                    controller: _jumlahController,
                    validator: _validatorJumlah,
                    maxHeightConstraints: maxJumlah,
                    hintText: 'masukkan nominal',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Pilih Diagnosa : ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: size.height * 0.5,
                    validator: _validatorDiagnosa,
                    value: selectedValueDiagnosa,
                    icon: selectedDiagnosa.isEmpty
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          )
                        : const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValueDiagnosa = newValue ?? '';
                      });
                    },
                    items: selectedDiagnosa.map((Map<String, dynamic> value) {
                      return DropdownMenuItem<String>(
                        value: value["id"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: TitleWidget(
                            title: value["nama"].toString(),
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxHeight: maxDiagnosa),
                      labelStyle: TextStyle(fontSize: textMedium),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: selectedValueDiagnosa != null
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Keterangan/Diagnosa ',
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    validator: _validatorKeterangan,
                    controller: _keteranganController,
                    maxHeightConstraints: maxKeterangan,
                    hintText: 'Keterangan',
                  ),
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
