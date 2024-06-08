import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/text_form_field_disable_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class KamarHotel extends StatefulWidget {
  const KamarHotel({super.key});

  @override
  State<KamarHotel> createState() => _KamarHotelState();
}

class _KamarHotelState extends State<KamarHotel> {
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> selectedPangkat = [];
  List<Map<String, dynamic>> selectedStatus = [];
  TextEditingController _searchcontroller = TextEditingController();
  TextEditingController _pangkatController = TextEditingController();
  TextEditingController _nominalController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  String? selectedValueStatus, selectedValuePangkat;

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    getDataMdPangkat();
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
      final ioClient = createIOClientWithInsecureConnection();

      final response = await ioClient.get(
        Uri.parse(
            '$apiUrl/master/kamar-hotel/get?page=${pageIndex ?? _pageIndex}&perPage=${rowPerPage ?? _rowsPerPage}&search=${searchQuery ?? _searchQuery}'),
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

  Future<void> getDataStatus() async {
    String jsonString = '''
    {
      "data": [
        {
          "id": "0",
          "nama": "Tidak Aktif"
        },
        {
          "id": "1",
          "nama": "Aktif"
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
    double padding5 = size.width * 0.0115;
    double maxHeightValidator = 60.0;
    double _maxHeightAtasan = 60.0;
    double sizedBoxHeightTall = size.height * 0.0163;

    Future<void> deleteData(String id) async {
      print('tombol delet bekerja dengan id :  $id');
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');
      print('ini token :  $token');
      if (token != null) {
        try {
          final ioClient = createIOClientWithInsecureConnection();

          final response = await ioClient.post(
              Uri.parse("$apiUrl/master/kamar-hotel/delete"),
              headers: <String, String>{
                'Content-Type': 'application/json;charset=UTF-8',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode({'id': id}));
          final responseData = jsonDecode(response.body);
          Get.snackbar('Infomation', responseData['success'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          if (response.statusCode == 200) {
            Navigator.pop(context);
            print('Item with id $id deleted successfully');
          } else {
            print("response error request: ${response.request}");
            throw Exception('Failed to delete item');
          }
        } catch (e) {
          print(e);
        }
      }
    }

    String? _validatorMdPangkat(dynamic value) {
      if (value == null || value.isEmpty) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Field Role Kosong';
      }

      setState(() {
        maxHeightValidator = 60.0;
      });
      return null;
    }

    String? _validatorNominal(dynamic value) {
      if (value == null || value.isEmpty) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Field Role Kosong';
      }

      setState(() {
        maxHeightValidator = 60.0;
      });
      return null;
    }

    String? _validatorStatus(dynamic value) {
      if (value == null || value.isEmpty) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Field Role Kosong';
      }

      setState(() {
        maxHeightValidator = 60.0;
      });
      return null;
    }

    Future<void> _submit() async {
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
      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.post(
          Uri.parse('$apiUrl/master/kamar-hotel/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'kode_pangkat': _pangkatController.text,
            'nominal': _nominalController.text,
            'status': _statusController.text,
            'tgl_berakhir': tanggalBerakhir != null
                ? tanggalBerakhir.toString()
                : DateTime.now().toString(),
            'tgl_mulai': tanggalMulai != null
                ? tanggalMulai.toString()
                : DateTime.now().toString(),
          }),
        );

        final responseData = jsonDecode(response.body);
        Get.snackbar('Infomation', responseData['success'],
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
        throw e;
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
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: paddingHorizontalNarrow,
                  vertical: paddingHorizontalNarrow,
                ),
                height: 550,
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
                                validator: _validatorMdPangkat,
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
                                    selectedValuePangkat = newValue;
                                    _pangkatController.text = newValue ?? '';
                                    print("$selectedValuePangkat");
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
                          const SizedBox(height: 10),
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
                              validator: _validatorNominal,
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
                          const SizedBox(height: 10),
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
                                validator: _validatorStatus,
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
                                    _statusController.text = newValue ?? '';
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
                          const SizedBox(height: 10),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    content: Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(
                                        _tanggalBerakhirController
                                                .selectedDate ??
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
                                    content: Container(
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
                                  horizontal: paddingHorizontalNarrow),
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
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    Widget content() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
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
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                  width: 5,
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
          ],
        ),
      );
    }

    Future<void> _submitUpdate(
        String valueTglBerakhir,
        String valueTglMulai,
        String valueNominal,
        String valueStatus,
        String valuePangkat,
        String id) async {
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

      try {
        final ioClient = createIOClientWithInsecureConnection();

        final response = await ioClient.post(
          Uri.parse('$apiUrl/master/kamar-hotel/update'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "id": id,
            "kode_pangkat": valuePangkat,
            "nominal": valueNominal,
            "status": valueStatus,
            "tgl_berakhir": valueTglBerakhir != null
                ? valueTglBerakhir.toString()
                : DateTime.now().toString(),
            "tgl_mulai": valueTglMulai != null
                ? valueTglMulai.toString()
                : DateTime.now().toString(),
          }),
        );

        final responseData = jsonDecode(response.body);
        Get.snackbar('Infomation', responseData['success'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);

        print(responseData);
        if (responseData['status'] == 'success') {}
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
      String pangkat,
      String nominal,
      String status,
      String tgl_mulai,
      String tgl_berakhir,
    ) async {
      Size size = MediaQuery.of(context).size;
      double textMedium = size.width * 0.0329;
      double paddingHorizontalNarrow = size.width * 0.035;
      double padding5 = size.width * 0.0115;
      double sizedBoxHeightTall = size.height * 0.0163;
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

      String valuePangkat = pangkat;
      String valueNominal = nominal;
      String valueStatus = status.toString();
      String valueTglMulai = dateMulai.toString();
      String valueTglBerakhir = dateBerakhir.toString();

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
              height: 550,
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
                              validator: _validatorMdPangkat,
                              value: pangkat,
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
                                  selectedValuePangkat = newValue;
                                  valuePangkat = newValue ?? '';
                                  print("$selectedValuePangkat");
                                });
                              },
                              items: selectedPangkat
                                  .map((Map<String, dynamic> value) {
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
                        const SizedBox(height: 10),
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
                            validator: _validatorNominal,
                            onChanged: (value) {
                              setState(() {
                                valueNominal = value;
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
                        const SizedBox(height: 10),
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
                              validator: _validatorStatus,
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
                                  valueStatus = newValue ?? '';
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
                        const SizedBox(height: 10),
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
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
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
                                        print(
                                            'Tanggal yang dipilih: $dateMulai');

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
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
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
                                        setState(() {});

                                        valueTglBerakhir =
                                            dateBerakhir.toString();
                                        print(
                                            'Tanggal yang dipilih: $dateBerakhir');

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
                                    valueTglBerakhir,
                                    valueTglMulai,
                                    valueNominal,
                                    valueStatus,
                                    valuePangkat,
                                    id);
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
                                'update',
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
                ],
              ),
            );
          });
    }

    Widget data() {
      List<dynamic> filteredData = _data.where((data) {
        String kodePangkat = data['pangkat'].toString().toLowerCase();
        String searchLower = _searchcontroller.text.toLowerCase();
        return kodePangkat.contains(searchLower);
      }).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Pangkat')),
                  DataColumn(label: Text('Nominal')),
                  DataColumn(label: Text('Tanggal Mulai')),
                  DataColumn(label: Text('Tanggal Berakhir')),
                  DataColumn(label: Text('Status')),
                  DataColumn(
                    label: Text("Aksi"),
                  ),
                ],
                columnSpacing: 20,
                rows: filteredData.map((data) {
                  int index = _data.indexOf(data) + 1;
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('$index')),
                      DataCell(Text(data['pangkat'].toString())),
                      DataCell(Text(data['nominal'].toString())),
                      DataCell(Text(DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(data['tgl_mulai'].toString())))),
                      DataCell(Text(DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(data['tgl_berakhir'].toString())))),
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
                                    String pangkat =
                                        data['kode_pangkat'].toString();
                                    String nominal = data['nominal'].toString();
                                    String status = data['status'];
                                    String tgl_mulai = data['tgl_mulai'];
                                    String tgl_berakhir = data['tgl_berakhir'];
                                    updateData(context, id, pangkat, nominal,
                                        status, tgl_mulai, tgl_berakhir);
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
                                            "Apakah Anda yakin ingin menghapus ${data['pangkat']} ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String id = data['id'].toString();
                                              await deleteData(id);
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
        preferredSize: const Size.fromHeight(190),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                surfaceTintColor: Colors.white,
                elevation: 0,
                backgroundColor: Colors.white,
                title: const Text('Master Data - Kamar Hotel'),
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
