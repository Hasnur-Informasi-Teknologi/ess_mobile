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

class CutiBersama extends StatefulWidget {
  const CutiBersama({super.key});

  @override
  State<CutiBersama> createState() => _CutiBersamaState();
}

class _CutiBersamaState extends State<CutiBersama> {
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchcontroller = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _jmlHariController = TextEditingController();
  final DateRangePickerController _tanggalMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;
  final DateRangePickerController _tanggalBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;
  double maxHeightValidator = 60.0;
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
            '$apiUrl/master/cuti-bersama/get?page=${pageIndex ?? _pageIndex}&perPage=$_rowsPerPage&search=$searchQuery'),
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

  String? _validatorDeskripsi(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Deskripsi Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double textMedium = size.width * 0.0329;
    double padding5 = size.width * 0.0115;
    double maxHeightValidator = 60.0;
    double sizedBoxHeightTall = size.height * 0.0163;

    String? _validatorJmlHari(dynamic value) {
      if (value == null || value.isEmpty) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Field Jumlah Hari Kosong';
      } else if (int.tryParse(value) == null) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Field Jumlah Hari harus angka';
      } else if (int.parse(value) <= 0) {
        setState(() {
          maxHeightValidator = 80.0;
        });
        return 'Jumlah Hari harus lebih besar dari 0';
      }

      setState(() {
        maxHeightValidator = 60.0;
      });
      return null;
    }

    int? parseJumlahHari(String value) {
      // Convert jumlahHari to an integer.
      final int? jumlahHariInt = int.tryParse(value);
      if (jumlahHariInt == null) {
        // Handle the error, maybe show a snackbar message indicating invalid input.
        return null;
      }
      return jumlahHariInt;
    }

    Future<void> _submit(void reset) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final int? jmlHariInt = parseJumlahHari(_jmlHariController.text);

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
        final response = await http.post(
          Uri.parse("$apiUrl/master/cuti-bersama/add"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'deskripsi': _deskripsiController.text,
            'jml_hari': jmlHariInt,
            'tgl_mulai': tanggalMulai != null
                ? tanggalMulai.toString()
                : DateTime.now().toString(),
            'tgl_berakhir': tanggalBerakhir != null
                ? tanggalBerakhir.toString()
                : DateTime.now().toString(),
          }),
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

        if (responseData['success'] == 'Data telah ditambahkan') {
          Navigator.pop(context);
          fetchData();
        }
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
                    title: 'Deskripsi *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _deskripsiController,
                    validator: _validatorDeskripsi,
                    decoration: InputDecoration(
                      hintText: "Masukkan Deskripsi",
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
                    title: 'Jumlah Hari *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _jmlHariController,
                    keyboardType: TextInputType.number,
                    validator: _validatorJmlHari,
                    decoration: InputDecoration(
                      hintText: "Masukkan Jumlah Hari",
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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _submit(_formKey.currentState!.reset());
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
              ],
            ),
          ),
        ),
      );
    }

    Future<void> deleteData(String id) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');
      if (token != null) {
        try {
          final response =
              await http.post(Uri.parse("$apiUrl/master/cuti-bersama/delete"),
                  headers: <String, String>{
                    'Content-Type': 'application/json;charset=UTF-8',
                    'Authorization': 'Bearer $token'
                  },
                  body: jsonEncode({'id': id}));
          if (response.statusCode == 200) {
            Get.snackbar('Infomation', 'Berhasil Hapus Data',
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
      String textFieldValueId,
      String textFieldValueDeskripsi,
      String textFieldValueJmlHari,
      String textFieldValueTglMulai,
      String textFieldValueTglBerakhir,
    ) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final int? jmlHariInt = parseJumlahHari(textFieldValueJmlHari);

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
        final response = await http.post(
          Uri.parse("$apiUrl/master/cuti-bersama/update"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'id': textFieldValueId,
            'deskripsi': textFieldValueDeskripsi,
            'jml_hari': jmlHariInt,
            'tgl_mulai': textFieldValueTglMulai.toString(),
            'tgl_berakhir': textFieldValueTglBerakhir.toString()
          }),
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
      String id,
      String deskripsi,
      String jmlHari,
      String tglMulai,
      String tglBerakhir,
    ) async {
      Size size = MediaQuery.of(context).size;
      double textMedium = size.width * 0.0329;
      double padding5 = size.width * 0.0115;
      double paddingHorizontalNarrow = size.width * 0.035;

      DateTime dateTimeAwal = DateFormat("yyyy-MM-dd").parse(tglMulai);
      String formattedDateStringAwal =
          DateFormat("dd-MM-yyyy").format(dateTimeAwal);
      DateTime dateTimeAwalFinal =
          DateFormat("dd-MM-yyyy").parse(formattedDateStringAwal);

      DateTime dateTimeAkhir = DateFormat("yyyy-MM-dd").parse(tglBerakhir);
      String formattedDateStringAkhir =
          DateFormat("dd-MM-yyyy").format(dateTimeAkhir);
      DateTime dateTimeAkhirFinal =
          DateFormat("dd-MM-yyyy").parse(formattedDateStringAkhir);

      String textFieldValueId = id.toString();
      String textFieldValueDeskripsi = deskripsi;
      String textFieldValueJmlHari = jmlHari.toString();
      String textFieldValueTglMulai = dateTimeAwalFinal.toString();
      String textFieldValueTglBerakhir = dateTimeAkhirFinal.toString();

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
                    title: 'Deskripsi *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    validator: _validatorDeskripsi,
                    initialValue: deskripsi,
                    onChanged: (value) => {
                      setState(() {
                        textFieldValueDeskripsi = value;
                      })
                    },
                    decoration: InputDecoration(
                      hintText: "Masukkan Deskripsi",
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
                    title: 'Jumlah Hari *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: _validatorJmlHari,
                    initialValue: jmlHari,
                    onChanged: (value) => {
                      setState(() {
                        textFieldValueJmlHari = value;
                      })
                    },
                    decoration: InputDecoration(
                      hintText: "Masukkan Jumlah Hari",
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
                          DateFormat('dd-MM-yyyy').format(dateTimeAwalFinal),
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
                              initialSelectedDate: dateTimeAwalFinal,
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                setState(() {
                                  dateTimeAwalFinal = args.value;
                                });
                              },
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                              initialDisplayDate: dateTimeAwalFinal,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {});
                                textFieldValueTglMulai =
                                    dateTimeAwalFinal.toString();

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
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
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
                          DateFormat('dd-MM-yyyy').format(dateTimeAkhirFinal),
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
                                  (DateRangePickerSelectionChangedArgs args) {
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
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _submitUpdate(
                          textFieldValueId,
                          textFieldValueDeskripsi,
                          textFieldValueJmlHari,
                          textFieldValueTglMulai,
                          textFieldValueTglBerakhir,
                        );

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

    Widget data() {
      List<dynamic> filteredData = _data.where((data) {
        String deskripsi = data['deskripsi'].toString().toLowerCase();
        String searchLower = _searchcontroller.text.toLowerCase();
        return deskripsi.contains(searchLower);
      }).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      "No",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Deskripsi",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Jumlah Hari",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Tanggal Mulai",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Tanggal Berakhir",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Aksi",
                    ),
                  ),
                ],
                columnSpacing: 20,
                rows: filteredData.map((data) {
                  int index = _data.indexOf(data) + 1;
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('$index')),
                      DataCell(Text(data['deskripsi'] ?? 'null')),
                      DataCell(TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Center(
                              child: Text(data['jml_hari'].toString())))),
                      DataCell(Text(data['tgl_mulai'] ?? 'null')),
                      DataCell(Text(data['tgl_berakhir'] ?? 'null')),
                      DataCell(
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  String id = data['id'].toString();
                                  String deskripsi = data['deskripsi'];
                                  String jmlHari = data['jml_hari'].toString();
                                  String tglMulai = data['tgl_mulai'];
                                  String tglBerakhir = data['tgl_berakhir'];
                                  updateData(context, id, deskripsi, jmlHari,
                                      tglMulai, tglBerakhir);
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
                                              fetchData();
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
                title: const Text('Master Data - Cuti Bersama'),
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
