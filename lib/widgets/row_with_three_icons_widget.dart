import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/dokument_model.dart';
import 'package:mobile_ess/screens/user/home/documents/documents_detail.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RowWithThreeIconsWidget extends StatefulWidget {
  const RowWithThreeIconsWidget({Key? key}) : super(key: key);

  @override
  _RowWithThreeIconsWidgetState createState() =>
      _RowWithThreeIconsWidgetState();
}

class _RowWithThreeIconsWidgetState extends State<RowWithThreeIconsWidget> {
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int currentPage = 1;
  final int perPage = 8;
  List<Map<String, dynamic>> selectedTypeDok = [];
  List<Map<String, dynamic>> selectedTipeDok = [];
  final _entitasController = TextEditingController();
  bool _isFileNull = false;
  List<PlatformFile>? _files;
  bool _isLoading = false;
  String? selectedType = '1', selectedValueTipeDok;
  late List<DokumenModel> dokumens = [];
  late List<String> tipeDokumen = [];

  Future<void> getTipeDokumen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse("$apiUrl/dokumen-perusahaan/md_tipe_dokumen"),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data_filter'];
      final List<dynamic> tipeDok = responseData['data'];
      print(data);
      setState(() {
        selectedTypeDok = List<Map<String, dynamic>>.from(data);
        selectedTipeDok = List<Map<String, dynamic>>.from(tipeDok);
        tipeDokumen =
            data.map((item) => item['tipe_dokumen'].toString()).toList();

        if (tipeDokumen.contains('1')) {
          selectedType = '1';
        }
      });
      getDataDocuments(currentPage, selectedType);
    } else {
      throw Exception('Failed to load tipe dokumen');
    }
  }

  Future<void> getDataDocuments(int currentPage, String? selectedType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse(
            "$apiUrl/dokumen-perusahaan/get?page=$currentPage&perPage=$perPage&search=&status=ALL&tipe=$selectedType"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        setState(() {
          dokumens = data.map((item) => DokumenModel.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load dokumen');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _files = result.files;
        _isFileNull = false;
      });
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File $fileName telah diunduh'),
      ),
    );
  }

  Future _submit(void reset) async {
    String apiUrl = API_URL;
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
    String? filePath;

    if (_files != null) {
      filePath = _files!.single.path;
      setState(() {
        _isFileNull = false;
      });
    } else {
      setState(() {
        _isFileNull = true;
        _isLoading = false;
      });
      return;
    }
    File file = File(filePath!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/dokumen-perusahaan/add'),
    );

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/dokumen-perusahaan/add'),
        headers: <String, String>{
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'tipe_dokumen': selectedValueTipeDok,
          'entitas': _entitasController.text,
          'lampiran': request.files.add(http.MultipartFile.fromBytes(
              'lampiran', file.readAsBytesSync(),
              filename: file.path.split('/').last)),
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
      }
    } catch (e) {
      print(e);
      throw e;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTipeDokumen();
    getDataDocuments(currentPage, selectedType);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;
    double textMedium = size.width * 0.0329;
    Future<void> handleButtonAdd() {
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
                    title: 'Tipe Dokumen *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: Container(
                    height: 55,
                    child: DropdownButtonFormField<String>(
                      hint: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Pilih Tipe Dokumen',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      value: selectedValueTipeDok,
                      icon: selectedTipeDok.isEmpty
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            )
                          : const Icon(Icons.arrow_drop_down),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValueTipeDok = newValue;
                          print(selectedValueTipeDok);
                        });
                      },
                      items: selectedTipeDok.map((Map<String, dynamic> value) {
                        return DropdownMenuItem<String>(
                          value: value["id"].toString() as String,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              value["tipe_dokumen"] as String,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 12),
                        focusedBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
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
                    title: 'Entitas *',
                    fontWeight: FontWeight.w300,
                    fontSize: textMedium,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
                  child: TextFormField(
                    controller: _entitasController,
                    validator: null,
                    decoration: InputDecoration(
                      hintText: "Cari Entitas",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWidget(
                        title: 'Lampiran Dokumen : *',
                        fontWeight: FontWeight.w300,
                        fontSize: textMedium,
                      ),
                      const Text(
                        'File Maximal 15MB',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
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
                              // subtitle: Text('${file.size} bytes'),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _submit(_formKey.currentState!.reset());
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
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: const Color(primaryYellow),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  handleButtonAdd();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.create_new_folder_sharp,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Upload',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 180,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedType,
                icon: selectedTypeDok.isEmpty
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                    : Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                    getDataDocuments(currentPage, selectedType);
                    print(selectedType);
                    print(
                        "$apiUrl/dokumen-perusahaan/get?page=$currentPage&perPage=$perPage&search=&status=ALL&tipe=$selectedType");
                  });
                },
                items: selectedTypeDok.map((Map<String, dynamic> value) {
                  return DropdownMenuItem<String>(
                    value: value["id"].toString(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        value["tipe_dokumen"] as String,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 12),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: selectedType != null
                          ? Colors.transparent
                          : Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              dokumens.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dokumens.length,
                      itemBuilder: (context, index) {
                        DokumenModel dokumen = dokumens[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Column(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 100,
                                ),
                                Text(dokumen.fileName),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      child: Icon(Icons.remove_red_eye),
                                      onTap: () {
                                        // Tambahkan aksi untuk melihat detail dokumen
                                      },
                                    ),
                                    GestureDetector(
                                      child: Icon(Icons.download_sharp),
                                      onTap: () {
                                        downloadFile(
                                            dokumen.lampiran, dokumen.fileName);
                                      },
                                    ),
                                    Icon(Icons.delete),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              // Handle onTap event
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (currentPage > 1) {
                        setState(() {
                          currentPage--;
                        });
                        getDataDocuments(currentPage, selectedType);
                        print(currentPage);
                      }
                    },
                    child: Text('Previous Page'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage++;
                      });
                      getDataDocuments(currentPage, selectedType);
                      print(currentPage);
                    },
                    child: Text('Next Page'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
