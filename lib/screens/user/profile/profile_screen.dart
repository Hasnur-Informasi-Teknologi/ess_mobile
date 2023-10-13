import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _apiUrl = API_URL;

  Future<Map<String, dynamic>> getData() async {
    print("Check data");
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    return responseData;
  }

  bool infoPribadi = false;
  bool infoKeluarga = false;
  bool infoFisik = false;
  bool infoKepegawaian = false;
  bool infoKontrak = false;
  bool infoPendidikan = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 43,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  maxRadius: 40,
                                  backgroundImage: AssetImage(
                                      'assets/images/user-profile-default.png'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ])
                    )
                  )
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                var data = snapshot!.data!['data'];
                return SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 43,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  maxRadius: 40,
                                  backgroundImage: AssetImage(
                                      'assets/images/user-profile-default.png'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                'Data Pribadi',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Add some spacing
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 1,
                            animationDuration: Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                infoPribadi = !infoPribadi;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Informasi Pribadi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
                                    children: [
                                      CustomRow(
                                          title: "NRP",
                                          choosedSetting: data['pernr']),
                                      CustomRow(
                                          title: "Nama",
                                          choosedSetting: data['nama']),
                                      CustomRow(
                                          title: "No KTP",
                                          choosedSetting: data['nomor_ktp']),
                                      CustomRow(
                                          title: "Tanggal Lahir",
                                          choosedSetting: data['tgl_lahir']),
                                      CustomRow(
                                          title: "Usia",
                                          choosedSetting: data['usia']),
                                      CustomRow(
                                          title: "Jenis Kelamin",
                                          choosedSetting:
                                              data['jenis_kelamin']),
                                      CustomRow(
                                          title: "Alamat",
                                          choosedSetting:
                                              data['alamat_tinggal']),
                                      CustomRow(
                                          title: "Kota",
                                          choosedSetting: data['kota_tinggal']),
                                      CustomRow(
                                          title: "Provinsi",
                                          choosedSetting:
                                              data['provinsi_tinggal']),
                                      CustomRow(
                                          title: "Kode Pos",
                                          choosedSetting: data['kode_pos']),
                                      CustomRow(
                                          title: "Alamat Surat",
                                          choosedSetting: data['alamat_surat']),
                                      CustomRow(
                                          title: "Kota Surat",
                                          choosedSetting: data['kota_surat']),
                                      CustomRow(
                                          title: "Kode Pos Surat",
                                          choosedSetting:
                                              data['kode_pos_surat']),
                                      CustomRow(
                                          title: "No Telepon Rumah",
                                          choosedSetting: data['no_telp_rmh']),
                                      CustomRow(
                                          title: "No HP",
                                          choosedSetting: data['no_hp']),
                                      CustomRow(
                                          title: "Golongan Darah",
                                          choosedSetting:
                                              data['golongan_darah']),
                                      CustomRow(
                                          title: "Status Pajak",
                                          choosedSetting: data['sts_pajak']),
                                      CustomRow(
                                          title: "Status Pernikahan",
                                          choosedSetting:
                                              data['status_pernikahan']),
                                      CustomRow(
                                          title: "Tanggal Pernikahan",
                                          choosedSetting:
                                              data['tanggal_nikah']),
                                      CustomRow(
                                          title: "Nama Pasangan",
                                          choosedSetting:
                                              data['nama_pasangan']),
                                      CustomRow(
                                          title: "Tanggal Lahir Pasangan",
                                          choosedSetting:
                                              data['tgl_lhr_pasangan']),
                                    ],
                                  ),
                                ),
                                isExpanded: infoPribadi,
                              ),
                            ],
                          ),

                          SizedBox(height: 10), // Add some spacing
                          // =====================================================================================
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 1,
                            animationDuration: Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                infoKeluarga = !infoKeluarga;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Informasi Keluarga',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
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
                                        height: 10,
                                      ),
                                      CustomRow(
                                          title: "Nama",
                                          choosedSetting: data['ayah_nama']),
                                      CustomRow(
                                          title: "Tanggal Lahir",
                                          choosedSetting:
                                              data['ayah_tgl_lahir']),
                                      CustomRow(
                                          title: "Tempat Lahir",
                                          choosedSetting:
                                              data['ayah_tempat_lahir']),
                                      SizedBox(
                                        height: 10,
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
                                        height: 10,
                                      ),
                                      CustomRow(
                                          title: "Nama",
                                          choosedSetting: data['ibu_nama']),
                                      CustomRow(
                                          title: "Tanggal Lahir",
                                          choosedSetting:
                                              data['ibu_tgl_lahir']),
                                      CustomRow(
                                          title: "Tempat Lahir",
                                          choosedSetting:
                                              data['ibu_tempat_lahir']),
                                    ],
                                  ),
                                ),
                                isExpanded: infoKeluarga,
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Add some spacing
                          // =====================================================================================
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 1,
                            animationDuration: Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                infoFisik = !infoFisik;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Informasi Fisik',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
                                    children: [
                                      CustomRow(
                                          title: "Tinggi Badan",
                                          choosedSetting: data['tinggi_badan']),
                                      CustomRow(
                                          title: "Berat Badan",
                                          choosedSetting: data['berat_badan']),
                                      CustomRow(
                                          title: "Ukuran Baju",
                                          choosedSetting: data['ukuran_baju']),
                                      CustomRow(
                                          title: "Ukuran Celana",
                                          choosedSetting:
                                              data['ukuran_celana']),
                                      CustomRow(
                                          title: "Ukuran Sepatu",
                                          choosedSetting:
                                              data['ukuran_sepatu']),
                                    ],
                                  ),
                                ),
                                isExpanded: infoFisik,
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Add some spacing
                          Row(
                            children: [
                              Text(
                                'Data Kepegawaian',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Add some spacing
                          // =====================================================================================
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 1,
                            animationDuration: Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                infoKepegawaian = !infoKepegawaian;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Informasi Kepegawaian',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
                                    children: [
                                      CustomRow(
                                          title: "Email Kantor",
                                          choosedSetting: data['email']),
                                      CustomRow(
                                          title: "Email Pribadi",
                                          choosedSetting:
                                              data['email_pribadi']),
                                      CustomRow(
                                          title: "Perusahaan",
                                          choosedSetting: data['pt']),
                                      CustomRow(
                                          title: "SBU/Direktorat",
                                          choosedSetting: data['sbu']),
                                      CustomRow(
                                          title: "Posisi",
                                          choosedSetting: data['position']),
                                      CustomRow(
                                          title: "Lokasi",
                                          choosedSetting: data['lokasi']),
                                      CustomRow(
                                          title: "Penempatan",
                                          choosedSetting: data['penempatan']),
                                      CustomRow(
                                          title: "Status Karyawan",
                                          choosedSetting:
                                              data['status_karyawan']),
                                      CustomRow(
                                          title: "Akhir Masa Probation",
                                          choosedSetting:
                                              data['akhir_probation']),
                                      CustomRow(
                                          title: "Personal Area",
                                          choosedSetting: data['per_area']),
                                      CustomRow(
                                          title: "Pangkat",
                                          choosedSetting: data['pangkat']),
                                      CustomRow(
                                          title: "Bank Key",
                                          choosedSetting: data['bank_key']),
                                      CustomRow(
                                          title: "No Rekening",
                                          choosedSetting: data['bank_account']),
                                      CustomRow(
                                          title: "NPWP",
                                          choosedSetting: data['npwp']),
                                      CustomRow(
                                          title: "BPJS Ketenagakerjaan",
                                          choosedSetting: data['jamsostek']),
                                      CustomRow(
                                          title: "BPJS Kesehatan",
                                          choosedSetting: data['bpjskes']),
                                      CustomRow(
                                          title: "Tanggal Masuk",
                                          choosedSetting:
                                              data['awal_kontrak_kerja1']),
                                      CustomRow(
                                          title: "Masa Kerja",
                                          choosedSetting: data['masa_kerja']),
                                    ],
                                  ),
                                ),
                                isExpanded: infoKepegawaian,
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Add some spacing
                          // =====================================================================================
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 1,
                            animationDuration: Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                infoKontrak = !infoKontrak;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Informasi Kontrak',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
                                    children: [
                                      CustomRow(
                                          title: "Kontrak Ke",
                                          choosedSetting: "I"),
                                      CustomRow(
                                          title: "Akhir Masa Kerja",
                                          choosedSetting:
                                              data['akhir_kontrak_kerja1']),
                                    ],
                                  ),
                                ),
                                isExpanded: infoKontrak,
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Add some spacing
                          Row(
                            children: [
                              Text(
                                'Data Kepegawaian',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Add some spacing
                          // =====================================================================================
                          ExpansionPanelList(
                            expandedHeaderPadding: EdgeInsets.zero,
                            elevation: 1,
                            animationDuration: Duration(milliseconds: 500),
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                infoPendidikan = !infoPendidikan;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Informasi Pendidikan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  );
                                },
                                body: ListTile(
                                  title: Column(
                                    children: [
                                      CustomRow(
                                          title: "Pendidikan Terakhir",
                                          choosedSetting: data['pendidikan']),
                                      CustomRow(
                                          title: "Jurusan",
                                          choosedSetting: data['jurusan']),
                                      CustomRow(
                                          title: "Asal Pendidikan",
                                          choosedSetting: data['asal_sekolah']),
                                      CustomRow(
                                          title: "Tahun Lulus",
                                          choosedSetting: data['tahun_lulus']),
                                    ],
                                  ),
                                ),
                                isExpanded: infoPendidikan,
                              ),
                            ],
                          ),
                          // =====================================================================================
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}

class CustomRow extends StatelessWidget {
  final String title;
  final String choosedSetting;

  const CustomRow({Key? key, required this.title, required this.choosedSetting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              title + " : ", // Name
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              choosedSetting, // Name
              style: const TextStyle(
                fontSize: 12,
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
