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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Entitas extends StatefulWidget {
  const Entitas({super.key});

  @override
  State<Entitas> createState() => _EntitasState();
}

class _EntitasState extends State<Entitas> {
  late List<DataRow> _rows = [];
  List<Map<String, dynamic>> selectedRole = [];
  List<Map<String, dynamic>> selectedPangkat = [];
  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedAtasanDariAtasan = [];
  String? selectedValuePangkat, selectedValueRole;
  bool _isLoading = false;
  late int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  late int _rowCount = 0;
  late int _pageIndex = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String apiUrl = API_URL;
  double maxHeightValidator = 60.0;
  TextEditingController _kodeController = TextEditingController();
  TextEditingController _namaController = TextEditingController();

  final DateRangePickerController _tanggalJoinController =
      DateRangePickerController();
  DateTime? tanggalJoin;

  String? _validatorKode(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Nrp Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorNama(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Nama Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  Future<void> updateData(context, String kode, String nama) {
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

    String textFieldValueKode = kode;
    String textFieldValueNama = nama;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                child: TitleWidget(
                  title: 'Kode *',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                child: TextFormField(
                  initialValue: kode,
                  validator: _validatorKode,
                  onChanged: (value) {
                    setState(() {
                      textFieldValueKode = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Masukan Kode",
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
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                child: TitleWidget(
                  title: 'Nama *',
                  fontWeight: FontWeight.w300,
                  fontSize: textMedium,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                child: TextFormField(
                  initialValue: nama,
                  onChanged: (value) {
                    setState(() {
                      textFieldValueNama = nama;
                    });
                  },
                  validator: _validatorNama,
                  decoration: InputDecoration(
                    hintText: "Masukan Nama",
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
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
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
                        textFieldValueKode,
                        textFieldValueNama,
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
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitUpdate(
    String textFieldValueKode,
    String textFieldValueNama,
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

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/master/entity/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'kode': textFieldValueKode,
          'nama': textFieldValueNama,
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
        Navigator.pop(context);
        fetchData();
      }
    } catch (e) {
      print(e);
      throw e;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
        Uri.parse(
            "$apiUrl/master/entity/get?page=$_pageIndex&perPage=$_rowsPerPage&search="),
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData["dataku"];
      final total = responseData["totalPage"];
      _rowCount = total['total_records'] ?? 'null'.length;
      _rows = List.generate(
        data.length,
        (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(data[index]['kode'] ?? 'null')),
            DataCell(
              Container(
                width: 200,
                child: Text(
                  data[index]['nama'] ?? 'null',
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
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
                          String kode = data[index]['kode'];
                          String nama = data[index]['nama'];
                          updateData(context, kode, nama);
                        },
                        child: const Icon(Icons.edit, color: Colors.white)),
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
                                  "Apakah Anda yakin ingin menghapus ${data[index]['kode']} ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String kode = data[index]['kode'] ?? 'null';
                                    await deleteData(kode);
                                    Navigator.of(context).pop();
                                    // Panggil fetchData kembali setelah berhasil menghapus data
                                    // fetchData(searchQuery: searchQuery);
                                    // getData();
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
        ),
      );
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
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
      final response = await http.post(
        Uri.parse('$apiUrl/master/entity/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'kode': _kodeController.text,
          'nama': _namaController.text,
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
        Navigator.pop(context);
        // Get.toNamed('/admin/administrator/user_management/user_management');
      }
    } catch (e) {
      print(e);
      throw e;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteData(String kode) async {
    // print('tombol delet bekerja dengan nrp :  $nrp');
    // print('API  : $apiUrl/user-management/delete/nrp=$nrp');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    print('ini token :  $token');
    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse("$apiUrl/master/entity/delete"),
                headers: <String, String>{
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'kode': kode}));
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
          print('Item with Kode $kode deleted successfully');

          // Get.toNamed('/admin/administrator/user_management/user_management');
        } else {
          print("response error request: ${response.request}");
          throw Exception('Failed to delete item');
        }
        // print("$token");
        // print("$dataPangkatApi");
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Widget build(BuildContext context) {
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
    // double padding8 = size.width * 0.0188;
    // double padding10 = size.width * 0.023;
    List<DataRow>? filterData;

    bool _isLoading = false;

    @override
    void initState() {
      filterData = _rows;
      super.initState();
    }

    TextEditingController _searchcontroller = TextEditingController();

    _handleButtonAdd() {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
              top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Kode *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _kodeController,
                    validator: _validatorKode,
                    decoration: InputDecoration(
                      hintText: "Masukan Kode",
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
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TitleWidget(
                    title: 'Nama *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _namaController,
                    validator: _validatorNama,
                    decoration: InputDecoration(
                      hintText: "Masukan Nama",
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
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
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
                        _submit();
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
      );
    }

    Widget content() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      );
    }

    Widget data() {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
              child: Container(
                height: 50,
                width: 200,
                padding: const EdgeInsets.all(3),
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
                  onChanged: (value) {
                    // setState(() {
                    //   data = filterData!
                    //       .where((element) => element.nama.contains(value))
                    //       .toList();
                    // });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            PaginatedDataTable(
              rowsPerPage: _rowsPerPage,
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage = value!;
                });
              },
              onPageChanged: (pageIndex) {
                setState(() {
                  _pageIndex = pageIndex + 1;
                  fetchData(); // Fetch data for the new page
                });
              },
              columnSpacing: 10,
              availableRowsPerPage: const [
                5,
                10,
                50,
                100,
              ], // Choose rows per page
              source: MyDataTableSource(
                rows: _rows,
                rowCount: _rowCount,
                pageIndex: _pageIndex,
                rowsPerPage: _rowsPerPage,
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    "No",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Kode",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Nama",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Aksi",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Master Data - Entitas'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          content(),
          data(),
        ],
      )),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<DataRow> rows;
  final int rowCount;
  final int pageIndex;
  final int rowsPerPage;

  MyDataTableSource({
    required this.rows,
    required this.rowCount,
    required this.pageIndex,
    required this.rowsPerPage,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    final data = rows[index];
    return data;
  }

  @override
  int get _rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
// entitas