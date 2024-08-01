import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
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

class DetailRawatJalanDaftarPermintaan extends StatefulWidget {
  const DetailRawatJalanDaftarPermintaan({super.key});

  @override
  State<DetailRawatJalanDaftarPermintaan> createState() =>
      _DetailRawatJalanDaftarPermintaanState();
}

class _DetailRawatJalanDaftarPermintaanState
    extends State<DetailRawatJalanDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailRawatJalan = {};
  List<Map<String, dynamic>> masterDataDetailRincianRawatJalan = [];
  List<Map<String, dynamic>> masterDataDetailApprovedRawatJalan = [];
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoadingScreen = false;

  List daftarPengajuanHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Nama Pasien',
    'Hubungan',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List daftarPengajuanKey = [
    'index',
    'jenis_penggantian',
    'detail_penggantian',
    'nm_pasien',
    'hub_karyawan',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah_rp',
  ];

  List approvalCompensationHeader = [
    'No',
    'Jenis Penggantian',
    'Detail Penggantian',
    'Nama Pasien',
    'Hubungan',
    'No Kuitansi',
    'Tanggal Kuitansi',
    'Nominal (RP)',
  ];

  List approvalCompensationKey = [
    'index',
    'jenis_penggantian',
    'detail_penggantian',
    'nm_pasien',
    'hub_karyawan',
    'no_kuitansi',
    'tgl_kuitansi',
    'jumlah',
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailRawatJalan();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> getDataDetailRawatJalan() async {
    final token = await _getToken();
    if (token == null) return;
    final id = int.parse(arguments['id'].toString());

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final ioClient = createIOClientWithInsecureConnection();
      final response = await ioClient.get(
        Uri.parse("$_apiUrl/rawat/jalan/$id/detail"),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      _handleResponse(response);
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoadingScreen = false;
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    final dataDetailRawatJalanApi = responseData['data'];
    final dataDetailRincianRawatJalanApi = dataDetailRawatJalanApi['detail'];
    final dataDetailApprovedRawatJalanApi =
        dataDetailRawatJalanApi['approved_detail'];

    setState(() {
      masterDataDetailRawatJalan =
          Map<String, dynamic>.from(dataDetailRawatJalanApi);
      masterDataDetailRincianRawatJalan =
          List<Map<String, dynamic>>.from(dataDetailRincianRawatJalanApi);
      masterDataDetailApprovedRawatJalan =
          List<Map<String, dynamic>>.from(dataDetailApprovedRawatJalanApi);
      _isLoadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;
    const double sizedBoxHeightExtraTall = 20;

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
                'Detail Permintaan Rawat Jalan',
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
                    approvalCompensationTable(context),
                    hasilVerivikasiPicHrgsWidget(context),
                    footerWidget(context)
                  ],
                ),
              ),
            ),
          );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Nomor',
        'value': '${masterDataDetailRawatJalan['no_doc'] ?? '-'}',
      },
      {
        'label': 'NRP',
        'value': '${masterDataDetailRawatJalan['pernr'] ?? '-'}',
      },
      {
        'label': 'Nama Karyawan',
        'value': '${masterDataDetailRawatJalan['nama'] ?? '-'}',
      },
      {
        'label': 'Perusahaan',
        'value': '${masterDataDetailRawatJalan['pt'] ?? '-'}',
      },
      {
        'label': 'Lokasi Kerja',
        'value': '${masterDataDetailRawatJalan['lokasi'] ?? '-'}',
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': '${masterDataDetailRawatJalan['tgl_pengajuan'] ?? '-'}',
      },
      {
        'label': 'Pangkat Karyawan',
        'value': '${masterDataDetailRawatJalan['pangkat'] ?? '-'}',
      },
      {
        'label': 'Tanggal Masuk',
        'value': '${masterDataDetailRawatJalan['hire_date'] ?? '-'}',
      },
      {
        'label': 'Periode Rawat',
        'value': '${masterDataDetailRawatJalan['prd_rawat'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowWithSemicolonWidget(
                  textLeft: item['label'],
                  textRight: item['value'].toString(),
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                SizedBox(height: sizedBoxHeightShort),
              ],
            )),
        const TitleWidget(
          title:
              'Daftar Pengajuan Jenis Penggantian Biaya Kesehatan Rawat Jalan',
        ),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget daftarPengajuanTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailRincianRawatJalan.isNotEmpty
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
                  rows: masterDataDetailRincianRawatJalan
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;
                    return TableViewRow(
                      height: 60,
                      cells: daftarPengajuanKey.map((column) {
                        if (column == 'jenis_penggantian') {
                          return TableViewCell(
                            child: Text(
                              data['md_rw_jalan'] != null
                                  ? '${data['md_rw_jalan']['kd_rw_jalan']} - ${data['md_rw_jalan']['ket']}'
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

  Widget approvalCompensationTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: masterDataDetailApprovedRawatJalan.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizedBoxHeightExtraTall,
                ),
                const TitleWidget(title: 'Approval Compensation & Benefit'),
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                const LineWidget(),
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: approvalCompensationHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataDetailApprovedRawatJalan
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: approvalCompensationKey.map((column) {
                            if (column == 'jenis_penggantian') {
                              return TableViewCell(
                                child: Text(
                                  '${data['plafon_type']} - ${data['plafon_name']}',
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
                ),
              ],
            )
          : const SizedBox(
              height: 0,
            ),
    );
  }

  Widget hasilVerivikasiPicHrgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Tanggal Terima',
        'value': '${masterDataDetailRawatJalan['tgl_pengajuan'] ?? '-'}',
      },
      {
        'label': 'Nominal Disetujui',
        'value': 'Rp. ${masterDataDetailRawatJalan['jumlah_setuju'] ?? '-'}',
      },
      {
        'label': 'Catatan',
        'value': '${masterDataDetailRawatJalan['catatan'] ?? '-'}',
      },
      {
        'label': 'Dokumen',
        'value': '${masterDataDetailRawatJalan['ket_doc'] ?? '-'}',
      },
      {
        'label': 'Tanggal Payment',
        'value': '${masterDataDetailRawatJalan['tgl_payment'] ?? '-'}',
      },
      {
        'label': 'Keterangan Atasan',
        'value': '${masterDataDetailRawatJalan['keterangan_atasan'] ?? '-'}',
      },
      {
        'label': 'Keterangan PIC HCGS',
        'value': '${masterDataDetailRawatJalan['keterangan_pic_hcgs'] ?? '-'}',
      },
      {
        'label': 'Keterangan Direksi',
        'value': '${masterDataDetailRawatJalan['keterangan_direksi'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightTall),
        const TitleWidget(title: 'Hasil Verifikasi PIC HRGS'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
        ...data.map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowWithSemicolonWidget(
                  textLeft: item['label'],
                  textRight: item['value'].toString(),
                  fontSizeLeft: textMedium,
                  fontSizeRight: textMedium,
                ),
                SizedBox(height: sizedBoxHeightShort),
              ],
            )),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightExtraTall),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: '${masterDataDetailRawatJalan['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailRawatJalan['created_at'] != null ? formatDate(masterDataDetailRawatJalan['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }
}
