import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

class DetailPenilaianKinerjaKaryawanDaftarPermintaan extends StatefulWidget {
  const DetailPenilaianKinerjaKaryawanDaftarPermintaan({super.key});

  @override
  State<DetailPenilaianKinerjaKaryawanDaftarPermintaan> createState() =>
      _DetailPenilaianKinerjaKaryawanDaftarPermintaanState();
}

class _DetailPenilaianKinerjaKaryawanDaftarPermintaanState
    extends State<DetailPenilaianKinerjaKaryawanDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailPenilaianKinerjaKaryawan = {};
  List<Map<String, dynamic>> masterDataAspekPenilaianTable = [];
  List<Map<String, dynamic>> masterDataAspekPenilaianFinalTable = [];

  final Map<String, dynamic> arguments = Get.arguments;

  List aspekPenilaianHeader = [
    'A. Aspek Umum',
    'Nilai',
    'B. Aspek Manajerial',
    'Nilai',
  ];

  List aspekPenilaianKey = [
    'judul_aspek_a',
    'nilai_a',
    'judul_aspek_b',
    'nilai_b',
  ];

  @override
  void initState() {
    super.initState();
    getDataDetailPenilaianKinerjaKaryawan();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> getDataDetailPenilaianKinerjaKaryawan() async {
    final token = await _getToken();
    if (token == null) return;

    final id = int.parse(arguments['id'].toString());

    try {
      final response =
          await _fetchDataDetailPenilaianKinerjaKaryawan(token, id);
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

  Future<http.Response> _fetchDataDetailPenilaianKinerjaKaryawan(
      String token, int id) {
    final ioClient = createIOClientWithInsecureConnection();

    final url = Uri.parse("$_apiUrl/penilaian-kinerja/detail/$id");
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
    final dataDetailPenilaianKinerjaKaryawanApi = responseData['parent'];
    final dataAspekPenilaianTableApi = responseData['child'];

    setState(() {
      masterDataDetailPenilaianKinerjaKaryawan =
          Map<String, dynamic>.from(dataDetailPenilaianKinerjaKaryawanApi);

      masterDataAspekPenilaianTable =
          List<Map<String, dynamic>>.from(dataAspekPenilaianTableApi);

      final groupedData = _groupDataByIndex(masterDataAspekPenilaianTable);
      masterDataAspekPenilaianFinalTable = _mergeGroupedData(groupedData);

      // final encoder = JsonEncoder.withIndent('  ');
      // final prettyprint = encoder.convert(result);
      print(masterDataAspekPenilaianFinalTable);
    });
  }

  Map<String, Map<String, dynamic>> _groupDataByIndex(
      List<Map<String, dynamic>> data) {
    final Map<String, Map<String, dynamic>> groupedData = {};

    for (var item in data) {
      final index = item['indeks_aspek'];
      final num = index.substring(1);

      if (!groupedData.containsKey(num)) {
        groupedData[num] = {};
      }

      groupedData[num]![index.substring(0, 1)] = item;
    }

    return groupedData;
  }

  String _truncateDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    }
    return description.substring(0, maxLength) + '...';
  }

  List<Map<String, dynamic>> _mergeGroupedData(
      Map<String, Map<String, dynamic>> groupedData) {
    return groupedData.entries.map((entry) {
      final Map<String, dynamic> mergedMap = {};

      if (entry.value.containsKey('A')) {
        final a = entry.value['A'];
        mergedMap.addAll({
          'id_a': a['id'],
          'judul_aspek_a': a['judul_aspek'],
          'deskripsi_aspek_a': _truncateDescription(a['deskripsi_aspek'], 100),
          'tipe_aspek_a': a['tipe_aspek'],
          'indeks_aspek_a': a['indeks_aspek'],
          'id_nilai_a': a['id_nilai'],
          'nilai_a': a['nilai'],
        });
      }

      if (entry.value.containsKey('B')) {
        final b = entry.value['B'];
        mergedMap.addAll({
          'id_b': b['id'],
          'judul_aspek_b': b['judul_aspek'],
          'deskripsi_aspek_b': _truncateDescription(b['deskripsi_aspek'], 100),
          'tipe_aspek_b': b['tipe_aspek'],
          'indeks_aspek_b': b['indeks_aspek'],
          'id_nilai_b': b['id_nilai'],
          'nilai_b': b['nilai'],
        });
      }

      return mergedMap;
    }).toList();
  }

  void _handleErrorResponse(http.Response response) {
    print('Failed to fetch data: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;
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
          'Penilaian Kinerja Karyawan',
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
              ditujukanKepadaWidget(context),
              atasanWidget(context),
              direkturOperasionalWidget(context),
              compensationBenefitWidget(context),
              financeDirekturWidget(context),
              catatanHasilPenilaianWidget(context),
              aspekPenilaianTable(context),
              usulanHasilPenilaianWidget(context),
              catatanApproverWidget(context),
              footerWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget aspekPenilaianTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightShort = size.height * 0.0086;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Aspek Penilaian'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataAspekPenilaianFinalTable.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 500,
                    width: 2000,
                    child: ScrollableTableView(
                      headers: aspekPenilaianHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataAspekPenilaianFinalTable
                          .asMap()
                          .entries
                          .map((entry) {
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 200,
                          cells: aspekPenilaianKey.map((column) {
                            if (column == 'judul_aspek_a') {
                              return TableViewCell(
                                child: Column(
                                  children: [
                                    Text(
                                      data['judul_aspek_a'] != null
                                          ? '${data['judul_aspek_a']}'
                                          : '-',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      data['deskripsi_aspek_a'] != null
                                          ? '${data['deskripsi_aspek_a']}'
                                          : '-',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (column == 'judul_aspek_b') {
                              return TableViewCell(
                                child: Column(
                                  children: [
                                    Text(
                                      data['judul_aspek_b'] != null
                                          ? '${data['judul_aspek_b']}'
                                          : '-',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      data['deskripsi_aspek_b'] != null
                                          ? '${data['deskripsi_aspek_b']}'
                                          : '-',
                                      style: TextStyle(
                                        color: const Color(primaryBlack),
                                        fontSize: textMedium,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
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
      ],
    );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP Pemohon',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_user'] ?? '-'
      },
      {
        'label': 'Nama Pemohon',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_user'] ?? '-'
      },
      {
        'label': 'Entitas Pemohon',
        'value': masterDataDetailPenilaianKinerjaKaryawan['entitas_user'] ?? '-'
      },
      {
        'label': 'Jabatan Pemohon',
        'value': masterDataDetailPenilaianKinerjaKaryawan['jabatan_user'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Diajukan Oleh'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget ditujukanKepadaWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_to'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_to'] ?? '-'
      },
      {
        'label': 'Entitas',
        'value': masterDataDetailPenilaianKinerjaKaryawan['entitas_to'] ?? '-'
      },
      {
        'label': 'Jabatan',
        'value': masterDataDetailPenilaianKinerjaKaryawan['jabatan_to'] ?? '-'
      },
      {
        'label': 'Status',
        'value': masterDataDetailPenilaianKinerjaKaryawan['status_to'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Ditujukan Kepada'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget atasanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_atasan'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_atasan'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Atasan'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget direkturOperasionalWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_dirops'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_dirops'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Direktur Operasional'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget hcaDirekturWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_hca'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_hca'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'HCA Direktur'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget compensationBenefitWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_comben'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_comben'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Compensation & Benefit'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget financeDirekturWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'NRP',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nrp_finance'] ?? '-'
      },
      {
        'label': 'Nama',
        'value': masterDataDetailPenilaianKinerjaKaryawan['nama_finance'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Finance Direktur'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget catatanHasilPenilaianWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Kelebihan Karyawan',
        'value':
            masterDataDetailPenilaianKinerjaKaryawan['emp_kelebihan'] ?? '-'
      },
      {
        'label': 'Hal Yang Harus Dikembangkan Dari Karyawan',
        'value': masterDataDetailPenilaianKinerjaKaryawan['emp_improve'] ?? '-'
      },
      {
        'label': 'Pengembangan Karyawan',
        'value': masterDataDetailPenilaianKinerjaKaryawan['emp_training'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Catatan Hasil Penilaian'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget usulanHasilPenilaianWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'PKWT diperpanjang s/d',
        'value': masterDataDetailPenilaianKinerjaKaryawan['usul_pkwt_amount'] !=
                null
            ? '${masterDataDetailPenilaianKinerjaKaryawan['usul_pkwt_amount'].toString()} Bulan'
            : '-'
      },
      {
        'label': 'Kenaikan Gaji/Upah menjadi',
        'value': masterDataDetailPenilaianKinerjaKaryawan[
                    'usul_rapel_amount'] !=
                null
            ? 'Rp. ${masterDataDetailPenilaianKinerjaKaryawan['usul_rapel_amount'].toString()}'
            : '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Usulan Hasil Penilaian'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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

  Widget catatanApproverWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    List<Map<String, String>> data = [
      {
        'label': 'Catatan Atasan',
        'value':
            masterDataDetailPenilaianKinerjaKaryawan['catatan_atasan'] ?? '-'
      },
      {
        'label': 'Catatan Direktur Operasional',
        'value':
            masterDataDetailPenilaianKinerjaKaryawan['catatan_dirops'] ?? '-'
      },
      {
        'label': 'Catatan Compensation & Benefit',
        'value':
            masterDataDetailPenilaianKinerjaKaryawan['catatan_comben'] ?? '-'
      },
      {
        'label': 'HCA Direktur',
        'value': masterDataDetailPenilaianKinerjaKaryawan['catatan_hca'] ?? '-'
      },
      {
        'label': 'Finance Direktur',
        'value':
            masterDataDetailPenilaianKinerjaKaryawan['catatan_finance'] ?? '-'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Catatan Approver'),
        SizedBox(height: sizedBoxHeightShort),
        const LineWidget(),
        const SizedBox(height: 15),
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
              '${masterDataDetailPenilaianKinerjaKaryawan['status_approve'] ?? '-'}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(height: sizedBoxHeightShort),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight:
              ': ${masterDataDetailPenilaianKinerjaKaryawan['created_at'] != null ? formatDate(masterDataDetailPenilaianKinerjaKaryawan['created_at']) : ''}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(height: sizedBoxHeightExtraTall),
      ],
    );
  }
}
