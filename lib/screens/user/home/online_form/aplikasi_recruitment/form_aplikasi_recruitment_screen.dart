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
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateRangePickerController _tanggalPengajuanController =
      DateRangePickerController();
  DateTime? tanggalPengajuan;
  // Pengajuan
  final TextEditingController _nomorController = TextEditingController();
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
  final DateRangePickerController _tanggalMulaiKerjaController =
      DateRangePickerController();
  DateTime? tanggalMulaiKerja;
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
      selectedValuePresidenDirektur;

  List<Map<String, dynamic>> selectedEntitasAtasanLangsung = [];
  List<Map<String, dynamic>> selectedAtasanLangsung = [];
  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedDepartemen = [];
  List<Map<String, dynamic>> selectedLokasiKerja = [];
  List<Map<String, dynamic>> selectedPangkatAwal = [];
  List<Map<String, dynamic>> selectedPangkatAkhir = [];
  List<Map<String, dynamic>> selectedPendidikanAwal = [];
  List<Map<String, dynamic>> selectedPendidikanAkhir = [];
  List<Map<String, dynamic>> selectedJenisKelamin = [];
  List<Map<String, dynamic>> selectedNrpDiUraianJabatan = [];
  List<Map<String, dynamic>> selectedStatusKaryawan = [];
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
    getDataRole();
    getDataUserDetail();
    getDataEntitas();
    getDataJabatan();
    getDataLokasi();
    getDataPangkat();
    getDataJurusan();
    getDataSertifikasi();
    getDataPengajuan();
  }

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

  Future<void> getDataRole() async {
    await _fetchData("master/profile/get_role", (data) {
      final dataHasilApi = data['data'];
      // setState(() {
      //   selectedEntitas = List<Map<String, dynamic>>.from(dataEntitasApi);
      // });
    });
  }

  Future<void> getDataUserDetail() async {
    await _fetchData("user-detail", (data) {
      final dataHasilApi = data;
    });
  }

  Future<void> getDataEntitas() async {
    await _fetchData("master/entitas", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataJabatan() async {
    await _fetchData("master/jabatan", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataLokasi() async {
    await _fetchData("master/lokasi", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataPangkat() async {
    await _fetchData("master/pangkat", (data) {
      final dataHasilApi = data['data'];
    });
  }

  Future<void> getDataJurusan() async {
    await _fetchData("master/jurusan", (data) {
      final dataHasilApi = data['data'];
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

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(3000, 2, 1, 10, 20);
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildDropdownWithTitle(
              title: 'Pilih Entitas Atasan Langsung : ',
              selectedValue: selectedValueEntitasAtasanLangsung,
              itemList: selectedEntitasAtasanLangsung,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasAtasanLangsung = newValue ?? '';
                  // selectedValueAtasan = null;
                  // getDataAtasan();
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightEntitasAtasanLangsung,
              isLoading: selectedEntitasAtasanLangsung.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
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
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Entitas : ',
              selectedValue: selectedValueEntitas,
              itemList: selectedEntitas,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitas = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightEntitas,
              isLoading: selectedEntitas.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Lokasi Kerja : ',
              selectedValue: selectedValueLokasiKerja,
              itemList: selectedLokasiKerja,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueLokasiKerja = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightLokasiKerja,
              isLoading: selectedLokasiKerja.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Pangkat Awal : ',
              selectedValue: selectedValuePangkatAwal,
              itemList: selectedPangkatAwal,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePangkatAwal = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightPangkatAwal,
              isLoading: selectedPangkatAwal.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Pangkat Akhir : ',
              selectedValue: selectedValuePangkatAkhir,
              itemList: selectedPangkatAkhir,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePangkatAkhir = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightPangkatAkhir,
              isLoading: selectedPangkatAkhir.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildTextFieldSection(
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
                        tanggalMulaiKerja != null
                            ? DateFormat('dd-MM-yyyy').format(
                                _tanggalMulaiKerjaController.selectedDate ??
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
                            controller: _tanggalMulaiKerjaController,
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              setState(() {
                                tanggalMulaiKerja = args.value;
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
                title: 'Kualifikasi yang Dibutuhkan',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            _buildDropdownWithTitle(
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
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
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
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildTextFieldSection(
              title: 'Jurusan',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _nrpController,
              hintText: 'Pilih Jurusan',
              maxHeightConstraints: _maxHeightJurusan,
            ),
            _buildTextFieldSection(
              title: 'Sertifikasi',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _nrpController,
              hintText: 'Pilih Sertifikasi',
              maxHeightConstraints: _maxHeightSertifikasi,
            ),
            _buildTextFieldSection(
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
            _buildDropdownWithTitle(
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
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
              title: 'Soft Skill',
              isMandatory: true,
              textSize: textMedium,
              horizontalPadding: paddingHorizontalNarrow,
              verticalSpacing: sizedBoxHeightShort,
              controller: _softSkillController,
              hintText: 'Soft Skill',
              maxHeightConstraints: _maxHeightSoftSkill,
            ),
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildDropdownWithTitle(
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
              valueKey: "kode",
              titleKey: "nama",
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
            _buildDropdownWithTitle(
              title: 'Pilih NRP : ',
              selectedValue: selectedValueNrpDiUraianJabatan,
              itemList: selectedNrpDiUraianJabatan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueNrpDiUraianJabatan = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightStatusKaryawan,
              isLoading: selectedNrpDiUraianJabatan.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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
            _buildTextFieldSection(
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

  Widget approvalWidget(BuildContext context) {
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
                title: 'Diajukan Kepada',
                fontWeight: FontWeight.w500,
                fontSize: textLarge,
              ),
            ),
            SizedBox(
              height: sizedBoxHeightTall,
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Entitas Direktur HCGS : ',
              selectedValue: selectedValueEntitasDirekturHcgs,
              itemList: selectedEntitasDirekturHcgs,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasDirekturHcgs = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightEntitasDirekturHcgs,
              isLoading: selectedEntitasDirekturHcgs.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Direktur HCGS : ',
              selectedValue: selectedValueDirekturHcgs,
              itemList: selectedDirekturHcgs,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueDirekturHcgs = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightDirekturHcgs,
              isLoading: selectedDirekturHcgs.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Entitas Direktur Keuangan : ',
              selectedValue: selectedValueEntitasDirekturKeuangan,
              itemList: selectedEntitasDirekturKeuangan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasDirekturKeuangan = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightEntitasDirekturKeuangan,
              isLoading: selectedEntitasDirekturKeuangan.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Direktur Keuangan : ',
              selectedValue: selectedValueDirekturKeuangan,
              itemList: selectedDirekturKeuangan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueDirekturKeuangan = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightDirekturKeuangan,
              isLoading: selectedDirekturKeuangan.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Entitas Presiden Direktur : ',
              selectedValue: selectedValueEntitasPresidenDirektur,
              itemList: selectedEntitasPresidenDirektur,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValueEntitasPresidenDirektur = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightEntitasPresidenDirektur,
              isLoading: selectedEntitasPresidenDirektur.isEmpty,
              valueKey: "kode",
              titleKey: "nama",
            ),
            _buildDropdownWithTitle(
              title: 'Pilih Presiden Direktur : ',
              selectedValue: selectedValuePresidenDirektur,
              itemList: selectedPresidenDirektur,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValuePresidenDirektur = newValue ?? '';
                });
              },
              // validator: _validatorEntitas,
              maxHeight: _maxHeightPresidenDirektur,
              isLoading: selectedPresidenDirektur.isEmpty,
              valueKey: "kode",
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
    double paddingHorizontalWide = size.width * 0.0585;
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

  Widget _buildTextFieldSection({
    required String title,
    required bool isMandatory,
    required double textSize,
    required double horizontalPadding,
    required double verticalSpacing,
    required TextEditingController controller,
    required String hintText,
    double? maxHeightConstraints,
    String? Function(String?)? validator,
    bool isNumberField = false,
    bool isDisable = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double sizedBoxHeightTall = size.height * 0.0163;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: FontWeight.w300,
                fontSize: textSize,
              ),
              if (isMandatory)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: textSize,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          if (isNumberField && !isDisable)
            TextFormFieldNumberWidget(
              validator: validator,
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
              hintText: hintText,
            ),
          if (isDisable && !isNumberField)
            TextFormFielDisableWidget(
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
            ),
          if (!isDisable && !isNumberField)
            TextFormFieldWidget(
              validator: validator,
              controller: controller,
              maxHeightConstraints: maxHeightConstraints ?? 50.0,
              hintText: hintText,
            ),
          SizedBox(height: sizedBoxHeightTall),
        ],
      ),
    );
  }

  Widget _buildDropdownWithTitle({
    required String title,
    required String? selectedValue,
    required List<Map<String, dynamic>> itemList,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    double? maxHeight,
    bool isLoading = false,
    String valueKey = "value",
    String titleKey = "title",
  }) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalWide = size.width * 0.0585;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleWidget(
                title: title,
                fontWeight: FontWeight.w300,
                fontSize: textMedium,
              ),
              Text(
                '*',
                textAlign: TextAlign.start,
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
          DropdownButtonFormField<String>(
            menuMaxHeight: size.height * 0.5,
            value: selectedValue,
            onChanged: onChanged,
            items: itemList.map((value) {
              return DropdownMenuItem<String>(
                value: value[valueKey].toString(),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TitleWidget(
                    title: value[titleKey] as String,
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              constraints:
                  BoxConstraints(maxHeight: maxHeight ?? double.infinity),
              labelStyle: TextStyle(fontSize: textMedium),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: selectedValue != null ? Colors.black54 : Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            validator: validator,
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : const Icon(Icons.arrow_drop_down),
          ),
          SizedBox(height: sizedBoxHeightExtraTall)
        ],
      ),
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
