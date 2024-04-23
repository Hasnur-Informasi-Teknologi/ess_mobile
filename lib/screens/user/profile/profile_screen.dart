import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/three_row_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  RxBool infoPribadi = false.obs;
  RxBool infoKeluarga = false.obs;
  RxBool infoFisik = false.obs;
  RxBool infoKepegawaian = false.obs;
  RxBool infoKontrak = false.obs;
  RxBool infoPendidikan = false.obs;
  var data = {}.obs;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _apiUrl = API_URL;
  ProfileController x = Get.put(ProfileController());

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('nrp');
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightTall = size.height * 0.0163;
    double paddingHorizontalWide = size.width * 0.0585;
    double sizedBoxHeightExtraTall = size.height * 0.0215;

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  GestureDetector(
                    onDoubleTap: () {},
                    child: Container(
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 53,
                          child: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              maxRadius: 50,
                              backgroundImage: x.data['pernr'] == null
                                  ? const AssetImage(
                                          'assets/images/user-profile-default.png')
                                      as ImageProvider
                                  : NetworkImage(
                                      '$_apiUrl/get_photo2?nrp=' +
                                          x.data['pernr'],
                                    )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  const TitleWidget(title: 'Data Pribadi'),
                  SizedBox(height: sizedBoxHeightShort),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.zero,
                    elevation: 1,
                    animationDuration: Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        x.infoPribadi.value = !x.infoPribadi.value;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.person_2),
                            title: Text(
                              'Informasi Pribadi',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textMedium),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "NRP",
                                      choosedSetting: x.data['pernr'] ?? ''),
                                  CustomRow(
                                      title: "Nama",
                                      choosedSetting: x.data['nama'] ?? ''),
                                  CustomRow(
                                      title: "No KTP",
                                      choosedSetting:
                                          x.data['nomor_ktp'] ?? ''),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      choosedSetting:
                                          x.data['tgl_lahir'] ?? ''),
                                  CustomRow(
                                      title: "Usia",
                                      choosedSetting: x.data['usia'] ?? ''),
                                  CustomRow(
                                      title: "Jenis Kelamin",
                                      choosedSetting:
                                          x.data['jenis_kelamin'] ?? ''),
                                  CustomRow(
                                      title: "Alamat",
                                      choosedSetting:
                                          x.data['alamat_tinggal'] ?? ''),
                                  CustomRow(
                                      title: "Kota",
                                      choosedSetting:
                                          x.data['kota_tinggal'] ?? ''),
                                  CustomRow(
                                      title: "Provinsi",
                                      choosedSetting:
                                          x.data['provinsi_tinggal'] ?? ''),
                                  CustomRow(
                                      title: "Kode Pos",
                                      choosedSetting: x.data['kode_pos'] ?? ''),
                                  CustomRow(
                                      title: "Alamat Surat",
                                      choosedSetting:
                                          x.data['alamat_surat'] ?? ''),
                                  CustomRow(
                                      title: "Kota Surat",
                                      choosedSetting:
                                          x.data['kota_surat'] ?? ''),
                                  CustomRow(
                                      title: "Kode Pos Surat",
                                      choosedSetting:
                                          x.data['kode_pos_surat'] ?? ''),
                                  CustomRow(
                                      title: "No Telepon Rumah",
                                      choosedSetting:
                                          x.data['no_telp_rmh'] ?? ''),
                                  CustomRow(
                                      title: "No HP",
                                      choosedSetting: x.data['no_hp'] ?? ''),
                                  CustomRow(
                                      title: "Golongan Darah",
                                      choosedSetting:
                                          x.data['golongan_darah'] ?? ''),
                                  CustomRow(
                                      title: "Status Pajak",
                                      choosedSetting:
                                          x.data['sts_pajak'] ?? ''),
                                  CustomRow(
                                      title: "Status Pernikahan",
                                      choosedSetting:
                                          x.data['status_pernikahan'] ?? ''),
                                  CustomRow(
                                      title: "Tanggal Pernikahan",
                                      choosedSetting:
                                          x.data['tanggal_nikah'] ?? ''),
                                  CustomRow(
                                      title: "Nama Pasangan",
                                      choosedSetting:
                                          x.data['nama_pasangan'] ?? ''),
                                  CustomRow(
                                      title: "Tanggal Lahir Pasangan",
                                      choosedSetting:
                                          x.data['tgl_lhr_pasangan'] ?? ''),
                                ],
                              )),
                        ),
                        isExpanded: x.infoPribadi.value,
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeightTall),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.zero,
                    elevation: 1,
                    animationDuration: Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        x.infoKeluarga.value = !x.infoKeluarga.value;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.family_restroom),
                            title: Text(
                              'Informasi Keluarga',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textMedium),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Obx(() => Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Ayah Kandung",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  CustomRow(
                                      title: "Nama",
                                      choosedSetting:
                                          x.data['ayah_nama'] ?? ''),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      choosedSetting:
                                          x.data['ayah_tgl_lahir'] ?? ''),
                                  CustomRow(
                                      title: "Tempat Lahir",
                                      choosedSetting:
                                          x.data['ayah_tempat_lahir'] ?? ''),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Ibu Kandung",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizedBoxHeightShort,
                                  ),
                                  CustomRow(
                                      title: "Nama",
                                      choosedSetting: x.data['ibu_nama'] ?? ''),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      choosedSetting:
                                          x.data['ibu_tgl_lahir'] ?? ''),
                                  CustomRow(
                                      title: "Tempat Lahir",
                                      choosedSetting:
                                          x.data['ibu_tempat_lahir'] ?? ''),
                                ],
                              )),
                        ),
                        isExpanded: x.infoKeluarga.value,
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeightShort),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.zero,
                    elevation: 1,
                    animationDuration: Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        x.infoFisik.value = !x.infoFisik.value;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.info),
                            title: Text(
                              'Informasi Fisik',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textMedium),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Tinggi Badan",
                                      choosedSetting:
                                          x.data['tinggi_badan'] ?? ''),
                                  CustomRow(
                                      title: "Berat Badan",
                                      choosedSetting:
                                          x.data['berat_badan'] ?? ''),
                                  CustomRow(
                                      title: "Ukuran Baju",
                                      choosedSetting:
                                          x.data['ukuran_baju'] ?? ''),
                                  CustomRow(
                                      title: "Ukuran Celana",
                                      choosedSetting:
                                          x.data['ukuran_celana'] ?? ''),
                                  CustomRow(
                                      title: "Ukuran Sepatu",
                                      choosedSetting:
                                          x.data['ukuran_sepatu'] ?? ''),
                                ],
                              )),
                        ),
                        isExpanded: x.infoFisik.value,
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeightTall),
                  const Divider(),
                  const TitleWidget(title: 'Data Kepegawaian'),
                  SizedBox(height: sizedBoxHeightShort),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.zero,
                    elevation: 1,
                    animationDuration: Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        x.infoKepegawaian.value = !x.infoKepegawaian.value;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.work),
                            title: Text(
                              'Informasi Kepegawaian',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textMedium),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Email Kantor",
                                      choosedSetting: x.data['email'] ?? ''),
                                  CustomRow(
                                      title: "Email Pribadi",
                                      choosedSetting:
                                          x.data['email_pribadi'] ?? ''),
                                  CustomRow(
                                      title: "Perusahaan",
                                      choosedSetting: x.data['pt'] ?? ''),
                                  CustomRow(
                                      title: "SBU/Direktorat",
                                      choosedSetting: x.data['sbu'] ?? ''),
                                  CustomRow(
                                      title: "Posisi",
                                      choosedSetting: x.data['position'] ?? ''),
                                  CustomRow(
                                      title: "Lokasi",
                                      choosedSetting: x.data['lokasi'] ?? ''),
                                  CustomRow(
                                      title: "Penempatan",
                                      choosedSetting:
                                          x.data['penempatan'] ?? ''),
                                  CustomRow(
                                      title: "Status Karyawan",
                                      choosedSetting:
                                          x.data['status_karyawan'] ?? ''),
                                  CustomRow(
                                      title: "Akhir Masa Probation",
                                      choosedSetting:
                                          x.data['akhir_probation'] ?? ''),
                                  CustomRow(
                                      title: "Personal Area",
                                      choosedSetting: x.data['per_area'] ?? ''),
                                  CustomRow(
                                      title: "Pangkat",
                                      choosedSetting: x.data['pangkat'] ?? ''),
                                  CustomRow(
                                      title: "Bank Key",
                                      choosedSetting: x.data['bank_key'] ?? ''),
                                  CustomRow(
                                      title: "No Rekening",
                                      choosedSetting:
                                          x.data['bank_account'] ?? ''),
                                  CustomRow(
                                      title: "NPWP",
                                      choosedSetting: x.data['npwp'] ?? ''),
                                  CustomRow(
                                      title: "BPJS Ketenagakerjaan",
                                      choosedSetting:
                                          x.data['jamsostek'] ?? ''),
                                  CustomRow(
                                      title: "BPJS Kesehatan",
                                      choosedSetting: x.data['bpjskes'] ?? ''),
                                  CustomRow(
                                      title: "Tanggal Masuk",
                                      choosedSetting:
                                          x.data['awal_kontrak_kerja1'] ?? ''),
                                  CustomRow(
                                      title: "Masa Kerja",
                                      choosedSetting:
                                          x.data['masa_kerja'] ?? ''),
                                ],
                              )),
                        ),
                        isExpanded: x.infoKepegawaian.value,
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeightShort),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.zero,
                    elevation: 1,
                    animationDuration: Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        x.infoKontrak.value = !x.infoKontrak.value;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.description),
                            title: Text(
                              'Informasi Kontrak',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textMedium),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Kontrak Ke", choosedSetting: "I"),
                                  CustomRow(
                                      title: "Akhir Masa Kerja",
                                      choosedSetting:
                                          x.data['akhir_kontrak_kerja1'] ?? ''),
                                ],
                              )),
                        ),
                        isExpanded: x.infoKontrak.value,
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeightTall),
                  Divider(),
                  const TitleWidget(title: 'Data Kepegawaian'),
                  SizedBox(height: sizedBoxHeightShort),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.zero,
                    elevation: 1,
                    animationDuration: Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        x.infoPendidikan.value = !x.infoPendidikan.value;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: const Icon(Icons.school),
                            title: Text(
                              'Informasi Pendidikan',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textMedium),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Pendidikan Terakhir",
                                      choosedSetting:
                                          x.data['pendidikan'] ?? ''),
                                  CustomRow(
                                      title: "Jurusan",
                                      choosedSetting: x.data['jurusan'] ?? ''),
                                  CustomRow(
                                      title: "Asal Pendidikan",
                                      choosedSetting:
                                          x.data['asal_sekolah'] ?? ''),
                                  CustomRow(
                                      title: "Tahun Lulus",
                                      choosedSetting:
                                          x.data['tahun_lulus'] ?? ''),
                                ],
                              )),
                        ),
                        isExpanded: x.infoPendidikan.value,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black87,
                            elevation: 5,
                            primary: Color.fromARGB(255, 17, 209, 27),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed('/user/profile/edit');
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit),
                                Text('Edit Profile')
                              ]),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.black87,
                            elevation: 5,
                            primary: Color.fromARGB(255, 230, 24, 72),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          // onPressed: () async {
                          //   SharedPreferences prefs =
                          //       await SharedPreferences.getInstance();
                          //   prefs.remove('token');
                          //   prefs.remove('nrp');
                          //   Get.offAllNamed('/');
                          // },
                          onPressed: () {
                            showModal(context);
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.logout), Text('Logout')]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 300,
                  ),
                  // =====================================================================================
                ],
              ),
            ),
          ),
        ));
  }

  void showModal(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.info)),
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Konfirmasi Logout',
                  style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Center(
                child: Text(
                  'Apakah Anda Yakin ?',
                  style: TextStyle(
                    color: const Color(primaryBlack),
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: padding5,
                ),
                InkWell(
                  onTap: () {
                    _logout();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.3,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: const Color(primaryYellow),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(primaryBlack),
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CustomRow extends StatelessWidget {
  final String title;
  final String choosedSetting;

  const CustomRow({Key? key, required this.title, required this.choosedSetting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              title + " : ",
              style: TextStyle(
                fontSize: textSmall,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              choosedSetting,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
