import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class DetailSuratIzinKeluarDaftarPermintaan extends StatefulWidget {
  const DetailSuratIzinKeluarDaftarPermintaan({super.key});

  @override
  State<DetailSuratIzinKeluarDaftarPermintaan> createState() =>
      _DetailSuratIzinKeluarDaftarPermintaanState();
}

class _DetailSuratIzinKeluarDaftarPermintaanState
    extends State<DetailSuratIzinKeluarDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataParentSuratIzinKeluar = {};
  List<Map<String, dynamic>> masterDataChildSuratIzinKeluar = [];
  final Map<String, dynamic> arguments = Get.arguments;
  bool _isLoading = false;

  List diberikanKepadaHeader = [
    'No',
    'NRP Karyawan',
    'Nama Karyawan',
  ];

  List diberikanKepadaKey = [
    'index',
    'nrp_karyawan',
    'nama_karyawan',
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailSuratIzinKeluar();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> getDataDetailSuratIzinKeluar() async {
    final token = await _getToken();
    if (token == null) return;
    final id = int.parse(arguments['id'].toString());

    setState(() {
      _isLoading = true;
    });

    try {
      final ioClient = createIOClientWithInsecureConnection();
      final response = await ioClient.get(
        Uri.parse("$_apiUrl/izin-keluar/detail/$id"),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      _handleResponse(response);
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    final dataDetailSuratIzinKeluarApi = responseData['parent'];
    final dataDetailChildSuratIzinKeluarApi = responseData['child'];

    setState(() {
      masterDataParentSuratIzinKeluar =
          Map<String, dynamic>.from(dataDetailSuratIzinKeluarApi);
      masterDataChildSuratIzinKeluar =
          List<Map<String, dynamic>>.from(dataDetailChildSuratIzinKeluarApi);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
    double paddingHorizontalWide = size.width * 0.0585;

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
                },
              ),
              title: Text(
                'Detail Permintaan Surat Izin Keluar',
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
                    detailIzinKeluarWidget(context),
                    diberikanKepadaTable(context),
                    footerWidget(context),
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
    double sizedBoxHeightTall = 15;

    List<Map<String, dynamic>> data = [
      {
        'label': 'NRP',
        'value': '${masterDataParentSuratIzinKeluar['nrp_user'] ?? '-'}',
      },
      {
        'label': 'Nama',
        'value': '${masterDataParentSuratIzinKeluar['nama_user'] ?? '-'}',
      },
      {
        'label': 'Tanggal Pengajuan',
        'value': '${masterDataParentSuratIzinKeluar['created_at'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
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

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, dynamic>> data = [
      {
        'label': 'NRP Atasan',
        'value': '${masterDataParentSuratIzinKeluar['nrp_atasan'] ?? '-'}',
      },
      {
        'label': 'Nama Atasan',
        'value': '${masterDataParentSuratIzinKeluar['nama_atasan'] ?? '-'}',
      },
      {
        'label': 'Entitas Atasan',
        'value': '${masterDataParentSuratIzinKeluar['entitas_atasan'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
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

  Widget hcgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, dynamic>> data = [
      {
        'label': 'NRP HCGS',
        'value': '${masterDataParentSuratIzinKeluar['nrp_hrgs'] ?? '-'}',
      },
      {
        'label': 'Nama HCGS',
        'value': '${masterDataParentSuratIzinKeluar['nama_hrgs'] ?? '-'}',
      },
      {
        'label': 'Entitas HCGS',
        'value': '${masterDataParentSuratIzinKeluar['entitas_hrgs'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'HCGS'),
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

  Widget detailIzinKeluarWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    List<Map<String, String>> data = [
      {
        'label': 'Tanggal Izin',
        'value': '${masterDataParentSuratIzinKeluar['tgl_izin'] ?? '-'}',
      },
      {
        'label': 'Jam Keluar',
        'value': '${masterDataParentSuratIzinKeluar['jam_keluar'] ?? '-'}',
      },
      {
        'label': 'Keperluan',
        'value': '${masterDataParentSuratIzinKeluar['keperluan'] ?? '-'}',
      },
      {
        'label': 'Entitas',
        'value': '${masterDataParentSuratIzinKeluar['entitas_user'] ?? '-'}',
      },
      {
        'label': 'Jenis Izin Keluar',
        'value': '${masterDataParentSuratIzinKeluar['jenis_izin'] ?? '-'}',
      },
      {
        'label': 'Jam Kembali',
        'value': '${masterDataParentSuratIzinKeluar['jam_kembali'] ?? '-'}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Izin Keluar'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(height: sizedBoxHeightTall),
        ...data.map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowWithSemicolonWidget(
                  textLeft: item['label'],
                  textRight: item['value'],
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

  Widget diberikanKepadaTable(BuildContext context) {
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
        const TitleWidget(title: 'Diberikan Kepada'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataChildSuratIzinKeluar.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: diberikanKepadaHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataChildSuratIzinKeluar
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: diberikanKepadaKey.map((column) {
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
          textRight:
              '${masterDataParentSuratIzinKeluar['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataParentSuratIzinKeluar['created_at'] != null ? formatDate(masterDataParentSuratIzinKeluar['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }
}
