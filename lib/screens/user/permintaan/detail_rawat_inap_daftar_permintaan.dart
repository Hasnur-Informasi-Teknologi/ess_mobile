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
    final token = await _getToken();
    if (token == null) return;
    final id = int.parse(arguments['id'].toString());

    setState(() {
      _isLoadingScreen = true;
    });

    try {
      final ioClient = createIOClientWithInsecureConnection();
      final response = await ioClient.get(
        Uri.parse("$_apiUrl/rawat/inap/$id/detail"),
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
    final dataDetailRawatInapApi = responseData['data'];
    final dataDetailRincianRawatInapApi = dataDetailRawatInapApi['detail'];

    setState(() {
      masterDataDetailRawatInap =
          Map<String, dynamic>.from(dataDetailRawatInapApi);
      masterDataDetailRincianRawatInap =
          List<Map<String, dynamic>>.from(dataDetailRincianRawatInapApi);

      totalPengajuanFormated =
          _formatCurrency(dataDetailRawatInapApi['total_pengajuan']);
      selisihFormated =
          _formatCurrency(dataDetailRawatInapApi['total_pengajuan']);
      totalDigantiFormated =
          _formatCurrency(dataDetailRawatInapApi['total_diganti']);

      _isLoadingScreen = false;
    });
  }

  String _formatCurrency(String? amount) {
    int value = int.tryParse(amount ?? '') ?? 0;
    return NumberFormat.decimalPattern('id-ID').format(value);
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

    List<Map<String, dynamic>> data = [
      {
        'label': 'Kode',
        'value': '${masterDataDetailRawatInap['kode_rawat_inap'] ?? '-'}',
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': '${masterDataDetailRawatInap['tgl_pengajuan'] ?? '-'}',
      },
      {
        'label': 'Nrp',
        'value': '${masterDataDetailRawatInap['pernr'] ?? '-'}',
      },
      {
        'label': 'Nama Karyawan',
        'value': '${masterDataDetailRawatInap['nama'] ?? '-'}',
      },
      {
        'label': 'Perusahaan',
        'value': '${masterDataDetailRawatInap['pt'] ?? '-'}',
      },
      {
        'label': 'Lokasi Kerja',
        'value': '${masterDataDetailRawatInap['lokasi'] ?? '-'}',
      },
      {
        'label': 'Pangkat Karyawan',
        'value': '${masterDataDetailRawatInap['pangkat'] ?? '-'}',
      },
      {
        'label': 'Tanggal Masuk',
        'value': '${masterDataDetailRawatInap['hire_date'] ?? '-'}',
      },
      {
        'label': 'Periode Rawat (Mulai)',
        'value': '${masterDataDetailRawatInap['prd_rawat_mulai'] ?? '-'}',
      },
      {
        'label': 'Periode Rawat (Berakhir)',
        'value': '${masterDataDetailRawatInap['prd_rawat_akhir'] ?? '-'}',
      },
      {
        'label': 'Nama Pasien',
        'value': '${masterDataDetailRawatInap['nm_pasien'] ?? '-'}',
      },
      {
        'label': 'Hubungan Dengan Karyawan',
        'value': '${masterDataDetailRawatInap['hub_karyawan'] ?? '-'}',
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
        const TitleWidget(title: 'Daftar Pengajuan'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
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
        'value': masterDataDetailRawatInap['approved_date2'] ?? '-',
      },
      {
        'label': 'Total Pengajuan',
        'value': 'Rp. $totalPengajuanFormated',
      },
      {
        'label': 'Selisih',
        'value': 'Rp. $selisihFormated',
      },
      {
        'label': 'Catatan',
        'value': masterDataDetailRawatInap['catatan'] ?? '-',
      },
      {
        'label': 'Keterangan Atasan',
        'value': masterDataDetailRawatInap['keterangan_atasan'] ?? '-',
      },
      {
        'label': 'Keterangan PIC HCGS',
        'value': masterDataDetailRawatInap['keterangan_pic_hcgs'] ?? '-',
      },
      {
        'label': 'Keterangan Direksi',
        'value': masterDataDetailRawatInap['keterangan_direksi'] ?? '-',
      },
      {
        'label': 'Dokumen',
        'value': masterDataDetailRawatInap['dokumen'] ?? '-',
      },
      {
        'label': 'Total Diganti Perusahaan',
        'value': 'Rp. $totalDigantiFormated',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: sizedBoxHeightExtraTall),
        const TitleWidget(title: 'Hasil Verifikasi PIC HCGS'),
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
      ],
    );
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    String statusApprove = masterDataDetailRawatInap['status_approve'] ?? '-';
    String createdAt = masterDataDetailRawatInap['created_at'] ?? '-';

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
