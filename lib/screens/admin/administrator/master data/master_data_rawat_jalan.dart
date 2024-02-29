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

class RawatJalan extends StatefulWidget {
  const RawatJalan({super.key});

  @override
  State<RawatJalan> createState() => _RawatJalanState();
}

class _RawatJalanState extends State<RawatJalan> {
  late TextEditingController _searchcontroller;
  late List<DataRow> _rows = [];
  List<Map<String, dynamic>> selectedMdNikah = [];
  List<Map<String, dynamic>> selectedMdPangkat = [];
  List<Map<String, dynamic>> selectedEntitas = [];
  List<Map<String, dynamic>> selectedAtasan = [];
  List<Map<String, dynamic>> selectedAtasanDariAtasan = [];
  String? selectedValueAnnouncement,
      selectedValueApplication,
      selectedValueApprovalList,
      selectedValueAssignmentInterviewer,
      selectedValueDashboardAdmin,
      selectedValueDataProfile,
      selectedValueDetailPlafon,
      selectedValueDocumentCompany,
      selectedValueEmployee,
      selectedValueFormOnline,
      selectedValuePerformanceManagement,
      selectedValueUserAdministrator,
      selectedValueMdPangkat,
      selectedValueMdNikah;
  bool _isLoading = false;
  late int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  late int _rowCount = 0;
  late int _pageIndex = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String apiUrl = API_URL;
  double maxHeightValidator = 60.0;

  TextEditingController _mdPangkatController = TextEditingController();
  TextEditingController _mdNikahController = TextEditingController();
  TextEditingController _kursController = TextEditingController();
  TextEditingController _nominalController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  Timer? _searchDebounce;

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchData(searchQuery: value);
    });
  }

  final DateRangePickerController _tanggalMulaiController =
      DateRangePickerController();
  DateTime? tanggalMulai;

  final DateRangePickerController _tanggalBerakhirController =
      DateRangePickerController();
  DateTime? tanggalBerakhir;

  Future<void> getDataMdNikah() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http
            .get(Uri.parse("$apiUrl/master/nikah"), headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
        final responseData = jsonDecode(response.body);
        final dataMdNikah = responseData['data'];
        print("$token");
        print("$dataMdNikah");

        setState(
          () {
            selectedMdNikah = List<Map<String, dynamic>>.from(dataMdNikah);
            // selectedEntitasPengganti =
            //     List<Map<String, dynamic>>.from(dataEntitasApi);
          },
        );
      } catch (e) {
        print(e);
      }
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
        // print("$token");
        print("$dataMdPangkatApi");

        setState(
          () {
            selectedMdPangkat =
                List<Map<String, dynamic>>.from(dataMdPangkatApi);
            // selectedEntitasPengganti =
            //     List<Map<String, dynamic>>.from(dataEntitasApi);
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> deleteData(String id) async {
    print('tombol delet bekerja dengan id :  $id');
    // print('API  : $apiUrl/user-management/delete/nrp=$nrp');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');
    print('ini token :  $token');
    if (token != null) {
      try {
        final response =
            await http.post(Uri.parse("$apiUrl/master/rawat-jalan/delete"),
                headers: <String, String>{
                  'Content-Type': 'application/json;charset=UTF-8',
                  'Authorization': 'Bearer $token'
                },
                body: jsonEncode({'id': id}));
        if (response.statusCode == 200) {
          print('Item with id $id deleted successfully');

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

  String? _validatorAnnouncement(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field announcement Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorApplication(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field application Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorApprovalList(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field approval_list Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorAssignmentInterviewer(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field assignment_interviewer Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorDashboardAdmin(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field dashboard_admin Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorDataProfile(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field data_profile Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorDetailPlafon(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field detail_plafon Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorDocumentCompany(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field document_company Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorEmployee(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field employee Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorFormOnline(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field form_online Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorPerformanceManagement(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field performance_management Kosong';
    }

    setState(() {
      maxHeightValidator = 60.0;
    });
    return null;
  }

  String? _validatorUserAdministrator(dynamic value) {
    if (value == null || value.isEmpty) {
      setState(() {
        maxHeightValidator = 80.0;
      });
      return 'Field user_administrator Kosong';
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

  String? _validatorMdNikah(dynamic value) {
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

  String? _validatorKurs(dynamic value) {
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

  Future<void> updateData(
      context,
      String id,
      String mdNikah,
      String mdPangkat,
      String kurs,
      String nominal,
      String status,
      String tgl_mulai,
      String tgl_berakhir) async {
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

    // print("date string : " + formattedDateMulaiString);
    String valueMdPangkat = mdPangkat;
    String valueMdNikah = mdNikah;
    String valueKurs = kurs;
    String valueNominal = nominal;
    String valueStatus = status;
    String valueTglMulai = dateMulai.toString();
    String valueTglBerakhir = dateBerakhir.toString();

    print(mdNikah);
    print(mdPangkat);
    // print(valueTglMulai);
    // print(valueTglBerakhir);

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
                          title: 'md pangkat *',
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
                              "Pilih md pangkat",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorMdPangkat,
                            value: mdPangkat,
                            icon: selectedMdPangkat.isEmpty
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                    ),
                                  )
                                : Icon(Icons.arrow_drop_down),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValueMdPangkat = newValue;
                                valueMdPangkat = newValue ??
                                    ''; // Update the TextEditingController value
                                print("$selectedValueMdPangkat");
                              });
                            },
                            items: selectedMdPangkat
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
                                  color: selectedValueMdPangkat != null
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
                          title: 'md nikah *',
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
                              "Pilih md nikah",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            // validator: _validatorRole,
                            value: mdNikah,
                            icon: selectedMdNikah.isEmpty
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
                                selectedValueMdNikah = newValue;
                                valueMdNikah = newValue ??
                                    ''; // Update the TextEditingController value
                                print("$selectedValueMdNikah");
                              });
                            },
                            items: selectedMdNikah
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
                                  color: selectedValueMdNikah != null
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
                          title: 'kurs *',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          // controller: _kursController,
                          validator: _validatorKurs,
                          initialValue: kurs,
                          onChanged: (value) {
                            setState(() {
                              valueKurs =
                                  value; // Menyimpan nilai setiap kali berubah
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Masukan kurs",
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
                          title: 'Nominal *',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          // controller: _nominalController,
                          initialValue: nominal,
                          validator: _validatorNominal,
                          onChanged: (value) {
                            setState(() {
                              valueNominal =
                                  value; // Menyimpan nilai setiap kali berubah
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
                        child: TextFormField(
                          // controller: _statusController,
                          initialValue: status,
                          validator: _validatorStatus,
                          onChanged: (value) {
                            setState(() {
                              valueStatus =
                                  value; // Menyimpan nilai setiap kali berubah
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Masukan Status",
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
                          title: 'Tanggal mulai *',
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
                                        // Update tanggalMulai jika diperlukan
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
                                      // Ambil tanggal yang sudah dipilih
                                      valueTglMulai = dateMulai.toString();
                                      print('Tanggal yang dipilih: $dateMulai');

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
                                        // Update tanggalBerakhir jika diperlukan
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
                                      // Ambil tanggal yang sudah dipilih
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
                                  valueKurs,
                                  valueMdNikah,
                                  valueMdPangkat,
                                  id);
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
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _submitUpdate(
      String valueTglBerakhir,
      String valueTglMulai,
      String valueNominal,
      String valueStatus,
      String valueKurs,
      String valueMdNikah,
      String valueMdPangkat,
      String id) async {
    print("update btn");
    print("ini id : " + id);
    print("ini valueTglMulai : " + valueTglMulai);
    print("ini valueTglBerakhir: " + valueTglBerakhir);
    print("ini valueNominal : " + valueNominal);
    print("ini valueStatus : " + valueStatus);
    print("ini valueKurs : " + valueKurs);
    print("ini valueMdNikah : " + valueMdNikah);
    print("ini valueMdPangkat : " + valueMdPangkat);
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
        Uri.parse('$apiUrl/master/rawat-jalan/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "id": id,
          "kode_nikah": valueMdNikah,
          "kode_pangkat": valueMdPangkat,
          "kurs": valueKurs,
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

  Future<void> fetchData({String searchQuery = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          "$apiUrl/master/rawat-jalan/get?page=$_pageIndex&perPage=$_rowsPerPage&search=$searchQuery"),
      headers: <String, String>{
        "Content-Type": "application/json;charset=UTF-8",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData["dataku"];
      final total = responseData["totalPage"];

      setState(() {
        _rowCount = total['total_records'] ?? 0;
        _rows = data.asMap().entries.map<DataRow>((entry) {
          int index = entry.key;
          var item = entry.value;

          return DataRow(
            key: ValueKey<String>(item['id'].toString()),
            cells: [
              DataCell(
                  Text((index + 1).toString())), // Display sequential number
              DataCell(Text(item['id'].toString())),
              DataCell(Text(item['kode_nikah'] ?? 'null')),
              DataCell(Text(item['kode_pangkat'] ?? 'null')),
              DataCell(Text(item['kurs'] ?? 'null')),
              DataCell(Text(item['nominal'].toString() ?? 'null')),
              DataCell(Text(item['tgl_mulai'] ?? 'null')),
              DataCell(Text(item['tgl_berakhir'] ?? 'null')),
              DataCell(Text(item['status'] ?? 'null')),
              DataCell(Text(item['kategori'] ?? 'null')),
              DataCell(Text(item['pangkat'] ?? 'null')),
              DataCell(
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          String id = item['id'].toString();
                          String mdNikah = item['kode_nikah'];
                          String mdPangkat = item['kode_pangkat'];
                          String kurs = item['kurs'];
                          String nominal = item['nominal'].toString();
                          String status = item['status'];
                          String tgl_mulai = item['tgl_mulai'];
                          String tgl_berakhir = item['tgl_berakhir'];

                          updateData(context, id, mdNikah, mdPangkat, kurs,
                              nominal, status, tgl_mulai, tgl_berakhir);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white),
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
                                title: Text("Konfirmasi"),
                                content: Text(
                                    "Apakah Anda yakin ingin menghapus data ini?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String id = item['id'].toString();
                                      await deleteData(id);
                                      // Perform delete action
                                      Navigator.of(context).pop();
                                      fetchData();
                                    },
                                    child: Text("Hapus"),
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
                          child: const Icon(Icons.delete_outline,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList();
      });
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
    // print(_roleController.text);
    // print("ini announce : " + _announcementController.text);
    // print("ini applicatin : " + _applicationController.text);
    // print("ini approval : " + _approvalListController.text);
    // print("ini assignmen : " + _assignmentInterviewerController.text);
    // print("ini dashboard : " + _dashboardAdminController.text);
    // print("ini datprof : " + _dataProfileController.text);
    // print("ini detplaf : " + _detailPlafonController.text);
    // print("ini doc : " + _documentCompanyController.text);
    // print("ini employ : " + _employeeController.text);
    // print("ini formonli : " + _formOnlineController.text);
    // print("ini pertform : " + _performanceManagementController.text);
    // print("ini user : " + _userAdministratorController.text);
    print("ini md pangkat : " + _mdPangkatController.text);
    print("ini md nikah : " + _mdNikahController.text);
    print("ini kurs : " + _kursController.text);
    print("ini nominal : " + _nominalController.text);
    print("ini status : " + _statusController.text);
    print("ini tgl mulai : " + tanggalMulai.toString());
    print("ini tgl berakhir : " + tanggalBerakhir.toString());
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/master/rawat-jalan/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'kode_nikah': _mdNikahController.text,
          'kode_pangkat': _mdPangkatController.text,
          'kurs': _kursController.text,
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
        fetchData();
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

  @override
  void initState() {
    super.initState();
    _searchcontroller = TextEditingController();
    _searchcontroller.addListener(() {
      _onSearchChanged(_searchcontroller.text);
    });
    fetchData();
    getDataMdNikah();
    getDataMdPangkat();
  }

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    DateTime tanggalMasuk = DateTime(3000, 2, 1, 10, 20);
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
        useSafeArea: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                              title: 'md pangkat *',
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
                                  "Pilih md pangkat",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorMdPangkat,
                                value: selectedValueMdPangkat,
                                icon: selectedMdPangkat.isEmpty
                                    ? SizedBox(
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
                                    selectedValueMdPangkat = newValue;
                                    _mdPangkatController.text = newValue ??
                                        ''; // Update the TextEditingController value
                                    print("$selectedValueMdPangkat");
                                  });
                                },
                                items: selectedMdPangkat
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
                                      color: selectedValueMdPangkat != null
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
                              title: 'md nikah *',
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
                                  "Pilih md nikah",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                // validator: _validatorRole,
                                value: selectedValueMdNikah,
                                icon: selectedMdNikah.isEmpty
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
                                    selectedValueMdNikah = newValue;
                                    _mdNikahController.text = newValue ??
                                        ''; // Update the TextEditingController value
                                    print("$selectedValueMdNikah");
                                  });
                                },
                                items: selectedMdNikah
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
                                      color: selectedValueMdNikah != null
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
                              title: 'kurs *',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormField(
                              controller: _kursController,
                              validator: _validatorKurs,
                              decoration: InputDecoration(
                                hintText: "Masukan kurs",
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
                            child: TextFormField(
                              controller: _statusController,
                              validator: _validatorStatus,
                              decoration: InputDecoration(
                                hintText: "Masukan Status",
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
                              title: 'Tanggal mulai *',
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
                          'Add',
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
                  onChanged: _onSearchChanged,
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
                    "ID",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Kode Nikah",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Kode Pangkat",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Kurs",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Nominal",
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
                    "Kategori",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Pangkat",
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
        title: const Text('Rawat Jalan'),
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
    if (index >= 0 && index < rows.length) {
      return rows[index];
    }
    return null; // Return null for indexes outside the list range.
  }

  @override
  int get _rowCount => rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
