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

class UserAuthorization extends StatefulWidget {
  const UserAuthorization({super.key});

  @override
  State<UserAuthorization> createState() => _UserAuthorizationState();
}

class _UserAuthorizationState extends State<UserAuthorization> {
  late TextEditingController _searchcontroller;
  late List<DataRow> _rows = [];
  List<Map<String, dynamic>> selectedRole = [];
  List<Map<String, dynamic>> selectedPangkat = [];
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
      selectedValueUserAdministrator;
  bool _isLoading = false;
  late int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  late int _rowCount = 0;
  late int _pageIndex = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String apiUrl = API_URL;
  double maxHeightValidator = 60.0;
  TextEditingController _nrpController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cocdController = TextEditingController();
  TextEditingController _testController = TextEditingController();
  TextEditingController _announcementController = TextEditingController();
  TextEditingController _applicationController = TextEditingController();
  TextEditingController _approvalListController = TextEditingController();
  TextEditingController _assignmentInterviewerController =
      TextEditingController();
  TextEditingController _dashboardAdminController = TextEditingController();
  TextEditingController _dataProfileController = TextEditingController();
  TextEditingController _detailPlafonController = TextEditingController();
  TextEditingController _documentCompanyController = TextEditingController();
  TextEditingController _employeeController = TextEditingController();
  TextEditingController _formOnlineController = TextEditingController();
  TextEditingController _performanceManagementController =
      TextEditingController();
  TextEditingController _userAdministratorController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  Timer? _searchDebounce;

  void _onSearchChanged(String value) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchData(searchQuery: value);
    });
  }

  final DateRangePickerController _tanggalJoinController =
      DateRangePickerController();
  DateTime? tanggalJoin;

  Future<void> getDataRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$apiUrl/user-autorization/get_all"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final dataRoleApi = responseData['data_role'];
        print("$token");
        print("$dataRoleApi");

        setState(
          () {
            selectedRole = List<Map<String, dynamic>>.from(dataRoleApi);
            // selectedEntitasPengganti =
            //     List<Map<String, dynamic>>.from(dataEntitasApi);
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getDataPangkat() async {
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
        final dataPangkatApi = responseData['data'];
        // print("$token");
        // print("$dataPangkatApi");

        setState(
          () {
            selectedPangkat = List<Map<String, dynamic>>.from(dataPangkatApi);
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
            await http.post(Uri.parse("$apiUrl/user-autorization/delete"),
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

  Future<void> updateData(
    context,
    String id,
    String announcement,
    String application,
    String approval_list,
    String assignment_interviewer,
    String dashboard_admin,
    String data_profile,
    String detail_plafon,
    String document_company,
    String employee,
    String form_online,
    String performance_management,
    String user_administrator,
    String role,
  ) async {
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
    // DateTime dateTimeAwal = DateFormat("yyyy-MM-dd").parse(tglMasuk);
    // String formattedDateString = DateFormat("dd-MM-yyyy").format(dateTimeAwal);
    // DateTime dateTime = DateFormat("dd-MM-yyyy").parse(formattedDateString);
    print("role : $role");

    //menyimpan data yang diketikan pada textfield
    String idDataValue = id;
    String announcementDataValue = announcement;
    String applicationDataValue = application;
    String approval_listDataValue = approval_list;
    String assignment_interviewerDataValue = assignment_interviewer;
    String dashboard_adminDataValue = dashboard_admin;
    String data_profileDataValue = data_profile;
    String detail_plafonDataValue = detail_plafon;
    String document_companyDataValue = document_company;
    String employeeDataValue = employee;
    String form_onlineDataValue = form_online;
    String performance_managementDataValue = performance_management;
    String user_administratorDataValue = user_administrator;
    String roleDataValue = role;

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
                          title: 'Role *',
                          fontWeight: FontWeight.w300,
                          fontSize: textMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontalNarrow),
                        child: TextFormField(
                          validator: _validatorRole,
                          initialValue: role,
                          onChanged: (value) {
                            setState(() {
                              roleDataValue =
                                  value; // Menyimpan nilai setiap kali berubah
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Masukan Role",
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
                          title: 'announcement *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorAnnouncement,
                            value: announcement,
                            onChanged: (String? newValue) {
                              setState(() {
                                // selectedValueAnnouncement = newValue ?? '';
                                announcementDataValue =
                                    newValue ?? announcement;
                                print("$selectedValueAnnouncement");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueAnnouncement != null
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
                          title: 'application *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorApplication,
                            value: application,
                            onChanged: (String? newValue) {
                              setState(() {
                                approval_listDataValue = newValue ?? '';
                                print("$selectedValueApplication");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueApplication != null
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
                          title: 'approval list *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorApprovalList,
                            value: approval_list,
                            onChanged: (String? newValue) {
                              setState(() {
                                approval_listDataValue = newValue ?? '';
                                print("$selectedValueApprovalList");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueApprovalList != null
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
                          title: 'assignment interviewer *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorAssignmentInterviewer,
                            value: assignment_interviewer,
                            onChanged: (String? newValue) {
                              setState(() {
                                assignment_interviewerDataValue =
                                    newValue ?? '';
                                print("$selectedValueAssignmentInterviewer");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color:
                                      selectedValueAssignmentInterviewer != null
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
                          title: 'dashboard admin *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorDashboardAdmin,
                            value: dashboard_admin,
                            onChanged: (String? newValue) {
                              setState(() {
                                dashboard_adminDataValue = newValue ?? '';
                                print("$selectedValueDashboardAdmin");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueDashboardAdmin != null
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
                          title: 'data profile *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorDataProfile,
                            value: data_profile,
                            onChanged: (String? newValue) {
                              setState(() {
                                data_profileDataValue = newValue ?? '';
                                print("$selectedValueDataProfile");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueDataProfile != null
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
                          title: 'detail plafon *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorDetailPlafon,
                            value: detail_plafon,
                            onChanged: (String? newValue) {
                              setState(() {
                                detail_plafonDataValue = newValue ?? '';
                                print("$selectedValueDetailPlafon");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueDetailPlafon != null
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
                          title: 'document company *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorDocumentCompany,
                            value: document_company,
                            onChanged: (String? newValue) {
                              setState(() {
                                document_companyDataValue = newValue ?? '';
                                print("$selectedValueDocumentCompany");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueDocumentCompany != null
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
                          title: 'employee *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorEmployee,
                            value: employee,
                            onChanged: (String? newValue) {
                              setState(() {
                                employeeDataValue = newValue ?? '';
                                print("$selectedValueEmployee");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueEmployee != null
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
                          title: 'form online *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorFormOnline,
                            value: form_online,
                            onChanged: (String? newValue) {
                              setState(() {
                                form_onlineDataValue = newValue ?? '';
                                print("$selectedValueFormOnline");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueFormOnline != null
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
                          title: 'performance management *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorPerformanceManagement,
                            value: performance_management,
                            onChanged: (String? newValue) {
                              setState(() {
                                performance_managementDataValue =
                                    newValue ?? '';
                                print("$selectedValuePerformanceManagement");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color:
                                      selectedValuePerformanceManagement != null
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
                          title: 'user administrator *',
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
                              "Pilih Hak Akses",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: textMedium,
                              ),
                            ),
                            validator: _validatorUserAdministrator,
                            value: user_administrator,
                            onChanged: (String? newValue) {
                              setState(() {
                                user_administratorDataValue = newValue ?? '';
                                print("$selectedValueUserAdministrator");
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '1',
                                child: Text('Iya'),
                              ),
                              DropdownMenuItem<String>(
                                value: '0',
                                child: Text('Tidak'),
                              ),
                            ],
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
                                  color: selectedValueUserAdministrator != null
                                      ? Colors.transparent
                                      : Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                  id,
                                  announcementDataValue,
                                  applicationDataValue,
                                  approval_listDataValue,
                                  assignment_interviewerDataValue,
                                  dashboard_adminDataValue,
                                  data_profileDataValue,
                                  detail_plafonDataValue,
                                  document_companyDataValue,
                                  employeeDataValue,
                                  form_onlineDataValue,
                                  performance_managementDataValue,
                                  user_administratorDataValue,
                                  roleDataValue);
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
      String id,
      String announcementDataValue,
      String applicationDataValue,
      String approval_listDataValue,
      String assignment_interviewerDataValue,
      String dashboard_adminDataValue,
      String data_profileDataValue,
      String detail_plafonDataValue,
      String document_companyDataValue,
      String employeeDataValue,
      String form_onlineDataValue,
      String performance_managementDataValue,
      String user_administratorDataValue,
      String roleDataValue) async {
    print("update btn");
    print("ini id : " + id);
    print("ini nama role: " + roleDataValue);
    print("ini announce : " + announcementDataValue);
    print("ini applicatin : " + applicationDataValue);
    print("ini approval : " + approval_listDataValue);
    print("ini assignmen : " + assignment_interviewerDataValue);
    print("ini dashboard : " + dashboard_adminDataValue);
    print("ini datprof : " + data_profileDataValue);
    print("ini detplaf : " + detail_plafonDataValue);
    print("ini doc : " + document_companyDataValue);
    print("ini employ : " + employeeDataValue);
    print("ini formonli : " + form_onlineDataValue);
    print("ini pertform : " + performance_managementDataValue);
    print("ini user : " + user_administratorDataValue);
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
        Uri.parse('$apiUrl/user-autorization/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'announcement': announcementDataValue,
          'application': applicationDataValue,
          'approval_list': approval_listDataValue,
          'assignment_interviewer': assignment_interviewerDataValue,
          'dashboard_admin': dashboard_adminDataValue,
          'data_profile': data_profileDataValue,
          'detail_plafon': detail_plafonDataValue,
          'document_company': document_companyDataValue,
          'employee': employeeDataValue,
          'form_online': form_onlineDataValue,
          'performance_management': performance_managementDataValue,
          'user_administrator': user_administratorDataValue,
          'role': roleDataValue,
          'id': id,
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

  Future<void> fetchData({String searchQuery = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          "$apiUrl/user-autorization/get?page=$_pageIndex&perPage=$_rowsPerPage&search=$searchQuery"),
      headers: <String, String>{
        "Content-Type": "application/json;charset=UTF-8",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData["data"];
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
              DataCell(Text(item['role'] ?? 'null')),
              DataCell(Text(item['form_online'] ?? 'null')),
              DataCell(Text(item['approval_list'] ?? 'null')),
              DataCell(Text(item['assignment_interviewer'] ?? 'null')),
              DataCell(Text(item['document_company'] ?? 'null')),
              DataCell(Text(item['employee'] ?? 'null')),
              DataCell(Text(item['detail_plafon'] ?? 'null')),
              DataCell(Text(item['application'] ?? 'null')),
              DataCell(Text(item['announcement'] ?? 'null')),
              DataCell(Text(item['user_administrator'] ?? 'null')),
              DataCell(Text(item['performance_management'] ?? 'null')),
              DataCell(Text(item['data_profile'] ?? 'null')),
              DataCell(Text(item['change_password'] ?? 'null')),
              DataCell(Text(item['dashboard_admin'] ?? 'null')),
              DataCell(Text(item['dashboard_user'] ?? 'null')),
              DataCell(Text(item['notification'] ?? 'null')),
              DataCell(
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          String id = item['id'].toString();
                          String announcement = item['announcement'];
                          String application = item['application'];
                          String approval_list = item['approval_list'];
                          String assignment_interviewer =
                              item['assignment_interviewer'];
                          String dashboard_admin = item['dashboard_admin'];
                          String data_profile = item['data_profile'];
                          String detail_plafon = item['detail_plafon'];
                          String document_company = item['document_company'];
                          String employee = item['employee'];
                          String form_online = item['form_online'];
                          String performance_management =
                              item['performance_management'];
                          String user_administrator =
                              item['user_administrator'];
                          String role = item['role'];

                          updateData(
                            context,
                            id,
                            announcement,
                            application,
                            approval_list,
                            assignment_interviewer,
                            dashboard_admin,
                            data_profile,
                            detail_plafon,
                            document_company,
                            employee,
                            form_online,
                            performance_management,
                            user_administrator,
                            role,
                          );
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
    print(_roleController.text);
    print("ini announce : " + _announcementController.text);
    print("ini applicatin : " + _applicationController.text);
    print("ini approval : " + _approvalListController.text);
    print("ini assignmen : " + _assignmentInterviewerController.text);
    print("ini dashboard : " + _dashboardAdminController.text);
    print("ini datprof : " + _dataProfileController.text);
    print("ini detplaf : " + _detailPlafonController.text);
    print("ini doc : " + _documentCompanyController.text);
    print("ini employ : " + _employeeController.text);
    print("ini formonli : " + _formOnlineController.text);
    print("ini pertform : " + _performanceManagementController.text);
    print("ini user : " + _userAdministratorController.text);
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/user-autorization/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'announcement': _announcementController.text,
          'application': _applicationController.text,
          'approval_list': _approvalListController.text,
          'assignment_interviewer': _assignmentInterviewerController.text,
          'dashboard_admin': _dashboardAdminController.text,
          'data_profile': _dataProfileController.text,
          'detail_plafon': _detailPlafonController.text,
          'document_company': _documentCompanyController.text,
          'employee': _employeeController.text,
          'form_online': _formOnlineController.text,
          'performance_management': _performanceManagementController.text,
          'user_administrator': _userAdministratorController.text,
          'role': _roleController.text,
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
    getDataRole();
    getDataPangkat();
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
                              title: 'Role *',
                              fontWeight: FontWeight.w300,
                              fontSize: textMedium,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingHorizontalNarrow),
                            child: TextFormField(
                              controller: _roleController,
                              validator: _validatorRole,
                              decoration: InputDecoration(
                                hintText: "Masukan Role",
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
                              title: 'announcement *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorAnnouncement,
                                value: selectedValueAnnouncement,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueAnnouncement = newValue ?? '';
                                    _announcementController.text =
                                        newValue ?? '';
                                    print("$selectedValueAnnouncement");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueAnnouncement != null
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
                              title: 'application *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorApplication,
                                value: selectedValueApplication,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueApplication = newValue ?? '';
                                    _applicationController.text =
                                        newValue ?? '';
                                    print("$selectedValueApplication");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueApplication != null
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
                              title: 'approval list *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorApprovalList,
                                value: selectedValueApprovalList,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueApprovalList = newValue ?? '';
                                    _approvalListController.text =
                                        newValue ?? '';
                                    print("$selectedValueApprovalList");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueApprovalList != null
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
                              title: 'assignment interviewer *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorAssignmentInterviewer,
                                value: selectedValueAssignmentInterviewer,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueAssignmentInterviewer =
                                        newValue ?? '';
                                    _assignmentInterviewerController.text =
                                        newValue ?? '';
                                    print(
                                        "$selectedValueAssignmentInterviewer");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color:
                                          selectedValueAssignmentInterviewer !=
                                                  null
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
                              title: 'dashboard admin *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDashboardAdmin,
                                value: selectedValueDashboardAdmin,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueDashboardAdmin =
                                        newValue ?? '';
                                    _dashboardAdminController.text =
                                        newValue ?? '';
                                    print("$selectedValueDashboardAdmin");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueDashboardAdmin != null
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
                              title: 'data profile *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDataProfile,
                                value: selectedValueDataProfile,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueDataProfile = newValue ?? '';
                                    _dataProfileController.text =
                                        newValue ?? '';
                                    print("$selectedValueDataProfile");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueDataProfile != null
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
                              title: 'detail plafon *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDetailPlafon,
                                value: selectedValueDetailPlafon,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueDetailPlafon = newValue ?? '';
                                    _detailPlafonController.text =
                                        newValue ?? '';
                                    print("$selectedValueDetailPlafon");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueDetailPlafon != null
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
                              title: 'document company *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDocumentCompany,
                                value: selectedValueDocumentCompany,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueDocumentCompany =
                                        newValue ?? '';
                                    _documentCompanyController.text =
                                        newValue ?? '';
                                    print("$selectedValueDocumentCompany");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color:
                                          selectedValueDocumentCompany != null
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
                              title: 'employee *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorEmployee,
                                value: selectedValueEmployee,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueEmployee = newValue ?? '';
                                    _employeeController.text = newValue ?? '';
                                    print("$selectedValueEmployee");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueEmployee != null
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
                              title: 'form online *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorFormOnline,
                                value: selectedValueFormOnline,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueFormOnline = newValue ?? '';
                                    _formOnlineController.text = newValue ?? '';
                                    print("$selectedValueFormOnline");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color: selectedValueFormOnline != null
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
                              title: 'performance management *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorPerformanceManagement,
                                value: selectedValuePerformanceManagement,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValuePerformanceManagement =
                                        newValue ?? '';
                                    _performanceManagementController.text =
                                        newValue ?? '';
                                    print(
                                        "$selectedValuePerformanceManagement");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color:
                                          selectedValuePerformanceManagement !=
                                                  null
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
                              title: 'user administrator *',
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
                                  "Pilih Hak Akses",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorUserAdministrator,
                                value: selectedValueUserAdministrator,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueUserAdministrator =
                                        newValue ?? '';
                                    _userAdministratorController.text =
                                        newValue ?? '';
                                    print("$selectedValueUserAdministrator");
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '1',
                                    child: Text('Iya'),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '0',
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                                      color:
                                          selectedValueUserAdministrator != null
                                              ? Colors.transparent
                                              : Colors.transparent,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

    // _handleButtonUpdate(dynamic value) {
    //   return showModalBottomSheet(
    //       context: context,
    //       isScrollControlled: true,
    //       useSafeArea: true,
    //       builder: (context) {
    //         return Container(
    //           margin: EdgeInsets.symmetric(
    //             horizontal: paddingHorizontalNarrow,
    //             vertical: paddingHorizontalNarrow,
    //           ),
    //           height: 650,
    //           width: double.infinity,
    //           child: ListView(
    //             children: [
    //               Form(
    //                 key: _formKey,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: 'NRP *',
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TextFormField(
    //                         controller: _nrpController,
    //                         validator: _validatorNrp,
    //                         decoration: InputDecoration(
    //                           hintText: "Masukan NRP",
    //                           hintStyle: TextStyle(
    //                             fontWeight: FontWeight.w300,
    //                             fontSize: textMedium,
    //                           ),
    //                           enabledBorder: const OutlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.grey,
    //                               width: 1.0,
    //                             ),
    //                           ),
    //                           contentPadding: const EdgeInsets.fromLTRB(
    //                               20.0, 10.0, 20.0, 10.0),
    //                           border: OutlineInputBorder(
    //                             borderRadius: BorderRadius.circular(5),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: 'Nama *',
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TextFormField(
    //                         controller: _namaController,
    //                         validator: _validatorNama,
    //                         decoration: InputDecoration(
    //                           hintText: "Masukan Nama",
    //                           hintStyle: TextStyle(
    //                             fontWeight: FontWeight.w300,
    //                             fontSize: textMedium,
    //                           ),
    //                           enabledBorder: const OutlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.grey,
    //                               width: 1.0,
    //                             ),
    //                           ),
    //                           contentPadding: const EdgeInsets.fromLTRB(
    //                               20.0, 10.0, 20.0, 10.0),
    //                           border: OutlineInputBorder(
    //                             borderRadius: BorderRadius.circular(5),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: 'Tanggal masuk *',
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     CupertinoButton(
    //                       child: Container(
    //                         height: 50,
    //                         width: size.width,
    //                         padding: EdgeInsets.symmetric(
    //                             horizontal: paddingHorizontalNarrow,
    //                             vertical: padding5),
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(5),
    //                             border: Border.all(color: Colors.grey)),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             const Icon(
    //                               Icons.calendar_month_outlined,
    //                               color: Colors.grey,
    //                             ),
    //                             Text(
    //                               DateFormat('dd-MM-yyyy').format(
    //                                   _tanggalJoinController.selectedDate ??
    //                                       DateTime.now()),
    //                               style: TextStyle(
    //                                 color: Colors.grey,
    //                                 fontSize: textMedium,
    //                                 fontFamily: 'Poppins',
    //                                 fontWeight: FontWeight.w300,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       onPressed: () {
    //                         showDialog(
    //                           context: context,
    //                           builder: (BuildContext context) {
    //                             return AlertDialog(
    //                               content: Container(
    //                                 height: 350,
    //                                 width: 350,
    //                                 child: SfDateRangePicker(
    //                                   controller: _tanggalJoinController,
    //                                   onSelectionChanged:
    //                                       (DateRangePickerSelectionChangedArgs
    //                                           args) {
    //                                     setState(() {
    //                                       tanggalJoin = args.value;
    //                                     });
    //                                   },
    //                                   selectionMode:
    //                                       DateRangePickerSelectionMode.single,
    //                                 ),
    //                               ),
    //                               actions: <Widget>[
    //                                 TextButton(
    //                                   onPressed: () => Navigator.pop(context),
    //                                   child: const Text('OK'),
    //                                 ),
    //                               ],
    //                             );
    //                           },
    //                         );
    //                       },
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: "Email *",
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TextFormField(
    //                         controller: _emailController,
    //                         validator: _validatorEmail,
    //                         decoration: InputDecoration(
    //                           hintText: "Masukan email",
    //                           hintStyle: TextStyle(
    //                             fontWeight: FontWeight.w300,
    //                             fontSize: textMedium,
    //                           ),
    //                           enabledBorder: const OutlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.grey,
    //                               width: 1.0,
    //                             ),
    //                           ),
    //                           contentPadding: const EdgeInsets.fromLTRB(
    //                               20.0, 10.0, 20.0, 10.0),
    //                           border: OutlineInputBorder(
    //                             borderRadius: BorderRadius.circular(5),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: "Cocd *",
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TextFormField(
    //                         controller: _cocdController,
    //                         validator: _validatorCocd,
    //                         decoration: InputDecoration(
    //                           hintText: "Masukan cocd",
    //                           hintStyle: TextStyle(
    //                             fontWeight: FontWeight.w300,
    //                             fontSize: textMedium,
    //                           ),
    //                           enabledBorder: const OutlineInputBorder(
    //                             borderSide: BorderSide(
    //                               color: Colors.grey,
    //                               width: 1.0,
    //                             ),
    //                           ),
    //                           contentPadding: const EdgeInsets.fromLTRB(
    //                               20.0, 10.0, 20.0, 10.0),
    //                           border: OutlineInputBorder(
    //                             borderRadius: BorderRadius.circular(5),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: 'Role *',
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: Container(
    //                         height: 50,
    //                         width: size.width,
    //                         padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow,
    //                         ),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(5),
    //                           border: Border.all(color: Colors.grey),
    //                         ),
    //                         child: DropdownButtonFormField<String>(
    //                           hint: Text(
    //                             "Pilih Role",
    //                             style: TextStyle(
    //                               fontWeight: FontWeight.w300,
    //                               fontSize: textMedium,
    //                             ),
    //                           ),
    //                           validator: _validatorRole,
    //                           value: selectedValueRole,
    //                           icon: selectedRole.isEmpty
    //                               ? const SizedBox(
    //                                   height: 20,
    //                                   width: 20,
    //                                   child: CircularProgressIndicator(
    //                                     valueColor:
    //                                         AlwaysStoppedAnimation<Color>(
    //                                             Colors.blue),
    //                                   ),
    //                                 )
    //                               : const Icon(Icons.arrow_drop_down),
    //                           onChanged: (String? newValue) {
    //                             setState(() {
    //                               selectedValueRole = newValue ?? '';
    //                               print("$selectedValueRole");
    //                             });
    //                           },
    //                           items: selectedRole
    //                               .map((Map<String, dynamic> value) {
    //                             return DropdownMenuItem<String>(
    //                               value: value["id"].toString(),
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(1.0),
    //                                 child: TitleWidget(
    //                                   title: value["role"] as String,
    //                                   fontWeight: FontWeight.w300,
    //                                   fontSize: textMedium,
    //                                 ),
    //                               ),
    //                             );
    //                           }).toList(),
    //                           decoration: InputDecoration(
    //                             constraints:
    //                                 BoxConstraints(maxHeight: _maxHeightAtasan),
    //                             labelStyle: TextStyle(fontSize: textMedium),
    //                             focusedBorder: const UnderlineInputBorder(
    //                               borderSide: BorderSide(
    //                                 color: Colors.transparent,
    //                                 width: 1.0,
    //                               ),
    //                             ),
    //                             enabledBorder: UnderlineInputBorder(
    //                               borderSide: BorderSide(
    //                                 color: selectedValueRole != null
    //                                     ? Colors.transparent
    //                                     : Colors.transparent,
    //                                 width: 1.0,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: TitleWidget(
    //                         title: 'Pangkat *',
    //                         fontWeight: FontWeight.w300,
    //                         fontSize: textMedium,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow),
    //                       child: Container(
    //                         height: 50,
    //                         width: size.width,
    //                         padding: EdgeInsets.symmetric(
    //                           horizontal: paddingHorizontalNarrow,
    //                         ),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(5),
    //                           border: Border.all(color: Colors.grey),
    //                         ),
    //                         child: DropdownButtonFormField<String>(
    //                           hint: Text(
    //                             'Pilih Pangkat',
    //                             style: TextStyle(
    //                               fontWeight: FontWeight.w300,
    //                               fontSize: textMedium,
    //                             ),
    //                           ),
    //                           validator: _validatorPangkat,
    //                           value: selectedValuePangkat,
    //                           icon: selectedPangkat.isEmpty
    //                               ? const SizedBox(
    //                                   height: 20,
    //                                   width: 20,
    //                                   child: CircularProgressIndicator(
    //                                     valueColor:
    //                                         AlwaysStoppedAnimation<Color>(
    //                                             Colors.blue),
    //                                   ),
    //                                 )
    //                               : const Icon(Icons.arrow_drop_down),
    //                           onChanged: (String? newValue) {
    //                             setState(() {
    //                               selectedValuePangkat = newValue ?? '';
    //                               print("$selectedValuePangkat");
    //                               // selectedValueAtasan = null;
    //                             });
    //                           },
    //                           items: selectedPangkat
    //                               .map((Map<String, dynamic> value) {
    //                             return DropdownMenuItem<String>(
    //                               value: value["kode"].toString(),
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(1.0),
    //                                 child: TitleWidget(
    //                                   title: value["nama"] as String,
    //                                   fontWeight: FontWeight.w300,
    //                                   fontSize: textMedium,
    //                                 ),
    //                               ),
    //                             );
    //                           }).toList(),
    //                           decoration: InputDecoration(
    //                             constraints: BoxConstraints(
    //                                 maxHeight: maxHeightValidator),
    //                             labelStyle: TextStyle(fontSize: textMedium),
    //                             focusedBorder: const UnderlineInputBorder(
    //                               borderSide: BorderSide(
    //                                 color: Colors.transparent,
    //                                 width: 1.0,
    //                               ),
    //                             ),
    //                             enabledBorder: UnderlineInputBorder(
    //                               borderSide: BorderSide(
    //                                 color: selectedValuePangkat != null
    //                                     ? Colors.transparent
    //                                     : Colors.transparent,
    //                                 width: 1.0,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: sizedBoxHeightTall,
    //                     ),
    //                     SizedBox(
    //                       width: size.width,
    //                       child: Padding(
    //                         padding: EdgeInsets.symmetric(
    //                             horizontal: paddingHorizontalNarrow),
    //                         child: ElevatedButton(
    //                           onPressed: () {
    //                             _submit();
    //                           },
    //                           style: ElevatedButton.styleFrom(
    //                             backgroundColor: const Color(primaryYellow),
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(8),
    //                             ),
    //                           ),
    //                           child: Text(
    //                             'Add',
    //                             style: TextStyle(
    //                                 color: const Color(primaryBlack),
    //                                 fontSize: textMedium,
    //                                 fontFamily: 'Poppins',
    //                                 letterSpacing: 0.9,
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       });
    // }

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
                          'Add role',
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
                    "Role",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Form Online",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Approval List",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Assignment Interviewer",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Document Company",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Employee",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Detail Plafon",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Application",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Announcement",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "User Administrator",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Performance Management",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Data Profile",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Dashboard Admin",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Dashboard User",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Notification",
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
        title: const Text('User Management'),
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
