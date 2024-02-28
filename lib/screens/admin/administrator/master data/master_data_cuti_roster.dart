import 'dart:convert';
import 'dart:developer';

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

class CutiRoster extends StatefulWidget {
  const CutiRoster({super.key});

  @override
  State<CutiRoster> createState() => _CutiRosterState();
}

class _CutiRosterState extends State<CutiRoster> {
  late List<DataRow> _rows = [];
  List<Map<String, dynamic>> selectedRole = [];
  List<Map<String, dynamic>> selectedPangkat = [];
  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedAtasanDariAtasan = [];
  List<Map<String, dynamic>> selectedStatus = [];
  String? selectedValueSatuan, selectedValueStatus, selectedValueEntitas;
  bool _isLoading = false;
  late int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  late int _rowCount = 0;
  late int _pageIndex = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String apiUrl = API_URL;
  double maxHeightValidator = 60.0;
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cocdController = TextEditingController();

  final TextEditingController _jumlahRosterController = TextEditingController();
  final TextEditingController _entitasController = TextEditingController();
  final TextEditingController _potongCutiBersamaController =
      TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final DateRangePickerController _tglMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;

  final DateRangePickerController _tglBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;

  final DateRangePickerController _tanggalJoinController =
      DateRangePickerController();
  DateTime? tanggalJoin;

  // Future<void> getDataRole() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String? token = prefs.getString('token');

  //   if (token != null) {
  //     try {
  //       final response = await http.get(
  //           Uri.parse("$apiUrl/user-autorization/get_all"),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json;charset=UTF-8',
  //             'Authorization': 'Bearer $token'
  //           });
  //       final responseData = jsonDecode(response.body);
  //       final dataRoleApi = responseData['data_role'];
  //       print("$token");
  //       print("$dataRoleApi");

  //       setState(
  //         () {
  //           selectedRole = List<Map<String, dynamic>>.from(dataRoleApi);
  //           // selectedEntitasPengganti =
  //           //     List<Map<String, dynamic>>.from(dataEntitasApi);
  //         },
  //       );
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  Future<void> getDataEntitas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/master/entity/get?page=1&perPage=100&search="),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataEntitasApi = responseData['dataku'];
        // print("$token");
        // print("$dataEntitasApi");

        setState(
          () {
            selectedEntitas = List<Map<String, dynamic>>.from(dataEntitasApi);
            // selectedEntitasPengganti =
            //     List<Map<String, dynamic>>.from(dataEntitasApi);
          },
        );
      } catch (e) {
        print(e);
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

  String? _validatorNrp(dynamic value) {
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

  String? _validator_jumlahRoster(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Jumlah Roster Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validator_entitas(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Entitas Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validator_potong_cuti_bersama(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Potong Cuti Bersama Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validator_status(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Status Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validator_tgl_mulai(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Tanggal Mulai Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validator_tgl_berakhir(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Tanggal Berakhir Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorEmail(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Email Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorCocd(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Cocd Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorRole(dynamic value) {
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

  String? _validatorPangkat(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field Pangkat Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  Future<void> updateData(
      context,
      String id,
      String nrp,
      String entitas,
      String jml_roster,
      String potong_cuti_bersama,
      String status,
      String tglBerakhir,
      String tglMulai) async {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;
    double sizedBoxHeightShort = size.height * 0.0086;
    const double maxHeightNrp = 40.0;
    double sizedBoxHeightTall = size.height * 0.0163;
    double paddingHorizontalWide = size.width * 0.0585;
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

    String textFieldValueId = id.toString();
    String textFieldValuenNrp = nrp.toString();
    String textFieldValueEntitas = entitas.toString();
    String textFieldValueJmlRoster = jml_roster.toString();
    String textFieldValuePotongCutiBersama = potong_cuti_bersama.toString();
    String textFieldValuestatus = status.toString();
    String textFieldValueTglMulai = dateTimeMulaiFinal.toString();
    String textFieldValueTglBerakhir = dateTimeAkhirFinal.toString();

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
                        child: TextFormField(
                          controller: _nrpController,
                          validator: _validatorNrp,
                          decoration: InputDecoration(
                            hintText: "Masukan NRP",
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
                          title: 'Entitas *',
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
                              'Pilih Entitas',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validator_entitas,
                            value: selectedValueEntitas,
                            icon: selectedEntitas.isEmpty
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
                                selectedValueEntitas = newValue ?? '';
                                print(
                                    'selectedValueEntitas: $selectedValueEntitas');
                              });
                            },
                            items: selectedEntitas
                                .map((Map<String, dynamic> value) {
                              return DropdownMenuItem<String>(
                                value: value["kode"].toString(),
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
                                  color: selectedValueEntitas != null
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
                          title: 'Jumlah Roster *',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          controller: _jumlahRosterController,
                          validator: _validator_jumlahRoster,
                          decoration: InputDecoration(
                            hintText: "Masukan Jumlah Roster",
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
                          title: 'Potong Cuti Bersama *',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          controller: _potongCutiBersamaController,
                          validator: _validator_potong_cuti_bersama,
                          decoration: InputDecoration(
                            hintText: "Masukan Potong Cuti Bersama",
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
                            validator: _validator_status,
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
                                    _tglMulaiController.selectedDate ??
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
                                    controller: _tglMulaiController,
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
                                    _tglBerakhirController.selectedDate ??
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
                                    controller: _tglBerakhirController,
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
                      const SizedBox(
                        height: 10,
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
                                  textFieldValuenNrp,
                                  textFieldValueEntitas,
                                  textFieldValueJmlRoster,
                                  textFieldValuePotongCutiBersama,
                                  textFieldValuestatus,
                                  textFieldValueTglMulai,
                                  textFieldValueTglBerakhir);
                              fetchData();
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
              ],
            ),
          );
        });
  }

  Future<void> _submitUpdate(
      textFieldValueId,
      String textFieldValuenNrp,
      String textFieldValueEntitas,
      String textFieldValueJmlRoster,
      String textFieldValuePotongCutiBersama,
      String textFieldValuestatus,
      String textFieldValueTglMulai,
      String textFieldValueTglBerakhir) async {
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
      final response = await http.put(
        Uri.parse('$apiUrl/master/cuti-roster/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          /* 'id':id, */
          'entitas': _entitasController.text,
          'jml_roster': _jumlahRosterController.text,
          'nrp': _nrpController.text,
          'potong_cuti_bersama': _potongCutiBersamaController.text,
          'status': _statusController.text,
          'tgl_mulai': tanggalMulai != null
              ? tanggalMulai.toString()
              : DateTime.now().toString(),
          'tgl_berakhir': tanggalBerakhir != null
              ? tanggalBerakhir.toString()
              : DateTime.now().toString(),
          'terminate': 'X',
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
      rethrow;
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
            "$apiUrl/master/cuti-roster/get?page=$_pageIndex&perPage=$_rowsPerPage&search="),
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      log('🚀 ~ _CutiRosterState ~ Future<void>fetchData ~ responseData:$responseData');
      final data = responseData["dataku"];
      final total = responseData["totalPage"];
      _rowCount = total['total_records'] ?? 'null'.length;
      _rows = List.generate(
        data.length,
        (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(data[index]['nrp'] ?? 'null')),
            // DataCell(
            //   SizedBox(
            //     width: 200,
            //     child: Text(
            //       data[index]['nama'] ?? 'null',
            //       overflow: TextOverflow.clip,
            //     ),
            //   ),
            // ),
            DataCell(
              SizedBox(
                width: 200,
                child: Text(
                  data[index]['entitas'] ?? 'null',
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            DataCell(Text(data[index]['jml_roster']?.toString() ?? 'null')),
            DataCell(Center(
                child: Text(data[index]['potong_cuti_bersama'] ?? 'null'))),
            DataCell(Text(data[index]['tgl_mulai'] ?? 'null')),
            DataCell(Text(data[index]['tgl_berakhir'] ?? 'null')),
            DataCell(Text(data[index]['status'] ?? 'null')),
            DataCell(Text(data[index]['created_by'] ?? 'null')),
            DataCell(Text(data[index]['created_at'] ?? 'null')),
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
                          String id = data[index]['id'].toString();
                          String nrp = data[index]['nrp'].toString();
                          String entitas = data[index]['entitas'].toString();
                          String jml_roster =
                              data[index]['jml_roster'].toString();
                          String potong_cuti_bersama =
                              data[index]['potong_cuti_bersama'];
                          String created_by = data[index]['created_by'];
                          String created_at = data[index]['created_at'];
                          String status = data[index]['status'];
                          String tglMulai = data[index]['tgl_mulai'];
                          String tglBerakhir = data[index]['tgl_berakhir'];
                          updateData(
                              context,
                              id,
                              nrp,
                              entitas,
                              jml_roster,
                              potong_cuti_bersama,
                              status,
                              tglBerakhir,
                              tglMulai);
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
                    child: const Icon(Icons.delete, color: Colors.white),
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
      final body = jsonEncode({
        'entitas': selectedValueEntitas.toString(),
        'jml_roster': _jumlahRosterController.text,
        'nrp': _nrpController.text,
        'potong_cuti_bersama': _potongCutiBersamaController.text,
        'status': selectedValueStatus.toString(),
        'tgl_mulai': tanggalMulai != null
            ? tanggalMulai.toString()
            : DateTime.now().toString(),
        'tgl_berakhir': tanggalBerakhir != null
            ? tanggalBerakhir.toString()
            : DateTime.now().toString(),
      });
      final response = await http.post(
        Uri.parse('$apiUrl/master/cuti-roster/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: body,
      );

      print('Request body: $body');

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
        // Get.toNamed('/admin/administrator/user_management/user_management');
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
  void initState() {
    super.initState();
    fetchData();
    getDataStatus();
    // getDataRole();
    getDataEntitas();
  }

  @override
  Widget build(BuildContext context) {
    DateTime tanggalMasuk = DateTime(3000, 2, 1, 10, 20);
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    double padding5 = size.width * 0.0115;
    double padding7 = size.width * 0.018;
    double sizedBoxHeightShort = size.height * 0.0086;
    const double maxHeightNrp = 40.0;
    double sizedBoxHeightTall = size.height * 0.0163;
    double paddingHorizontalWide = size.width * 0.0585;
    double maxHeightAtasan = 60.0;
    // double padding8 = size.width * 0.0188;
    // double padding10 = size.width * 0.023;
    List<DataRow>? filterData;

    bool isLoading = false;

    @override
    void initState() {
      filterData = _rows;
      super.initState();
    }

    TextEditingController searchcontroller = TextEditingController();

    handleButtonAdd() {
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
                          child: TextFormField(
                            controller: _nrpController,
                            validator: _validatorNrp,
                            decoration: InputDecoration(
                              hintText: "Masukan NRP",
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
                            title: 'Entitas *',
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
                                'Pilih Entitas',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validator_entitas,
                              value: selectedValueEntitas,
                              icon: selectedEntitas.isEmpty
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
                                  selectedValueEntitas = newValue ?? '';
                                  print(
                                      'selectedValueEntitas: $selectedValueEntitas');
                                });
                              },
                              items: selectedEntitas
                                  .map((Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["kode"].toString(),
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
                                    color: selectedValueEntitas != null
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
                            title: 'Jumlah Roster *',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TextFormField(
                            controller: _jumlahRosterController,
                            validator: _validator_jumlahRoster,
                            decoration: InputDecoration(
                              hintText: "Masukan Jumlah Roster",
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
                            title: 'Potong Cuti Bersama *',
                            fontWeight: FontWeight.w300,
                            fontSize: textMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontalNarrow),
                          child: TextFormField(
                            controller: _potongCutiBersamaController,
                            validator: _validator_potong_cuti_bersama,
                            decoration: InputDecoration(
                              hintText: "Masukan Potong Cuti Bersama",
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
                              validator: _validator_status,
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
                                      _tglMulaiController.selectedDate ??
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
                                      controller: _tglMulaiController,
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
                                      _tglBerakhirController.selectedDate ??
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
                                      controller: _tglBerakhirController,
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
                        const SizedBox(
                          height: 10,
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
                                fetchData();
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
                ],
              ),
            );
          });
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
                  controller: searchcontroller,
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
                    "NRP",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Entitas",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Jumlah Roster",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Potong Cuti Bersama",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Tanggal Mulai",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Tanggal Berakhir",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Created By",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Created At",
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
        title: const Text('Master Data - Cuti Roster'),
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
  @override
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
    return rows[index];
  }

  @override
  int get _rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

// cuti roster