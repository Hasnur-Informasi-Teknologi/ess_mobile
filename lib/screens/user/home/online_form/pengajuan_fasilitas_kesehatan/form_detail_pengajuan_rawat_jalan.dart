import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';

class FormDetailPengajuanRawatJalan extends StatefulWidget {
  const FormDetailPengajuanRawatJalan({super.key});

  @override
  State<FormDetailPengajuanRawatJalan> createState() =>
      _FormDetailPengajuanRawatJalanState();
}

class _FormDetailPengajuanRawatJalanState
    extends State<FormDetailPengajuanRawatJalan> {
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

  DateTime tanggalPengajuan = DateTime.now();

  Future<void> _tambah() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    _formKey.currentState!.save();

    jenisPengganti = _jenisPenggantiController.text;
    detailPengganti = _detailPenggantiController.text;
    namaPasient = _namaPasientController.text;
    hubunganDenganKaryawan = _hubunganDenganKaryawanController.text;
    noKwitansi = _noKwitansiController.text;
    jumlah = _jumlahController.text;
    keterangan = _keteranganController.text;
    String tanggalPengajuanFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalPengajuan);

    Map<String, dynamic> newData = {
      "id_md_jp_rawat_jalan": jenisPengganti ?? '',
      "detail_penggantian": detailPengganti ?? '',
      "no_kuitansi": noKwitansi ?? '',
      "tgl_kuitansi": tanggalPengajuanFormatted,
      "nm_pasien": namaPasient ?? '',
      "hub_karyawan": hubunganDenganKaryawan ?? '',
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
                    maxHeightConstraints: maxJenisPengganti,
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
                    maxHeightConstraints: maxDetailPengganti,
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
                    title: 'Hubungan Dengan Karyawan',
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
                    validator: _validatorHubunganDenganKaryawan,
                    controller: _hubunganDenganKaryawanController,
                    maxHeightConstraints: maxHubunganDenganKaryawan,
                    hintText: 'Anak Ke-1',
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
                          '${tanggalPengajuan.day}-${tanggalPengajuan.month}-${tanggalPengajuan.year}',
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
                          initialDateTime: tanggalPengajuan,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => tanggalPengajuan = newTime);
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
