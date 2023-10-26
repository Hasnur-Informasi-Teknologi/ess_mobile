import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_detail_pengajuan_rawat_inap.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  final _hubunganDenganKaryawanController = TextEditingController();
  final _namaPasienController = TextEditingController();
  double maxHeightKode = 40.0;
  double maxHeightNrp = 40.0;
  double maxHeightNama = 40.0;
  double maxHeightPerusahaan = 40.0;
  double maxHeightLokasiKerja = 40.0;
  double maxHeightPangkat = 40.0;
  double maxHeightHubunganDenganKaryawan = 40.0;
  double maxHeightNamaPasien = 40.0;
  DateTime tanggalMasuk = DateTime.now();
  DateTime tanggalPengajuan = DateTime.now();

  bool _isLoading = false;

  List<Map<String, dynamic>> dataDetail = [];
  List<Map<String, dynamic>> allData = [];
  String? jumlahTotal;

  @override
  void initState() {
    super.initState();
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
    jumlahTotal = total.toString();
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // String kode = _kodeController.text;
    String nrp = _nrpController.text;
    String nama = _namaController.text;
    String perusahaan = _perusahaanController.text;
    String lokasi = _lokasiKerjaController.text;
    String pangkat = _pangkatController.text;
    String hubunganDenganKaryawan = _hubunganDenganKaryawanController.text;
    String namaPasien = _namaPasienController.text;
    String tanggalMasukFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalMasuk);
    String tanggalPengajuanFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalPengajuan);

    // print(allData);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/rawat/inap/create'),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nama'] = nama;
    request.fields['pernr'] = nrp;
    request.fields['pt'] = perusahaan;
    request.fields['lokasi'] = lokasi;
    request.fields['pangkat'] = pangkat;
    request.fields['hire_date'] = tanggalPengajuanFormatted;
    request.fields['prd_rawat_mulai'] = tanggalMasukFormatted;
    request.fields['prd_rawat_akhir'] = tanggalPengajuanFormatted;
    request.fields['nm_pasien'] = namaPasien;
    request.fields['hub_karyawan'] = hubunganDenganKaryawan;
    request.fields['approved_by1'] = nrp;
    for (int i = 0; i < allData.length; i++) {
      request.fields['detail[$i][id_md_jp_rawat_inap]'] =
          allData[i]['id_md_jp_rawat_inap'].toString();
      request.fields['detail[$i][no_kuitansi]'] = allData[i]['no_kuitansi'];
      request.fields['detail[$i][detail_penggantian]'] =
          allData[i]['detail_penggantian'];
      request.fields['detail[$i][tgl_kuitansi]'] = allData[i]['tgl_kuitansi'];
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

    var response = await request.send();
    final responseData = await response.stream.bytesToString();
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
      Get.offAllNamed('/user/main_new');
    }
  }

  String? _validatorKode(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKode = 60.0;
      });
      return 'Field Kode Kosong';
    }

    setState(() {
      maxHeightKode = 40.0;
    });
    return null;
  }

  String? _validatorNrp(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNrp = 60.0;
      });
      return 'Field NRP Kosong';
    }

    setState(() {
      maxHeightNrp = 40.0;
    });
    return null;
  }

  String? _validatorNama(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNama = 60.0;
      });
      return 'Field Nama Kosong';
    }

    setState(() {
      maxHeightNama = 40.0;
    });
    return null;
  }

  String? _validatorPerusahaan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightPerusahaan = 60.0;
      });
      return 'Field Perusahaan Kosong';
    }

    setState(() {
      maxHeightPerusahaan = 40.0;
    });
    return null;
  }

  String? _validatorLokasiKerja(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightLokasiKerja = 60.0;
      });
      return 'Field Lokasi Kerja Kosong';
    }

    setState(() {
      maxHeightLokasiKerja = 40.0;
    });
    return null;
  }

  String? _validatorPangkat(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightPangkat = 60.0;
      });
      return 'Field Pangkat Kosong';
    }

    setState(() {
      maxHeightPangkat = 40.0;
    });
    return null;
  }

  String? _validatorHubunganDenganKaryawan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightHubunganDenganKaryawan = 60.0;
      });
      return 'Field Hubungan Dengan Karyawan Kosong';
    }

    setState(() {
      maxHeightHubunganDenganKaryawan = 40.0;
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
                  Get.back();
                  // Navigator.pop(context);
                },
              ),
              title: const Text(
                'Pengajuan Rawat Inap',
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
                          title: 'Kode',
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
                        child: TextFormFieldWidget(
                          validator: _validatorKode,
                          controller: _kodeController,
                          maxHeightConstraints: maxHeightKode,
                          hintText: 'Kode',
                        ),
                      ),
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
                        child: TextFormFieldWidget(
                          validator: _validatorNrp,
                          controller: _nrpController,
                          maxHeightConstraints: maxHeightNrp,
                          hintText: '78220012',
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
                        child: TextFormFieldWidget(
                          validator: _validatorNama,
                          controller: _namaController,
                          maxHeightConstraints: maxHeightNama,
                          hintText: 'Nama Karyawan',
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
                        child: TextFormFieldWidget(
                          validator: _validatorPerusahaan,
                          controller: _perusahaanController,
                          maxHeightConstraints: maxHeightPerusahaan,
                          hintText: 'Perusahaan',
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
                        child: TextFormFieldWidget(
                          validator: _validatorLokasiKerja,
                          controller: _lokasiKerjaController,
                          maxHeightConstraints: maxHeightLokasiKerja,
                          hintText: 'Lokasi Kerja',
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
                        child: TextFormFieldWidget(
                          validator: _validatorPangkat,
                          controller: _pangkatController,
                          maxHeightConstraints: maxHeightPangkat,
                          hintText: 'Pangkat',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Tanggal Masuk',
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
                                '${tanggalMasuk.day}-${tanggalMasuk.month}-${tanggalMasuk.year}',
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
                                initialDateTime: tanggalMasuk,
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() => tanggalMasuk = newTime);
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFieldWidget(
                          validator: _validatorHubunganDenganKaryawan,
                          controller: _hubunganDenganKaryawanController,
                          maxHeightConstraints: maxHeightHubunganDenganKaryawan,
                          hintText: 'Hubungan Dengan Karyawan',
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
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
                            Get.toNamed(
                                '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_inap/detail_pengajuan_rawat_inap');
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
                                              textRight:
                                                  ': ${data['id_md_jp_rawat_inap']}',
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
                                              textRight: ': ${data['jumlah']}',
                                              fontSizeLeft: textMedium,
                                              fontSizeRight: textMedium,
                                            ),
                                            SizedBox(
                                                height:
                                                    sizedBoxHeightExtraTall),
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
                                          fontWeight: FontWeight.w700,
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
                                    fontWeightLeft: FontWeight.w700,
                                    fontWeightRight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            )
                          : const Text(''),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: ElevatedButton(
                            onPressed: _submit,
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
