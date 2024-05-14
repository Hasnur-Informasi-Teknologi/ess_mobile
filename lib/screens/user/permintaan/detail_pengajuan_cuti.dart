import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/row_with_semicolon_widget.dart';
import 'package:mobile_ess/widgets/title_center_widget.dart';
import 'package:mobile_ess/widgets/title_center_with_badge_long_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailPengajuanCuti extends StatefulWidget {
  const DetailPengajuanCuti({super.key});

  @override
  State<DetailPengajuanCuti> createState() => _DetailPengajuanCutiState();
}

class _DetailPengajuanCutiState extends State<DetailPengajuanCuti> {
  final String _apiUrl = API_URL;
  Map<String, dynamic> masterDataDetailPengajuanCuti = {};
  final Map<String, dynamic> arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getDataDetailPengajuanCuti();
  }

  Future<void> getDataDetailPengajuanCuti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int id = arguments['id'];

    print(id);

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/pengajuan-cuti/detail/$id"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataDetailPengajuanCutiApi = responseData['dcuti'];
        print(dataDetailPengajuanCutiApi);

        setState(() {
          masterDataDetailPengajuanCuti =
              Map<String, dynamic>.from(dataDetailPengajuanCutiApi);
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
          'Detail Permintaan Pengajuan Cuti',
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
                textLeft: 'NRP',
                textRight: '${masterDataDetailPengajuanCuti['nrp_user']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Nama',
                textRight: '${masterDataDetailPengajuanCuti['nama_user']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Perusahaan',
                textRight: '${masterDataDetailPengajuanCuti['entitas_user']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Jabatan',
                textRight: '${masterDataDetailPengajuanCuti['posisi_user']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Lokasi Kerja',
                textRight: '${masterDataDetailPengajuanCuti['lokasi_user']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Tanggal Pengajuan Cuti'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Tanggal Mulai',
                textRight: '${masterDataDetailPengajuanCuti['tgl_mulai']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Tanggal Berakhir',
                textRight: '${masterDataDetailPengajuanCuti['tgl_berakhir']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Tanggal Kembali Kerja',
                textRight:
                    '${masterDataDetailPengajuanCuti['tgl_kembali_kerja']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Alamat',
                textRight: '${masterDataDetailPengajuanCuti['alamat_cuti']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'No Telpon',
                textRight: '${masterDataDetailPengajuanCuti['no_telp']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Keterangan Cuti'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Jenis Cuti',
                textRight: masterDataDetailPengajuanCuti['dibayar'] == 'X'
                    ? 'Cuti Tahunan Dibayar'
                    : masterDataDetailPengajuanCuti['tdk_dibayar'] == 'X'
                        ? 'Cuti Tahunan Tidak Dibayar'
                        : 'Cuti Lainnya',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Atasan'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Atasan',
                textRight: '${masterDataDetailPengajuanCuti['nama_atasan']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Atasan Dari Atasan',
                textRight:
                    masterDataDetailPengajuanCuti['nama_direktur'] == 'null'
                        ? masterDataDetailPengajuanCuti['nama_direktur']
                        : '-',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Catatan Cuti'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Nomor Dokumen',
                textRight: '${masterDataDetailPengajuanCuti['no_doc']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Keperluan Cuti',
                textRight: '${masterDataDetailPengajuanCuti['keperluan']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Total Cuti Yang Diambil',
                textRight: '${masterDataDetailPengajuanCuti['jml_cuti']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              const TitleWidget(title: 'Karyawan Pengganti'),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              const LineWidget(),
              const SizedBox(
                height: sizedBoxHeightTall,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Nama',
                textRight: '${masterDataDetailPengajuanCuti['nama_pengganti']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              RowWithSemicolonWidget(
                textLeft: 'Jabatan',
                textRight:
                    '${masterDataDetailPengajuanCuti['posisi_pengganti']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
              ),
              const SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              TitleCenterWithLongBadgeWidget(
                textLeft: 'Status Pengajuan',
                textRight: '${masterDataDetailPengajuanCuti['status_approve']}',
                fontSizeLeft: textMedium,
                fontSizeRight: textMedium,
                color: Colors.yellow,
              ),
              const SizedBox(
                height: sizedBoxHeightShort,
              ),
              TitleCenterWidget(
                textLeft: 'Pada',
                textRight: ': ${masterDataDetailPengajuanCuti['created_at']}',
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
