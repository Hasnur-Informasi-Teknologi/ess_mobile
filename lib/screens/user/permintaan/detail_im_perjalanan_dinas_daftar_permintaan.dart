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

class DetailImPerjalananDinasDaftarPermintaan extends StatefulWidget {
  const DetailImPerjalananDinasDaftarPermintaan({super.key});

  @override
  State<DetailImPerjalananDinasDaftarPermintaan> createState() =>
      _DetailImPerjalananDinasDaftarPermintaanState();
}

class _DetailImPerjalananDinasDaftarPermintaanState
    extends State<DetailImPerjalananDinasDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailImPerjalananDinas = {};
  List<Map<String, dynamic>> masterDataDetailRincianImPerjalananDinas = [];
  final Map<String, dynamic> arguments = Get.arguments;

  List biayaPerjalananDinasHeader = [
    'No',
    'Kategori',
    'Akomodasi',
    'Tanggal Mulai',
    'Tanggal Berakhir',
    'Tipe',
    'Keterangan',
    'Nilai (Rp)',
  ];

  List biayaPerjalananDinasKey = [
    'index',
    'kategori',
    'akomodasi',
    'tgl_mulai',
    'tgl_berakhir',
    'tipe',
    'keterangan',
    'nilai'
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailImPerjalananDinas();
  }

  Future<void> getDataDetailImPerjalananDinas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.get(
            Uri.parse("$_apiUrl/rencana-perdin/detail/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailImPerjalananDinasApi = responseData['parent'];
        final dataDetailRincianImPerjalananDinasApi = responseData['child'];

        setState(() {
          masterDataDetailImPerjalananDinas =
              Map<String, dynamic>.from(dataDetailImPerjalananDinasApi);

          masterDataDetailRincianImPerjalananDinas =
              List<Map<String, dynamic>>.from(
                  dataDetailRincianImPerjalananDinasApi);
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
          'Rencana Biaya Perjalanan Dinas',
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
              detailInternalMemoWidget(context),
              atasanWidget(context),
              hcgsWidget(context),
              catatanApproverWidget(context),
              costAssigmentWidget(context),
              biayaPerjalananDinasTable(context),
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
          textLeft: 'Nrp',
          textRight: '${masterDataDetailImPerjalananDinas['nrp_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas',
          textRight: '${masterDataDetailImPerjalananDinas['entitas_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Perihal',
          textRight: '${masterDataDetailImPerjalananDinas['perihal']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataDetailImPerjalananDinas['nama_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jabatan',
          textRight: '${masterDataDetailImPerjalananDinas['jabatan_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget detailInternalMemoWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Internal Memo'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nomor Dokumen',
          textRight: '${masterDataDetailImPerjalananDinas['no_doc']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Trip Number',
          textRight: '${masterDataDetailImPerjalananDinas['trip_number']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Trip Activity',
          textRight: '${masterDataDetailImPerjalananDinas['trip_activity']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal/Jam Berangkat',
          textRight: '${masterDataDetailImPerjalananDinas['tgl_berangkat']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal/Jam Kembali',
          textRight: '${masterDataDetailImPerjalananDinas['tgl_kembali']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tempat Tujuan',
          textRight: '${masterDataDetailImPerjalananDinas['tempat_tujuan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jenis Biaya',
          textRight: '${masterDataDetailImPerjalananDinas['nama_jenis_biaya']}',
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
          textRight: '${masterDataDetailImPerjalananDinas['nrp_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama Atasan',
          textRight: '${masterDataDetailImPerjalananDinas['nama_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas Atasan',
          textRight: '${masterDataDetailImPerjalananDinas['entitas_atasan']}',
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
          textRight: '${masterDataDetailImPerjalananDinas['nrp_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama HCGS',
          textRight: '${masterDataDetailImPerjalananDinas['nama_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas HCGS',
          textRight: '${masterDataDetailImPerjalananDinas['entitas_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget catatanApproverWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Catatan Approver'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Catatan Atasan',
          textRight: '${masterDataDetailImPerjalananDinas['catatan_atasan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Catatan HCGS',
          textRight: '${masterDataDetailImPerjalananDinas['catatan_hrgs']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget costAssigmentWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Cost Assigment'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tipe Cost Assigment',
          textRight: '${masterDataDetailImPerjalananDinas['type_cost_assign']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget biayaPerjalananDinasTable(BuildContext context) {
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
        const TitleWidget(title: 'Biaya Perjalanan Dinas'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataDetailRincianImPerjalananDinas.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 200,
                    child: ScrollableTableView(
                      headers: biayaPerjalananDinasHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataDetailRincianImPerjalananDinas
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 60,
                          cells: biayaPerjalananDinasKey.map((column) {
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
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: '${masterDataDetailImPerjalananDinas['status_approve']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': ${masterDataDetailImPerjalananDinas['created_at']}',
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
