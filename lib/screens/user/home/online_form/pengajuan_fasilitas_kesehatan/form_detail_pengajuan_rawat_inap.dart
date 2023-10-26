import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormDetailPengajuanRawatInap extends StatefulWidget {
  const FormDetailPengajuanRawatInap({super.key});

  @override
  State<FormDetailPengajuanRawatInap> createState() =>
      _FormDetailPengajuanRawatInapState();
}

class _FormDetailPengajuanRawatInapState
    extends State<FormDetailPengajuanRawatInap> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _jenisPenggantiController = TextEditingController();
  final _detailPenggantiController = TextEditingController();
  final _noKwitansiController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  double maxHeightJenisPengganti = 40.0;
  double maxHeightDetailPengganti = 40.0;
  double maxHeightNokwitansi = 40.0;
  double maxHeightJumlah = 40.0;
  double maxHeightKeterangan = 40.0;
  DateTime tanggalKwitansi = DateTime.now();
  bool _isFileNull = false;

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

  Future<void> _tambah() async {
    _formKey.currentState!.save();
    String tanggalKwitansiFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalKwitansi);

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
      "id_md_jp_rawat_inap": _jenisPenggantiController.text,
      "no_kuitansi": _noKwitansiController.text,
      "detail_penggantian": _detailPenggantiController.text,
      "tgl_kuitansi": tanggalKwitansiFormatted,
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
        maxHeightJenisPengganti = 60.0;
      });
      return 'Field Jenis Pengganti Kosong';
    }

    setState(() {
      maxHeightJenisPengganti = 40.0;
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
                  child: TextFormFieldWidget(
                    validator: _validatorJenisPengganti,
                    controller: _jenisPenggantiController,
                    maxHeightConstraints: maxHeightJenisPengganti,
                    hintText: 'Jenis Penggantian',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
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
                          '${tanggalKwitansi.day}-${tanggalKwitansi.month}-${tanggalKwitansi.year}',
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
                          initialDateTime: tanggalKwitansi,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalKwitansi = newTime);
                          },
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
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
