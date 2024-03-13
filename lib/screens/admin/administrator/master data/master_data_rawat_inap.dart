import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RawatInap extends StatefulWidget {
  const RawatInap({super.key});

  @override
  State<RawatInap> createState() => _RawatInapState();
}

class _RawatInapState extends State<RawatInap> {
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> selectedKategori = [];
  List<Map<String, dynamic>> selectedPangkat = [];
  List<Map<String, dynamic>> selectedSatuan = [];
  List<Map<String, dynamic>> selectedStatus = [];
  TextEditingController _searchcontroller = TextEditingController();
  TextEditingController _kodeController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  final TextEditingController _kursController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  final DateRangePickerController _tanggalMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;
  final DateRangePickerController _tanggalBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;
  String? selectedValueKategori,
      selectedValuePangkat,
      selectedValueSatuan,
      selectedValueStatus;

  int _rowsPerPage = 5;
  int _pageIndex = 1;
  int _totalRecords = 0;
  String searchQuery = '';
  List<dynamic> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    getDataKategori();
    getDataSatuan();
    getDataPangkat();
    getDataStatus();
  }

  Future<void> fetchData({
    int? pageIndex,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/master/rawat-inap/get?page=${pageIndex ?? _pageIndex}&perPage=$_rowsPerPage&search=$searchQuery'),
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['dataku'];
        final total = responseData["totalPage"];

        setState(() {
          _totalRecords = total['total_records'] ?? 0;

          if (pageIndex != null) {
            _data.clear();
          }

          _data.addAll(data);
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

  Future<void> getDataKategori() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/master/rawat-inap/kategori"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataKategoriApi = responseData['data'];
        print("$token");
        print("$dataKategoriApi");

        setState(
          () {
            selectedKategori = List<Map<String, dynamic>>.from(dataKategoriApi);
          },
        );
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  Future<void> getDataPangkat() async {
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
        final dataPangkatApi = responseData['data'];
        print("$token");
        print("$dataPangkatApi");

        setState(
          () {
            selectedPangkat = List<Map<String, dynamic>>.from(dataPangkatApi);
          },
        );
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  Future<void> getDataSatuan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/master/rawat-inap/satuan"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataSatuanApi = responseData['data'];
        print("$token");
        print("$dataSatuanApi");

        setState(
          () {
            selectedSatuan = List<Map<String, dynamic>>.from(dataSatuanApi);
          },
        );
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  Future<void> getDataStatus() async {
    // Your JSON string
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
      // Decode the JSON string
      final responseData = jsonDecode(jsonString);
      final dataStatusApi = responseData['data'];

      // Debugging purposes
      print('dataStatusApi: $dataStatusApi');

      // Assuming this is inside a StatefulWidget and you have access to setState
      setState(() {
        // Update your state with the new data
        selectedStatus = List<Map<String, dynamic>>.from(dataStatusApi);
      });
    } catch (e) {
      print(e); // Handle any errors here
      // Consider showing an error message in the UI
    }
  }

  void _filterData(String query) {
    setState(() {});
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
    double sizedBoxHeightTall = size.height * 0.0163;

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

    int? parseToInt(String value) {
      final int? intValue = int.tryParse(value);
      if (intValue == null) {
        return null;
      }
      return intValue;
    }

    Future<void> _submit() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print('click add');
      print(_formKey.currentState!.validate());

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
        final body = jsonEncode({
          'kode_kategori': selectedValueKategori.toString(),
          'kode_pangkat': selectedValuePangkat.toString(),
          'kode_satuan': selectedValueSatuan.toString(),
          'kurs': _kursController.text,
          'nominal': parseToInt(_nominalController.text),
          'status': selectedValueStatus.toString(),
          'tgl_mulai': tanggalMulai != null
              ? DateTime.utc(tanggalMulai!.year, tanggalMulai!.month,
                      tanggalMulai!.day)
                  .toIso8601String()
              : DateTime.utc(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 0, 0, 0, 0)
                  .toIso8601String(),
          'tgl_berakhir': tanggalBerakhir != null
              ? DateTime.utc(tanggalBerakhir!.year, tanggalBerakhir!.month,
                      tanggalBerakhir!.day)
                  .toIso8601String()
              : DateTime.utc(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 0, 0, 0, 0)
                  .toIso8601String(),
        });

        final response = await http.post(
          Uri.parse("$apiUrl/master/rawat-inap/add"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: body,
        );

        print('Request body: $body');

        final responseData = jsonDecode(response.body);

        print('response: $responseData');

        Get.snackbar('Infomation', responseData['success'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);

        if (responseData['success'] == 'Data telah ditambahkan') {}
      } catch (e) {
        print(e);
        rethrow;
      }

      setState(() {
        _isLoading = false;
      });
    }

    Future<void> _handleButtonAdd() {
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: paddingHorizontalNarrow,
                vertical: paddingHorizontalNarrow,
              ),
              height: 650,
              width: double.infinity,
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /* Kategori */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Kategori *',
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
                                'Pilih Kategori',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              validator: (value) =>
                                  validateField(value, 'Kategori'),
                              value: selectedValueKategori,
                              icon: selectedKategori.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValueKategori = newValue ?? '';
                                  print(
                                      'selectedValueKategori: $selectedValueKategori');
                                });
                              },
                              items: selectedKategori
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["id"].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value["nama"] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                    maxHeight: maxHeightValidator),
                                labelStyle: TextStyle(fontSize: textMedium),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: selectedValueKategori != null
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
                        /* Pangkat */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Pangkat *',
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
                                'Pilih Pangkat',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                  overflow: TextOverflow.ellipsis,
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
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValuePangkat = newValue ?? '';
                                  print(
                                      'selectedValuePangkat: $selectedValuePangkat');
                                });
                              },
                              items: selectedPangkat
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["kode"].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value["nama"] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                    maxHeight: maxHeightValidator),
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
                        const SizedBox(
                          height: 10,
                        ),
                        /* Satuan */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Satuan *',
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
                                'Pilih Satuan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              validator: (value) =>
                                  validateField(value, 'Satuan'),
                              value: selectedValueSatuan,
                              icon: selectedSatuan.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValueSatuan = newValue ?? '';
                                  print(
                                      'selectedValueSatuan: $selectedValueSatuan');
                                });
                              },
                              items: selectedSatuan
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["id"].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value["nama"] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                constraints: BoxConstraints(
                                    maxHeight: maxHeightValidator),
                                labelStyle: TextStyle(fontSize: textMedium),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: selectedValueSatuan != null
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
                        /* Kurs */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Kurs *',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TextFormField(
                            controller: _kursController,
                            keyboardType: TextInputType.number,
                            validator: (value) => validateField(value, 'Kurs'),
                            decoration: InputDecoration(
                              hintText: "Masukkan Kurs",
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
                                  20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /* Nominal */
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
                            controller: _nominalController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                validateField(value, 'Nominal'),
                            decoration: InputDecoration(
                              hintText: "Masukkan Nominal",
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
                                  20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /* Status */
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
                              validator: (value) =>
                                  validateField(value, 'Status'),
                              value: selectedValueStatus,
                              icon: selectedStatus.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValueStatus = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueStatus');
                                });
                              },
                              items: selectedStatus
                                  .map((Map<String, dynamic> value) {
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
                                constraints: BoxConstraints(
                                    maxHeight: maxHeightValidator),
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
                        /* Tanggal Mulai */
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
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        setState(() {
                                          tanggalMulai = args.value;
                                        });
                                        print('tanggalMulai: $tanggalMulai');
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
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        setState(() {
                                          tanggalBerakhir = args.value;
                                        });
                                        print(
                                            'tanggalBerakhir: $tanggalBerakhir');
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
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        SizedBox(
                          width: size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow,
                                vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _submit();
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
                                'Add',
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
                  ),
                ],
              ),
            );
          });
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

    Future<void> deleteData(String id) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');
      if (token != null) {
        try {
          final response =
              await http.post(Uri.parse("$apiUrl/master/rawat-inap/delete"),
                  headers: <String, String>{
                    'Content-Type': 'application/json;charset=UTF-8',
                    'Authorization': 'Bearer $token'
                  },
                  body: jsonEncode({'id': id}));
          final responseData = jsonDecode(response.body);
          if (response.statusCode == 200) {
            Get.snackbar('Infomation', responseData['success'],
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.amber,
                icon: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                shouldIconPulse: false);
            print('Item with id $id deleted successfully');
          } else {
            print("response error request: ${response.request}");
            throw Exception('Failed to delete item');
          }
        } catch (e) {
          print(e);
          rethrow;
        }
      }
    }

    Future<void> _submitUpdate(
      String textFieldValueKodeKategori,
      String textFieldValueKodePangkat,
      String textFieldValueKodeSatuan,
      String textFieldValueKurs,
      String textFieldValueNominal,
      String textFieldValueStatus,
      String textFieldValueTglMulai,
      String textFieldValueTglBerakhir,
      String textFieldValueId,
    ) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print('click update');
      print(_formKey.currentState!.validate());

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
        final body = jsonEncode({
          'kode_kategori': textFieldValueKodeKategori,
          'kode_pangkat': textFieldValueKodePangkat,
          'kode_satuan': textFieldValueKodeSatuan,
          'kurs': textFieldValueKurs,
          'nominal': parseToInt(textFieldValueNominal),
          'status': textFieldValueStatus,
          'tgl_mulai': textFieldValueTglMulai,
          'tgl_berakhir': textFieldValueTglBerakhir,
          'id': textFieldValueId,
        });

        final response = await http.post(
          Uri.parse("$apiUrl/master/rawat-inap/update"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: body,
        );

        final responseData = jsonDecode(response.body);

        print('response: $responseData');

        Get.snackbar('Infomation', responseData['success'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);

        if (responseData['success'] == 'Data has been updated') {
          Navigator.pop(context);
          fetchData(pageIndex: 1);
        }
      } catch (e) {
        print(e);
        rethrow;
      }

      setState(() {
        _isLoading = false;
      });
    }

    Future<void> updateData(
        context,
        String kodeKategori,
        String kodePangkat,
        String kodeSatuan,
        String kurs,
        String nominal,
        String status,
        String tglMulai,
        String tglBerakhir,
        String id) async {
      Size size = MediaQuery.of(context).size;
      double textMedium = size.width * 0.0329;
      double padding5 = size.width * 0.0115;
      double sizedBoxHeightTall = size.height * 0.0163;
      double paddingHorizontalNarrow = size.width * 0.035;
      double maxHeightAtasan = 60.0;

      DateTime dateTimeMulai = DateFormat("yyyy-MM-dd").parse(tglMulai);
      String formattedDateStringMulai =
          DateFormat("dd-MM-yyyy").format(dateTimeMulai);
      DateTime dateTimeMulaiFinal =
          DateFormat("dd-MM-yyyy").parse(formattedDateStringMulai);

      DateTime dateTimeAkhir = DateFormat("yyyy-MM-dd").parse(tglBerakhir);
      String formattedDateStringAkhir =
          DateFormat("dd-MM-yyyy").format(dateTimeAkhir);
      DateTime dateTimeAkhirFinal =
          DateFormat("dd-MM-yyyy").parse(formattedDateStringAkhir);

      String textFieldValueKodeKategori = kodeKategori.toString();
      String textFieldValueKodePangkat = kodePangkat.toString();
      String textFieldValueKodeSatuan = kodeSatuan.toString();
      String textFieldValueKurs = kurs;
      String textFieldValueNominal = nominal.toString();
      String textFieldValueStatus = status;
      String textFieldValueTglMulai = dateTimeMulaiFinal.toString();
      String textFieldValueTglBerakhir = dateTimeAkhirFinal.toString();
      String textFieldValueId = id.toString();

      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: paddingHorizontalNarrow,
                vertical: paddingHorizontalNarrow,
              ),
              height: 650,
              width: double.infinity,
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Kategori *',
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
                                'Pilih Kategori',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              validator: (value) =>
                                  validateField(value, 'Kategori'),
                              value: kodeKategori.toString(),
                              icon: selectedKategori.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  textFieldValueKodeKategori = newValue ?? '';
                                  print(
                                      'selectedValueKategori: $selectedValueKategori');
                                });
                              },
                              items: selectedKategori
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["id"].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value["nama"] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                constraints:
                                    BoxConstraints(maxHeight: maxHeightAtasan),
                                labelStyle: TextStyle(fontSize: textMedium),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: selectedValueKategori != null
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
                        /* Pangkat */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Pangkat *',
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
                                'Pilih Pangkat',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              validator: (value) =>
                                  validateField(value, 'Pangkat'),
                              value: kodePangkat.toString(),
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
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  textFieldValueKodePangkat = newValue ?? '';
                                  print(
                                      'selectedValuePangkat: $selectedValuePangkat');
                                });
                              },
                              items: selectedPangkat
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["kode"].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value["nama"] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                constraints:
                                    BoxConstraints(maxHeight: maxHeightAtasan),
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
                        const SizedBox(
                          height: 10,
                        ),
                        /* Satuan */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Satuan *',
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
                                'Pilih Satuan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              validator: (value) =>
                                  validateField(value, 'Satuan'),
                              value: kodeSatuan.toString(),
                              icon: selectedSatuan.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  textFieldValueKodeSatuan = newValue ?? '';
                                  print(
                                      'selectedValueSatuan: $selectedValueSatuan');
                                });
                              },
                              items: selectedSatuan
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["id"].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value["nama"] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                constraints:
                                    BoxConstraints(maxHeight: maxHeightAtasan),
                                labelStyle: TextStyle(fontSize: textMedium),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: selectedValueSatuan != null
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
                        /* Kurs */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'Kurs *',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) => validateField(value, 'Kurs'),
                            initialValue: kurs,
                            onChanged: (value) {
                              setState(() {
                                textFieldValueKurs = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Masukan Kurs",
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
                                  20.0, 10.0, 20.0, 10.0),
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
                            title: 'Nominal *',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                validateField(value, 'Nominal'),
                            initialValue: nominal,
                            onChanged: (value) {
                              setState(() {
                                textFieldValueNominal = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Masukan Nominal",
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
                                  20.0, 10.0, 20.0, 10.0),
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
                              validator: (value) =>
                                  validateField(value, 'Status'),
                              value: status,
                              icon: selectedStatus.isEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  textFieldValueStatus = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueStatus');
                                });
                              },
                              items: selectedStatus
                                  .map((Map<String, dynamic> value) {
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
                                    BoxConstraints(maxHeight: maxHeightAtasan),
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
                                  DateFormat('dd-MM-yyyy')
                                      .format(dateTimeMulaiFinal),
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
                                      initialSelectedDate: dateTimeMulaiFinal,
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        setState(() {
                                          dateTimeMulaiFinal = args.value;
                                        });
                                      },
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                      initialDisplayDate: dateTimeMulaiFinal,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        setState(() {});
                                        textFieldValueTglMulai =
                                            dateTimeMulaiFinal.toString();
                                        print(
                                            'dateTimeMulaiFinal: $dateTimeMulaiFinal');
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
                                  DateFormat('dd-MM-yyyy')
                                      .format(dateTimeAkhirFinal),
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
                                      initialSelectedDate: dateTimeAkhirFinal,
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        setState(() {
                                          dateTimeAkhirFinal = args.value;
                                        });
                                      },
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                      initialDisplayDate: dateTimeAkhirFinal,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        setState(() {});
                                        textFieldValueTglBerakhir =
                                            dateTimeAkhirFinal.toString();
                                        print(
                                            'dateTimeAkhirFinal: $dateTimeAkhirFinal');
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
                                _submitUpdate(
                                  textFieldValueKodeKategori,
                                  textFieldValueKodePangkat,
                                  textFieldValueKodeSatuan,
                                  textFieldValueKurs,
                                  textFieldValueNominal,
                                  textFieldValueStatus,
                                  textFieldValueTglMulai,
                                  textFieldValueTglBerakhir,
                                  textFieldValueId,
                                );
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
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    Widget data() {
      List<dynamic> filteredData = _data.where((data) {
        String kategori = data['kategori'].toString().toLowerCase();
        String satuan = data['satuan'].toString().toLowerCase();
        String searchLower = _searchcontroller.text.toLowerCase();
        return kategori.contains(searchLower) || satuan.contains(searchLower);
      }).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('No')),
                  DataColumn(
                    label: Text("Kategori"),
                  ),
                  DataColumn(
                    label: Text("Pangkat"),
                  ),
                  DataColumn(
                    label: Text("Satuan"),
                  ),
                  DataColumn(
                    label: Text("Kurs"),
                  ),
                  DataColumn(
                    label: Text("Nominal"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Tanggal Mulai"),
                  ),
                  DataColumn(
                    label: Text("Tanggal Berakhir"),
                  ),
                  DataColumn(
                    label: Text(
                      "Aksi",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                ],
                columnSpacing: 20,
                rows: filteredData.map((data) {
                  int index = _data.indexOf(data) + 1;
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('$index')),
                      DataCell(Text(data['kategori'] ?? '')),
                      DataCell(Text(data['pangkat'] ?? '')),
                      DataCell(Text(data['satuan'] ?? '')),
                      DataCell(Text(data['kurs'] ?? '')),
                      DataCell(Text(data['nominal'].toString())),
                      DataCell(Text(data['status'] ?? '')),
                      DataCell(Text(data['tgl_mulai'] ?? '')),
                      DataCell(Text(data['tgl_berakhir'] ?? '')),
                      DataCell(
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  String id = data['id'].toString();
                                  String kategori =
                                      data['kode_kategori'].toString();
                                  String pangkat =
                                      data['kode_pangkat'].toString();
                                  String satuan =
                                      data['kode_satuan'].toString();
                                  String kurs = data['kurs'];
                                  String nominal = data['nominal'].toString();
                                  String status = data['status'];
                                  String tglMulai = data['tgl_mulai'];
                                  String tglBerakhir = data['tgl_berakhir'];
                                  updateData(
                                    context,
                                    kategori,
                                    pangkat,
                                    satuan,
                                    kurs,
                                    nominal,
                                    status,
                                    tglMulai,
                                    tglBerakhir,
                                    id,
                                  );
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(Icons.edit,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Konfirmasi"),
                                        content: const Text(
                                            "Apakah Anda yakin ingin menghapus data ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String id = data['id'].toString();
                                              await deleteData(id);
                                              Navigator.of(context).pop();
                                              fetchData(pageIndex: 1);
                                            },
                                            child: const Text("Hapus"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
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
        preferredSize: const Size.fromHeight(190),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                surfaceTintColor: Colors.white,
                elevation: 0,
                backgroundColor: Colors.white,
                title: const Text('Master Data - Rawat Inap'),
              ),
              content(),
            ],
          ),
        ),
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
