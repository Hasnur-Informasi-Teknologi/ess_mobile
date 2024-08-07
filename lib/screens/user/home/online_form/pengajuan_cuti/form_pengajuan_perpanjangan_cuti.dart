import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';

import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormPengajuanPerpanjanganCuti extends StatefulWidget {
  const FormPengajuanPerpanjanganCuti({super.key});

  @override
  State<FormPengajuanPerpanjanganCuti> createState() =>
      _FormPengajuanPerpanjanganCutiState();
}

class _FormPengajuanPerpanjanganCutiState
    extends State<FormPengajuanPerpanjanganCuti> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _apiUrl = API_URL;

  final DateRangePickerController _tanggalPengajuanController =
      DateRangePickerController();
  DateTime? tanggalPengajuan;
  final DateRangePickerController _tanggalMasaPerpanjanganStartController =
      DateRangePickerController();
  DateTime? tanggalMasaPerpanjanganStart;
  final DateRangePickerController _tanggalMasaPerpanjanganEndController =
      DateRangePickerController();
  DateTime? tanggalMasaPerpanjanganEnd;
  DateRangePickerController _tanggalBergabungController =
      DateRangePickerController();
  DateTime? tanggalBergabung;

  final _hireDateController = TextEditingController();

  final _nrpController = TextEditingController();
  final _namaController = TextEditingController();
  final _entitasController = TextEditingController();
  final _sisaCutiController = TextEditingController();
  final _alasanController = TextEditingController();

  final double _maxHeightNrp = 50.0;
  final double _maxHeightNama = 50.0;
  final double _maxHeightEntitas = 50.0;
  double _maxHeightAtasan = 60.0;
  final double _maxHeightSisaCuti = 50.0;
  double _maxHeightAlasan = 50.0;

  String? selectedValueAtasan, cocd, entitasUser;
  bool _isLoading = false;

  List<Map<String, dynamic>> selectedAtasan = [];
  Map<String, dynamic> masterData = {};

  @override
  void initState() {
    super.initState();
    getData();
    getDataAtasan();
    getMasterDataCuti();
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

  Future<void> getData() async {
    await _fetchData("master/profile/get_user", (data) {
      final masterDataApi = data['data'];
      setState(() {
        cocd = masterDataApi['cocd'] ?? '';
        _nrpController.text = masterDataApi['nrp'] ?? '';
        _namaController.text = masterDataApi['nama'] ?? '';
        _entitasController.text = masterDataApi['nama_entitas'] ?? '';
        _hireDateController.text = masterDataApi['tgl_masuk'] ?? '';
      });

      getDataAtasan();
    });
  }

  Future<void> getDataAtasan() async {
    await _fetchData("master/cuti/atasan", (data) {
      final dataAtasanApi = data['list_karyawan'];
      setState(() {
        selectedAtasan = List<Map<String, dynamic>>.from(dataAtasanApi);
      });
    }, queryParams: {'entitas': cocd.toString()});
  }

  Future<void> getMasterDataCuti() async {
    await _fetchData("master/cuti/get", (data) {
      final masterDataCutiApi = data['md_cuti'];
      setState(() {
        _sisaCutiController.text = masterDataCutiApi['sisa_cuti'].toString();
      });
    });
  }

  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (tanggalMasaPerpanjanganStart == null ||
        tanggalMasaPerpanjanganEnd == null) {
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

    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _formKey.currentState!.save();

    try {
      final ioClient = createIOClientWithInsecureConnection();

      final response = await ioClient.post(
        Uri.parse('$_apiUrl/perpanjangan-cuti/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'nrp_atasan': selectedValueAtasan.toString(),
          'start_date': tanggalMasaPerpanjanganStart != null
              ? tanggalMasaPerpanjanganStart.toString()
              : DateTime.now().toString(),
          'expired_date': tanggalMasaPerpanjanganEnd != null
              ? tanggalMasaPerpanjanganEnd.toString()
              : DateTime.now().toString(),
          'tgl_pengajuan': tanggalPengajuan != null
              ? tanggalPengajuan.toString()
              : DateTime.now().toString(),
          'nrp_user': _nrpController.text,
          'nama_user': _namaController.text,
          'entitas_user': _entitasController.text,
          'entitas_kode': _entitasController.text,
          'tgl_masuk': _hireDateController.text,
          'jth_extend': _sisaCutiController.text,
          'total_sisa_cuti': _sisaCutiController.text,
          'alasan': _alasanController.text,
        }),
      );

      final responseData = jsonDecode(response.body);
      Get.snackbar('Infomation', responseData['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);

      print(responseData);
      if (responseData['status'] == 'success') {
        Get.offAllNamed('/user/main');
      }
    } catch (e) {
      print(e);
      throw e;
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? _validatorAtasan(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _maxHeightAtasan = 80.0;
      });
      return 'Field Atasan Kosong';
    }

    setState(() {
      _maxHeightAtasan = 60.0;
    });
    return null;
  }

  String? validatorAlasanCuti(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _maxHeightAlasan = 60.0;
      });
      return 'Field Keperluan Cuti Kosong';
    }

    setState(() {
      _maxHeightAlasan = 50.0;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    DateTime tanggalKembaliKerja = DateTime(3000, 2, 1, 10, 20);

    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double sizedBoxHeightExtraTall = size.height * 0.0215;
    double paddingHorizontalNarrow = size.width * 0.035;
    double paddingHorizontalWide = size.width * 0.0585;
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;

    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.toNamed('/user/main/home/online_form/pengajuan_cuti');
                },
              ),
              title: Text(
                'Pengajuan Perpanjangan Cuti',
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
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Tanggal Pengajuan',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
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
                                DateFormat('dd-MM-yyyy').format(
                                    _tanggalPengajuanController.selectedDate ??
                                        DateTime.now()),
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
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       content: Container(
                          //         height: 350,
                          //         width: 350,
                          //         child: SfDateRangePicker(
                          //           controller: _tanggalPengajuanController,
                          //           onSelectionChanged:
                          //               (DateRangePickerSelectionChangedArgs
                          //                   args) {
                          //             setState(() {
                          //               tanggalPengajuan = args.value;
                          //             });
                          //           },
                          //           selectionMode:
                          //               DateRangePickerSelectionMode.single,
                          //         ),
                          //       ),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: () => Navigator.pop(context),
                          //           child: Text('OK'),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'NRP',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFielDisableWidget(
                          controller: _nrpController,
                          maxHeightConstraints: _maxHeightNrp,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Nama',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFielDisableWidget(
                          controller: _namaController,
                          maxHeightConstraints: _maxHeightNama,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Entitas',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFielDisableWidget(
                          controller: _entitasController,
                          maxHeightConstraints: _maxHeightEntitas,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Pilih Atasan : ',
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: size.height * 0.5,
                          validator: _validatorAtasan,
                          value: selectedValueAtasan,
                          icon: selectedAtasan.isEmpty
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                )
                              : const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValueAtasan = newValue ?? '';
                            });
                          },
                          items:
                              selectedAtasan.map((Map<String, dynamic> value) {
                            return DropdownMenuItem<String>(
                              value: value["nrp"].toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TitleWidget(
                                  title: value["nama"] as String,
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            constraints:
                                BoxConstraints(maxHeight: _maxHeightAtasan),
                            labelStyle: TextStyle(fontSize: textMedium),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: selectedValueAtasan != null
                                    ? Colors.black54
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Sisa Cuti',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFielDisableWidget(
                          controller: _sisaCutiController,
                          maxHeightConstraints: _maxHeightSisaCuti,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      SizedBox(
                        height: sizedBoxHeightTall,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'Masa Perpanjangan',
                          fontWeight: FontWeight.w500,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: const LineWidget(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.46,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          tanggalMasaPerpanjanganStart != null
                                              ? DateFormat('dd-MM-yyyy').format(
                                                  _tanggalMasaPerpanjanganStartController
                                                          .selectedDate ??
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
                                              controller:
                                                  _tanggalMasaPerpanjanganStartController,
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs
                                                      args) {
                                                setState(() {
                                                  tanggalMasaPerpanjanganStart =
                                                      args.value;
                                                });
                                              },
                                              selectionMode:
                                                  DateRangePickerSelectionMode
                                                      .single,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('s/d')),
                          SizedBox(
                            width: size.width * 0.46,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          tanggalMasaPerpanjanganEnd != null
                                              ? DateFormat('dd-MM-yyyy').format(
                                                  _tanggalMasaPerpanjanganEndController
                                                          .selectedDate ??
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
                                              controller:
                                                  _tanggalMasaPerpanjanganEndController,
                                              onSelectionChanged:
                                                  (DateRangePickerSelectionChangedArgs
                                                      args) {
                                                setState(() {
                                                  tanggalMasaPerpanjanganEnd =
                                                      args.value;
                                                });
                                              },
                                              selectionMode:
                                                  DateRangePickerSelectionMode
                                                      .single,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: sizedBoxHeightShort,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Row(
                          children: [
                            TitleWidget(
                              title: 'Alasan Cuti Tidak Digunakan ',
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
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormFieldWidget(
                          controller: _alasanController,
                          validator: validatorAlasanCuti,
                          maxHeightConstraints: _maxHeightAlasan,
                          hintText: 'Karena ada ....',
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
                              showSubmitModal(context);
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void showSubmitModal(BuildContext context) {
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
                  'Konfirmasi Submit',
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
                    _submit();
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
                        'Submit',
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
