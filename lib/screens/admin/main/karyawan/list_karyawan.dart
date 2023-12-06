import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/admin/main/karyawan/data_karyawan_screen.dart';
import 'package:mobile_ess/screens/admin/main/karyawan/karyawan_edit_screen.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListKaryawanController extends GetxController {
  var entitas = 'Barito Putera'.obs;
  var status = ''.obs;
  var search = ''.obs;
  var isActive = true.obs;
  var currentPage = 1.obs;
  var pagination = [].obs;
  var data = {}.obs;
  var listController = {}.obs;
  var listItem = [].obs;
  var listEntitas = {}.obs;
}

class ListKaryawan extends StatefulWidget {
  const ListKaryawan({super.key});
  @override
  State<ListKaryawan> createState() => _ListKaryawanState();
}

class _ListKaryawanState extends State<ListKaryawan> {
  ListKaryawanController x = Get.put(ListKaryawanController());
  final String _apiUrl = API_URL;

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var userData = prefs.getString('userData');
    final response = await http.get(
      Uri.parse('$_apiUrl/get_data_entitas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token.toString()
      },
    );
    final responseData = jsonDecode(response.body);
    // print(responseData['data_entitas']);
    responseData['data_entitas'].forEach((e) {
      x.listEntitas[e['entitas']] = e['entitas'];
    });
    // x.data.value = responseData['data'];
    x.listController['search'] =
        TextEditingController(text: x.data['search'].toString());
    getEmployees(1);
  }

  Future getEmployees(page) async {
    x.listItem.value = [];
    x.pagination.value = [];
    x.currentPage.value=page;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var userData = prefs.getString('userData');
    final response = await http.get(
      Uri.parse(
          '$_apiUrl/get_data_karyawan?entitas=${x.entitas}&search=${x.search}&status=${x.status}&page=${page}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token.toString()
      },
    );
    final responseData = jsonDecode(response.body);
    if (responseData['status'] == 'success') {
      x.currentPage.value = page;
      for (var i = 0; i < responseData['data']['data'].length; i++) {
        x.listItem.add(responseData['data']['data'][i]);
      }
      for (var i = 0; i < responseData['data']['last_page']; i++) {
        x.pagination.add(i+1);
      }
    }
  }


  List<T> map<T>(List list, Function handler) {
    // CARA 4 dengan index value
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        height: 40,
                        width: Get.width,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(102, 158, 158, 158),
                            width: 1, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: DropdownButtonHideUnderline(
                            child: x.listEntitas.keys.length == 0
                                ? Text('Data Kosong')
                                : DropdownButton<String>(
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                    value: x.entitas.value,
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (newValue) {
                                      x.entitas.value = newValue.toString();
                                      getEmployees(x.currentPage.value);
                                    },
                                    items: x.listEntitas.keys
                                        .map<DropdownMenuItem<String>>((id) {
                                      return DropdownMenuItem<String>(
                                        value: id,
                                        child: Text(x.listEntitas[id]!),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: Get.width,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(
                              102, 158, 158, 158), // Set border color
                          width: 1, // Set border width
                        ),
                        borderRadius: BorderRadius.circular(
                            6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                      ),
                      child: TextFormField(
                        onFieldSubmitted: (String value) {
                          print('User pressed enter with input: $value');
                          x.search.value = value;
                          getEmployees(x.currentPage.value);
                        },
                        style: TextStyle(fontSize: 11),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          hintText: 'Search',
                        ),
                        controller: x.listController['search'],
                        onChanged: (val) => x.data['search'] = val,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  x.isActive.value = true;
                                  x.status.value = "";
                                  getEmployees(x.currentPage.value);
                                },
                                child: Text("Aktif"),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      x.isActive.value ? Colors.yellow : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  x.isActive.value = false;
                                  x.status.value = "X";
                                  getEmployees(x.currentPage.value);
                                },
                                child: Text("Tidak Aktif"),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      !x.isActive.value ? Colors.yellow : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Data Karyawan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(children: [
                              Icon(Icons.add_to_home_screen_rounded, size: 15),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Import", style: TextStyle(fontSize: 10)),
                            ]),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(children: [
                              Icon(Icons.expand_rounded, size: 15),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Export", style: TextStyle(fontSize: 10)),
                            ]),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => x.listItem.length == 0
                          ? Text('')
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: map<Widget>(x.listItem, (index, url) {
                                return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: Get.width,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(102, 158, 158,
                                                158), // Set border color
                                            width: 1, // Set border width
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              6), // BorderRadius -> .circular(12),all(10),only(topRight:Radius.circular(10)), vertical,horizontal
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  x.listItem[index]['nrp'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        onPrimary:
                                                            Colors.black87,
                                                        elevation: 5,
                                                        primary:x.listItem[index]['terminate']=='X'?Colors.red[500]:Colors.green[500],
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                      ),
                                                      onPressed: () {},
                                                      child:  Text(x.listItem[index]['terminate']=='X'?'Tidak Aktif':'Aktif',style: TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(KaryawanDataScreen(nrp: x.listItem[index]['nrp'],nama: x.listItem[index]['nama_karyawan'],));
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12), // BorderRadius -> .circular(12),all(10),only(topRight:10), vertical,horizontal
                                                          ),
                                                          child: Container(
                                                            child: Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                size: 15),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(KaryawanEditScreen(nrp: x.listItem[index]['nrp'],nama: x.listItem[index]['nama_karyawan'],));
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    35,
                                                                    211,
                                                                    12),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12), // BorderRadius -> .circular(12),all(10),only(topRight:10), vertical,horizontal
                                                          ),
                                                          child: Container(
                                                            child: Icon(
                                                                Icons
                                                                    .edit_square,
                                                                size: 15),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      x.listItem[index]
                                                          ['nama_karyawan'],
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      x.listItem[index]
                                                          ['email'],
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "PT " +
                                                          x.listItem[index]
                                                              ['entitas'],
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                Text(''),
                                              ],
                                            )
                                          ],
                                        )));
                              })),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Container(
                          child: x.pagination.length == 0
                              ? Text('')
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      map<Widget>(x.pagination, (index, url) {
                                    return GestureDetector(
                                      onTap: () {
                                        getEmployees(x.pagination[index]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(left: 8),
                                          decoration: BoxDecoration(
                                            color: x.currentPage.value == x.pagination[index]?Color.fromARGB(255, 90, 232, 90):Color.fromARGB(255, 247, 251, 247),
                                             border: Border.all(color: const Color.fromARGB(255, 23, 24, 24),width: 2), 
                                            borderRadius: BorderRadius.circular(
                                                15), // BorderRadius -> .circular(12),all(10),only(topRight:10), vertical,horizontal
                                          ),
                                          child: Container(
                                            child: Text(x.pagination[index].toString()),
                                          )),
                                    );
                                  })),
                        )),
                  ],
                )),
          ),
        ));
  }
}
