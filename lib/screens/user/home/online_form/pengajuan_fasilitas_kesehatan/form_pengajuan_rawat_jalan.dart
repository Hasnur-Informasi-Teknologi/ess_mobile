import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/user/home/online_form/pengajuan_fasilitas_kesehatan/form_detail_pengajuan_rawat_jalan.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_button_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  final double maxHeightKode = 40.0;
  final double maxHeightNrp = 40.0;
  final double maxHeightNama = 40.0;
  final double maxHeightPerusahaan = 40.0;
  final double maxHeightLokasiKerja = 40.0;
  final double maxHeightPangkat = 40.0;
  DateTime tanggalPengajuan = DateTime(3000, 2, 1, 10, 20);

  String? kode, nrp, nama, perusahaan, lokasiKerja, pangkat;

  List<PlatformFile>? _files;
  String? path;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _files = result.files;
      });
    }
    List<String> paths = _files?.map((file) => file.path ?? "").toList() ?? [];
    setState(() {
      path = paths[0];
    });
  }

  List<Map<String, dynamic>> dataDetail = [];
  List<Map<String, dynamic>> allData = [];

  String? jumlahTotal;

  @override
  void initState() {
    super.initState();
    Get.put(DataDetailPengajuanRawatJalanController());
    DataDetailPengajuanRawatJalanController
        dataDetailPengajuanRawatJalanController = Get.find();
    allData = dataDetailPengajuanRawatJalanController.getDataList();
    setState(() {
      dataDetail = allData;
    });

    // Hitung jumlah total
    int total = 0;
    for (var data in dataDetail) {
      final jumlah = int.tryParse(data['jumlah']) ?? 0;
      if (jumlah is int) {
        total += jumlah;
      }
    }

    // Set jumlahTotal dengan total
    jumlahTotal = total.toString();
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse("$_apiUrl/rawat/jalan/create");
    final request = http.MultipartRequest('POST', url);

    _formKey.currentState!.save();
    kode = _kodeController.text;
    nrp = _nrpController.text;
    nama = _namaController.text;
    perusahaan = _perusahaanController.text;
    lokasiKerja = _lokasiKerjaController.text;
    pangkat = _pangkatController.text;
    String tanggalPengajuanFormatted =
        DateFormat('yyyy-MM-dd').format(tanggalPengajuan);

    // print(pangkat);

    for (int i = 0; i < allData.length; i++) {
      final data = allData[i];
      request.fields['detail[$i][id_md_jp_rawat_jalan]'] =
          data['jenis_penggantian'].toString();
    }

    // Create a JSON-encoded body
    final body = jsonEncode({
      'nama': nama,
      'pernr': nrp,
      'pt': perusahaan,
      'lokasi': lokasiKerja,
      'pangkat': pangkat,
      'hire_date': tanggalPengajuanFormatted,
      'prd_rawat': tanggalPengajuanFormatted,
      'tgl_pengajuan': tanggalPengajuanFormatted,
      'approved_by1': nrp,
    });

    // Create a separate HTTP request for JSON data
    final jsonRequest = http.Request('POST', url)
      ..headers['Content-Type'] = 'application/json;charset=UTF-8'
      ..headers['Authorization'] = 'Bearer $token'
      ..body = body;

    // Send the JSON request
    try {
      final jsonResponse = await http.Client().send(jsonRequest);
      if (jsonResponse.statusCode == 200) {
        // Handle a successful response for JSON data.
        print('succes json');
      } else {
        // Handle an unsuccessful response for JSON data.
        final responseError = await jsonResponse.stream.bytesToString();
        final errorData = json.decode(responseError);
        print('Json Response JSON Error: $errorData');
      }
    } catch (error) {
      print(error);
      // Handle the error for JSON data.
    }

    // Send the Multipart request
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        // Handle a successful response.
        print('succes multipart');
        allData.clear();
        setState(() {
          dataDetail = [];
        });
      } else {
        // Handle an unsuccessful response.
        final responseError = await response.stream.bytesToString();
        final errorData = json.decode(responseError);
        print('Multipart Response JSON Error: $errorData');
      }
    } catch (error) {
      print(error);
      // Handle the error.
    }
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
            Get.offAllNamed(
                '/user/main/home/online_form/pengajuan_fasilitas_kesehatan');
            // Get.back();
          },
        ),
        title: const Text(
          'Pengajuan Rawat Jalan',
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
                    title: 'Kode',
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
                    controller: _kodeController,
                    maxHeightConstraints: maxHeightKode,
                    hintText: 'Kode',
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
                    title: 'NRP *',
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
                    controller: _nrpController,
                    maxHeightConstraints: maxHeightNrp,
                    hintText: '78220012',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _namaController,
                    maxHeightConstraints: maxHeightNama,
                    hintText: 'Nama Karyawan',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _perusahaanController,
                    maxHeightConstraints: maxHeightPerusahaan,
                    hintText: 'Perusahaan',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _lokasiKerjaController,
                    maxHeightConstraints: maxHeightLokasiKerja,
                    hintText: 'Lokasi Kerja',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormFieldWidget(
                    controller: _pangkatController,
                    maxHeightConstraints: maxHeightPangkat,
                    hintText: 'Pangkat',
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding10),
                  child: RowWithButtonWidget(
                    textLeft: 'Daftar Pengajuan Rawat Jalan',
                    textRight: 'Tambah Pengajuan',
                    fontSizeLeft: textMedium,
                    fontSizeRight: textSmall,
                    onTab: () {
                      Get.toNamed(
                          '/user/main/home/online_form/pengajuan_fasilitas_kesehatan/pengajuan_rawat_jalan/detail_pengajuan_rawat_jalan');
                    },
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
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
                                            ': ${data['jenis_penggantian']}',
                                        fontSizeLeft: textMedium,
                                        fontSizeRight: textMedium,
                                      ),
                                      SizedBox(height: sizedBoxHeightShort),
                                      TitleCenterWidget(
                                        textLeft: 'Detail Penggantian',
                                        textRight:
                                            ': ${data['detail_penggantian']}',
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
                                        textRight: ': ${data['jumlah']}',
                                        fontSizeLeft: textMedium,
                                        fontSizeRight: textMedium,
                                      ),
                                      SizedBox(height: sizedBoxHeightExtraTall),
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: pickFiles,
                        child: Text('Pilih File'),
                      ),
                      if (_files != null)
                        Column(
                          children: _files!.map((file) {
                            return ListTile(
                              title: Text(file.name),
                              // subtitle: Text('${file.size} bytes'),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                  //     TextFormFieldWidget(
                  //   controller: _namaController,
                  //   maxHeightConstraints: maxHeightNama,
                  //   hintText: 'Lampiran',
                  // ),
                ),
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
