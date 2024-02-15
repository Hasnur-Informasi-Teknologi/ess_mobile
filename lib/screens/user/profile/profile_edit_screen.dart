import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/user/home/home_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditController extends GetxController {
  RxBool infoPribadi = false.obs;
  RxBool infoKeluarga = false.obs;
  RxBool infoFisik = false.obs;
  RxBool infoKepegawaian = false.obs;
  RxBool infoKontrak = false.obs;
  RxBool infoPendidikan = false.obs;
  var message = ''.obs;
  var data = {}.obs;
  var listController = {}.obs;
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
    x.data.value = responseData['data'];
    if (x.data['status_pernikahan'] == 'Single') {
      x.data['status_pernikahan'] = 'Belum Menikah';
    } else if (x.data['status_pernikahan'] == 'Married') {
      x.data['status_pernikahan'] = 'Menikah';
    } else {
      x.data['status_pernikahan'] = 'Belum Menikah';
    }
    for (var key in x.data.keys.toList()) {
      x.listController[key] =
          TextEditingController(text: x.data[key].toString());
    }
    ;
    return responseData;
  }

  Future<void> simpanDataKaryawan() async {
    final String _apiUrl = API_URL;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final user = jsonDecode(userData.toString())['data'];
    String? token = prefs.getString('token');
    var data = {};
    for (var key in x.data.keys.toList()) {
      if (([
        'nomor_ktp',
        'tgl_lahir',
        'kota_tinggal',
        'provinsi_tinggal',
        'kode_pos',
        'kota_surat',
        'kode_pos_surat',
        'no_telp_rmh',
        'no_hp',
        'tanggal_nikah',
        'nama_pasangan',
        'tgl_lhr_pasangan',
        'tinggi_badan',
        'berat_badan',
        'ukuran_baju',
        'ukuran_celana',
        'ukuran_sepatu',
        'alamat_tinggal',
        'alamat_surat',
        'golongan_darah',
        'status_pernikahan',
        'sts_pajak',
        'email',
        'sbu',
        'lokasi',
        'penempatan',
        'akhir_probation',
        'per_area',
        'bank_key',
        'bank_account',
        'npwp',
        'jamsostek',
        'bpjskes',
        'hire_date',
        'awal_kontrak_kerja1',
        'akhir_kontrak_kerja1',
        'awal_kontrak_kerja2',
        'akhir_kontrak_kerja2',
        'jurusan',
        'asal_sekolah',
        'tahun_lulus',
        'hub',
        'nm',
        'jk',
        'tmpt',
        'tgl'
      ].contains(key))) {
        data[key] = x.data[key] ?? '';
      }
      if (([
        'nomor_ktp',
        'tgl_lahir',
        'kota_tinggal',
        'provinsi_tinggal',
        'kode_pos',
        'kota_surat',
        'kode_pos_surat',
        'no_telp_rmh',
        'no_hp',
        'tanggal_nikah',
        'nama_pasangan',
        'tgl_lhr_pasangan',
        'tinggi_badan',
        'berat_badan',
        'ukuran_baju',
        'ukuran_celana',
        'ukuran_sepatu',
        'alamat_tinggal',
        'alamat_surat',
        'golongan_darah',
        'status_pernikahan',
        'sts_pajak',
        'email',
        'sbu',
        'lokasi',
        'penempatan',
        'akhir_probation',
        'per_area',
        'bank_key',
        'bank_account',
        'npwp',
        'jamsostek',
        'bpjskes',
        'hire_date',
        'jurusan',
        'asal_sekolah',
        'tahun_lulus'
      ].contains(key))) {
        if (x.data[key] == '') {
          Get.defaultDialog(
              title: 'Error', content: Text("Field : " + key + " is Required"));
          return;
        }
      }
    }
    ;
    var datanya = jsonEncode(data);
    try {
      final response = await http.post(
          Uri.parse('$_apiUrl/edit_data_karyawan/' + user['pernr']),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + token.toString()
          },
          body: datanya);
      final responseData = jsonDecode(response.body);
      print(responseData);

      final user2 = await http.get(
        Uri.parse('$_apiUrl/get_profile_employee?nrp=' + user['pernr']),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + token.toString()
        },
      );

      final userData = user2.body;
      prefs.setString('userData', userData);
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

  Future _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<bool> uploadImage(imageFile) async {
    final String _apiUrl = API_URL;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final user = jsonDecode(userData.toString())['data'];
    String? token = prefs.getString('token');
    try {
      final request = http.MultipartRequest("POST",
          Uri.parse('$_apiUrl/master/profile/add_photo?nrp=' + user['pernr']));
      final headers = {
        "Content-type": "multipart/form-data",
        'Authorization': "Bearer " + token.toString()
      };

      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath(
        'image', // 'picture' here is the key for the API request
        imageFile.path,
      ));

      final response = await request.send();
      print("CHECK UPLOAD PHOTO");
      print(response);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Image uploaded!');
        x.message.value = "Image Uploaded!";
        return true;
      } else {
        print('Upload failed!');
        x.message.value = "Upload Failed!";
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
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
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text("Edit Profile",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                            () => Text(x.message.toString()),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              elevation: 5,
                              primary: Colors.blue[300],
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () async {
                              x.message.value = '';
                              final imageFile =
                                  await _pickImage(ImageSource.gallery);
                              if (imageFile != null) {
                                uploadImage(imageFile);
                              }
                            },
                            child: Row(children: [Text('Upload Photo ...')]),
                          ),
                        ],
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
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
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
                              title: Column(
                                children: [
                                  CustomRow(
                                    title: "No KTP",
                                    choosedSetting: 'nomor_ktp',
                                    enable: true,
                                  ),
                                  CustomRowDateInput(
                                      title: "Tanggal Lahir",
                                      choosedSetting: "tgl_lahir"),
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
                                      choosedSetting: 'status_pernikahan',
                                      listMap: ['Menikah', 'Belum Menikah']),
                                  CustomRowDateInput(
                                      title: "Tanggal Pernikahan",
                                      choosedSetting: "tanggal_nikah"),
                                  CustomRow(
                                      title: "Nama Pasangan",
                                      choosedSetting: 'nama_pasangan'),
                                  CustomRowDateInput(
                                      title: "Tanggal  Lahir Pasangan",
                                      choosedSetting: "tgl_lhr_pasangan"),
                                ],
                              ),
                            ),
                            isExpanded: x.infoPribadi.value,
                          ),
                        ],
                      ),

                      SizedBox(height: sizedBoxHeightTall),
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
                      SizedBox(height: sizedBoxHeightTall),
                      const Divider(),
                      const TitleWidget(title: 'Data Kepegawaian'),
                      SizedBox(height: sizedBoxHeightShort),
                      // =====================================================================================
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
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
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
                                  CustomRowDateInput(
                                      title: "Akhir Masa Probation",
                                      choosedSetting: "akhir_probation"),
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
                                      title: "NPWP", choosedSetting: 'npwp'),
                                  CustomRow(
                                      title: "BPJS Ketenagakerjaan",
                                      choosedSetting: 'jamsostek'),
                                  CustomRow(
                                      title: "BPJS Kesehatan",
                                      choosedSetting: 'bpjskes'),
                                  CustomRowDateInput(
                                      title: "Tanggal Masuk",
                                      choosedSetting: "awal_kontrak_kerja1"),
                                ],
                              ),
                            ),
                            isExpanded: x.infoKepegawaian.value,
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightShort),
                      // =====================================================================================
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
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
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
                              title: Column(
                                children: [
                                  CustomRowDateInput(
                                      title: "Akhir Masa Kerja",
                                      choosedSetting: "akhir_kontrak_kerja1"),
                                ],
                              ),
                            ),
                            isExpanded: x.infoKontrak.value,
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeightTall),
                      const Divider(),
                      const TitleWidget(title: 'Data Kepegawaian'),
                      SizedBox(height: sizedBoxHeightShort),
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
                              title: Column(
                                children: [
                                  CustomRow(
                                      title: "Jurusan",
                                      choosedSetting: 'jurusan'),
                                  CustomRow(
                                      title: "Asal Pendidikan",
                                      choosedSetting: 'asal_sekolah'),
                                  CustomRowDateInput(
                                      title: "Tahun Lulus",
                                      choosedSetting: "tahun_lulus"),
                                ],
                              ),
                            ),
                            isExpanded: x.infoPendidikan.value,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(''),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.black87,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text('Apakah Simpan data ini ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Get.back(result: false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Accept'),
                                      onPressed: () {
                                        Get.back(result: true);
                                      },
                                    ),
                                  ],
                                ),
                                barrierDismissible: false,
                              ).then((result) {
                                if (result != null && result == true) {
                                  simpanDataKaryawan();
                                  print("User accepted");
                                } else {
                                  print(
                                      "User did not accept or dismissed the dialog");
                                }
                              });
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save_as_rounded),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Ubah Data')
                                ]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                      ),
                      // =====================================================================================
                    ],
                  ),
                )),
          ),
        ));
  }
}

class CustomRow extends StatelessWidget {
  final String title;
  final String choosedSetting;
  final bool isTextFieldEnabled;
  final bool enable;
  final keyboardType;

  const CustomRow(
      {Key? key,
      required this.title,
      required this.choosedSetting,
      this.enable = true,
      this.isTextFieldEnabled = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfileEditController x = Get.put(ProfileEditController());
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Container(
            width: 110,
            child: Text(
              title, // Name
              style: TextStyle(
                fontSize: textSmall,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: TextField(
                enabled: enable,
                keyboardType: keyboardType,
                style: TextStyle(
                  fontSize: textSmall,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
                ),
                controller: x.listController[choosedSetting],
                onChanged: (val) => x.data[choosedSetting] = val,
              ),
              // TextFormField(
              //   enabled: enable,
              //   keyboardType: keyboardType,
              //   style: TextStyle(
              //     fontSize: textMedium,
              //     fontFamily: 'Poppins',
              //     color: Colors.black,
              //   ),
              //   controller: x.listController[choosedSetting],
              //   onChanged: (val) => x.data[choosedSetting] = val,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5),
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //         width: 0,
              //       ),
              //     ),
              //     constraints: BoxConstraints(maxHeight: 40),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5),
              //       borderSide: const BorderSide(color: Colors.black, width: 1),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5),
              //       borderSide: const BorderSide(color: Colors.grey, width: 0),
              //     ),
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRowDateInput extends StatelessWidget {
  final String title;
  final String choosedSetting;
  final bool isTextFieldEnabled;
  final keyboardType;

  const CustomRowDateInput(
      {Key? key,
      required this.title,
      required this.choosedSetting,
      this.isTextFieldEnabled = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfileEditController x = Get.put(ProfileEditController());
    DateRangePickerController _controller = DateRangePickerController();
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              title, // Name
              style: TextStyle(
                fontSize: textSmall,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Obx(() => Expanded(
                child: CupertinoButton(
                  child: Container(
                    // width: 100,
                    padding: EdgeInsets.all(5),
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: paddingHorizontalNarrow,
                    //     vertical: padding5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          x.data[choosedSetting] ?? 'Select Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 350, // Adjust as needed
                            width: 300, // Adjust as needed
                            child: SfDateRangePicker(
                              controller: _controller,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                if (args.value is DateTime) {
                                  x.data[choosedSetting] =
                                      DateFormat('yyyy-MM-dd')
                                          .format(args.value);
                                }
                              },
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )),
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

  const CustomSelectionMenikah(
      {Key? key,
      required this.title,
      required this.choosedSetting,
      this.isTextFieldEnabled = false,
      this.keyboardType = TextInputType.text,
      this.listMap = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProfileEditController x = Get.put(ProfileEditController());
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      child: Row(
        children: [
          Container(
            width: 110,
            child: Text(
              title, // Name
              style: TextStyle(
                fontSize: textSmall,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Obx(() => Expanded(
                child: DropdownButton<String>(
                  value: x.data[choosedSetting],
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    x.data[choosedSetting] = newValue.toString();
                  },
                  items: listMap.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }
}
