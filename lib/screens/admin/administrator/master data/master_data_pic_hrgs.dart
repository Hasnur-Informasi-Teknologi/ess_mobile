import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Replace API_URL with your actual API URL

class PicHrgs extends StatefulWidget {
  const PicHrgs({Key? key}) : super(key: key);

  @override
  _PicHrgsState createState() => _PicHrgsState();
}

class Item {
  final int idx;
  final String kode;
  final String nama;
  bool isSelected;

  Item(
      {required this.idx,
      required this.kode,
      required this.nama,
      this.isSelected = false});
}

class _PicHrgsState extends State<PicHrgs> {
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, List<Map<String, dynamic>>> entitiesById = {};
  List<Map<String, dynamic>> nrpCollection = [];
  int _rowsPerPage = 5;
  int _pageIndex = 1;
  int _totalRecords = 0;
  String _searchQuery = '';
  String? selectedValueNrp;
  final List<dynamic> _data = [];
  List<Item> _items = [];
  bool isSelected = false;
  bool _isLoading = false;
  final TextEditingController _searchcontroller = TextEditingController();
  double maxHeightValidator = 60.0;

  @override
  void initState() {
    super.initState();
    fetchData();
    getDataAllEntitas();
  }

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

  Future<void> fetchData({
    int? pageIndex,
    int? rowPerPage,
    String? searchQuery,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    List<Map<String, dynamic>> allData = [];

    setState(() {
      _isLoading = true;
    });

    // Fetch all data without limiting rows per page
    if (pageIndex == null) {
      try {
        final response = await http.get(
          Uri.parse(
              '$apiUrl/master/hrgs/get?page=1&perPage=999999999&search=$searchQuery'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)['dataku'];
          List<Map<String, dynamic>> fetchedData =
              List<Map<String, dynamic>>.from(data);

          // Remove items where the name is null
          fetchedData.removeWhere((item) => item['nama'] == null);

          allData.addAll(fetchedData);

          setState(() {
            nrpCollection = allData;
          });
        } else {
          throw Exception('Failed to load data from API');
        }
      } catch (e) {
        print('Error: $e');
        rethrow;
      }
    }

    // Continue with the current fetch implementation
    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/master/hrgs/get?page=${pageIndex ?? _pageIndex}&perPage=${rowPerPage ?? _rowsPerPage}&search=${searchQuery ?? _searchQuery}'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['dataku'];
        final total = responseData['totalPage'];

        for (var item in data) {
          await getDataEntitasByID(item['id'].toString());
        }

        setState(() {
          _totalRecords = total['total_records'] ?? 0;

          if (pageIndex != null) {
            _data.clear();
          }

          _data.addAll(data);
          _isLoading = false;
        });

        print('nrpCollection, $nrpCollection');
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> getDataAllEntitas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/master/entitas'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> items = responseData['data'];
        print(responseData);
        List<Item> fetchedItems = [];
        int index = 0;
        for (var item in items) {
          fetchedItems
              .add(Item(idx: index++, kode: item['kode'], nama: item['nama']));
        }
        setState(() {
          _items = fetchedItems;
        });
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> getDataEntitasByID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$apiUrl/master/hrgs/get_entitas?id=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
        );
        final responseData = jsonDecode(response.body);
        final dataEntitasApi = responseData['dataku'];

        entitiesById[id] = List<Map<String, dynamic>>.from(dataEntitasApi);
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  Future<void> deleteData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse('$apiUrl/master/hrgs/delete'),
                headers: <String, String>{
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'id': id}));
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Get.snackbar('Infomation', responseData['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          print('Item with id $id deleted successfully');
        } else {
          print('response error request: ${response.request}');
          throw Exception('Failed to delete item');
        }
      } catch (e) {
        print(e);
        rethrow;
      }
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

  Future<void> updateData(
      context, String id, String nama, String nrp, String entitas) async {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double paddingHorizontalNarrow = size.width * 0.035;
    double maxHeightValidator = 60.0;

    String textFieldValueId = id.toString();
    String textFieldValueNama = nama;
    String textFieldValueNrp = nrp;
    String textFieldValueSelectedEntitas = entitas.toString();

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
              height: 700,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* NRP */
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TitleWidget(
                          title: 'NRP *',
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
                          child: Center(
                            child: DropdownButtonFormField<String>(
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
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              hint: Text(
                                'Pilih NRP',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              validator: (value) => validateField(value, 'NRP'),
                              value: nrp.toString(),
                              icon: nrpCollection.isEmpty
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
                                  textFieldValueNrp = newValue ?? '';
                                  print('selectedValueNrp: $textFieldValueNrp');
                                });
                              },
                              items: nrpCollection
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value['nrp'],
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Text(
                                      value['nrp'] + '   -   ' + value['nama']
                                          as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: textMedium * 0.9,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
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
                          title: 'Entitas *',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(_items[index].kode),
                              value: _items[index].isSelected,
                              onChanged: (value) {
                                setState(() {
                                  _items[index].isSelected = value!;
                                });
                              },
                            );
                          },
                        ),
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
                              _submitUpdate(
                                  textFieldValueId,
                                  textFieldValueNama,
                                  textFieldValueNrp,
                                  textFieldValueSelectedEntitas);
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitUpdate(
    String textFieldValueId,
    String textFieldValueNama,
    String textFieldValueNrp,
    String textFieldValueSelectedEntitas,
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
        'id': textFieldValueId,
        'nama': textFieldValueNama,
        'nrp': textFieldValueNrp,
        'selectedItems': textFieldValueSelectedEntitas,
      });

      final response = await http.post(
        Uri.parse('$apiUrl/master/hrgs/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);

      print('response: $responseData');

      Get.snackbar('Infomation', responseData['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.amber,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);

      if (responseData['message'] == 'Update PIC Berhasil diupdate') {
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double sizedBoxHeightTall = size.height * 0.0163;
    double textMedium = size.width * 0.0329;

    Future<void> submit() async {
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
          Uri.parse('$apiUrl/master/hrgs/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'nrp': selectedValueNrp,
            for (var item in _items.where((item) => item.isSelected))
              'selectedItems[${item.idx}][kode]': item.kode,
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
        if (responseData['message'] == 'Tambah PIC Gagal, NRP sudah ada') {
          setState(() {
            for (var element in _items) {
              element.isSelected = false;
            }
          });
        } else if (responseData['message'] == 'Tambah PIC Berhasil') {
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

    Future<void> handleButtonAdd() {
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
                height: 700,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TitleWidget(
                            title: 'NRP *',
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
                            child: Center(
                              child: DropdownButtonFormField<String>(
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
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                hint: Text(
                                  'Pilih NRP',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: textMedium,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                validator: (value) =>
                                    validateField(value, 'NRP'),
                                value: selectedValueNrp,
                                icon: nrpCollection.isEmpty
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
                                    selectedValueNrp = newValue ?? '';
                                    print(
                                        'selectedValueNrp: $selectedValueNrp');
                                  });
                                },
                                items: nrpCollection
                                    .map((Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['nrp'],
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        (value['nrp'] ?? 'null') +
                                            '   -   ' +
                                            (value['nama'] ?? 'null'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: textMedium * 0.9,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }).toList(),
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
                            title: 'Entitas *',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(_items[index].kode),
                                value: _items[index].isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    _items[index].isSelected = value!;
                                  });
                                },
                              );
                            },
                          ),
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
                                submit();
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
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(primaryYellow),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: handleButtonAdd,
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
            SizedBox(
              height: 50,
              width: 200,
              child: TextField(
                controller: _searchcontroller,
                decoration: const InputDecoration(
                  labelText: 'Search',
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
        String nrp = data['nrp'].toString().toLowerCase();
        String nama = data['nama'].toString().toLowerCase();
        String searchLower = _searchcontroller.text.toLowerCase();
        return nrp.contains(searchLower) || nama.contains(searchLower);
      }).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('No')),
                DataColumn(label: Text('NRP')),
                DataColumn(label: Text('Nama')),
                DataColumn(
                  label: Text(
                    'Aksi',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
              columnSpacing: 20,
              rows: filteredData.map((data) {
                int index = _data.indexOf(data) + 1;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text('$index')),
                    DataCell(Text(data['nrp'] ?? 'null')),
                    DataCell(Text(data['nama'] ?? 'null')),
                    DataCell(
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                String id = data['id'].toString();
                                String nrp = data['nrp'];
                                String nama = data['nama'];
                                updateData(context, id, nrp, nama, '');
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child:
                                    const Icon(Icons.edit, color: Colors.white),
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
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus data ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            String id = data['id'].toString();
                                            await deleteData(id);
                                            Navigator.of(context).pop();
                                            fetchData(pageIndex: 1);
                                          },
                                          child: const Text('Hapus'),
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
                title: const Text('Master Data - PIC HRGS'),
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
                        'Showing',
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
