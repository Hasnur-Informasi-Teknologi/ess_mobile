import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class DetailLpjPerjalananDinasDaftarPermintaan extends StatefulWidget {
  const DetailLpjPerjalananDinasDaftarPermintaan({super.key});

  @override
  State<DetailLpjPerjalananDinasDaftarPermintaan> createState() =>
      _DetailLpjPerjalananDinasDaftarPermintaanState();
}

class _DetailLpjPerjalananDinasDaftarPermintaanState
    extends State<DetailLpjPerjalananDinasDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailLpjPerjalananDinas = {};
  List<Map<String, dynamic>> masterDataLaporanAktivitasPerjalananDinas = [];
  List<Map<String, dynamic>> masterDataLaporanBiayaPerjalananDinas = [];

  List laporanAktivitasPerjalananDinasHeader = [
    'No',
    'Tanggal',
    'Aktivitas',
    'Hasil Aktivitas',
    'Hambatan',
    'Tindak Lanjut',
  ];

  List laporanAktivitasPerjalananDinasKey = [
    'index',
    'tgl_aktivitas',
    'aktivitas',
    'hasil_aktivitas',
    'hambatan',
    'tindak_lanjut',
  ];

  List laporanBiayaPerjalananDinasHeader = [
    'No',
    'Tanggal',
    'Uraian',
    'Kategori',
    'Nilai',
  ];

  List laporanBiayaPerjalananDinasKey = [
    'index',
    'tgl_biaya',
    'uraian',
    'deskripsi_ca',
    'nilai',
  ];

  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getDataDetailLpjPerjalananDinas();
  }

  Future<void> getDataDetailLpjPerjalananDinas() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response = await _fetchDataDetailLpjPerjalananDinas(token, id);
      if (response.statusCode == 200) {
        _handleSuccessResponse(response);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<http.Response> _fetchDataDetailLpjPerjalananDinas(
      String token, int id) async {
    final ioClient = createIOClientWithInsecureConnection();
    final url = Uri.parse("$_apiUrl/laporan-perdin/detail/$id");
    return ioClient.get(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  void _handleSuccessResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    final dataDetailLpjPerjalananDinasApi = responseData['parent'];
    final dataLaporanAktivitasPerjalananDinasApi =
        responseData['child_aktivitas_lpj'];
    final dataLaporanBiayaPerjalananDinasApi = responseData['child_biaya_lpj'];

    setState(() {
      masterDataDetailLpjPerjalananDinas =
          Map<String, dynamic>.from(dataDetailLpjPerjalananDinasApi);
      masterDataLaporanAktivitasPerjalananDinas =
          List<Map<String, dynamic>>.from(
              dataLaporanAktivitasPerjalananDinasApi);
      masterDataLaporanBiayaPerjalananDinas =
          List<Map<String, dynamic>>.from(dataLaporanBiayaPerjalananDinasApi);
    });
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double padding7 = size.width * 0.018;
    double paddingHorizontalWide = size.width * 0.0585;
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
          'Laporan Biaya Perjalanan Dinas',
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
              atasanWidget(context),
              hcgsWidget(context),
              catatanApproverWidget(context),
              detailLaporanPerjalananDinasWidget(context),
              biayaAktivitasPerjalananDinasTable(context),
              laporanBiayaPerjalananDinasTable(context),
              laporanBiayaPerjalananDinasWidget(context),
              footerWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget biayaAktivitasPerjalananDinasTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Laporan Aktivitas Perjalanan Dinas'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataLaporanAktivitasPerjalananDinas.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers:
                          laporanAktivitasPerjalananDinasHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataLaporanAktivitasPerjalananDinas
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells:
                              laporanAktivitasPerjalananDinasKey.map((column) {
                            if (column == 'index') {
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
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget laporanBiayaPerjalananDinasTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = 15;
    double sizedBoxHeightShort = 8;
    double sizedBoxHeightExtraTall = 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Laporan Biaya Perjalanan Dinas'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataLaporanBiayaPerjalananDinas.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: laporanBiayaPerjalananDinasHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataLaporanBiayaPerjalananDinas
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: laporanBiayaPerjalananDinasKey.map((column) {
                            if (column == 'index') {
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
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Nrp',
        'value': masterDataDetailLpjPerjalananDinas['nrp_user'] ?? '-',
      },
      {
        'label': 'Entitas',
        'value': masterDataDetailLpjPerjalananDinas['entitas_user'] ?? '-',
      },
      {
        'label': 'Perihal',
        'value': masterDataDetailLpjPerjalananDinas['perihal'] ?? '-',
      },
      {
        'label': 'Nama',
        'value': masterDataDetailLpjPerjalananDinas['nama_user'] ?? '-',
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailLpjPerjalananDinas['jabatan_user'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
      ],
    );
  }

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'NRP Atasan',
        'value': masterDataDetailLpjPerjalananDinas['nrp_atasan'] ?? '-',
      },
      {
        'label': 'Nama Atasan',
        'value': masterDataDetailLpjPerjalananDinas['nama_atasan'] ?? '-',
      },
      {
        'label': 'Entitas Atasan',
        'value': masterDataDetailLpjPerjalananDinas['entitas_atasan'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
      ],
    );
  }

  Widget hcgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'NRP HCGS',
        'value': masterDataDetailLpjPerjalananDinas['nrp_hrgs'] ?? '-',
      },
      {
        'label': 'Nama HCGS',
        'value': masterDataDetailLpjPerjalananDinas['nama_hrgs'] ?? '-',
      },
      {
        'label': 'Entitas HCGS',
        'value': masterDataDetailLpjPerjalananDinas['entitas_hrgs'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'HCGS'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
      ],
    );
  }

  Widget catatanApproverWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = size.height * 0.015;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Catatan Atasan',
        'value': masterDataDetailLpjPerjalananDinas['catatan_atasan'] ?? '-',
      },
      {
        'label': 'Catatan HCGS',
        'value': masterDataDetailLpjPerjalananDinas['catatan_hrgs'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Catatan Approver'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightShort),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }

  Widget detailLaporanPerjalananDinasWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Trip Number',
        'value': masterDataDetailLpjPerjalananDinas['trip_number'] ?? '-',
      },
      {
        'label': 'Cost Assigment',
        'value': masterDataDetailLpjPerjalananDinas['type_cost_assign'] ?? '-',
      },
      {
        'label': 'Nomor Dokumen LPJ',
        'value': masterDataDetailLpjPerjalananDinas['no_doc_lpj'] ?? '-',
      },
      {
        'label': 'Nomor Dokumen IM',
        'value': masterDataDetailLpjPerjalananDinas['no_doc_im'] ?? '-',
      },
      {
        'label': 'Tanggal Pengajuan Berangkat',
        'value': masterDataDetailLpjPerjalananDinas['tgl_berangkat'] ?? '-',
      },
      {
        'label': 'Tanggal Pengajuan Pulang',
        'value': masterDataDetailLpjPerjalananDinas['tgl_kembali'] ?? '-',
      },
      {
        'label': 'Lama Pengajuan Perjalanan Dinas',
        'value':
            masterDataDetailLpjPerjalananDinas['lama_rencana_perdin'] ?? '-',
      },
      {
        'label': 'Tanggal Aktual Berangkat',
        'value':
            masterDataDetailLpjPerjalananDinas['tgl_aktual_berangkat'] ?? '-',
      },
      {
        'label': 'Tanggal Aktual Pulang',
        'value':
            masterDataDetailLpjPerjalananDinas['tgl_aktual_kembali'] ?? '-',
      },
      {
        'label': 'Lama Aktual Perjalanan Dinas',
        'value':
            masterDataDetailLpjPerjalananDinas['lama_aktual_perdin'] ?? '-',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Laporan Perjalanan Dinas'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
        ...data.map((item) => Padding(
              padding: EdgeInsets.only(bottom: sizedBoxHeightExtraTall),
              child: RowWithSemicolonWidget(
                textLeft: item['label'],
                textRight: item['value'].toString(),
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
            )),
      ],
    );
  }

  Widget laporanBiayaPerjalananDinasWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, dynamic>> data = [
      {
        'label': 'Jumlah Kas Diterima',
        'value':
            '${masterDataDetailLpjPerjalananDinas['jml_kas_diterima'] ?? '-'}',
      },
      {
        'label': 'Jumlah Pengeluaran',
        'value':
            '${masterDataDetailLpjPerjalananDinas['jml_pengeluaran'] ?? '-'}',
      },
      {
        'label': 'Kelebihan Kas',
        'value':
            '${masterDataDetailLpjPerjalananDinas['jml_kelebihan_kas'] ?? '-'}',
      },
      {
        'label': 'Kekurangan Kas',
        'value':
            '${masterDataDetailLpjPerjalananDinas['jml_kekurangan_kas'] ?? '-'}',
      },
      {
        'label': 'Catatan',
        'value':
            '${masterDataDetailLpjPerjalananDinas['catatan_biaya'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    String statusApprove =
        masterDataDetailLpjPerjalananDinas['status_approve'] ?? '-';
    String createdAt = masterDataDetailLpjPerjalananDinas['created_at'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightExtraTall),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: statusApprove,
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': $createdAt',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightShort),
      ],
    );
  }
}
