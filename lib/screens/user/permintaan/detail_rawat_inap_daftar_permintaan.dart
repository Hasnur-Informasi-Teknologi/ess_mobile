import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailRawatInapDaftarPermintaan extends StatefulWidget {
  const DetailRawatInapDaftarPermintaan({super.key});

  @override
  State<DetailRawatInapDaftarPermintaan> createState() =>
      _DetailRawatInapDaftarPermintaanState();
}

class _DetailRawatInapDaftarPermintaanState
    extends State<DetailRawatInapDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailRawatInap = {};
  List<Map<String, dynamic>> masterDataDetailRincianRawatInap = [];
  final Map<String, dynamic> arguments = Get.arguments;
  String? totalPengajuanFormated, selisihFormated, totalDigantiFormated;

  @override
  void initState() {
    super.initState();
    getDataDetailRawatInap();
  }

  Future<void> getDataDetailRawatInap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/rawat/inap/$id/detail"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailRawatInapApi = responseData['data'];
        final dataDetailRincianRawatInapApi = responseData['data']['detail'];

        setState(() {
          masterDataDetailRawatInap =
              Map<String, dynamic>.from(dataDetailRawatInapApi);

          masterDataDetailRincianRawatInap =
              List<Map<String, dynamic>>.from(dataDetailRincianRawatInapApi);
          print(masterDataDetailRincianRawatInap);

          String? totalPengajuanString =
              dataDetailRawatInapApi['total_pengajuan'];
          int totalPengajuan = int.tryParse(totalPengajuanString ?? '') ?? 0;
          totalPengajuanFormated =
              NumberFormat.decimalPattern('id-ID').format(totalPengajuan);

          String? selisihString = dataDetailRawatInapApi['total_pengajuan'];
          int selisih = int.tryParse(selisihString ?? '') ?? 0;
          selisihFormated =
              NumberFormat.decimalPattern('id-ID').format(selisih);

          String? totalDigantiString = dataDetailRawatInapApi['total_diganti'];
          int totalDiganti = int.tryParse(totalDigantiString ?? '') ?? 0;
          totalDigantiFormated =
              NumberFormat.decimalPattern('id-ID').format(totalDiganti);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textMedium = size.width * 0.0329; // 14 px
    double textLarge = size.width * 0.04; // 18 px
    double padding20 = size.width * 0.047; // 20 px
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585; // 25 px
    const double sizedBoxHeightTall = 15;
    const double sizedBoxHeightShort = 8;
    const double sizedBoxHeightExtraTall = 20;

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
          },
        ),
        title: Text(
          'Detail Permintaan Rawat Inap',
          style: TextStyle(
            color: Colors.black,
            fontSize: textLarge,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalWide, vertical: padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleWidget(title: 'Diajukan Oleh'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Kode',
                textRight: '${masterDataDetailRawatInap['kode_rawat_inap']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Tanggal Pengajuan',
                textRight: '${masterDataDetailRawatInap['tgl_pengajuan']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Nrp',
                textRight: '${masterDataDetailRawatInap['pernr']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Nama Karyawan',
                textRight: '${masterDataDetailRawatInap['nama']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Perusahaan',
                textRight: '${masterDataDetailRawatInap['pt']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Lokasi Kerja',
                textRight: '${masterDataDetailRawatInap['lokasi']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Pangkat Karyawan',
                textRight: '${masterDataDetailRawatInap['pangkat']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Tanggal Masuk',
                textRight: '${masterDataDetailRawatInap['hire_date']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Periode Rawat (Mulai)',
                textRight: '${masterDataDetailRawatInap['prd_rawat_mulai']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Periode Rawat (Berakhir)',
                textRight: '${masterDataDetailRawatInap['prd_rawat_akhir']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Nama Pasien',
                textRight: '${masterDataDetailRawatInap['nm_pasien']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Hubungan Dengan Karyawan',
                textRight: '${masterDataDetailRawatInap['hub_karyawan']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Daftar Pengajuan'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: masterDataDetailRincianRawatInap.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    width: 500,
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('No'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('Jenis Penggantian'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('Detail Penggantian'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('Diagnosa'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('No Kuitansi'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('Tanggal Kuitansi'),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(padding7),
                                    child: const Center(
                                      child: Text('Jumlah'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Data Rows
                            ...masterDataDetailRincianRawatInap
                                .asMap()
                                .entries
                                .map((entry) {
                              final int rowIndex = entry.key + 1;
                              final Map<String, dynamic> data = entry.value;
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      width: 500,
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                          child: Text(rowIndex.toString())),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                        child: Text(
                                            '${data['md_rw_inap']['kd_rw_inap']} - ${data['md_rw_inap']['ket']}'),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                        child: Text(
                                            '${data['md_kategori_inap']['nama']}'),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                        child:
                                            Text('${data['diagnosa']['nama']}'),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                        child: Text('${data['no_kuitansi']}'),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                        child: Text('${data['tgl_kuitansi']}'),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(padding7),
                                      child: Center(
                                        child: Text('${data['jumlah']}'),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      )
                    : Text(''),
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Hasil Verifikasi PIC HCGS'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Tanggal Terima',
                textRight: masterDataDetailRawatInap['approved_date2'] ?? '',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Total Pengajuan',
                textRight: 'Rp. $totalPengajuanFormated',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Selisih',
                textRight: 'Rp. $selisihFormated',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Catatan',
                textRight: masterDataDetailRawatInap['catatan'] ?? '',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Keterangan Atasan',
                textRight: masterDataDetailRawatInap['keterangan_atasan'] ?? '',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Keterangan PIC HCGS',
                textRight:
                    masterDataDetailRawatInap['keterangan_pic_hcgs'] ?? '',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Keterangan Direksi',
                textRight:
                    masterDataDetailRawatInap['keterangan_direksi'] ?? '',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Dokumen',
                textRight: masterDataDetailRawatInap['dokumen'] ?? '',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Total Diganti Perusahaan',
                textRight: 'Rp. $totalDigantiFormated',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              TitleCenterWithLongBadgeWidget(
                textLeft: 'Status Pengajuan',
                textRight: '${masterDataDetailRawatInap['status_approve']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
                color: Colors.yellow,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Pada',
                textRight: ': ${masterDataDetailRawatInap['created_at']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
