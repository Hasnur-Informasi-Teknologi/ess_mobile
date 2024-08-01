import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/line_widget.dart';
import 'package:mobile_ess/widgets/title_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> selectedEntitas = [];
  List<String> selectedValueEntitas = [];
  List<Map<String, dynamic>> selectedDocumentType = [];
  // tipe dokumen versi object
  Map<String, dynamic> selectedValueDocumentTypeObject = {};
  // tipe dokumen versi string
  String? selectedValueDocumentTypeString;
  List<Map<String, dynamic>> selectedDocument = [];
  PlatformFile? _files;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoadingDocumentType = false;
  bool _isLoadingDocument = false;
  bool _isLoadingEntitas = true;
  bool _isAllSelected = false;
  bool _isOpenUploadForm = false;
  bool _isLoading = false;
  bool _isFileNull = false;

  int page = 1;
  int perPage = 8;
  double _sizeKbs = 0;
  final int maxSizeKbs = 1024;
  final String apiUrl = API_URL;

  void onSelectAll(bool? value) {
    setState(() {
      _isAllSelected = value ?? false;
      if (_isAllSelected) {
        selectedValueEntitas = selectedEntitas
            .map((e) => e['kode'] as String?)
            .where((kode) => kode != null)
            .map((kode) => kode!)
            .toList();
      } else {
        selectedValueEntitas.clear();
      }

      for (var entitas in selectedEntitas) {
        entitas['selected'] = _isAllSelected;
      }
    });

    debugPrint('Selected Value Entitas All: $selectedValueEntitas');
  }

  void onSelectItem(bool? value, String kode) {
    setState(() {
      if (value == true) {
        selectedValueEntitas.add(kode);
      } else {
        selectedValueEntitas.remove(kode);
      }

      for (var entitas in selectedEntitas) {
        if (entitas['kode'] == kode) {
          entitas['selected'] = value;
          break;
        }
      }
    });

    debugPrint('Selected Value Entitas Item: $selectedValueEntitas');
  }

  Future<void> getDataEntitas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingEntitas = true;
      });

      try {
        final response = await http.get(
            Uri.parse('$apiUrl/dokumen-perusahaan/entitas'),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataEntitas = responseData['data'];

        setState(() {
          selectedEntitas = List<Map<String, dynamic>>.from(dataEntitas);
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingEntitas = false;
        });
      }
    }
  }

  Future<void> getTipeDokumen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingDocumentType = true;
      });

      try {
        final response = await http.get(
            Uri.parse("$apiUrl/dokumen-perusahaan/md_tipe_dokumen"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          selectedDocumentType = List<Map<String, dynamic>>.from(
            data,
          );
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingDocumentType = false;
        });
      }
    }
  }

  Future<void> getDataDokumen(int page, int perPage, String documentType,
      [String search = '']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _isLoadingDocument = true;
      });

      try {
        final response = await http.get(
            Uri.parse(
                "$apiUrl/dokumen-perusahaan/get?page=$page&perPage=$perPage&search=$search&status=ALL&tipe=$documentType"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        setState(() {
          selectedDocument = List<Map<String, dynamic>>.from(
            data,
          );
        });
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      } finally {
        setState(() {
          _isLoadingDocument = false;
        });
      }
    }
  }

  Future<void> getDetailDokumen(String uuid, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/dokumen-perusahaan/preview?id=$uuid"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token',
            });
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];

        // Assuming 'lampiran' contains the base64 encoded string
        final bytes1 = base64.decode(data['lampiran'].replaceAll('\n', ''));
        final data1 = utf8.decode(bytes1);
        final bytes2 = base64.decode(data1);
        final String fileName = data['file_name'];

        // Save the decoded bytes as a file
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes2);

        if (action == 'download') {
          // Download the file
          downloadFile(file.path, fileName);
        } else if (action == 'preview') {
          // Open the file
          print(file.path);
          await OpenFile.open(file.path);
        }
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<void> downloadFile(String filePath, String fileName) async {
    final bytes = File(filePath).readAsBytesSync();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    debugPrint('File path: ${file.path}');
    debugPrint('Filename: $fileName');
    await file.writeAsBytes(bytes);
    Get.snackbar('Information', 'File $fileName telah diunduh',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false);
  }

  Future<void> deleteDokumen(BuildContext context, String id) async {
    bool? confirmDelete = await showDeleteConfirmationDialog(context);
    if (!confirmDelete) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse("$apiUrl/dokumen-perusahaan/delete"),
                headers: <String, String>{
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'id': id}));
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          Get.snackbar('Infomation', responseData['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
        } else {
          debugPrint("response error request: ${response.request}");
          throw Exception('Failed to delete item');
        }
      } catch (e) {
        debugPrint('Error: $e');
        rethrow;
      }
    }
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content:
                  const Text('Apakah kamu yakin ingin menghapus dokumen ini?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tidak'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child:
                      const Text('Iya', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withReadStream: true,
    );

    if (result != null) {
      final size = result.files.first.size;
      _sizeKbs = size / 1024;
      if (_sizeKbs > maxSizeKbs) {
        _isFileNull = true;
        Get.snackbar(
          'File Tidak Valid',
          'Ukuran file melebihi batas maksimum yang diizinkan sebesar 5 MB.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      } else {
        setState(() {
          _files = result.files.single;
          _isFileNull = false;
        });
        Get.snackbar(
          'Success',
          'File berhasil diproses.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (selectedValueDocumentTypeString == null ||
        selectedValueEntitas.isEmpty ||
        _files == null) {
      Get.snackbar(
        'Infomation',
        'Harap isi semua field',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 4),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/dokumen-perusahaan/add'),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'tipe_dokumen': selectedValueDocumentTypeString.toString(),
      'entitas': jsonEncode(selectedValueEntitas),
    });

    if (_files != null) {
      File file = File(_files!.path!);
      request.files.add(http.MultipartFile(
          'lampiran', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }

    debugPrint('Request: ${request.fields}');
    debugPrint('Request: ${request.files}');

    try {
      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      final responseDataMessage = json.decode(responseData);

      if (response.statusCode == 200) {
        Get.snackbar('Information', responseDataMessage['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.amber,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
        if (mounted) Navigator.pop(context);
      } else {
        Get.snackbar(
          'Error',
          responseDataMessage['error'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
        _isOpenUploadForm = false;
      });
      getTipeDokumen();
    }
  }

  @override
  void initState() {
    super.initState();
    getTipeDokumen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double textMedium = size.width * 0.0329;
    double sizedBoxHeightTall = size.height * 0.0163;
    double sizedBoxHeightShort = size.height * 0.0086;
    double paddingHorizontalNarrow = size.width * 0.035;

    Widget dropdownlistTipeDokumen() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              hint: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Pilih Tipe Dokumen',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              menuMaxHeight: 500,
              icon: _isLoadingDocumentType
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
              value: selectedValueDocumentTypeString,
              items: selectedDocumentType.isNotEmpty
                  ? selectedDocumentType.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            value['tipe_dokumen'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: 'no-data',
                        enabled: false,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'No Data Available',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ],
              onChanged: (newValue) {
                setState(() {
                  selectedValueDocumentTypeString = newValue!;
                  debugPrint(
                      'selectedValueDocumentTypeString $selectedValueDocumentTypeString');
                });
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget entitasTable() {
      return SizedBox(
        height: 450,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                label: Checkbox(
                  value: _isAllSelected,
                  onChanged: onSelectAll,
                ),
              ),
              const DataColumn(label: Text('Kode')),
              const DataColumn(label: Text('Nama')),
            ],
            rows: selectedEntitas.map((entitas) {
              bool isSelected = entitas['selected'] ?? false;
              return DataRow(
                cells: [
                  DataCell(
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        onSelectItem(value, entitas['kode']);
                      },
                    ),
                  ),
                  DataCell(Text(entitas['kode'] ?? 'N/A')),
                  DataCell(Text(entitas['nama'] ?? 'N/A')),
                ],
              );
            }).toList(),
          ),
        ),
      );
    }

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
                  Get.back();
                },
              ),
              title: const Text(
                'Dokumen Perusahaan',
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sizedBoxHeightTall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontalNarrow),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isOpenUploadForm = true;
                              getDataEntitas();
                            });
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.create_new_folder_sharp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (selectedValueDocumentTypeObject.isNotEmpty &&
                        !_isOpenUploadForm)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedValueDocumentTypeObject = {};
                                perPage = 8;
                                page = 1;
                                _searchController.clear();
                                selectedDocument = [];
                              });
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: sizedBoxHeightTall),
                if (selectedValueDocumentTypeObject.isNotEmpty &&
                    !_isOpenUploadForm)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontalNarrow),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 12),
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        hintText: 'Cari Dokumen',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        getDataDokumen(
                            page,
                            perPage,
                            selectedValueDocumentTypeObject['id'].toString(),
                            value);
                      },
                    ),
                  ),
                selectedValueDocumentTypeObject.isEmpty && !_isOpenUploadForm
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: _isLoadingDocumentType
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: selectedDocumentType.length,
                                  itemBuilder: (context, index) {
                                    final documentType =
                                        selectedDocumentType[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: paddingHorizontalNarrow),
                                      child: ListTile(
                                        title: Column(
                                          children: [
                                            Icon(
                                              Icons.folder,
                                              color: Colors.indigo[900],
                                              size: 100,
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            const LineWidget(),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            Text(documentType['tipe_dokumen']),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedValueDocumentTypeObject =
                                                documentType;
                                            getDataDokumen(page, perPage,
                                                documentType['id'].toString());
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )
                    : _isOpenUploadForm
                        ? Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: paddingHorizontalNarrow),
                                child: _isLoadingEntitas
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: sizedBoxHeightTall),
                                            Row(
                                              children: [
                                                TitleWidget(
                                                  title: 'Tipe Dokumen',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: textMedium,
                                                ),
                                                Text(
                                                  ' *',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: textSmall,
                                                      fontFamily: 'Poppins',
                                                      letterSpacing: 0.6,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            dropdownlistTipeDokumen(),
                                            SizedBox(
                                                height: sizedBoxHeightTall),
                                            Row(
                                              children: [
                                                TitleWidget(
                                                  title: 'Entitas',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: textMedium,
                                                ),
                                                Text(
                                                  ' *',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: textSmall,
                                                      fontFamily: 'Poppins',
                                                      letterSpacing: 0.6,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightShort),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    entitasTable(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: sizedBoxHeightTall),
                                            Row(
                                              children: [
                                                TitleWidget(
                                                  title: 'Lampiran',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: textMedium,
                                                ),
                                                Text(
                                                  ' * (File upload maksimal 15 MB)',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: textSmall,
                                                      fontFamily: 'Poppins',
                                                      letterSpacing: 0.6,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: sizedBoxHeightShort,
                                            ),
                                            Column(
                                              children: [
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        pickFiles(),
                                                    child: const Text(
                                                        'Pilih File'),
                                                  ),
                                                ),
                                                if (_files != null)
                                                  Column(children: [
                                                    ListTile(
                                                      title: Text(_files!.name),
                                                    )
                                                  ]),
                                              ],
                                            ),
                                            SizedBox(
                                              height: sizedBoxHeightShort,
                                            ),
                                            if (_isFileNull) ...[
                                              Center(
                                                  child: Text(
                                                'File Kosong',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: textMedium),
                                              ))
                                            ],
                                            SizedBox(
                                                height: sizedBoxHeightTall),
                                            SizedBox(
                                              width: size.width,
                                              child: Column(
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isOpenUploadForm =
                                                            false;
                                                        getTipeDokumen();
                                                      });
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _submit();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              primaryYellow),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                          color: const Color(
                                                              primaryBlack),
                                                          fontSize: textMedium,
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.9,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                          )
                        : Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontalNarrow),
                              child: _isLoadingDocument
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : selectedDocument.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: selectedDocument.length,
                                          itemBuilder: (context, index) {
                                            final document =
                                                selectedDocument[index];
                                            return Card(
                                              margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      paddingHorizontalNarrow),
                                              child: ListTile(
                                                leading: const Icon(
                                                    Icons.description,
                                                    size: 50,
                                                    color: Colors.blue),
                                                title: Text(
                                                  document['file_name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Size: ${document['size_aktual']}'),
                                                    Text(
                                                        document['created_at']),
                                                  ],
                                                ),
                                                trailing:
                                                    PopupMenuButton<String>(
                                                  onSelected: (value) async {
                                                    if (value == 'Download') {
                                                      setState(() {
                                                        getDetailDokumen(
                                                            document['uuid'],
                                                            'download');
                                                      });
                                                    } else if (value ==
                                                        'Delete') {
                                                      String id = document['id']
                                                          .toString();
                                                      await deleteDokumen(
                                                          context, id);
                                                      getDataDokumen(
                                                          page,
                                                          perPage,
                                                          selectedValueDocumentTypeObject[
                                                                  'id']
                                                              .toString());
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    return [
                                                      const PopupMenuItem(
                                                        value: 'Download',
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                Icons.download),
                                                            SizedBox(width: 8),
                                                            Text('Download'),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 'Delete',
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.delete),
                                                            SizedBox(width: 8),
                                                            Text('Delete'),
                                                          ],
                                                        ),
                                                      ),
                                                    ];
                                                  },
                                                  icon: const Icon(
                                                      Icons.more_vert),
                                                ),
                                                onTap: () {
                                                  getDetailDokumen(
                                                      document['uuid'],
                                                      'preview');
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text('No Data Available'),
                                        ),
                            ),
                          ),
                SizedBox(height: sizedBoxHeightTall),
                if (selectedValueDocumentTypeObject.isNotEmpty &&
                    !_isOpenUploadForm)
                  Column(
                    children: [
                      DropdownButton<int>(
                        value: perPage,
                        items: const [
                          DropdownMenuItem(value: 8, child: Text('8')),
                          DropdownMenuItem(value: 16, child: Text('16')),
                          DropdownMenuItem(value: 32, child: Text('32')),
                          DropdownMenuItem(value: 100, child: Text('100')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            perPage = value!;
                            getDataDokumen(
                                page,
                                perPage,
                                selectedValueDocumentTypeObject['id']
                                    .toString());
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '* Dokumen bersifat rahasia',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              if (page > 1) {
                                setState(() {
                                  page--;
                                  getDataDokumen(
                                      page,
                                      perPage,
                                      selectedValueDocumentTypeObject['id']
                                          .toString());
                                });
                              }
                            },
                          ),
                          Text('$page'),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                page++;
                                getDataDokumen(
                                    page,
                                    perPage,
                                    selectedValueDocumentTypeObject['id']
                                        .toString());
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
  }
}
