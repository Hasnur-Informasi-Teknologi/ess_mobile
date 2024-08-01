import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_dropdown_with_two_title_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/build_text_field_widget.dart';
import 'package:mobile_ess/widgets/higher_custom_widget/custom_tabbar.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormAplikasiRecruitmentScreen extends StatefulWidget {
  const FormAplikasiRecruitmentScreen({super.key});

  @override
  State<FormAplikasiRecruitmentScreen> createState() =>
      _FormAplikasiRecruitmentScreenState();
}

class _FormAplikasiRecruitmentScreenState
    extends State<FormAplikasiRecruitmentScreen> {
  final String _apiUrl = API_URL;
  bool? _isTinggiChecked = false;
  bool? _isNormalChecked = false;
  bool? _isRendahChecked = false;

  List<Map<String, dynamic>> masterDataJurusan = [];
  Map<int, bool> selectedItems = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateRangePickerController _tanggalPengajuanController =
      DateRangePickerController();
  DateTime? tanggalPengajuan;

  // Pengajuan
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _entitasController = TextEditingController();
  // Permintaan Rekrutmen Karyawan
  final TextEditingController _jabatanRekrutmenKaryawanController =
      TextEditingController();
  final TextEditingController _estimasiMulaiBekerjaController =
      TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final DateRangePickerController _tanggalKembaliKerjaController =
      DateRangePickerController();
  DateTime? tanggalKembaliKerja;
  // Kualifikasi
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _sertifikasiController = TextEditingController();
  final TextEditingController _ipkController = TextEditingController();
  final TextEditingController _usiaAwalController = TextEditingController();
  final TextEditingController _usiaAkhirController = TextEditingController();
  final TextEditingController _pengalamanKerjaController =
      TextEditingController();
  final TextEditingController _softSkillController = TextEditingController();
  final TextEditingController _hardSkillController = TextEditingController();
  // Uraian Jabatan
  final TextEditingController _tanggungJawabController =
      TextEditingController();
  final TextEditingController _namaDiUraianJabatanController =
      TextEditingController();
  final TextEditingController _jabatanDiUraianJabatanController =
      TextEditingController();
  final TextEditingController _entitasDiUraianJabatanController =
      TextEditingController();
  bool? _isNew = false;
  bool? _isOld = false;

  String? selectedValueEntitasAtasanLangsung,
      selectedValueAtasanLangsung,
      selectedValueEntitas,
      selectedValueDepartemen,
      selectedValueLokasiKerja,
      selectedValuePangkatAwal,
      selectedValuePangkatAkhir,
      selectedValuePendidikanAwal,
      selectedValuePendidikanAkhir,
      selectedValueJenisKelamin,
      selectedValueNrpDiUraianJabatan,
      selectedValueStatusKaryawan,
      selectedValueEntitasDirekturHcgs,
      selectedValueDirekturHcgs,
      selectedValueEntitasDirekturKeuangan,
      selectedValueDirekturKeuangan,
      selectedValueEntitasPresidenDirektur,
      selectedValuePresidenDirektur,
      cocd;

  List<Map<String, dynamic>> selectedEntitasAtasanLangsung = [];
  List<Map<String, dynamic>> selectedAtasanLangsung = [];
  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedDepartemen = [];
  List<Map<String, dynamic>> selectedLokasiKerja = [];
  List<Map<String, dynamic>> selectedPangkatAwal = [];
  List<Map<String, dynamic>> selectedPangkatAkhir = [];
  List<Map<String, dynamic>> selectedPendidikanAwal = [
    {'pendidikan': 'SD'},
    {'pendidikan': 'SMP'},
    {'pendidikan': 'SMA/SMK'},
    {'pendidikan': 'Paket B'},
    {'pendidikan': 'Paket C'},
    {'pendidikan': 'D1'},
    {'pendidikan': 'D2'},
    {'pendidikan': 'D3'},
    {'pendidikan': 'D4'},
    {'pendidikan': 'S1'},
    {'pendidikan': 'S2'},
    {'pendidikan': 'S3'}
  ];
  List<Map<String, dynamic>> selectedPendidikanAkhir = [
    {'pendidikan': 'SD'},
    {'pendidikan': 'SMP'},
    {'pendidikan': 'SMA/SMK'},
    {'pendidikan': 'Paket B'},
    {'pendidikan': 'Paket C'},
    {'pendidikan': 'D1'},
    {'pendidikan': 'D2'},
    {'pendidikan': 'D3'},
    {'pendidikan': 'D4'},
    {'pendidikan': 'S1'},
    {'pendidikan': 'S2'},
    {'pendidikan': 'S3'}
  ];
  List<Map<String, dynamic>> selectedJenisKelamin = [
    {'jenis': 'Laki-Laki'},
    {'jenis': 'Perempuan'}
  ];
  List<Map<String, dynamic>> selectedNrpDiUraianJabatan = [];
  List<Map<String, dynamic>> selectedStatusKaryawan = [
    {'status': 'Permanen'},
    {'status': 'Kontrak'},
    {'status': 'KHL'},
    {'status': 'KHT'},
    {'status': 'PB'},
    {'status': 'Magang'},
    {'status': 'Outsourcing'},
  ];
  List<Map<String, dynamic>> selectedEntitasDirekturHcgs = [];
  List<Map<String, dynamic>> selectedDirekturHcgs = [];
  List<Map<String, dynamic>> selectedEntitasDirekturKeuangan = [];
  List<Map<String, dynamic>> selectedDirekturKeuangan = [];
  List<Map<String, dynamic>> selectedEntitasPresidenDirektur = [];
  List<Map<String, dynamic>> selectedPresidenDirektur = [];

  final double _maxHeightNomor = 40.0;
  // Permintaan Rekrutmen Karyawan
  final double _maxHeightEntitasAtasanLangsung = 60.0;
  final double _maxHeightAtasanLangsung = 60.0;
  final double _maxHeightEntitas = 60.0;
  final double _maxHeightDepartement = 60.0;
  final double _maxHeightLokasiKerja = 60.0;
  final double _maxHeightPangkatAwal = 60.0;
  final double _maxHeightPangkatAkhir = 60.0;
  final double _maxHeightJabatanRekrutmenKaryawan = 50.0;
  final double _maxHeightQty = 50.0;
  final double _maxHeightCatatan = 80.0;
  // Kualifikasi
  final double _maxHeightPendidikanAwal = 60.0;
  final double _maxHeightPendidikanAkhir = 60.0;
  final double _maxHeightJurusan = 50.0;
  final double _maxHeightSertifikasi = 50.0;
  final double _maxHeightIpk = 50.0;
  final double _maxHeightJenisKelamin = 60.0;
  final double _maxHeightUsiaAwal = 50.0;
  final double _maxHeightUsiaAkhir = 50.0;
  final double _maxHeightPengalamanKerja = 80.0;
  final double _maxHeightSoftSkill = 50.0;
  final double _maxHeightHardSkill = 50.0;
  // Uraian Jabatan
  final double _maxHeightTanggungJawab = 80.0;
  final double _maxHeightStatusKaryawan = 60.0;
  final double _maxHeightNrpDiUraianJabatan = 60.0;
  final double _maxHeightNamaDiUraianJabatan = 50.0;
  final double _maxHeightJabatanDiUraianJabatan = 50.0;
  final double _maxHeightEntitasDiUraianJabatan = 50.0;
  // Approval
  final double _maxHeightEntitasDirekturHcgs = 60.0;
  final double _maxHeightDirekturHcgs = 60.0;
  final double _maxHeightEntitasDirekturKeuangan = 60.0;
  final double _maxHeightDirekturKeuangan = 60.0;
  final double _maxHeightEntitasPresidenDirektur = 60.0;
  final double _maxHeightPresidenDirektur = 60.0;

  List jurusanHeader = [
    'Select',
    'Jurusan',
    'Aksi',
  ];

  List jurusanKey = [
    'select',
    'jurusan',
    'aksi',
  ];

  bool _isLoading = false;
  bool _isFileNull = false;
  List<PlatformFile>? _files;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _files = result.files;
        _isFileNull = false;
      });
    }
  }

  void deleteFile(PlatformFile file) {
    setState(() {
      _files?.remove(file);
      _isFileNull = _files?.isEmpty ?? true;
    });
  }

  int current = 0;

  @override
  void initState() {
    super.initState();
    getData();
    getDataRole();
    getDataUserDetail();
    getDataEntitas();
    getDataJabatan();
    getDataPangkat();
    getDataLokasi();
    getDataJurusan();
    getDataSertifikasi();
    getDataPengajuan();
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('userData');
    final responseData = jsonDecode(userData.toString())['data'];
    setState(() {
      _nrpController.text = responseData['pernr'];
      _namaController.text = responseData['nama'];
      _jabatanController.text = responseData['position'];
      _entitasController.text = responseData['pt'];
      cocd = responseData['cocd'];
    });
    getDataNrpUraianJabatan();
  }

  // cocd

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchData(
    String endpoint,
    Function(Map<String, dynamic>) onSuccess, {
    Map<String, String>? queryParams,
  }) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final ioClient = createIOClientWithInsecureConnection();

      final url =
          Uri.parse("$_apiUrl/$endpoint").replace(queryParameters: queryParams);

      final response = await ioClient.get(
        url,
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      onSuccess(responseData);
    } catch (e) {
      print('Error fetching data from $endpoint: $e');
    }
  }

  Future<void> getDataEntitas() async {
    await _fetchData("master/entitas", (data) {
      final dataHasilApi = data['data'];

      setState(() {
        selectedEntitasAtasanLangsung =
            List<Map<String, dynamic>>.from(dataHasilApi);
        selectedEntitas = List<Map<String, dynamic>>.from(dataHasilApi);
        selectedEntitasDirekturHcgs =
            List<Map<String, dynamic>>.from(dataHasilApi);
        selectedEntitasDirekturKeuangan =
            List<Map<String, dynamic>>.from(dataHasilApi);
        selectedEntitasPresidenDirektur =
            List<Map<String, dynamic>>.from(dataHasilApi);
      });
    });
  }

  Future<void> getDataAtasan() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataHasilApi = data['data'];
        setState(() {
          selectedAtasanLangsung =
              List<Map<String, dynamic>>.from(dataHasilApi);
        });
      },
      queryParams: {
        'atasan': '05',
        'entitas': selectedValueEntitasAtasanLangsung.toString(),
      },
    );
  }

  Future<void> getDataNrpUraianJabatan() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataHasilApi = data['data'];
        setState(() {
          selectedNrpDiUraianJabatan =
              List<Map<String, dynamic>>.from(dataHasilApi);
        });
      },
      queryParams: {
        'atasan': '05',
        'entitas': cocd.toString(),
      },
    );
  }

  Future<void> getDataDepartemen() async {
    await _fetchData(
      "master/departemen",
      (data) {
        final dataHasilApi = data['data'];
        setState(() {
          selectedDepartemen = List<Map<String, dynamic>>.from(dataHasilApi);
        });
      },
      queryParams: {
        'pt': selectedValueEntitas.toString(),
      },
    );
  }

  Future<void> getDataLokasi() async {
    await _fetchData("master/lokasi", (data) {
      final dataHasilApi = data['data'];
      setState(() {
        selectedLokasiKerja = List<Map<String, dynamic>>.from(dataHasilApi);
      });
    });
  }

  Future<void> getDataPangkat() async {
    await _fetchData("master/pangkat", (data) {
      final dataHasilApi = data['data'];
      setState(() {
        selectedPangkatAwal = List<Map<String, dynamic>>.from(dataHasilApi);
        selectedPangkatAkhir = List<Map<String, dynamic>>.from(dataHasilApi);
      });
    });
  }

  Future<void> getDataDirekturHcgs() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataHasilApi = data['data'];
        setState(() {
          selectedDirekturHcgs = List<Map<String, dynamic>>.from(dataHasilApi);
        });
      },
      queryParams: {
        'atasan': '12',
        'entitas': selectedValueEntitasDirekturHcgs.toString(),
      },
    );
  }

  Future<void> getDataDirekturKeuangan() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataHasilApi = data['data'];
        setState(() {
          selectedDirekturKeuangan =
              List<Map<String, dynamic>>.from(dataHasilApi);
        });
      },
      queryParams: {
        'atasan': '12',
        'entitas': selectedValueEntitasDirekturKeuangan.toString(),
      },
    );
  }

  Future<void> getDataPresidenDirektur() async {
    await _fetchData(
      "karyawan/dept-head",
      (data) {
        final dataHasilApi = data['data'];
        setState(() {
          selectedPresidenDirektur =
              List<Map<String, dynamic>>.from(dataHasilApi);
        });
      },
      queryParams: {
        'atasan': '12',
        'entitas': selectedValueEntitasPresidenDirektur.toString(),
      },
    );
  }

  Future<void> getDataRole() async {
    await _fetchData("master/profile/get_role", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataUserDetail() async {
    await _fetchData("user-detail", (data) {
      final dataHasilApi = data;
    });
  }

  Future<void> getDataJabatan() async {
    await _fetchData("master/jabatan", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataJurusan() async {
    await _fetchData("master/jurusan", (data) {
      final dataHasilApi = data['data'];

      setState(() {
        masterDataJurusan = List<Map<String, dynamic>>.from(dataHasilApi);
      });
    });
  }

  Future<void> getDataSertifikasi() async {
    await _fetchData("master/sertifikasi", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataPengajuan() async {
    await _fetchData("master/profile/get_all_pengajuan", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> _addJurusan() async {
    final token = await _getToken();

    String jurusan = _jurusanController.text;

    try {
      final ioClient = createIOClientWithInsecureConnection();

      final response =
          await ioClient.post(Uri.parse('$_apiUrl/master/jurusan/add'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode({
                'jurusan': jurusan.toString(),
              }));

      final responseData = jsonDecode(response.body);
      print(responseData);

      if (responseData['status'] == 'success') {
        getDataJurusan();
        _jurusanController.text = '';
        _showSnackbar('Success', 'Tambah Jurusan berhasil');
      }
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan saat manambahkan jurusan.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteJurusan(dynamic id) async {
    final token = await _getToken();

    try {
      final ioClient = createIOClientWithInsecureConnection();

      final response = await ioClient.delete(
          Uri.parse('$_apiUrl/master/jurusan/delete?id=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          });

      final responseData = jsonDecode(response.body);
      print(responseData);

      if (responseData['status'] == 'success') {
        getDataJurusan();
        _showSnackbar('Success', 'Delete Jurusan berhasil');
      }
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan saat menghapus jurusan.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      shouldIconPulse: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;
    double paddingHorizontalWide = size.width * 0.0585;

    final tabTitles = [
      'Diajukan Oleh',
      'Permintaan Rekrutmen Karyawan',
      'Kualifikasi',
      'Uraian Jabatan',
      'Approval'
    ];

    void updateData(int index) {
      setState(() {
        current = index;
        print(current);
      });
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
            'Form Aplikasi Rekrutmen',
            style: TextStyle(
                color: const Color(primaryBlack),
                fontSize: textLarge,
                fontFamily: 'Poppins',
                letterSpacing: 0.6,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: sizedBoxHeightExtraTall,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                child: TitleWidget(
                  title: 'Prioritas',
                  fontWeight: FontWeight.w500,
                  fontSize: textMedium,
                ),
              ),
              SizedBox(
                height: sizedBoxHeightShort,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCheckbox('Tinggi', _isTinggiChecked),
                  buildCheckbox('Normal', _isNormalChecked),
                  buildCheckbox('Rendah', _isRendahChecked),
                ],
              ),
              SizedBox(
                height: sizedBoxHeightShort,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
                child: TitleWidget(
                  title: 'Tanggal Pengajuan',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding7),
                child: CupertinoButton(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                        vertical: padding5),
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
                          tanggalPengajuan != null
                              ? DateFormat('dd-MM-yyyy').format(
                                  _tanggalPengajuanController.selectedDate ??
                                      DateTime.now())
                              : 'dd/mm/yyyy',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: textMedium,
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
                            height: 350,
                            width: 350,
                            child: SfDateRangePicker(
                              controller: _tanggalPengajuanController,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                setState(() {
                                  tanggalPengajuan = args.value;
                                });
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
              ),
              SizedBox(
                height: sizedBoxHeightShort,
              ),
              Expanded(
                child: Column(
                  children: [
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      tabAlignment: TabAlignment.center,
                      isScrollable: true,
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelPadding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow),
                      tabs: tabTitles.map((title) => Tab(text: title)).toList(),
                      onTap: updateData,
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          diajukanOlehWidget(context),
                          permintaanRekrutmenKaryawanWidget(context),
                          kualifikasiWidget(context),
                          uraianJabatanWidget(context),
                          approvalWidget(context)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizedBoxHeightTall,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: ElevatedButton(
                          onPressed: () {
                            // showSubmitModal(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(primaryYellow),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: const Color(primaryBlack),
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.9,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizedBoxHeightTall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget diajukanOlehWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Diajukan Oleh',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            BuildTextFieldWidget(
              title: 'NRP',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _nrpController,
              hintText: 'NRP',
              maxHeightConstraints: 50,
              isDisable: true,
            ),
            BuildTextFieldWidget(
              title: 'Nama',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _namaController,
              hintText: 'Nama',
              maxHeightConstraints: 50,
              isDisable: true,
            ),
            BuildTextFieldWidget(
              title: 'Jabatan',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _jabatanController,
              hintText: 'Jabatan',
              maxHeightConstraints: 50,
              isDisable: true,
            ),
            BuildTextFieldWidget(
              title: 'Entitas',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _entitasController,
              hintText: 'Entitas',
              maxHeightConstraints: 50,
              isDisable: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget permintaanRekrutmenKaryawanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding7 = size.width * 0.018;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Permintaan Rekrutmen Karyawan Oleh',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Entitas Atasan Langsung : ',
              selectedValue: selectedValueEntitasAtasanLangsung,
              itemList: selectedEntitasAtasanLangsung,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasAtasanLangsung = newValue ?? '';
                  selectedValueAtasanLangsung = null;
                  selectedAtasanLangsung = [];
                  getDataAtasan();
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightEntitasAtasanLangsung,
              isLoading: selectedEntitasAtasanLangsung.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Atasan Langsung : ',
              selectedValue: selectedValueAtasanLangsung,
              itemList: selectedAtasanLangsung,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueAtasanLangsung = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightAtasanLangsung,
              isLoading: selectedAtasanLangsung.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pernr",
              titleKey: "nama",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Entitas : ',
              selectedValue: selectedValueEntitas,
              itemList: selectedEntitas,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitas = newValue ?? '';
                  selectedValueDepartemen = null;
                  selectedDepartemen = [];
                  getDataDepartemen();
                });
              },
              maxHeight: _maxHeightEntitas,
              isLoading: selectedEntitas.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Departemen : ',
              selectedValue: selectedValueDepartemen,
              itemList: selectedDepartemen,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueDepartemen = newValue ?? '';
                });
              },
              maxHeight: _maxHeightDepartement,
              isLoading: selectedDepartemen.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "organizational_unit",
              titleKey: "organizational_unit",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Lokasi Kerja : ',
              selectedValue: selectedValueLokasiKerja,
              itemList: selectedLokasiKerja,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueLokasiKerja = newValue ?? '';
                });
              },
              maxHeight: _maxHeightLokasiKerja,
              isLoading: selectedLokasiKerja.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "lokasi",
              titleKey: "lokasi",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Pangkat Awal : ',
              selectedValue: selectedValuePangkatAwal,
              itemList: selectedPangkatAwal,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePangkatAwal = newValue ?? '';
                });
              },
              maxHeight: _maxHeightPangkatAwal,
              isLoading: selectedPangkatAwal.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Pangkat Akhir : ',
              selectedValue: selectedValuePangkatAkhir,
              itemList: selectedPangkatAkhir,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePangkatAkhir = newValue ?? '';
                });
              },
              maxHeight: _maxHeightPangkatAkhir,
              isLoading: selectedPangkatAkhir.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildTextFieldWidget(
              title: 'Jabatan',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _jabatanRekrutmenKaryawanController,
              hintText: 'Jabatan',
              maxHeightConstraints: _maxHeightJabatanRekrutmenKaryawan,
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalWide),
              child: TitleWidget(
                title: 'Tanggal Kembali Kerja',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding7),
              child: CupertinoButton(
                child: Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding5),
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
                        tanggalKembaliKerja != null
                            ? DateFormat('dd-MM-yyyy').format(
                                _tanggalKembaliKerjaController.selectedDate ??
                                    DateTime.now())
                            : 'dd/mm/yyyy',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: textMedium,
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
                          height: 350,
                          width: 350,
                          child: SfDateRangePicker(
                            controller: _tanggalKembaliKerjaController,
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              setState(() {
                                tanggalKembaliKerja = args.value;
                              });
                            },
                            selectionMode: DateRangePickerSelectionMode.single,
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
            ),
            BuildTextFieldWidget(
              title: 'Qty',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _qtyController,
              hintText: '',
              maxHeightConstraints: _maxHeightQty,
              isNumberField: true,
            ),
            BuildTextFieldWidget(
              title: 'Catatan',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _catatanController,
              hintText: '',
              maxHeightConstraints: _maxHeightCatatan,
            ),
          ],
        ),
      ),
    );
  }

  Widget kualifikasiWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Kualifikasi yang Dibutuhkan',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Pendidikan Awal : ',
              selectedValue: selectedValuePendidikanAwal,
              itemList: selectedPendidikanAwal,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePendidikanAwal = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightPendidikanAwal,
              isLoading: selectedPendidikanAwal.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pendidikan",
              titleKey: "pendidikan",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Pendidikan Akhir : ',
              selectedValue: selectedValuePendidikanAkhir,
              itemList: selectedPendidikanAkhir,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePendidikanAkhir = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightPendidikanAkhir,
              isLoading: selectedPendidikanAkhir.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pendidikan",
              titleKey: "pendidikan",
            ),
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Jurusan',
                        fontWeight: FontWeight.w300,
                        fontSize: textMedium,
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: textMedium,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: ElevatedButton(
                      onPressed: () {
                        showJurusanModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Pilih Jurusan',
                        style: TextStyle(
                            color: const Color(primaryBlack),
                            fontSize: textMedium,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.9,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            BuildTextFieldWidget(
              title: 'Sertifikasi',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _sertifikasiController,
              hintText: 'Pilih Sertifikasi',
              maxHeightConstraints: _maxHeightSertifikasi,
            ),
            BuildTextFieldWidget(
              title: 'IPK / Nilai',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _ipkController,
              hintText: '',
              maxHeightConstraints: _maxHeightIpk,
              isNumberField: true,
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Jenis Kelamin : ',
              selectedValue: selectedValueJenisKelamin,
              itemList: selectedJenisKelamin,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueJenisKelamin = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightJenisKelamin,
              isLoading: selectedJenisKelamin.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "jenis",
              titleKey: "jenis",
            ),
            BuildTextFieldWidget(
              title: 'Rentang Usia Awal',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _usiaAwalController,
              hintText: '',
              maxHeightConstraints: _maxHeightUsiaAwal,
              isNumberField: true,
            ),
            BuildTextFieldWidget(
              title: 'Rentang Usia Akhir',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _usiaAkhirController,
              hintText: '',
              maxHeightConstraints: _maxHeightUsiaAkhir,
              isNumberField: true,
            ),
            BuildTextFieldWidget(
              title: 'Pengalaman Kerja',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _pengalamanKerjaController,
              hintText: '',
              maxHeightConstraints: _maxHeightPengalamanKerja,
            ),
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Kepribadian & Kemampuan yang Dibutuhkan',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            BuildTextFieldWidget(
              title: 'Soft Skill',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _softSkillController,
              hintText: 'Soft Skill',
              maxHeightConstraints: _maxHeightSoftSkill,
            ),
            BuildTextFieldWidget(
              title: 'Hard Skill',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _hardSkillController,
              hintText: 'Hard Skill',
              maxHeightConstraints: _maxHeightHardSkill,
            ),
          ],
        ),
      ),
    );
  }

  Widget uraianJabatanWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding7 = size.width * 0.018;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Uraian Jabatan',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            BuildTextFieldWidget(
              title: 'Tugas & Tanggung Jawab',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _tanggungJawabController,
              hintText: '',
              maxHeightConstraints: _maxHeightTanggungJawab,
            ),
            SizedBox(
              height: sizedBoxHeightShort,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Lampiran Struktur Organisasi : ',
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: pickFiles,
                      child: Text('Pilih File'),
                    ),
                  ),
                  if (_files != null)
                    Column(
                      children: _files!.map((file) {
                        return ListTile(
                          title: Text(file.name),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteFile(file),
                          ),
                          // subtitle: Text('${file.size} bytes'),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            _isFileNull
                ? Center(
                    child: Text(
                    'File Kosong',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: textMedium),
                  ))
                : const Text(''),
            _buildTitle(
              title: 'Status Karyawan',
              fontSize: textLarge,
              fontWeight: FontWeight.w500,
              horizontalPadding: paddingHorizontalNarrow,
              isRequired: false,
            ),
            BuildDropdownWithTitleWidget(
              title: 'Status Karyawan : ',
              selectedValue: selectedValueStatusKaryawan,
              itemList: selectedStatusKaryawan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueStatusKaryawan = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightStatusKaryawan,
              isLoading: selectedStatusKaryawan.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "status",
              titleKey: "status",
            ),
            _buildTitle(
              title: 'Status Aplikasi Rekrutmen',
              fontSize: textLarge,
              fontWeight: FontWeight.w500,
              horizontalPadding: paddingHorizontalNarrow,
              isRequired: false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildUraianJabatanCheckbox('Baru', _isNew),
                buildUraianJabatanCheckbox(
                    'Untuk Pangganti Karyawan Lama', _isOld),
              ],
            ),
            BuildDropdownWithTwoTitleWidget(
              title: 'Pilih NRP : ',
              selectedValue: selectedValueNrpDiUraianJabatan,
              itemList: selectedNrpDiUraianJabatan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueNrpDiUraianJabatan = newValue ?? '';
                  if (newValue != null) {
                    final selectedData = selectedNrpDiUraianJabatan
                        .firstWhere((element) => element['pernr'] == newValue);
                    _namaDiUraianJabatanController.text = selectedData['nama'];
                    _jabatanDiUraianJabatanController.text =
                        selectedData['pangkat'];
                    _entitasDiUraianJabatanController.text = selectedData['pt'];
                  } else {
                    _namaDiUraianJabatanController.clear();
                  }
                });
              },
              maxHeight: _maxHeightStatusKaryawan,
              isLoading: selectedNrpDiUraianJabatan.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pernr",
              titleKey: "nama",
            ),
            BuildTextFieldWidget(
              title: 'Nama',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _namaDiUraianJabatanController,
              hintText: '',
              maxHeightConstraints: _maxHeightNamaDiUraianJabatan,
              isDisable: true,
            ),
            BuildTextFieldWidget(
              title: 'Jabatan',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _jabatanDiUraianJabatanController,
              hintText: '',
              maxHeightConstraints: _maxHeightJabatanDiUraianJabatan,
              isDisable: true,
            ),
            BuildTextFieldWidget(
              title: 'Entitas',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _entitasDiUraianJabatanController,
              hintText: '',
              maxHeightConstraints: _maxHeightEntitasDiUraianJabatan,
              isDisable: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showJurusanModal(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textSmall = size.width * 0.027;
    double padding7 = size.width * 0.018;
    double padding5 = size.width * 0.0115;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightTall = size.height * 0.015;
    double paddingHorizontalNarrow = size.width * 0.035;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontalNarrow,
                vertical: paddingHorizontalNarrow,
              ),
              height: 700,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Jurusan',
                        style: TextStyle(
                          color: const Color(primaryBlack),
                          fontSize: textLarge,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizedBoxHeightTall,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: BuildTextFieldWidget(
                            title: '',
                            isWithTitle: false,
                            isMandatory: false,
                            textSize: textMedium,
                            horizontalPadding: paddingHorizontalNarrow,
                            verticalSpacing: sizedBoxHeightShort,
                            controller: _jurusanController,
                            hintText: 'Jurusan',
                            maxHeightConstraints: _maxHeightJurusan,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              _addJurusan();
                            },
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              decoration: BoxDecoration(
                                color: const Color(primaryYellow),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizedBoxHeightTall,
                    ),
                    SizedBox(
                      height: 500,
                      child: jurusanData(context, setState),
                      // child: Column(
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: paddingHorizontalNarrow,
                      //           vertical: padding7),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Container(
                      //             width: size.width * 1 / 4,
                      //             padding: EdgeInsets.all(padding5),
                      //             child: Text(
                      //               'Select',
                      //               style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: textMedium,
                      //                 fontFamily: 'Poppins',
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             width: size.width * 1 / 2.8,
                      //             padding: EdgeInsets.all(padding5),
                      //             child: Text(
                      //               'Jurusan',
                      //               style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: textMedium,
                      //                 fontFamily: 'Poppins',
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             width: size.width * 1 / 4,
                      //             padding: EdgeInsets.all(padding5),
                      //             child: Text(
                      //               'Aksi',
                      //               style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: textMedium,
                      //                 fontFamily: 'Poppins',
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: SingleChildScrollView(
                      //         child: SizedBox(
                      //           height: 400,
                      //           child: ListView.builder(
                      //             padding: EdgeInsets.symmetric(
                      //               horizontal: paddingHorizontalNarrow,
                      //               vertical: padding7,
                      //             ),
                      //             itemCount: 1,
                      //             itemBuilder:
                      //                 (BuildContext context, int index) {
                      //               return Column(
                      //                 children: [
                      //                   SizedBox(
                      //                     height: sizedBoxHeightTall,
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Container(
                      //                         width: size.width * 1 / 4,
                      //                         padding: EdgeInsets.all(padding5),
                      //                         child: Text(
                      //                           'test',
                      //                           style: TextStyle(
                      //                             color: Colors.grey[700],
                      //                             fontSize: textSmall,
                      //                             fontFamily: 'Poppins',
                      //                             fontWeight: FontWeight.w300,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       Container(
                      //                         width: size.width * 1 / 2.8,
                      //                         padding: EdgeInsets.all(padding5),
                      //                         child: Text(
                      //                           'test',
                      //                           style: TextStyle(
                      //                             color: Colors.grey[700],
                      //                             fontSize: textSmall,
                      //                             fontFamily: 'Poppins',
                      //                             fontWeight: FontWeight.w300,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       Container(
                      //                         width: size.width * 1 / 4,
                      //                         padding: EdgeInsets.all(padding5),
                      //                         child: Text(
                      //                           'test',
                      //                           style: TextStyle(
                      //                             color: Colors.grey[700],
                      //                             fontSize: textSmall,
                      //                             fontFamily: 'Poppins',
                      //                             fontWeight: FontWeight.w300,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    // jurusanTable(context, setState),
                    SizedBox(
                      height: sizedBoxHeightTall,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: size.width * 0.3,
                          height: size.height * 0.04,
                          padding: EdgeInsets.all(size.width * 0.0115),
                          decoration: BoxDecoration(
                            color: const Color(primaryYellow),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(
                              'Keluar',
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget jurusanData(BuildContext context, StateSetter setState) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double padding5 = size.width * 0.0115;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = size.height * 0.0163;

    print(masterDataJurusan);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontalNarrow, vertical: padding7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 1 / 4,
                padding: EdgeInsets.all(padding5),
                child: Text(
                  'Select',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: size.width * 1 / 2.8,
                padding: EdgeInsets.all(padding5),
                child: Text(
                  'Jurusan',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: size.width * 1 / 4.5,
                padding: EdgeInsets.all(padding5),
                child: Text(
                  'Aksi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: textMedium,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontalNarrow,
                  vertical: padding7,
                ),
                itemCount: masterDataJurusan.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 1 / 4,
                            padding: const EdgeInsets.only(right: 30),
                            child: Checkbox(
                              value: selectedItems[index] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedItems[index] = value ?? false;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: size.width * 1 / 2.8,
                            padding: EdgeInsets.all(padding5),
                            child: Text(
                              '${masterDataJurusan[index]['jurusan'] ?? '-'}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: textMedium,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 1 / 4.5,
                            padding: EdgeInsets.all(padding5),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // _deleteJurusan(
                                    //     masterDataJurusan[index]['id']);
                                    print(masterDataJurusan[index]['id']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child:
                                        const Center(child: Icon(Icons.remove)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child:
                                        const Center(child: Icon(Icons.edit)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget jurusanTable(BuildContext context, StateSetter setState) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double padding7 = size.width * 0.018;
    double paddingHorizontalNarrow = size.width * 0.035;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: masterDataJurusan.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontalNarrow, vertical: padding7),
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: ScrollableTableView(
                      headers: jurusanHeader.map((column) {
                        return TableViewHeader(
                          label: column,
                        );
                      }).toList(),
                      rows: masterDataJurusan.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> data = entry.value;
                        return TableViewRow(
                          height: 40,
                          cells: jurusanKey.map((column) {
                            if (column == 'select') {
                              return TableViewCell(
                                child: Checkbox(
                                  value: selectedItems[index] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedItems[index] = value ?? false;
                                    });
                                  },
                                ),
                              );
                            } else if (column == 'aksi') {
                              return TableViewCell(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // handleButtonDelete(context, index);
                                        _deleteJurusan(data['id']);
                                        // print(data['id']);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                        ),
                                        child: const Center(
                                            child: Icon(Icons.remove)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                        ),
                                        child: const Center(
                                            child: Icon(Icons.edit)),
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
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget approvalWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizedBoxHeightExtraTall,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: TitleWidget(
                title: 'Diajukan Kepada',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Entitas Direktur HCGS : ',
              selectedValue: selectedValueEntitasDirekturHcgs,
              itemList: selectedEntitasDirekturHcgs,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasDirekturHcgs = newValue ?? '';
                  selectedValueDirekturHcgs = null;
                  selectedDirekturHcgs = [];
                  getDataDirekturHcgs();
                });
              },
              maxHeight: _maxHeightEntitasDirekturHcgs,
              isLoading: selectedEntitasDirekturHcgs.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildDropdownWithTwoTitleWidget(
              title: 'Pilih Direktur HCGS : ',
              selectedValue: selectedValueDirekturHcgs,
              itemList: selectedDirekturHcgs,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueDirekturHcgs = newValue ?? '';
                });
              },
              maxHeight: _maxHeightDirekturHcgs,
              isLoading: selectedDirekturHcgs.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pernr",
              titleKey: "nama",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Entitas Direktur Keuangan : ',
              selectedValue: selectedValueEntitasDirekturKeuangan,
              itemList: selectedEntitasDirekturKeuangan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasDirekturKeuangan = newValue ?? '';
                  selectedValueDirekturKeuangan = null;
                  selectedDirekturKeuangan = [];
                  getDataDirekturKeuangan();
                });
              },
              maxHeight: _maxHeightEntitasDirekturKeuangan,
              isLoading: selectedEntitasDirekturKeuangan.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildDropdownWithTwoTitleWidget(
              title: 'Pilih Direktur Keuangan : ',
              selectedValue: selectedValueDirekturKeuangan,
              itemList: selectedDirekturKeuangan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueDirekturKeuangan = newValue ?? '';
                });
              },
              maxHeight: _maxHeightDirekturKeuangan,
              isLoading: selectedDirekturKeuangan.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pernr",
              titleKey: "nama",
            ),
            BuildDropdownWithTitleWidget(
              title: 'Pilih Entitas Presiden Direktur : ',
              selectedValue: selectedValueEntitasPresidenDirektur,
              itemList: selectedEntitasPresidenDirektur,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasPresidenDirektur = newValue ?? '';
                  selectedValuePresidenDirektur = null;
                  selectedPresidenDirektur = [];
                  getDataPresidenDirektur();
                });
              },
              maxHeight: _maxHeightEntitasPresidenDirektur,
              isLoading: selectedEntitasPresidenDirektur.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "kode",
              titleKey: "nama",
            ),
            BuildDropdownWithTwoTitleWidget(
              title: 'Pilih Presiden Direktur : ',
              selectedValue: selectedValuePresidenDirektur,
              itemList: selectedPresidenDirektur,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePresidenDirektur = newValue ?? '';
                });
              },
              maxHeight: _maxHeightPresidenDirektur,
              isLoading: selectedPresidenDirektur.isEmpty,
              horizontalPadding: paddingHorizontalNarrow,
              valueKey: "pernr",
              titleKey: "nama",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle({
    required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required double horizontalPadding,
    bool isRequired = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;

    return Column(
      children: [
        SizedBox(
          height: sizedBoxHeightTall,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
              if (isRequired)
                Text(
                  '*',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: fontSize,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: const LineWidget(),
        ),
        SizedBox(
          height: sizedBoxHeightShort,
        ),
      ],
    );
  }

  Widget buildCheckbox(String label, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isTinggiChecked = label == 'Tinggi' ? newValue : false;
              _isNormalChecked = label == 'Normal' ? newValue : false;
              _isRendahChecked = label == 'Rendah' ? newValue : false;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget buildUraianJabatanCheckbox(String label, bool? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: (newValue) {
            setState(() {
              _isNew = label == 'Baru' ? newValue : false;
              _isOld =
                  label == 'Untuk Pangganti Karyawan Lama' ? newValue : false;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
