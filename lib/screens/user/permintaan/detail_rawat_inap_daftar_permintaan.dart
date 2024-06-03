import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
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
  bool _isLoadingScreen = false;

  List daftarPengajuanHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Diagnosa',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List daftarPengajuanKey = [
    'index',
    'md_rw_inap',
    'detail_penggantian',
    'diagnosa',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah_rp',
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailRawatInap();
  }

  Future<void> getDataDetailRawatInap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    setState(() {
      _isLoadingScreen = true;
    });

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

          _isLoadingScreen = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;

    return _isLoadingScreen
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
                    diajukanOlehWidget(context),
                    daftarPengajuanTable(context),
                    hasilVerivikasiPicHrgsWidget(context),
                    footerWidget(context)
                  ],
                ),
              ),
            ),
          );
  }

  Widget daftarPengajuanTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailRincianRawatInap.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontalNarrow, vertical: padding7),
              child: SizedBox(
                height: 200,
                child: ScrollableTableView(
                  headers: daftarPengajuanHeader.map((column) {
                    return TableViewHeader(
                      label: column,
                    );
                  }).toList(),
                  rows: masterDataDetailRincianRawatInap
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return TableViewRow(
                      height: 60,
                      cells: daftarPengajuanKey.map((column) {
                        if (column == 'md_rw_inap') {
                          return TableViewCell(
                            child: Text(
                              data['md_rw_inap'] != null
                                  ? '${data['md_rw_inap']['kd_rw_inap']} - ${data['md_rw_inap']['ket']}'
                                  : '-',
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else if (column == 'diagnosa') {
                          return TableViewCell(
                            child: Text(
                              data['diagnosa'] != null
                                  ? '${data['diagnosa']['nama']}'
                                  : '-',
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else if (column == 'index') {
                          return TableViewCell(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        } else {
                          return TableViewCell(
                            child: Text(
                              data[column].toString(),
                              style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Kode',
          textRight: '${masterDataDetailRawatInap['kode_rawat_inap']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Pengajuan',
          textRight: '${masterDataDetailRawatInap['tgl_pengajuan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nrp',
          textRight: '${masterDataDetailRawatInap['pernr']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama Karyawan',
          textRight: '${masterDataDetailRawatInap['nama']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Perusahaan',
          textRight: '${masterDataDetailRawatInap['pt']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Lokasi Kerja',
          textRight: '${masterDataDetailRawatInap['lokasi']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Pangkat Karyawan',
          textRight: '${masterDataDetailRawatInap['pangkat']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Masuk',
          textRight: '${masterDataDetailRawatInap['hire_date']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Periode Rawat (Mulai)',
          textRight: '${masterDataDetailRawatInap['prd_rawat_mulai']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Periode Rawat (Berakhir)',
          textRight: '${masterDataDetailRawatInap['prd_rawat_akhir']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama Pasien',
          textRight: '${masterDataDetailRawatInap['nm_pasien']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Hubungan Dengan Karyawan',
          textRight: '${masterDataDetailRawatInap['hub_karyawan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        const TitleWidget(title: 'Daftar Pengajuan'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
      ],
    );
  }

  Widget hasilVerivikasiPicHrgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        const TitleWidget(title: 'Hasil Verifikasi PIC HCGS'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Terima',
          textRight: masterDataDetailRawatInap['approved_date2'] ?? '',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Total Pengajuan',
          textRight: 'Rp. $totalPengajuanFormated',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Selisih',
          textRight: 'Rp. $selisihFormated',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Catatan',
          textRight: masterDataDetailRawatInap['catatan'] ?? '',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan Atasan',
          textRight: masterDataDetailRawatInap['keterangan_atasan'] ?? '',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan PIC HCGS',
          textRight: masterDataDetailRawatInap['keterangan_pic_hcgs'] ?? '',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan Direksi',
          textRight: masterDataDetailRawatInap['keterangan_direksi'] ?? '',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Dokumen',
          textRight: masterDataDetailRawatInap['dokumen'] ?? '',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Total Diganti Perusahaan',
          textRight: 'Rp. $totalDigantiFormated',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
      ],
    );
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Column(
      children: [
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: '${masterDataDetailRawatInap['status_approve']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': ${masterDataDetailRawatInap['created_at']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
      ],
    );
  }
}
