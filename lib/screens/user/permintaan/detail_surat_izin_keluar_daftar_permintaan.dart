import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  Future<void> getDataDetailSuratIzinKeluar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.get(
            Uri.parse("$_apiUrl/izin-keluar/detail/${id}"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailSuratIzinKeluarApi = responseData['parent'];
        final dataDetailChildSuratIzinKeluarApi = responseData['child'];

        setState(() {
          masterDataParentSuratIzinKeluar =
              Map<String, dynamic>.from(dataDetailSuratIzinKeluarApi);
          masterDataChildSuratIzinKeluar = List<Map<String, dynamic>>.from(
              dataDetailChildSuratIzinKeluarApi);
          print(masterDataChildSuratIzinKeluar);
          _isLoading = false;
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
          textLeft: 'NRP',
          textRight: '${masterDataParentSuratIzinKeluar['nrp_user'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataParentSuratIzinKeluar['nama_user'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Pengajuan',
          textRight: '${masterDataParentSuratIzinKeluar['created_at'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'NRP Atasan',
          textRight: '${masterDataParentSuratIzinKeluar['nrp_atasan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama Atasan',
          textRight: '${masterDataParentSuratIzinKeluar['nama_atasan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas Atasan',
          textRight:
              '${masterDataParentSuratIzinKeluar['entitas_atasan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget hcgsWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'HCGS'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'NRP HCGS',
          textRight: '${masterDataParentSuratIzinKeluar['nrp_hrgs'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama HCGS',
          textRight: '${masterDataParentSuratIzinKeluar['nama_hrgs'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas HCGS',
          textRight:
              '${masterDataParentSuratIzinKeluar['entitas_hrgs'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget detailIzinKeluarWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Izin Keluar'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Izin',
          textRight: '${masterDataParentSuratIzinKeluar['tgl_izin'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jam Keluar',
          textRight: '${masterDataParentSuratIzinKeluar['jam_keluar'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keperluan',
          textRight: '${masterDataParentSuratIzinKeluar['keperluan'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas',
          textRight:
              '${masterDataParentSuratIzinKeluar['entitas_user'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jenis Izin Keluar',
          textRight: '${masterDataParentSuratIzinKeluar['jenis_izin'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jam Kembali',
          textRight: '${masterDataParentSuratIzinKeluar['jam_kembali'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight:
              '${masterDataParentSuratIzinKeluar['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataParentSuratIzinKeluar['created_at'] ?? '-'}',
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
