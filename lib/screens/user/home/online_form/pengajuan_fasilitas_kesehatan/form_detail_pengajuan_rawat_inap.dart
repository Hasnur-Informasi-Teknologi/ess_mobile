import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_number_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormDetailPengajuanRawatInap extends StatefulWidget {
  const FormDetailPengajuanRawatInap({super.key});

  @override
  State<FormDetailPengajuanRawatInap> createState() =>
      _FormDetailPengajuanRawatInapState();
}

class _FormDetailPengajuanRawatInapState
    extends State<FormDetailPengajuanRawatInap> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _noKwitansiController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _keteranganController = TextEditingController();
  double maxHeightDetailPengganti = 60.0;
  double maxHeightNokwitansi = 40.0;
  double maxHeightJumlah = 40.0;
  double maxHeightKeterangan = 40.0;
  double maxHeightJenisPengganti = 60.0;
  double maxHeightDiagnosa = 60.0;
  bool _isFileNull = false;
  final DateRangePickerController _tanggalKwitansiController =
      DateRangePickerController();
  DateTime? tanggalKwitansi;
  final Function? onClose = Get.arguments['onClose'];

  String? id,
      jenisPengganti,
      detailPengganti,
      idDiagnosa,
      namaPasient,
      noKwitansi,
      jumlah,
      keterangan;

  String? selectedValueJenisPengganti,
      selectedValueDetailPengganti,
      selectedValueDiagnosa;

  List<Map<String, dynamic>> selectedJenisPengganti = [
    {'id': '4000', 'jenis': 'Rawat Inap'},
    {'id': '5000', 'jenis': 'Persalinan'},
  ];
  List<Map<String, dynamic>> selectedDetailPengganti = [];
  List<Map<String, dynamic>> selectedDiagnosa = [];

  List<PlatformFile>? files;
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        files = result.files;
        _isFileNull = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataDetailPengganti();
    getDiagnosa();
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

  Future<void> getDataDetailPengganti() async {
    await _fetchData(
      "master/jenis/penggantian/inap",
      (data) {
        final dataDetailPenggantiApi = data['data'];
        print(dataDetailPenggantiApi);

        setState(() {
          selectedDetailPengganti =
              List<Map<String, dynamic>>.from(dataDetailPenggantiApi);
        });
      },
    );
  }

  Future<void> getDiagnosa() async {
    await _fetchData(
      "master/diagnosa",
      (data) {
        final dataDiagnosaApi = data['data'];

        setState(() {
          selectedDiagnosa = List<Map<String, dynamic>>.from(dataDiagnosaApi);
        });
      },
    );
  }

  Future<void> _tambah() async {
    if (tanggalKwitansi == null) {
      Get.snackbar('Infomation', 'Tanggal Wajib Diisi',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
      return;
    }

    _formKey.currentState!.save();

    if (_formKey.currentState!.validate() == false) {
      return;
    }

    String? filePath;

    if (files != null) {
      filePath = files!.single.path;
      setState(() {
        _isFileNull = false;
      });
    } else {
      setState(() {
        _isFileNull = true;
      });
      return;
    }

    jenisPengganti = selectedValueJenisPengganti;
    List<String> separatedValues = selectedValueDetailPengganti!.split(',');
    id = separatedValues[0].trim();
    detailPengganti = separatedValues[1].trim();
    noKwitansi = _noKwitansiController.text;
    jumlah = _jumlahController.text;
    idDiagnosa = selectedValueDiagnosa;
    keterangan = _keteranganController.text;

    Map<String, dynamic> newData = {
      "id": id ?? '',
      "benefit_type": jenisPengganti ?? '',
      "id_diagnosa": idDiagnosa ?? '',
      "no_kuitansi": noKwitansi ?? '',
      "tgl_kuitansi": tanggalKwitansi != null
          ? "${tanggalKwitansi?.year}-${tanggalKwitansi?.month.toString().padLeft(2, '0')}-${tanggalKwitansi?.day.toString().padLeft(2, '0')}"
          : "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "detail_penggantian": detailPengganti ?? '',
      "jumlah": jumlah ?? '',
      "keterangan": keterangan ?? '',
      "lampiran_pembayaran": filePath,
    };

    DataDetailPengajuanRawatInapController
        dataDetailPengajuanRawatInapController = Get.find();

    dataDetailPengajuanRawatInapController.tambahData(newData);
    onClose?.call();
    Get.back();
  }

  String? _validatorJenisPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightJenisPengganti = 80.0;
      });
      return 'Field Jenis Pengganti Kosong';
    }

    setState(() {
      maxHeightJenisPengganti = 60.0;
    });
    return null;
  }

  String? _validatorDetailPengganti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightDetailPengganti = 80.0;
      });
      return 'Field Detail Pengganti Kosong';
    }

    setState(() {
      maxHeightDetailPengganti = 60.0;
    });
    return null;
  }

  String? _validatorNoKwitansi(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightNokwitansi = 60.0;
      });
      return 'Field No Kwitansi Kosong';
    }

    setState(() {
      maxHeightNokwitansi = 40.0;
    });
    return null;
  }

  String? _validatorJumlah(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightJumlah = 60.0;
      });
      return 'Field Jumlah Kosong';
    }

    setState(() {
      maxHeightJumlah = 40.0;
    });
    return null;
  }

  String? _validatorDiagnosa(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightDiagnosa = 80.0;
      });
      return 'Field Diagnosa Kosong';
    }

    setState(() {
      maxHeightDiagnosa = 60.0;
    });
    return null;
  }

  String? _validatorKeterangan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightKeterangan = 60.0;
      });
      return 'Field Jumlah Kosong';
    }

    setState(() {
      maxHeightKeterangan = 40.0;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;

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
            // Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Pengajuan Rawat Inap',
          style: TextStyle(
              color: const Color(primaryBlack),
              fontSize: textLarge,
              fontFamily: 'Poppins',
              letterSpacing: 0.6,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdownWithTwoTitle(
                  title: 'Pilih Jenis Pengganti : ',
                  selectedValue: selectedValueJenisPengganti,
                  itemList: selectedJenisPengganti,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueJenisPengganti = newValue ?? '';
                    });
                  },
                  validator: _validatorJenisPengganti,
                  maxHeight: maxHeightJenisPengganti,
                  isLoading: selectedJenisPengganti.isEmpty,
                  valueKey: "id",
                  titleKey: "jenis",
                  isRequired: true,
                ),
                _buildDropdownWithTwoValue(
                  title: 'Pilih Detail Penggantian : ',
                  selectedValue: selectedValueDetailPengganti,
                  itemList: selectedDetailPengganti,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueDetailPengganti = newValue ?? '';
                    });
                  },
                  validator: _validatorDetailPengganti,
                  maxHeight: maxHeightJenisPengganti,
                  isLoading: selectedDetailPengganti.isEmpty,
                  valueKey: "id",
                  titleKey: "nama",
                  isRequired: true,
                ),
                _buildTextFieldSection(
                  title: 'No Kwitansi',
                  isMandatory: true,
                  textSize: textMedium,
                  horizontalPadding: paddingHorizontalNarrow,
                  verticalSpacing: sizedBoxHeightShort,
                  controller: _noKwitansiController,
                  hintText: 'No Kwitansi',
                  validator: _validatorNoKwitansi,
                  maxHeightConstraints: maxHeightNokwitansi,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Tanggal Kwitansi ',
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
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                CupertinoButton(
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
                          tanggalKwitansi != null
                              ? DateFormat('dd-MM-yyyy').format(
                                  _tanggalKwitansiController.selectedDate ??
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
                              controller: _tanggalKwitansiController,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                setState(() {
                                  tanggalKwitansi = args.value;
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
                _buildTextFieldSection(
                  title: 'Jumlah',
                  isMandatory: true,
                  textSize: textMedium,
                  horizontalPadding: paddingHorizontalNarrow,
                  verticalSpacing: sizedBoxHeightShort,
                  controller: _jumlahController,
                  hintText: 'masukkan nominal',
                  validator: _validatorJumlah,
                  maxHeightConstraints: maxHeightJumlah,
                  isNumberField: true,
                ),
                _buildDropdownWithTitle(
                  title: 'Pilih Diagnosa : ',
                  selectedValue: selectedValueDiagnosa,
                  itemList: selectedDiagnosa,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueDiagnosa = newValue ?? '';
                    });
                  },
                  validator: _validatorDiagnosa,
                  maxHeight: maxHeightDiagnosa,
                  isLoading: selectedDiagnosa.isEmpty,
                  valueKey: "id",
                  titleKey: "nama",
                ),
                _buildTextFieldSection(
                  title: 'Keterangan/Diagnosa',
                  isMandatory: true,
                  textSize: textMedium,
                  horizontalPadding: paddingHorizontalNarrow,
                  verticalSpacing: sizedBoxHeightShort,
                  controller: _keteranganController,
                  hintText: 'Keterangan',
                  validator: _validatorKeterangan,
                  maxHeightConstraints: maxHeightKeterangan,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Row(
                    children: [
                      TitleWidget(
                        title: 'Lampiran Bukti Pembayaran ',
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
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
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
                      if (files != null)
                        Column(
                          children: files!.map((file) {
                            return ListTile(
                              title: Text(file.name),
                              // subtitle: Text('${file.size} bytes'),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightShort,
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
                SizedBox(
                  height: sizedBoxHeightShort,
                ),
                SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: ElevatedButton(
                      onPressed: _tambah,
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
                )
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildDropdownWithTwoTitle({
    required String title,
    required String? selectedValue,
    required List<Map<String, dynamic>> itemList,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    double? maxHeight,
    bool isLoading = false,
    String valueKey = "value",
    String titleKey = "title",
    bool isRequired = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;

    double sizedBoxHeightExtraTall = size.height * 0.0215;

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
              if (isRequired)
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
                    title: '${value[titleKey]} - ${value[valueKey]}',
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

  Widget _buildDropdownWithTwoValue({
    required String title,
    required String? selectedValue,
    required List<Map<String, dynamic>> itemList,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    double? maxHeight,
    bool isLoading = false,
    String valueKey = "value",
    String titleKey = "title",
    bool isRequired = false,
  }) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;

    double sizedBoxHeightExtraTall = size.height * 0.0215;

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
              if (isRequired)
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
                value: '${value["valueKey"]},${value["titleKey"]}',
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TitleWidget(
                    title: '${value[titleKey]}',
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
}

class DataDetailPengajuanRawatInapController extends GetxController {
  var data = <Map<String, dynamic>>[].obs;

  void tambahData(Map<String, dynamic> newData) {
    data.add(newData);
  }

  List<Map<String, dynamic>> getDataList() {
    return data;
  }
}
