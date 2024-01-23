import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
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
  final _jenisPenggantiController = TextEditingController();
  final _detailPenggantiController = TextEditingController();
  final _namaPasientController = TextEditingController();
  final _hubunganDenganKaryawanController = TextEditingController();
  final _noKwitansiController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  double maxJenisPengganti = 40.0;
  double maxDetailPengganti = 40.0;
  double maxNamaPasien = 40.0;
  double maxHubunganDenganKaryawan = 40.0;
  double maxHeightJenisPengganti = 60.0;
  double maxNoKwitansi = 40.0;
  double maxJumlah = 40.0;
  double maxKeterangan = 40.0;

  String? jenisPengganti,
      detailPengganti,
      namaPasient,
      hubunganDenganKaryawan,
      noKwitansi,
      jumlah,
      keterangan;

  String? selectedValueJenisPengganti,
      selectedValueDetailPengganti,
      selectedValueHubunganDenganKarwayan;

  List<Map<String, dynamic>> selectedJenisPengganti = [];
  List<Map<String, dynamic>> selectedDetailPengganti = [
    {'opsi': 'Frame'},
    {'opsi': 'Lensa'},
    {'opsi': 'Frame + Lensa'},
  ];

  List<Map<String, dynamic>> selectedHubunganDenganKarwayan = [
    {'opsi': 'Diri Sendiri'},
    {'opsi': 'Anak 1'},
    {'opsi': 'Anak 2'},
    {'opsi': 'Anak 3'},
    {'opsi': 'Pasangan'},
  ];

  final DateRangePickerController _tanggalKwitansiController =
      DateRangePickerController();
  DateTime? tanggalKwitansi;

  DateTime tanggalPengajuan = DateTime.now();

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
        print(responseData);
        final dataEntitasApi = responseData['data'];

        setState(() {
          selectedJenisPengganti =
              List<Map<String, dynamic>>.from(dataEntitasApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getJenisPengganti();
  }

  Future<void> _tambah() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    _formKey.currentState!.save();

    jenisPengganti = selectedValueJenisPengganti;
    detailPengganti = selectedValueJenisPengganti == '9'
        ? selectedValueDetailPengganti
        : _detailPenggantiController.text;
    namaPasient = _namaPasientController.text;
    hubunganDenganKaryawan = _hubunganDenganKaryawanController.text;
    noKwitansi = _noKwitansiController.text;
    jumlah = _jumlahController.text;
    keterangan = _keteranganController.text;

    Map<String, dynamic> newData = {
      "id_md_jp_rawat_jalan": jenisPengganti ?? '',
      "detail_penggantian": detailPengganti ?? '',
      "no_kuitansi": noKwitansi ?? '',
      "tgl_kuitansi": tanggalKwitansi != null
          ? tanggalKwitansi.toString()
          : DateTime.now().toString(),
      "nm_pasien": namaPasient ?? '',
      "hub_karyawan": selectedValueHubunganDenganKarwayan ?? '',
      "jumlah": jumlah ?? '',
      "keterangan": keterangan ?? '',
    };

    DataDetailPengajuanRawatJalanController
        dataDetailPengajuanRawatJalanController = Get.find();
    dataDetailPengajuanRawatJalanController.tambahData(newData);

    Get.offAllNamed(
        '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_jalan');
  }

  String? _validatorJenisPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxJenisPengganti = 60.0;
      });
      return 'Field Jenis Pengganti Kosong';
    }

    setState(() {
      maxJenisPengganti = 40.0;
    });
    return null;
  }

  String? _validatorDetailPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxDetailPengganti = 60.0;
      });
      return 'Field Detail Pengganti Kosong';
    }

    setState(() {
      maxDetailPengganti = 40.0;
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
        maxHubunganDenganKaryawan = 60.0;
      });
      return 'Field Hubungan Dengan Karyawan Kosong';
    }

    setState(() {
      maxHubunganDenganKaryawan = 40.0;
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
        title: const Text(
          'Detail Pengajuan Rawat Jalan',
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
                  child: TitleWidget(
                    title: 'Pilih Jenis Pengganti : ',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: DropdownButtonFormField<String>(
                    // validator: _validatorEntitas,
                    value: selectedValueJenisPengganti,
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
                        value: value["id_md_jp_rawat_jalan"].toString(),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: TitleWidget(
                            title: value["jp_rawat_jalan"] as String,
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      constraints:
                          BoxConstraints(maxHeight: maxHeightJenisPengganti),
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
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: selectedValueJenisPengganti == '9'
                        ? 'Pilih Detail Penggantian : '
                        : 'Detail Penggantian',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                selectedValueJenisPengganti == '9'
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          value: selectedValueDetailPengganti,
                          icon: selectedJenisPengganti.isEmpty
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
                              selectedValueDetailPengganti = newValue ?? '';
                            });
                          },
                          items: selectedDetailPengganti
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
                                maxHeight: maxHeightJenisPengganti),
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
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFieldWidget(
                          validator: _validatorDetailPengganti,
                          controller: _detailPenggantiController,
                          maxHeightConstraints: maxDetailPengganti,
                          hintText: 'Detail Penggantian',
                        ),
                      ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Pilih Hubungan Dengan Karyawan : ',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: DropdownButtonFormField<String>(
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
                          BoxConstraints(maxHeight: maxHeightJenisPengganti),
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
                  child: TitleWidget(
                    title: 'Nama Pasien',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    validator: _validatorNamaPasien,
                    controller: _namaPasientController,
                    maxHeightConstraints: maxNamaPasien,
                    hintText: 'Nama Pasien',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'No Kwitansi',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
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
                              _tanggalKwitansiController.selectedDate ??
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
                              controller: _tanggalKwitansiController,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                setState(() {
                                  tanggalKwitansi = args.value;
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
                  child: TitleWidget(
                    title: 'Jumlah',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    validator: _validatorJumlah,
                    controller: _jumlahController,
                    maxHeightConstraints: maxJumlah,
                    hintText: 'Rp 700.000',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Keterangan/Diagnosa',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
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
