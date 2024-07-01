import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_ess/helpers/http_override.dart';
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
  Uint8List? _imageBytes;

  bool _isLoading = false;

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
    _fetchImage();
  }

  // Non Crop
  // Future _pickImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     return File(pickedFile.path);
  //   }
  //   return null;
  // }

  // Crop
  Future<XFile?> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    return await _picker.pickImage(source: source);
  }

  Future<File?> _cropImage(String sourcePath) async {
    final ImageCropper _cropper = ImageCropper();
    final croppedFile = await _cropper.cropImage(
      sourcePath: sourcePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }

  Future<bool> uploadImage(imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final user = jsonDecode(userData.toString())['data'];
    String nrp = user['pernr'];
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });
    try {
      final request = http.MultipartRequest(
          "POST", Uri.parse('$_apiUrl/master/profile/add_photo?nrp=$nrp'));
      final headers = {
        "Content-type": "multipart/form-data",
        'Authorization': "Bearer $token"
      };

      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

      final response = await request.send();
      String responseBody = await response.stream.bytesToString();
      var responseData = json.decode(responseBody);
      String message = responseData['message'];
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Infomation', message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        Get.offAllNamed('/user/main');
        return true;
      } else {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Infomation', message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        Get.offAllNamed('/user/main');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> _fetchImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final ioClient = createIOClientWithInsecureConnection();
    final response = await ioClient.get(
      Uri.parse('$_apiUrl/master/profile/get_photo'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _imageBytes = response.bodyBytes;
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (key != 'permission') {
        prefs.remove(key);
      }
    }

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

    ImageProvider<Object>? imageProvider;

    if (_imageBytes == null) {
      imageProvider =
          const AssetImage('assets/images/user-profile-default.png');
    } else {
      imageProvider = MemoryImage(_imageBytes!);
    }

    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
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
                            child: Stack(children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 53,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[100],
                                  maxRadius: 50,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              Positioned(
                                bottom: -5,
                                left: 75,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit_document,
                                    // color: Colors.green,
                                  ),
                                  onPressed: () {
                                    // Get.toNamed('/user/profile/edit');
                                    showUpdatePhotoModal(context);
                                  },
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      const TitleWidget(title: 'Data Pribadi'),
                      SizedBox(height: sizedBoxHeightShort),
                      informasiPribadiWidget(context),
                      SizedBox(height: sizedBoxHeightTall),
                      informasiKeluargaWidget(context),
                      SizedBox(height: sizedBoxHeightShort),
                      informasiFisikWidget(context),
                      SizedBox(height: sizedBoxHeightTall),
                      const Divider(),
                      const TitleWidget(title: 'Data Kepegawaian'),
                      SizedBox(height: sizedBoxHeightShort),
                      informasiKepegawaianWidget(context),
                      SizedBox(height: sizedBoxHeightShort),
                      informasiKontrakWidget(context),
                      SizedBox(height: sizedBoxHeightTall),
                      const Divider(),
                      const TitleWidget(title: 'Data Kepegawaian'),
                      SizedBox(height: sizedBoxHeightShort),
                      informasiPendidikanWidget(context),
                      SizedBox(
                        height: sizedBoxHeightExtraTall,
                      ),
                      editAndLogoutButton(context),
                      const SizedBox(
                        height: 300,
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void showUpdatePhotoModal(BuildContext context) {
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
              SizedBox(
                height: sizedBoxHeightTall,
              ),
              Center(
                child: Text(
                  'Change profile photo',
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
            ],
          ),
          actions: [
            Column(
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    // Crop
                    final imageFile = await _pickImage(ImageSource.gallery);
                    if (imageFile != null) {
                      final croppedFile = await _cropImage(imageFile.path);
                      if (croppedFile != null) {
                        await uploadImage(File(croppedFile.path));
                      }
                    }
                    // Non Crop
                    //   final imageFile = await _pickImage(ImageSource.gallery);
                    //   if (imageFile != null) {
                    //     uploadImage(imageFile);
                    //   }
                  },
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.04,
                    padding: EdgeInsets.all(padding5),
                    decoration: BoxDecoration(
                      color: const Color(primaryYellow),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Upload Photo',
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
                  height: padding5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.9,
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
              ],
            ),
          ],
        );
      },
    );
  }

  Widget informasiPribadiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return InkWell(
      onTap: () {
        setState(() {
          x.infoPribadi.value = !x.infoPribadi.value;
        });
      },
      child: ExpansionPanelList(
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
                      fontWeight: FontWeight.w600, fontSize: textMedium),
                ),
              );
            },
            body: ListTile(
              title: Obx(() => Column(
                    children: [
                      CustomRow(
                          title: "NRP", choosedSetting: x.data['pernr'] ?? ''),
                      CustomRow(
                          title: "Nama", choosedSetting: x.data['nama'] ?? ''),
                      CustomRow(
                          title: "No KTP",
                          choosedSetting: x.data['nomor_ktp'] ?? ''),
                      CustomRow(
                          title: "Tanggal Lahir",
                          choosedSetting: x.data['tgl_lahir'] ?? ''),
                      CustomRow(
                          title: "Usia", choosedSetting: x.data['usia'] ?? ''),
                      CustomRow(
                          title: "Jenis Kelamin",
                          choosedSetting: x.data['jenis_kelamin'] ?? ''),
                      CustomRow(
                          title: "Alamat",
                          choosedSetting: x.data['alamat_tinggal'] ?? ''),
                      CustomRow(
                          title: "Kota",
                          choosedSetting: x.data['kota_tinggal'] ?? ''),
                      CustomRow(
                          title: "Provinsi",
                          choosedSetting: x.data['provinsi_tinggal'] ?? ''),
                      CustomRow(
                          title: "Kode Pos",
                          choosedSetting: x.data['kode_pos'] ?? ''),
                      CustomRow(
                          title: "Alamat Surat",
                          choosedSetting: x.data['alamat_surat'] ?? ''),
                      CustomRow(
                          title: "Kota Surat",
                          choosedSetting: x.data['kota_surat'] ?? ''),
                      CustomRow(
                          title: "Kode Pos Surat",
                          choosedSetting: x.data['kode_pos_surat'] ?? ''),
                      CustomRow(
                          title: "No Telepon Rumah",
                          choosedSetting: x.data['no_telp_rmh'] ?? ''),
                      CustomRow(
                          title: "No HP",
                          choosedSetting: x.data['no_hp'] ?? ''),
                      CustomRow(
                          title: "Golongan Darah",
                          choosedSetting: x.data['golongan_darah'] ?? ''),
                      CustomRow(
                          title: "Status Pajak",
                          choosedSetting: x.data['sts_pajak'] ?? ''),
                      CustomRow(
                          title: "Status Pernikahan",
                          choosedSetting: x.data['status_pernikahan'] ?? ''),
                      CustomRow(
                          title: "Tanggal Pernikahan",
                          choosedSetting: x.data['tanggal_nikah'] ?? ''),
                      CustomRow(
                          title: "Nama Pasangan",
                          choosedSetting: x.data['nama_pasangan'] ?? ''),
                      CustomRow(
                          title: "Tanggal Lahir Pasangan",
                          choosedSetting: x.data['tgl_lhr_pasangan'] ?? ''),
                    ],
                  )),
            ),
            isExpanded: x.infoPribadi.value,
          ),
        ],
      ),
    );
  }

  Widget informasiKeluargaWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightShort = size.height * 0.0086;

    return InkWell(
      onTap: () {
        setState(() {
          x.infoKeluarga.value = !x.infoKeluarga.value;
        });
      },
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 1,
        animationDuration: const Duration(milliseconds: 500),
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
                      fontWeight: FontWeight.w600, fontSize: textMedium),
                ),
              );
            },
            body: ListTile(
              title: Obx(() => Column(
                    children: [
                      const Row(
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
                          choosedSetting: x.data['ayah_nama'] ?? ''),
                      CustomRow(
                          title: "Tanggal Lahir",
                          choosedSetting: x.data['ayah_tgl_lahir'] ?? ''),
                      CustomRow(
                          title: "Tempat Lahir",
                          choosedSetting: x.data['ayah_tempat_lahir'] ?? ''),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      const Row(
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
                          choosedSetting: x.data['ibu_tgl_lahir'] ?? ''),
                      CustomRow(
                          title: "Tempat Lahir",
                          choosedSetting: x.data['ibu_tempat_lahir'] ?? ''),
                    ],
                  )),
            ),
            isExpanded: x.infoKeluarga.value,
          ),
        ],
      ),
    );
  }

  Widget informasiFisikWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return InkWell(
      onTap: () {
        setState(() {
          x.infoFisik.value = !x.infoFisik.value;
        });
      },
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 1,
        animationDuration: const Duration(milliseconds: 500),
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
                      fontWeight: FontWeight.w600, fontSize: textMedium),
                ),
              );
            },
            body: ListTile(
              title: Obx(() => Column(
                    children: [
                      CustomRow(
                          title: "Tinggi Badan",
                          choosedSetting: x.data['tinggi_badan'] ?? ''),
                      CustomRow(
                          title: "Berat Badan",
                          choosedSetting: x.data['berat_badan'] ?? ''),
                      CustomRow(
                          title: "Ukuran Baju",
                          choosedSetting: x.data['ukuran_baju'] ?? ''),
                      CustomRow(
                          title: "Ukuran Celana",
                          choosedSetting: x.data['ukuran_celana'] ?? ''),
                      CustomRow(
                          title: "Ukuran Sepatu",
                          choosedSetting: x.data['ukuran_sepatu'] ?? ''),
                    ],
                  )),
            ),
            isExpanded: x.infoFisik.value,
          ),
        ],
      ),
    );
  }

  Widget informasiKepegawaianWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return InkWell(
      onTap: () {
        setState(() {
          x.infoKepegawaian.value = !x.infoKepegawaian.value;
        });
      },
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 1,
        animationDuration: const Duration(milliseconds: 500),
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
                      fontWeight: FontWeight.w600, fontSize: textMedium),
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
                          choosedSetting: x.data['email_pribadi'] ?? ''),
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
                          choosedSetting: x.data['penempatan'] ?? ''),
                      CustomRow(
                          title: "Status Karyawan",
                          choosedSetting: x.data['status_karyawan'] ?? ''),
                      CustomRow(
                          title: "Akhir Masa Probation",
                          choosedSetting: x.data['akhir_probation'] ?? ''),
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
                          choosedSetting: x.data['bank_account'] ?? ''),
                      CustomRow(
                          title: "NPWP", choosedSetting: x.data['npwp'] ?? ''),
                      CustomRow(
                          title: "BPJS Ketenagakerjaan",
                          choosedSetting: x.data['jamsostek'] ?? ''),
                      CustomRow(
                          title: "BPJS Kesehatan",
                          choosedSetting: x.data['bpjskes'] ?? ''),
                      CustomRow(
                          title: "Tanggal Masuk",
                          choosedSetting: x.data['awal_kontrak_kerja1'] ?? ''),
                      CustomRow(
                          title: "Masa Kerja",
                          choosedSetting: x.data['masa_kerja'] ?? ''),
                    ],
                  )),
            ),
            isExpanded: x.infoKepegawaian.value,
          ),
        ],
      ),
    );
  }

  Widget informasiKontrakWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return InkWell(
      onTap: () {
        setState(() {
          x.infoKontrak.value = !x.infoKontrak.value;
        });
      },
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 1,
        animationDuration: const Duration(milliseconds: 500),
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
                      fontWeight: FontWeight.w600, fontSize: textMedium),
                ),
              );
            },
            body: ListTile(
              title: Obx(() => Column(
                    children: [
                      const CustomRow(title: "Kontrak Ke", choosedSetting: "I"),
                      CustomRow(
                          title: "Akhir Masa Kerja",
                          choosedSetting: x.data['akhir_kontrak_kerja1'] ?? ''),
                    ],
                  )),
            ),
            isExpanded: x.infoKontrak.value,
          ),
        ],
      ),
    );
  }

  Widget informasiPendidikanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;

    return InkWell(
      onTap: () {
        setState(() {
          x.infoPendidikan.value = !x.infoPendidikan.value;
        });
      },
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 1,
        animationDuration: const Duration(milliseconds: 500),
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
                      fontWeight: FontWeight.w600, fontSize: textMedium),
                ),
              );
            },
            body: ListTile(
              title: Obx(() => Column(
                    children: [
                      CustomRow(
                          title: "Pendidikan Terakhir",
                          choosedSetting: x.data['pendidikan'] ?? ''),
                      CustomRow(
                          title: "Jurusan",
                          choosedSetting: x.data['jurusan'] ?? ''),
                      CustomRow(
                          title: "Asal Pendidikan",
                          choosedSetting: x.data['asal_sekolah'] ?? ''),
                      CustomRow(
                          title: "Tahun Lulus",
                          choosedSetting: x.data['tahun_lulus'] ?? ''),
                    ],
                  )),
            ),
            isExpanded: x.infoPendidikan.value,
          ),
        ],
      ),
    );
  }

  Widget editAndLogoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Flexible(
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       onPrimary: Colors.black87,
        //       elevation: 5,
        //       primary: Color.fromARGB(255, 17, 209, 27),
        //       padding: const EdgeInsets.symmetric(horizontal: 16),
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(8)),
        //       ),
        //     ),
        //     onPressed: () {
        //       Get.toNamed('/user/profile/edit');
        //     },
        //     child: const Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [Icon(Icons.edit), Text('Edit Profile')]),
        //   ),
        // ),
        // const SizedBox(
        //   width: 30,
        // ),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              elevation: 5,
              primary: Color.fromARGB(255, 230, 24, 72),
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onPressed: () {
              showModal(context);
            },
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.logout), Text('Logout')]),
          ),
        ),
      ],
    );
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
