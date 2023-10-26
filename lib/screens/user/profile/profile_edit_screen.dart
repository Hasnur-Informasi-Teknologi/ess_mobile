import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditController extends GetxController{
  RxBool infoPribadi = false.obs;
  RxBool infoKeluarga = false.obs;
  RxBool infoFisik = false.obs;
  RxBool infoKepegawaian = false.obs;
  RxBool infoKontrak = false.obs;
  RxBool infoPendidikan = false.obs;
  var data={}.obs;
  var listController={}.obs;
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  ProfileEditController x = Get.put(ProfileEditController());
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = 'Belum Menikah';

  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString());
    x.data.value=responseData['data'];
    if(x.data['status_pernikahan']=='Single'){
      x.data['status_pernikahan']='Belum Menikah';
    }else if(x.data['status_pernikahan']=='Married'){
      x.data['status_pernikahan']='Menikah';
    }
    for (var key in x.data.keys.toList()){
      x.listController[key]=TextEditingController(text: x.data[key].toString());
    };
    return responseData;
  }

Future<void> simpanDataKaryawan() async {
  final String _apiUrl = API_URL;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final user = jsonDecode(userData.toString())['data'];
    String? token = prefs.getString('token');
    var data={};
    for (var key in x.data.keys.toList()){
       if ((['nomor_ktp','tgl_lahir','kota_tinggal','provinsi_tinggal','kode_pos','kota_surat','kode_pos_surat','no_telp_rmh','no_hp','tanggal_nikah','nama_pasangan','tgl_lhr_pasangan','tinggi_badan','berat_badan','ukuran_baju','ukuran_celana','ukuran_sepatu','alamat_tinggal','alamat_surat','golongan_darah','status_pernikahan','sts_pajak','email','sbu','lokasi','penempatan','akhir_probation','per_area','bank_key','bank_account','npwp','jamsostek','bpjskes','hire_date','awal_kontrak_kerja1','akhir_kontrak_kerja1','awal_kontrak_kerja2','akhir_kontrak_kerja2','jurusan','asal_sekolah','tahun_lulus','hub','nm','jk','tmpt','tgl'].contains(key))) {
         data[key]=x.data[key]??'';
        
       }
       if ((['nomor_ktp','tgl_lahir','kota_tinggal','provinsi_tinggal','kode_pos','kota_surat','kode_pos_surat','no_telp_rmh','no_hp','tanggal_nikah','nama_pasangan','tgl_lhr_pasangan','tinggi_badan','berat_badan','ukuran_baju','ukuran_celana','ukuran_sepatu','alamat_tinggal','alamat_surat','golongan_darah','status_pernikahan','sts_pajak','email','sbu','lokasi','penempatan','akhir_probation','per_area','bank_key','bank_account','npwp','jamsostek','bpjskes','hire_date','jurusan','asal_sekolah','tahun_lulus'].contains(key))) {
          if(x.data[key]==''){
            Get.defaultDialog(title: 'Error', content: Text("Field : "+key+" is Required"));
            return;
          }
       }

    };
    var datanya= jsonEncode(data);
    try {
      final response = await http.post(Uri.parse('$_apiUrl/edit_data_karyawan/'+user['pernr']),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':"Bearer "+token.toString()
      },
      body: datanya);
      final responseData = jsonDecode(response.body);
      print(responseData);

      final user2 = await http.get(
        Uri.parse('$_apiUrl/get_profile_employee?nrp='+user['pernr']),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':"Bearer "+token.toString()
        },
      );

      final userData = user2.body;
      print(userData);
      prefs.setString('userData', userData);
      // NAVIGATION ROUTE
      Get.offAllNamed('/user/main');
    } catch (e) {
      print(e);
      throw e;
    }
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
      body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child:Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(child: Text("Edit Profile", style: TextStyle(
                              // color: Colors.yellow,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),),
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
                              title: Column(
                                children: [
                                  CustomRow(
                                      title: "No KTP",
                                      choosedSetting: 'nomor_ktp'),
                                  CustomRow(
                                      title: "Tanggal Lahir",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting: 'tgl_lahir'),
                                  CustomRow(
                                      title: "Alamat",
                                      choosedSetting: 'alamat_tinggal'),
                                  CustomRow(
                                      title: "Kota",
                                      choosedSetting: 'kota_tinggal'),
                                  CustomRow(
                                      title: "Provinsi",
                                      choosedSetting: 'provinsi_tinggal'),
                                  CustomRow(
                                      title: "Kode Pos",
                                      keyboardType: TextInputType.number,
                                      choosedSetting: 'kode_pos'),
                                  CustomRow(
                                      title: "Alamat Surat",
                                      choosedSetting: 'alamat_surat'),
                                  CustomRow(
                                      title: "Kota Surat",
                                      choosedSetting: 'kota_surat'),
                                  CustomRow(
                                      title: "Kode Pos Surat",
                                      keyboardType: TextInputType.number,
                                      choosedSetting: 'kode_pos_surat'),
                                  CustomRow(
                                      title: "No Telepon Rumah",
                                      keyboardType: TextInputType.number,
                                      choosedSetting: 'no_telp_rmh'),
                                  CustomRow(
                                      title: "No HP",
                                      keyboardType: TextInputType.number,
                                      choosedSetting: 'no_hp'),
                                  CustomRow(
                                      title: "Golongan Darah",
                                      choosedSetting: 'golongan_darah'),
                                  CustomRow(
                                      title: "Status Pajak",
                                      choosedSetting: 'sts_pajak'),
                                  CustomSelectionMenikah(
                                      title: "Status Pernikahan",
                                      choosedSetting:
                                          'status_pernikahan',
                                      listMap:['Menikah','Belum Menikah']
                                      ),
                                  CustomRow(
                                      title: "Tanggal Pernikahan",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting: 'tanggal_nikah'),
                                  CustomRow(
                                      title: "Nama Pasangan",
                                      choosedSetting: 'nama_pasangan'),
                                  CustomRow(
                                      title: "Tanggal Lahir Pasangan",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting: 'tgl_lhr_pasangan'),
                                ],
                              ), 
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
                              title: Column(
                                children: [
                                  CustomRow(
                                      title: "Tinggi Badan",
                                      choosedSetting: 'tinggi_badan'),
                                  CustomRow(
                                      title: "Berat Badan",
                                      choosedSetting: 'berat_badan'),
                                  CustomRow(
                                      title: "Ukuran Baju",
                                      choosedSetting: 'ukuran_baju'),
                                  CustomRow(
                                      title: "Ukuran Celana",
                                      choosedSetting: 'ukuran_celana'),
                                  CustomRow(
                                      title: "Ukuran Sepatu",
                                      choosedSetting: 'ukuran_sepatu'),
                                ],
                              ),
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
                              title: Column(
                                children: [
                                  CustomRow(
                                      title: "Email Kantor",
                                      choosedSetting: 'email'),
                                 
                                  CustomRow(
                                      title: "SBU/Direktorat",
                                      choosedSetting: 'sbu'),
                                  CustomRow(
                                      title: "Lokasi",
                                      choosedSetting: 'lokasi'),
                                  CustomRow(
                                      title: "Penempatan",
                                      choosedSetting: 'penempatan'),
                                  CustomRow(
                                      title: "Akhir Masa Probation",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting: 'akhir_probation'),
                                  CustomRow(
                                      title: "Personal Area",
                                      choosedSetting: 'per_area'),
                                  CustomRow(
                                      title: "Bank Key",
                                      choosedSetting: 'bank_key'),
                                  CustomRow(
                                      title: "No Rekening",
                                      choosedSetting: 'bank_account'),
                                  CustomRow(
                                      title: "NPWP",
                                      choosedSetting: 'npwp'),
                                  CustomRow(
                                      title: "BPJS Ketenagakerjaan",
                                      choosedSetting: 'jamsostek'),
                                  CustomRow(
                                      title: "BPJS Kesehatan",
                                      choosedSetting: 'bpjskes'),
                                  CustomRow(
                                      title: "Tanggal Masuk",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting:
                                          'awal_kontrak_kerja1'),
                                ],
                              ),
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
                              title: Column(
                                children: [
                                  CustomRow(
                                      title: "Akhir Masa Kerja",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting:
                                          'akhir_kontrak_kerja1'),
                                ],
                              ),
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
                              title: Column(
                                children: [
                                  CustomRow(
                                      title: "Jurusan",
                                      choosedSetting: 'jurusan'),
                                  CustomRow(
                                      title: "Asal Pendidikan",
                                      choosedSetting: 'asal_sekolah'),
                                  CustomRow(
                                      title: "Tahun Lulus",
                                      keyboardType: TextInputType.datetime,
                                      choosedSetting: 'tahun_lulus'),
                                ],
                              ),
                            ),
                            isExpanded: x.infoPendidikan.value,
                          ),
                        ],
                      ),

                      SizedBox(height: 50,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Flexible(child: 
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              elevation: 5,
                              primary: Color.fromARGB(255, 17, 209, 27),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            onPressed: () {
                              simpanDataKaryawan();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Icon(Icons.save_as_rounded),
                              SizedBox(width: 10,),
                              Text('Simpan')
                            ]),
                          ),
                        ),
                      ],),
                      SizedBox(height: 300,),
                      // =====================================================================================
                    ],
                  ),
                )),
              ),
            )
    );
  }
}

class CustomRow extends StatelessWidget {
  final String title;
  final String choosedSetting;
  final bool isTextFieldEnabled;
  final keyboardType;

  const CustomRow({Key? key, required this.title, required this.choosedSetting, this.isTextFieldEnabled=false, this.keyboardType=TextInputType.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
  ProfileEditController x = Get.put(ProfileEditController());
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
          Obx(() => Expanded(child:   TextField(
            keyboardType:keyboardType,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            controller: x.listController[choosedSetting],
            onChanged: (val)=>x.data[choosedSetting]=val,
          ),)),  
        ],
      ),
    );
  }
}

class CustomSelectionMenikah extends StatelessWidget {
  final String title;
  final String choosedSetting;
  final bool isTextFieldEnabled;
  final keyboardType;
  final listMap;

  const CustomSelectionMenikah({Key? key, required this.title, required this.choosedSetting, this.isTextFieldEnabled=false, this.keyboardType=TextInputType.text, this.listMap=""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
  ProfileEditController x = Get.put(ProfileEditController());
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
          Obx(() => Expanded(child:   DropdownButton<String>(
                  value: x.data[choosedSetting],
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(
                      color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    x.data[choosedSetting] = newValue.toString();
                  },
                  items: listMap.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
          ),)),  
        ],
      ),
    );
  }
}
