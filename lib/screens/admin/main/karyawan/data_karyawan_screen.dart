import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KaryawanDataController extends GetxController{
  RxBool infoPribadi = false.obs;
  RxBool infoKeluarga = false.obs;
  RxBool infoFisik = false.obs;
  RxBool infoKepegawaian = false.obs;
  RxBool infoKontrak = false.obs;
  RxBool infoPendidikan = false.obs;
  var data={}.obs;
}

class KaryawanDataScreen extends StatefulWidget {
   final String? nrp,nama;

  const KaryawanDataScreen({ 
    super.key,
    this.nrp,
    this.nama,
    });

  @override
  State<KaryawanDataScreen> createState() => _KaryawanDataScreenState();
}

class _KaryawanDataScreenState extends State<KaryawanDataScreen> {
  final String _apiUrl = API_URL;
  KaryawanDataController x = Get.put(KaryawanDataController());

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final user = await http.get(
        Uri.parse('$_apiUrl/get_detail_data_karyawan/${widget.nrp.toString()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':"Bearer "+token.toString()
        },
      );
    final responseData = jsonDecode(user.body.toString());
    x.data.value = responseData['data'];
    return responseData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title:Text(widget.nama.toString()),
      backgroundColor: Colors.white,),
      body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onDoubleTap: (){
                        },
                        child: Container(
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
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Data Pribadi',
                            style: TextStyle(
                              fontSize: 16,
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
                            x.infoPribadi.value = !x.infoPribadi.value;
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
                              title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "NRP",
                                      choosedSetting: x.data['pernr'].toString()??''),
                                  CustomRow(
                                      title: "Nama",
                                      choosedSetting: x.data['nama']??''),
                                  CustomRow(
                                      title: "No KTP",
                                      choosedSetting: x.data['nomor_ktp']??''),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      choosedSetting: x.data['tgl_lahir']??''),
                                  CustomRow(
                                      title: "Usia",
                                      choosedSetting: x.data['usia']??''),
                                  CustomRow(
                                      title: "Jenis Kelamin",
                                      choosedSetting: x.data['jenis_kelamin']??''),
                                  CustomRow(
                                      title: "Alamat",
                                      choosedSetting: x.data['alamat_tinggal']??''),
                                  CustomRow(
                                      title: "Kota",
                                      choosedSetting: x.data['kota_tinggal']??''),
                                  CustomRow(
                                      title: "Provinsi",
                                      choosedSetting: x.data['provinsi_tinggal']??''),
                                  CustomRow(
                                      title: "Kode Pos",
                                      choosedSetting: x.data['kode_pos']??''),
                                  CustomRow(
                                      title: "Alamat Surat",
                                      choosedSetting: x.data['alamat_surat']??''),
                                  CustomRow(
                                      title: "Kota Surat",
                                      choosedSetting: x.data['kota_surat']??''),
                                  CustomRow(
                                      title: "Kode Pos Surat",
                                      choosedSetting: x.data['kode_pos_surat']??''),
                                  CustomRow(
                                      title: "No Telepon Rumah",
                                      choosedSetting: x.data['no_telp_rmh']??''),
                                  CustomRow(
                                      title: "No HP",
                                      choosedSetting: x.data['no_hp']??''),
                                  CustomRow(
                                      title: "Golongan Darah",
                                      choosedSetting: x.data['golongan_darah']??''),
                                  CustomRow(
                                      title: "Status Pajak",
                                      choosedSetting: x.data['sts_pajak']??''),
                                  CustomRow(
                                      title: "Status Pernikahan",
                                      choosedSetting:
                                          x.data['status_pernikahan']??''),
                                  CustomRow(
                                      title: "Tanggal Pernikahan",
                                      choosedSetting: x.data['tanggal_nikah']??''),
                                  CustomRow(
                                      title: "Nama Pasangan",
                                      choosedSetting: x.data['nama_pasangan']??''),
                                  CustomRow(
                                      title: "Tanggal Lahir Pasangan",
                                      choosedSetting: x.data['tgl_lhr_pasangan']??''),
                                ],
                              )), 
                            ),
                            isExpanded: x.infoPribadi.value,
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
                            x.infoKeluarga.value = !x.infoKeluarga.value;
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
                                    height: 10,
                                  ),
                                  CustomRow(
                                      title: "Nama",
                                      choosedSetting: x.data['ayah_nama']??''),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      choosedSetting: x.data['ayah_tgl_lahir']??''),
                                  CustomRow(
                                      title: "Tempat Lahir",
                                      choosedSetting:
                                          x.data['ayah_tempat_lahir']??''),
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
                                      choosedSetting: x.data['ibu_nama']??''),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      choosedSetting: x.data['ibu_tgl_lahir']??''),
                                  CustomRow(
                                      title: "Tempat Lahir",
                                      choosedSetting: x.data['ibu_tempat_lahir']??''),
                                ],
                              )),
                            ),
                            isExpanded: x.infoKeluarga.value,
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
                            x.infoFisik.value = !x.infoFisik.value;
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
                              title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Tinggi Badan",
                                      choosedSetting: x.data['tinggi_badan']??''),
                                  CustomRow(
                                      title: "Berat Badan",
                                      choosedSetting: x.data['berat_badan']??''),
                                  CustomRow(
                                      title: "Ukuran Baju",
                                      choosedSetting: x.data['ukuran_baju']??''),
                                  CustomRow(
                                      title: "Ukuran Celana",
                                      choosedSetting: x.data['ukuran_celana']??''),
                                  CustomRow(
                                      title: "Ukuran Sepatu",
                                      choosedSetting: x.data['ukuran_sepatu']??''),
                                ],
                              )),
                            ),
                            isExpanded: x.infoFisik.value,
                          ),
                        ],
                      ),
                      SizedBox(height: 20), // Add some spacing
                      Row(
                        children: [
                          Text(
                            'Data Kepegawaian',
                            style: TextStyle(
                              fontSize: 16,
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
                            x.infoKepegawaian.value= !x.infoKepegawaian.value;
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
                              title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Email Kantor",
                                      choosedSetting: x.data['email']??''),
                                  CustomRow(
                                      title: "Email Pribadi",
                                      choosedSetting: x.data['email_pribadi']??''),
                                  CustomRow(
                                      title: "Perusahaan",
                                      choosedSetting: x.data['pt']??''),
                                  CustomRow(
                                      title: "SBU/Direktorat",
                                      choosedSetting: x.data['sbu']??''),
                                  CustomRow(
                                      title: "Posisi",
                                      choosedSetting: x.data['position']??''),
                                  CustomRow(
                                      title: "Lokasi",
                                      choosedSetting: x.data['lokasi']??''),
                                  CustomRow(
                                      title: "Penempatan",
                                      choosedSetting: x.data['penempatan']??''),
                                  CustomRow(
                                      title: "Status Karyawan",
                                      choosedSetting: x.data['status_karyawan']??''),
                                  CustomRow(
                                      title: "Akhir Masa Probation",
                                      choosedSetting: x.data['akhir_probation']??''),
                                  CustomRow(
                                      title: "Personal Area",
                                      choosedSetting: x.data['per_area']??''),
                                  CustomRow(
                                      title: "Pangkat",
                                      choosedSetting: x.data['pangkat']??''),
                                  CustomRow(
                                      title: "Bank Key",
                                      choosedSetting: x.data['bank_key']??''),
                                  CustomRow(
                                      title: "No Rekening",
                                      choosedSetting: x.data['bank_account']??''),
                                  CustomRow(
                                      title: "NPWP",
                                      choosedSetting: x.data['npwp']??''),
                                  CustomRow(
                                      title: "BPJS Ketenagakerjaan",
                                      choosedSetting: x.data['jamsostek']??''),
                                  CustomRow(
                                      title: "BPJS Kesehatan",
                                      choosedSetting: x.data['bpjskes']??''),
                                  CustomRow(
                                      title: "Tanggal Masuk",
                                      choosedSetting:
                                          x.data['awal_kontrak_kerja1']??''),
                                  CustomRow(
                                      title: "Masa Kerja",
                                      choosedSetting: x.data['masa_kerja']??''),
                                ],
                              )),
                            ),
                            isExpanded: x.infoKepegawaian.value,
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
                            x.infoKontrak.value= !x.infoKontrak.value;
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
                              title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Kontrak Ke", choosedSetting: "I"),
                                  CustomRow(
                                      title: "Akhir Masa Kerja",
                                      choosedSetting:
                                          x.data['akhir_kontrak_kerja1']??''),
                                ],
                              )),
                            ),
                            isExpanded: x.infoKontrak.value,
                          ),
                        ],
                      ),
                      SizedBox(height: 20), // Add some spacing
                      Row(
                        children: [
                          Text(
                            'Data Kepegawaian',
                            style: TextStyle(
                              fontSize: 16,
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
                            x.infoPendidikan.value = !x.infoPendidikan.value;
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
                              title: Obx(() => Column(
                                children: [
                                  CustomRow(
                                      title: "Pendidikan Terakhir",
                                      choosedSetting: x.data['pendidikan']??''),
                                  CustomRow(
                                      title: "Jurusan",
                                      choosedSetting: x.data['jurusan']??''),
                                  CustomRow(
                                      title: "Asal Pendidikan",
                                      choosedSetting: x.data['asal_sekolah']??''),
                                  CustomRow(
                                      title: "Tahun Lulus",
                                      choosedSetting: x.data['tahun_lulus']??''),
                                ],
                              )),
                            ),
                            isExpanded: x.infoPendidikan.value,
                          ),
                        ],
                      ),

                      SizedBox(height: 300,),
                      // =====================================================================================
                    ],
                  ),
                ),
              ),
            )
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
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              title + " : ", // Name
              style: const TextStyle(
                fontSize: 11,
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
