import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailBantuanKomunikasiDaftarPermintaan extends StatefulWidget {
  const DetailBantuanKomunikasiDaftarPermintaan({super.key});

  @override
  State<DetailBantuanKomunikasiDaftarPermintaan> createState() =>
      _DetailBantuanKomunikasiDaftarPermintaanState();
}

class _DetailBantuanKomunikasiDaftarPermintaanState
    extends State<DetailBantuanKomunikasiDaftarPermintaan> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailBantuanKomunikasi = {};
  String? nominalFormated;
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getDataDetailBantuanKomunikasi();
  }

  Future<void> getDataDetailBantuanKomunikasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? nominal;
    int id = arguments['id'];

    print(id);

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.get(
            Uri.parse("$_apiUrl/bantuan-komunikasi/detail/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailBantuanKomunikasiApi = responseData['dkomunikasi'];

        setState(() {
          masterDataDetailBantuanKomunikasi =
              Map<String, dynamic>.from(dataDetailBantuanKomunikasiApi);
          nominal = masterDataDetailBantuanKomunikasi['nominal'];
          nominalFormated =
              NumberFormat.decimalPattern('id-ID').format(nominal);
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
          'Detail Permintaan Bantuan Komunikasi',
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
              diberikanKepadaWidget(context),
              detailFasilitasKomunikasiWidget(context),
              keteranganWidget(context),
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
          textRight: '${masterDataDetailBantuanKomunikasi['nrp_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataDetailBantuanKomunikasi['nama_user']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tanggal Pengajuan',
          textRight: '${masterDataDetailBantuanKomunikasi['tgl_pengajuan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget diberikanKepadaWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

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
        RowWithSemicolonWidget(
          textLeft: 'NRP',
          textRight: '${masterDataDetailBantuanKomunikasi['nrp_penerima']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nama',
          textRight: '${masterDataDetailBantuanKomunikasi['nama_penerima']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jabatan',
          textRight: '${masterDataDetailBantuanKomunikasi['jabatan_penerima']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Entitas',
          textRight: '${masterDataDetailBantuanKomunikasi['entitas_penerima']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Pangkat',
          textRight: '${masterDataDetailBantuanKomunikasi['pangkat_penerima']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget detailFasilitasKomunikasiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Detail Fasilitas Komunikasi'),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        const LineWidget(),
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Kelompok Jabatan',
          textRight:
              '${masterDataDetailBantuanKomunikasi['pangkat_komunikasi']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Nominal (IDR)',
          textRight: '${nominalFormated}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jenis Fasilitas',
          textRight: '${masterDataDetailBantuanKomunikasi['nama_fasilitas']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Jenis Mobile Phone',
          textRight: '${masterDataDetailBantuanKomunikasi['jenis_phone_name']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        (masterDataDetailBantuanKomunikasi['merek_phone'] != null)
            ? RowWithSemicolonWidget(
                textLeft: 'Merek Mobile Phone',
                textRight:
                    '${masterDataDetailBantuanKomunikasi['merek_phone']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              )
            : const SizedBox(
                height: 0,
              ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Prioritas',
          textRight: masterDataDetailBantuanKomunikasi['prioritas'] == '0'
              ? 'Rendah'
              : masterDataDetailBantuanKomunikasi['prioritas'] == '1'
                  ? 'Sedang'
                  : 'Tinggi',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tujuan Komunikasi Internal',
          textRight: '${masterDataDetailBantuanKomunikasi['tujuan_internal']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Tujuan Komunikasi Eksternal',
          textRight: '${masterDataDetailBantuanKomunikasi['tujuan_eksternal']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        RowWithSemicolonWidget(
          textLeft: 'Keterangan',
          textRight: '${masterDataDetailBantuanKomunikasi['keterangan']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
        ),
        SizedBox(
          height: sizedBoxHeightExtraTall,
        ),
      ],
    );
  }

  Widget keteranganWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = 15;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TitleWidget(title: 'Keterangan'),
      SizedBox(
        height: sizedBoxHeightShort,
      ),
      const LineWidget(),
      SizedBox(
        height: sizedBoxHeightTall,
      ),
      RowWithSemicolonWidget(
        textLeft: 'Tujuan Komunikasi Internal',
        textRight: '${masterDataDetailBantuanKomunikasi['tujuan_internal']}',
        fontSizeLeft: textMedium,
        fontSizeRight: textMedium,
      ),
      SizedBox(
        height: sizedBoxHeightShort,
      ),
      RowWithSemicolonWidget(
        textLeft: 'Tujuan Komunikasi Ekternal',
        textRight: '${masterDataDetailBantuanKomunikasi['tujuan_eksternal']}',
        fontSizeLeft: textMedium,
        fontSizeRight: textMedium,
      ),
      SizedBox(
        height: sizedBoxHeightShort,
      ),
      RowWithSemicolonWidget(
        textLeft: 'Keterangan',
        textRight: '${masterDataDetailBantuanKomunikasi['keterangan']}',
        fontSizeLeft: textMedium,
        fontSizeRight: textMedium,
      ),
    ]);
  }

  Widget footerWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightTall = 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        TitleCenterWithLongBadgeWidget(
          textLeft: 'Status Pengajuan',
          textRight: '${masterDataDetailBantuanKomunikasi['status_approve']}',
          fontSizeLeft: textMedium,
          fontSizeRight: textMedium,
          color: Colors.yellow,
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        TitleCenterWidget(
          textLeft: 'Pada',
          textRight: ': ${masterDataDetailBantuanKomunikasi['created_at']}',
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
