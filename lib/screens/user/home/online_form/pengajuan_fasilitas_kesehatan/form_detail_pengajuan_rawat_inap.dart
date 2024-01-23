import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormDetailPengajuanRawatInap extends StatefulWidget {
  const FormDetailPengajuanRawatInap({super.key});

  @override
  State<FormDetailPengajuanRawatInap> createState() =>
      _FormDetailPengajuanRawatInapState();
}

class _FormDetailPengajuanRawatInapState
    extends State<FormDetailPengajuanRawatInap> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _detailPenggantiController = TextEditingController();
  final _noKwitansiController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  double maxHeightDetailPengganti = 40.0;
  double maxHeightNokwitansi = 40.0;
  double maxHeightJumlah = 40.0;
  double maxHeightKeterangan = 40.0;
  double maxHeightJenisPengganti = 60.0;
  bool _isFileNull = false;
  final DateRangePickerController _tanggalKwitansiController =
      DateRangePickerController();
  DateTime? tanggalKwitansi;

  String? selectedValueJenisPengganti;

  List<Map<String, dynamic>> selectedJenisPengganti = [];

  List<PlatformFile>? files;
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        files = result.files;
        _isFileNull = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataJenisPengganti();
  }

  Future<void> getDataJenisPengganti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/master/jenis/penggantian/inap"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataJenisPenggantiApi = responseData['data'];

        setState(() {
          selectedJenisPengganti =
              List<Map<String, dynamic>>.from(dataJenisPenggantiApi);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _tambah() async {
    _formKey.currentState!.save();

    if (_formKey.currentState!.validate() == false) {
      return;
    }

    String? filePath;

    if (files != null) {
      filePath = files!.single.path;
      setState(() {
        _isFileNull = false;
      });
    } else {
      setState(() {
        _isFileNull = true;
      });
      return;
    }

    Map<String, dynamic> newData = {
      "id": selectedValueJenisPengganti,
      "no_kuitansi": _noKwitansiController.text,
      "detail_penggantian": _detailPenggantiController.text,
      "tgl_kuitansi": tanggalKwitansi != null
          ? "${tanggalKwitansi?.year}-${tanggalKwitansi?.month.toString().padLeft(2, '0')}-${tanggalKwitansi?.day.toString().padLeft(2, '0')}"
          : "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "jumlah": _jumlahController.text,
      "keterangan": _keteranganController.text,
      "lampiran_pembayaran": filePath,
    };

    DataDetailPengajuanRawatInapController
        dataDetailPengajuanRawatInapController = Get.find();

    dataDetailPengajuanRawatInapController.tambahData(newData);

    Get.offAllNamed(
        '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_inap');
  }

  String? _validatorJenisPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightJenisPengganti = 80.0;
      });
      return 'Field Jenis Pengganti Kosong';
    }

    setState(() {
      maxHeightJenisPengganti = 60.0;
    });
    return null;
  }

  String? _validatorDetailPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightDetailPengganti = 60.0;
      });
      return 'Field Detail Pengganti Kosong';
    }

    setState(() {
      maxHeightDetailPengganti = 40.0;
    });
    return null;
  }

  String? _validatorNoKwitansi(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNokwitansi = 60.0;
      });
      return 'Field No Kwitansi Kosong';
    }

    setState(() {
      maxHeightNokwitansi = 40.0;
    });
    return null;
  }

  String? _validatorJumlah(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightJumlah = 60.0;
      });
      return 'Field Jumlah Kosong';
    }

    setState(() {
      maxHeightJumlah = 40.0;
    });
    return null;
  }

  String? _validatorKeterangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKeterangan = 60.0;
      });
      return 'Field Jumlah Kosong';
    }

    setState(() {
      maxHeightKeterangan = 40.0;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
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
        title: const Text(
          'Detail Pengajuan Rawat Inap',
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
                    title: 'Jenis Penggantian',
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
                    validator: _validatorJenisPengganti,
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
                        value: value["id"].toString(),
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
                    title: 'Detail Penggantian',
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
                    validator: _validatorDetailPengganti,
                    controller: _detailPenggantiController,
                    maxHeightConstraints: maxHeightDetailPengganti,
                    hintText: 'Detail Penggantian',
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
                    maxHeightConstraints: maxHeightNokwitansi,
                    hintText: 'No Kwitansi',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Tanggal Kwitansi',
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
                          DateFormat('yyyy-MM-dd').format(
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
                    maxHeightConstraints: maxHeightJumlah,
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
                    maxHeightConstraints: maxHeightKeterangan,
                    hintText: 'Keterangan',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Lampiran Bukti Pembayaran',
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
                  child: Column(
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: pickFiles,
                          child: Text('Pilih File'),
                        ),
                      ),
                      if (files != null)
                        Column(
                          children: files!.map((file) {
                            return ListTile(
                              title: Text(file.name),
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
                            fontWeight: FontWeight.w700,
                            fontSize: textMedium),
                      ))
                    : const Text(''),
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

class DataDetailPengajuanRawatInapController extends GetxController {
  var data = <Map<String, dynamic>>[].obs;

  void tambahData(Map<String, dynamic> newData) {
    data.add(newData);
  }

  List<Map<String, dynamic>> getDataList() {
    return data;
  }
}
