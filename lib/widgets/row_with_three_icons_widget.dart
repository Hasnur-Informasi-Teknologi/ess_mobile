import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/dokument_model.dart';
import 'package:mobile_ess/screens/user/home/documents/documents_detail.dart';
import 'package:mobile_ess/themes/constant.dart';
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
  int currentPage = 1;
  final int perPage = 8;
  // late String selectedType = '1';
  List<Map<String, dynamic>> selectedTypeDok = [];
  String? selectedType = '1';
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
      print(data);
      setState(() {
        selectedTypeDok = List<Map<String, dynamic>>.from(data);
        tipeDokumen =
            data.map((item) => item['tipe_dokumen'].toString()).toList();
        // Periksa apakah '1' ada dalam daftar tipeDokumen
        if (tipeDokumen.contains('1')) {
          selectedType = '1'; // Jika ya, atur selectedType menjadi '1'
        }
      });
      // Panggil getDataDocuments setelah mendapatkan tipe dokumen
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

  @override
  void initState() {
    super.initState();
    getTipeDokumen();
    getDataDocuments(currentPage, selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            hint: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Pilih Tipe Dokumen',
                style: TextStyle(fontSize: 12),
              ),
            ),
            value: selectedType,
            icon: selectedTypeDok.isEmpty
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                value: value["id"].toString() as String,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    value["tipe_dokumen"] as String,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              labelStyle: const TextStyle(fontSize: 12),
              focusedBorder: UnderlineInputBorder(
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
          const SizedBox(height: 20),
          dokumens.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
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
                },
                child: Text('Next Page'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
