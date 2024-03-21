import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UangMakanDalamNegeri extends StatefulWidget {
  const UangMakanDalamNegeri({super.key});

  @override
  State<UangMakanDalamNegeri> createState() => _UangMakanDalamNegeriState();
}

class _UangMakanDalamNegeriState extends State<UangMakanDalamNegeri> {
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchcontroller = TextEditingController();
  TextEditingController _mdJPController = TextEditingController();
  List _mdPangkatController = [];
  TextEditingController _nominalController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  List<Map<String, dynamic>> selectedJP = [];
  List<Map<String, dynamic>> selectedPangkat = [];
  List<Map<String, dynamic>> selectedStatus = [];
  String? selectedValueJP, selectedValuePangkat, selectedValueStatus;
  final DateRangePickerController _tanggalMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;
  final DateRangePickerController _tanggalBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;
  int _rowsPerPage = 5;
  int _pageIndex = 1;
  int _totalRecords = 0;
  String _searchQuery = '';
  List<dynamic> _data = [];
  List<dynamic> _subData = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    getDataMdPangkat();
    getDataMdJP();
    getDataStatus();
  }

  Future<void> fetchData({
    int? pageIndex,
    int? rowPerPage,
    String? searchQuery,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/master/makan-dalam/get?page=${pageIndex ?? _pageIndex}&perPage=${rowPerPage ?? _rowsPerPage}&search=${searchQuery ?? _searchQuery}'),
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['dataku'];
        final List<dynamic> subData = responseData['child'];

        final total = responseData["totalPage"];

        setState(() {
          _totalRecords = total['total_records'] ?? 0;

          if (pageIndex != null) {
            _data.clear();
          }

          _data.addAll(data);
          _subData.addAll(subData);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> getDataMdPangkat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http
            .get(Uri.parse("$apiUrl/master/pangkat"), headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
        final responseData = jsonDecode(response.body);
        final dataMdPangkatApi = responseData['data'];

        print("$dataMdPangkatApi");

        setState(
          () {
            selectedPangkat = List<Map<String, dynamic>>.from(dataMdPangkatApi);
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataMdJP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/master/makan-dalam/jp"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataMdJPApi = responseData['data'];

        print("$dataMdJPApi");

        setState(
          () {
            selectedJP = List<Map<String, dynamic>>.from(dataMdJPApi);
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataStatus() async {
    String jsonString = '''
    {
      "data": [
        {
          "id": "1",
          "nama": "Aktif"
        },
        {
          "id": "0",
          "nama": "Tidak Aktif"
        }
      ]
    }
    ''';

    try {
      final responseData = jsonDecode(jsonString);
      final dataStatusApi = responseData['data'];
      print('dataStatusApi: $dataStatusApi');
      setState(() {
        selectedStatus = List<Map<String, dynamic>>.from(dataStatusApi);
      });
    } catch (e) {
      print(e);
    }
  }

  void _filterData(String query) {
    if (query.isNotEmpty) {
      setState(() {
        fetchData(pageIndex: 1, rowPerPage: _totalRecords, searchQuery: query);
      });
    } else {
      setState(() {
        fetchData(pageIndex: 1);
      });
    }
  }

  void nextPage() {
    if ((_pageIndex * _rowsPerPage) < _totalRecords) {
      setState(() {
        _pageIndex++;
      });
      fetchData(pageIndex: _pageIndex);
    }
  }

  void prevPage() {
    if (_pageIndex > 1) {
      setState(() {
        _pageIndex--;
      });
      fetchData(pageIndex: _pageIndex);
    }
  }

  void onRowsPerPageChanged(int? value) {
    setState(() {
      _rowsPerPage = value!;
      _pageIndex = 1;
    });
    fetchData(pageIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double textMedium = size.width * 0.0329;
    double maxHeightValidator = 60.0;
    double _maxHeightAtasan = 60.0;
    double padding5 = size.width * 0.0115;

    String? validateField(String? value, String fieldName) {
      if (value == null || value.isEmpty) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Field $fieldName Kosong';
      }

      setState(() {
        maxHeightValidator = 60.0;
      });
      return null;
    }

    Future<void> _submit(List pangkat) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

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

      Map<String, dynamic> bodyData = {
        'kode_jp': _mdJPController.text,
        'kode_pangkat': pangkat,
        'nominal': _nominalController.text,
        'status': _statusController.text,
        'tgl_mulai': tanggalMulai != null
            ? tanggalMulai.toString()
            : DateTime.now().toString(),
        'tgl_berakhir': tanggalBerakhir != null
            ? tanggalBerakhir.toString()
            : DateTime.now().toString(),
      };
      try {
        final response = await http.post(
          Uri.parse('$apiUrl/master/makan-dalam/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
        );
        print(response.body);

        final responseData = jsonDecode(response.body);
        Get.snackbar('Infomation', responseData['Data telah ditambahkan'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);

        print(responseData);
        if (responseData['status'] == 'success') {
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      }

      setState(() {
        _isLoading = false;
      });
    }

    Future<void> _handleButtonAdd() {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
              top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Jenis Penggantian *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Container(
                      height: 50,
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          "Pilih Jenis",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        validator: (value) =>
                            validateField(value, 'Pilih Jenis Pengganti'),
                        value: selectedValueJP,
                        icon: selectedJP.isEmpty
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              )
                            : Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueJP = newValue;
                            _mdJPController.text = newValue ?? '';
                            print("'selectedValueJP: $selectedValueJP");
                          });
                        },
                        items: selectedJP.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value["id"].toString(),
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
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: selectedValueJP != null
                                  ? Colors.transparent
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  selectedValueJP == '2'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Jenjang Kepangkatan *',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: MultiSelectDialogField(
                                buttonIcon: Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.grey[700],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                items: selectedPangkat
                                    .map((value) => MultiSelectItem<String>(
                                        value['kode'].toString(),
                                        value['nama']))
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (List<String> value) {
                                  selectedValuePangkat = value.toString();
                                  _mdPangkatController = value;
                                  print('kode_pangkat:$_mdPangkatController');
                                },
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Jenjang Kepangkatan *',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: Container(
                                height: 50,
                                width: size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingHorizontalNarrow),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: DropdownButtonFormField<String>(
                                  hint: Text(
                                    "Pilih Pangkat",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: textMedium,
                                    ),
                                  ),
                                  validator: (value) =>
                                      validateField(value, 'Pangkat'),
                                  value: selectedValuePangkat,
                                  icon: selectedPangkat.isEmpty
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        )
                                      : Icon(Icons.arrow_drop_down),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValuePangkat = newValue ?? '';
                                      _mdPangkatController = [
                                        newValue.toString()
                                      ];
                                      print(
                                          "kode_pangkat: $_mdPangkatController");
                                    });
                                  },
                                  items: selectedPangkat
                                      .map<DropdownMenuItem<String>>(
                                          (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value["kode"] as String,
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
                                    constraints: BoxConstraints(
                                        maxHeight: _maxHeightAtasan),
                                    labelStyle: TextStyle(fontSize: textMedium),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: selectedValuePangkat != null
                                            ? Colors.transparent
                                            : Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Jumlah *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      controller: _nominalController,
                      validator: (value) => validateField(value, 'Jumlah'),
                      decoration: InputDecoration(
                        hintText: "Jumlah",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(
                          20.0,
                          10.0,
                          20.0,
                          10.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Status *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Container(
                      height: 50,
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          'Pilih Status',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        validator: (value) => validateField(value, 'Status'),
                        value: selectedValueStatus,
                        icon: selectedStatus.isEmpty
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
                            selectedValueStatus = newValue ?? '';
                            _statusController.text = newValue ?? '';
                            print('selectedValueStatus: $selectedValueStatus');
                          });
                        },
                        items: selectedStatus.map((Map<String, dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value["id"].toString(),
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
                              BoxConstraints(maxHeight: maxHeightValidator),
                          labelStyle: TextStyle(fontSize: textMedium),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: selectedValueStatus != null
                                  ? Colors.transparent
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Tanggal Mulai *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  CupertinoButton(
                    child: Container(
                      height: 50,
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
                                _tanggalMulaiController.selectedDate ??
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 350,
                              width: 350,
                              child: SfDateRangePicker(
                                controller: _tanggalMulaiController,
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs args) {
                                  setState(() {
                                    tanggalMulai = args.value;
                                  });
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Tanggal Berakhir *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  CupertinoButton(
                    child: Container(
                      height: 50,
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
                                _tanggalBerakhirController.selectedDate ??
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 350,
                              width: 350,
                              child: SfDateRangePicker(
                                controller: _tanggalBerakhirController,
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs args) {
                                  setState(() {
                                    tanggalBerakhir = args.value;
                                  });
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_mdJPController == '1') {
                            String listString = _mdPangkatController.toString();
                            print(listString);
                            print("gagal");
                          } else {
                            List<String> listString = _mdPangkatController
                                .map((e) => e.toString())
                                .toList();
                            print('listString : $listString');
                            _submit(listString);
                            Navigator.pop(context);
                            fetchData(pageIndex: 1);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(primaryYellow),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: const Color(primaryBlack),
                              fontSize: textMedium,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget content() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(primaryYellow),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: _handleButtonAdd,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        SizedBox(),
                        Text(
                          'Add Data',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff002B5B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.description,
                          color: Colors.white,
                        ),
                        SizedBox(),
                        Text(
                          'Export',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 200,
              child: TextField(
                controller: _searchcontroller,
                decoration: const InputDecoration(
                  labelText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 17,
                  ),
                ),
                onChanged: _filterData,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Future<void> deleteData(int id) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');
      if (token != null) {
        try {
          final response =
              await http.post(Uri.parse("$apiUrl/master/makan-dalam/delete"),
                  headers: <String, String>{
                    'Content-Type': 'application/json;charset=UTF-8',
                    'Authorization': 'Bearer $token'
                  },
                  body: jsonEncode({'id': id}));
          final responseData = jsonDecode(response.body);
          Get.snackbar('Infomation', responseData['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          if (response.statusCode == 200) {
            print('Item with Kode $id deleted successfully');
          } else {
            throw Exception('Failed to delete item');
          }
        } catch (e) {
          print(e);
        }
      }
    }

    Future<void> _submitUpdate(
      valueId,
      valueJP,
      valuePangkat,
      valueNominal,
      valueStatus,
      valueTglMulai,
      valueTglBerakhir,
    ) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

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

      Map<String, dynamic> bodyData = {
        'id': valueId,
        'kode_jp': valueJP,
        'kode_pangkat': valuePangkat,
        'nominal': valueNominal,
        'status': valueStatus,
        'tgl_mulai': valueTglMulai,
        'tgl_berakhir': valueTglBerakhir
      };
      try {
        final response = await http.post(
          Uri.parse('$apiUrl/master/makan-dalam/update'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(bodyData),
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
        if (responseData['status'] == 'Berhasil Update Data') {}
      } catch (e) {
        print(e);
        throw e;
      }

      setState(() {
        _isLoading = false;
      });
    }

    Future<void> updateData(
      context,
      String id,
      String jp,
      String mdPangkat,
      String nominal,
      String status,
      String tgl_mulai,
      String tgl_berakhir,
    ) {
      Size size = MediaQuery.of(context).size;
      double textMedium = size.width * 0.0329;
      double paddingHorizontalNarrow = size.width * 0.035;
      double padding5 = size.width * 0.0115;
      double padding7 = size.width * 0.018;
      double sizedBoxHeightShort = size.height * 0.0086;
      final double _maxHeightNrp = 40.0;
      double sizedBoxHeightTall = size.height * 0.0163;
      double paddingHorizontalWide = size.width * 0.0585;
      double _maxHeightAtasan = 60.0;
      DateTime dateTimeMulai = DateFormat("yyyy-MM-dd").parse(tgl_mulai);
      String formattedDateMulaiString =
          DateFormat("yyyy-MM-dd").format(dateTimeMulai);
      DateTime dateMulai =
          DateFormat("yyyy-MM-dd").parse(formattedDateMulaiString);

      DateTime dateTimeBerakhir = DateFormat("yyyy-MM-dd").parse(tgl_berakhir);
      String formattedDateBerakhirString =
          DateFormat("yyyy-MM-dd").format(dateTimeBerakhir);
      DateTime dateBerakhir =
          DateFormat("yyyy-MM-dd").parse(formattedDateBerakhirString);
      String valueId = id.toString();
      String valueJP = jp.toString();
      String valuePangkat = mdPangkat.toString();
      print('ini data get update: $valuePangkat');
      String valueNominal = nominal.toString();
      String valueStatus = status.toString();
      String valueTglMulai = dateMulai.toString();
      String valueTglBerakhir = dateBerakhir.toString();
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
              top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Jenis Penggantian *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Container(
                      height: 50,
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          "Pilih Jenis",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        validator: (value) =>
                            validateField(value, 'Pilih Jenis Pengganti'),
                        value: jp,
                        icon: selectedJP.isEmpty
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              )
                            : Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValueJP = newValue;
                            valueJP = newValue ?? '';
                            print("'selectedValueJP: $valueJP");
                          });
                        },
                        items: selectedJP.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value["id"].toString(),
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
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: selectedValueJP != null
                                  ? Colors.transparent
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  jp == '2'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Jenjang Kepangkatan *',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: MultiSelectDialogField(
                                initialValue: [mdPangkat],
                                buttonIcon: Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.grey[700],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                items: selectedPangkat
                                    .map((value) => MultiSelectItem<String>(
                                        value['kode'].toString(),
                                        value['nama']))
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (List<String> value) {
                                  selectedValuePangkat = value.toString();
                                  valuePangkat = value.toString();
                                  print('valuePangkat:$mdPangkat');
                                },
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: TitleWidget(
                                title: 'Jenjang Kepangkatan *',
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: Container(
                                height: 50,
                                width: size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingHorizontalNarrow),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: DropdownButtonFormField<String>(
                                  hint: Text(
                                    "Pilih Pangkat",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: textMedium,
                                    ),
                                  ),
                                  validator: (value) =>
                                      validateField(value, 'Pangkat'),
                                  value: mdPangkat,
                                  icon: selectedPangkat.isEmpty
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        )
                                      : Icon(Icons.arrow_drop_down),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValuePangkat = newValue ?? '';
                                      valuePangkat = newValue ?? '';
                                      print(
                                          "kode_pangkat: $_mdPangkatController");
                                    });
                                  },
                                  items: selectedPangkat
                                      .map<DropdownMenuItem<String>>(
                                          (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value["kode"] as String,
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
                                    constraints: BoxConstraints(
                                        maxHeight: _maxHeightAtasan),
                                    labelStyle: TextStyle(fontSize: textMedium),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: selectedValuePangkat != null
                                            ? Colors.transparent
                                            : Colors.transparent,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Nominal *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      initialValue: nominal,
                      validator: (value) => validateField(value, 'Nominal'),
                      onChanged: (value) {
                        setState(() {
                          valueNominal = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Nominal",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(
                          20.0,
                          10.0,
                          20.0,
                          10.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Status *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: Container(
                      height: 50,
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          'Pilih Status',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        validator: (value) => validateField(value, 'Status'),
                        value: status,
                        icon: selectedStatus.isEmpty
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
                            selectedValueStatus = newValue ?? '';
                            valueStatus = newValue ?? '';
                            print('selectedValueStatus: $selectedValueStatus');
                          });
                        },
                        items: selectedStatus.map((Map<String, dynamic> value) {
                          return DropdownMenuItem<String>(
                            value: value["id"].toString(),
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
                              BoxConstraints(maxHeight: maxHeightValidator),
                          labelStyle: TextStyle(fontSize: textMedium),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: selectedValueStatus != null
                                  ? Colors.transparent
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Tanggal mulai *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  CupertinoButton(
                    child: Container(
                      height: 50,
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
                            DateFormat('yyyy-MM-dd')
                                .format(dateMulai ?? DateTime.now()),
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
                                initialSelectedDate: dateMulai,
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs args) {
                                  setState(() {
                                    dateMulai = args.value;
                                  });
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                                initialDisplayDate: dateMulai,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  valueTglMulai = dateMulai.toString();
                                  print('Tanggal yang dipilih: $dateMulai');

                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TitleWidget(
                      title: 'Tanggal Berakhir *',
                      fontWeight: FontWeight.w300,
                      fontSize: textMedium,
                    ),
                  ),
                  CupertinoButton(
                    child: Container(
                      height: 50,
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
                            DateFormat('yyyy-MM-dd')
                                .format(dateBerakhir ?? DateTime.now()),
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
                                initialSelectedDate: dateBerakhir,
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs args) {
                                  setState(() {
                                    dateBerakhir = args.value;
                                  });
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                                initialDisplayDate: dateBerakhir,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    valueTglBerakhir = dateBerakhir.toString();
                                  });

                                  print('Tanggal yang dipilih: $dateBerakhir');

                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow, vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _submitUpdate(
                            valueId,
                            valueJP,
                            valuePangkat,
                            valueNominal,
                            valueStatus,
                            valueTglMulai,
                            valueTglBerakhir,
                          );
                          Navigator.pop(context);
                          fetchData(pageIndex: 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(primaryYellow),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: const Color(primaryBlack),
                              fontSize: textMedium,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget data() {
      List<dynamic> filteredData = _data.where((data) {
        String pangkat = data['pangkat'].toString().toLowerCase();
        String searchLower = _searchcontroller.text.toLowerCase();
        return pangkat.contains(searchLower);
      }).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Jenis')),
                  DataColumn(label: Text('Pangkat')),
                  DataColumn(label: Text('Nominal')),
                  DataColumn(label: Text('Tanggal Mulai')),
                  DataColumn(label: Text('Tanggal Berakhir')),
                  DataColumn(label: Text('Status')),
                  DataColumn(
                    label: Text(
                      "Aksi",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ],
                columnSpacing: 30,
                rows: filteredData.map((data) {
                  int index = _data.indexOf(data) + 1;
                  List<dynamic> dataChild = _subData
                      .where((item) => item['id_makan_pic'] == data['id'])
                      .toList();
                  Set<String> distinctDataChild = Set.from(dataChild
                      .map((subDataItem) => subDataItem['pangkat'].toString()));
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('$index')),
                      DataCell(Text(data['jenis'].toString())),
                      DataCell(
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: distinctDataChild.map((pangkat) {
                                return Text(pangkat);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(data['nominal'].toString())),
                      DataCell(
                        Text(DateFormat('dd-MM-yyyy')
                            .format(DateTime.parse(data['tgl_mulai']))),
                      ),
                      DataCell(
                        Text(DateFormat('dd-MM-yyyy')
                            .format(DateTime.parse(data['tgl_berakhir']))),
                      ),
                      DataCell(Text(
                          data['status'] == "1" ? 'Aktif' : 'Tidak Aktif')),
                      DataCell(
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    String id = data['id'].toString();
                                    String jp = data['kode_jp'].toString();
                                    List<dynamic> dataChild = _subData
                                        .where((item) =>
                                            item['id_makan_pic'] == data['id'])
                                        .toList();
                                    Set<String> distinctDataChild = Set.from(
                                        dataChild.map((subDataItem) =>
                                            subDataItem['kode_pangkat']
                                                .toString()));
                                    List<String> pangkatList =
                                        distinctDataChild.toList();
                                    String pangkat = pangkatList.join(',');
                                    String nominal = data['nominal'].toString();
                                    String status = data['status'];
                                    String tgl_mulai = data['tgl_mulai'];
                                    String tgl_berakhir = data['tgl_berakhir'];
                                    print(pangkat);
                                    print(status);
                                    updateData(
                                      context,
                                      id,
                                      jp,
                                      pangkat,
                                      nominal,
                                      status,
                                      tgl_mulai,
                                      tgl_berakhir,
                                    );
                                  },
                                  child: const Icon(Icons.edit,
                                      color: Colors.white)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Konfirmasi"),
                                        content: Text(
                                            "Apakah Anda yakin ingin menghapus ${data['kode']} ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              int id = data['id'];
                                              await deleteData(id);
                                              Navigator.of(context).pop();
                                              fetchData(pageIndex: 1);
                                            },
                                            child: Text("Hapus"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: content(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  data(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Showing",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(primaryYellow)),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _rowsPerPage,
                        onChanged: onRowsPerPageChanged,
                        items: [5, 10, 50, 100]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                      Text('of $_totalRecords'),
                      TextButton(
                        onPressed: prevPage,
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(primaryYellow),
                        ),
                      ),
                      Text('Page $_pageIndex'),
                      TextButton(
                        onPressed: nextPage,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(primaryYellow),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
