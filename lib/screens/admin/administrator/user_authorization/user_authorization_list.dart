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
  final String apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _rowsPerPage = 5;
  int _pageIndex = 1;
  int _totalRecords = 0;
  String _searchQuery = '';
  List<dynamic> _data = [];
  bool _isLoading = false;
  double maxHeightValidator = 60.0;
  TextEditingController _searchcontroller = TextEditingController();
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
  List<Map<String, dynamic>> selectedHakAkses = [];
  @override
  void initState() {
    super.initState();
    fetchData();
    getPilihan();
  }

  Future<void> getPilihan() async {
    String jsonString = '''
    {
      "data": [
        {
          "id": "0",
          "nama": "No"
        },
        {
          "id": "1",
          "nama": "Yes"
        }
      ]
    }
    ''';

    try {
      final responseData = jsonDecode(jsonString);
      final dataPilihanApi = responseData['data'];
      print('dataPilihanApi: $dataPilihanApi');
      setState(() {
        selectedHakAkses = List<Map<String, dynamic>>.from(dataPilihanApi);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchData({
    int? pageIndex,
    int? rowPerPage,
    String? searchQuery,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl/user-autorization/get?page=${pageIndex ?? _pageIndex}&perPage=${rowPerPage ?? _rowsPerPage}&search=${searchQuery ?? _searchQuery}'),
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingHorizontalNarrow = size.width * 0.035;

    double textMedium = size.width * 0.0329;
    double _maxHeightAtasan = 60.0;
    double sizedBoxHeightTall = size.height * 0.0163;
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
        if (responseData['status'] == 'Berhasil Update Data') {
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

    Future _handleButtonAdd() {
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
                          //yabetul
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorAnnouncement,
                                value: selectedValueAnnouncement,
                                icon: selectedHakAkses.isEmpty
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
                                    _announcementController.text =
                                        newValue ?? '';
                                    selectedValueAnnouncement = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueAnnouncement');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorApplication,
                                value: selectedValueApplication,
                                icon: selectedHakAkses.isEmpty
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
                                    _applicationController.text =
                                        newValue ?? '';
                                    selectedValueApplication = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueApplication');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorApprovalList,
                                value: selectedValueApprovalList,
                                icon: selectedHakAkses.isEmpty
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
                                    _approvalListController.text =
                                        newValue ?? '';
                                    selectedValueApprovalList = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueApprovalList');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorAssignmentInterviewer,
                                value: selectedValueAssignmentInterviewer,
                                icon: selectedHakAkses.isEmpty
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
                                    _assignmentInterviewerController.text =
                                        newValue ?? '';
                                    selectedValueAssignmentInterviewer =
                                        newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueAssignmentInterviewer');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDashboardAdmin,
                                value: selectedValueDashboardAdmin,
                                icon: selectedHakAkses.isEmpty
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
                                    _dashboardAdminController.text =
                                        newValue ?? '';
                                    selectedValueDashboardAdmin =
                                        newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueDashboardAdmin');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDataProfile,
                                value: selectedValueDataProfile,
                                icon: selectedHakAkses.isEmpty
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
                                    _dataProfileController.text =
                                        newValue ?? '';
                                    selectedValueDataProfile = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueDataProfile');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDetailPlafon,
                                value: selectedValueDetailPlafon,
                                icon: selectedHakAkses.isEmpty
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
                                    _detailPlafonController.text =
                                        newValue ?? '';
                                    selectedValueDetailPlafon = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueDetailPlafon');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorDocumentCompany,
                                value: selectedValueDocumentCompany,
                                icon: selectedHakAkses.isEmpty
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
                                    _documentCompanyController.text =
                                        newValue ?? '';
                                    selectedValueDocumentCompany =
                                        newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueDocumentCompany');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorEmployee,
                                value: selectedValueEmployee,
                                icon: selectedHakAkses.isEmpty
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
                                    _employeeController.text = newValue ?? '';
                                    selectedValueEmployee = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueEmployee');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorFormOnline,
                                value: selectedValueFormOnline,
                                icon: selectedHakAkses.isEmpty
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
                                    _formOnlineController.text = newValue ?? '';
                                    selectedValueFormOnline = newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueFormOnline');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorPerformanceManagement,
                                value: selectedValuePerformanceManagement,
                                icon: selectedHakAkses.isEmpty
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
                                    _performanceManagementController.text =
                                        newValue ?? '';
                                    selectedValuePerformanceManagement =
                                        newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValuePerformanceManagement');
                                  });
                                },
                                items: selectedHakAkses
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
                                horizontal: paddingHorizontalNarrow,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Pilih Hak Akses',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: textMedium,
                                  ),
                                ),
                                validator: _validatorUserAdministrator,
                                value: selectedValueUserAdministrator,
                                icon: selectedHakAkses.isEmpty
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
                                    _userAdministratorController.text =
                                        newValue ?? '';
                                    selectedValueUserAdministrator =
                                        newValue ?? '';
                                    print(
                                        'selectedValueStatus: $selectedValueUserAdministrator');
                                  });
                                },
                                items: selectedHakAkses
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
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: paddingHorizontalNarrow),
                        //   child: TitleWidget(
                        //     title: 'announcement *',
                        //     fontWeight: FontWeight.w300,
                        //     fontSize: textMedium,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: paddingHorizontalNarrow),
                        //   child: Container(
                        //     height: 50,
                        //     width: size.width,
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: paddingHorizontalNarrow),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5),
                        //       border: Border.all(color: Colors.grey),
                        //     ),
                        //     child: DropdownButtonFormField<String>(
                        //       hint: Text(
                        //         "Pilih Hak Akses",
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w300,
                        //           fontSize: textMedium,
                        //         ),
                        //       ),
                        //       validator: _validatorAnnouncement,
                        //       value: announcement,
                        //       onChanged: (String? newValue) {
                        //         setState(() {
                        //           // selectedValueAnnouncement = newValue ?? '';
                        //           announcementDataValue =
                        //               newValue ?? announcement;
                        //           print("$selectedValueAnnouncement");
                        //         });
                        //       },
                        //       items: [
                        //         DropdownMenuItem<String>(
                        //           value: '1',
                        //           child: Text('Iya'),
                        //         ),
                        //         DropdownMenuItem<String>(
                        //           value: '0',
                        //           child: Text('Tidak'),
                        //         ),
                        //       ],
                        //       decoration: InputDecoration(
                        //         constraints:
                        //             BoxConstraints(maxHeight: _maxHeightAtasan),
                        //         labelStyle: TextStyle(fontSize: textMedium),
                        //         focusedBorder: const UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: Colors.transparent,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: selectedValueAnnouncement != null
                        //                 ? Colors.transparent
                        //                 : Colors.transparent,
                        //             width: 1.0,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),

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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorAnnouncement,
                              value: announcement,
                              icon: selectedHakAkses.isEmpty
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
                                  _announcementController.text = newValue ?? '';
                                  announcementDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueAnnouncement');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorApplication,
                              value: application,
                              icon: selectedHakAkses.isEmpty
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
                                  _applicationController.text = newValue ?? '';
                                  applicationDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueApplication');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorApprovalList,
                              value: approval_list,
                              icon: selectedHakAkses.isEmpty
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
                                  _approvalListController.text = newValue ?? '';
                                  approval_listDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueApprovalList');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorAssignmentInterviewer,
                              value: assignment_interviewer,
                              icon: selectedHakAkses.isEmpty
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
                                  _assignmentInterviewerController.text =
                                      newValue ?? '';
                                  assignment_interviewerDataValue =
                                      newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueAssignmentInterviewer');
                                });
                              },
                              items: selectedHakAkses
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
                                    color: selectedValueAssignmentInterviewer !=
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorDashboardAdmin,
                              value: dashboard_admin,
                              icon: selectedHakAkses.isEmpty
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
                                  _dashboardAdminController.text =
                                      newValue ?? '';
                                  dashboard_adminDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueDashboardAdmin');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorDataProfile,
                              value: data_profile,
                              icon: selectedHakAkses.isEmpty
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
                                  _dataProfileController.text = newValue ?? '';
                                  data_profileDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueDataProfile');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorDetailPlafon,
                              value: detail_plafon,
                              icon: selectedHakAkses.isEmpty
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
                                  _detailPlafonController.text = newValue ?? '';
                                  detail_plafonDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueDetailPlafon');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorDocumentCompany,
                              value: document_company,
                              icon: selectedHakAkses.isEmpty
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
                                  _documentCompanyController.text =
                                      newValue ?? '';
                                  document_companyDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueDocumentCompany');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorEmployee,
                              value: employee,
                              icon: selectedHakAkses.isEmpty
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
                                  _employeeController.text = newValue ?? '';
                                  employeeDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueEmployee');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorFormOnline,
                              value: form_online,
                              icon: selectedHakAkses.isEmpty
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
                                  _formOnlineController.text = newValue ?? '';
                                  form_onlineDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueFormOnline');
                                });
                              },
                              items: selectedHakAkses
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorPerformanceManagement,
                              value: performance_management,
                              icon: selectedHakAkses.isEmpty
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
                                  _performanceManagementController.text =
                                      newValue ?? '';
                                  performance_managementDataValue =
                                      newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValuePerformanceManagement');
                                });
                              },
                              items: selectedHakAkses
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
                                    color: selectedValuePerformanceManagement !=
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
                              horizontal: paddingHorizontalNarrow,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                'Pilih Hak Akses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: textMedium,
                                ),
                              ),
                              validator: _validatorUserAdministrator,
                              value: user_administrator,
                              icon: selectedHakAkses.isEmpty
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
                                  _userAdministratorController.text =
                                      newValue ?? '';
                                  user_administratorDataValue = newValue ?? '';
                                  print(
                                      'selectedValueStatus: $selectedValueUserAdministrator');
                                });
                              },
                              items: selectedHakAkses
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
                                Navigator.pop(context);
                                fetchData(pageIndex: 1);
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
          final responseData = jsonDecode(response.body);
          Get.snackbar('Infomation', responseData['message'],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.amber,
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              shouldIconPulse: false);
          if (responseData['success'] == 'Berhasil Hapus Data') {
            fetchData(pageIndex: 1);
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
                          'Add Role',
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
        String role = data['role'].toString().toLowerCase();
        String searchLower = _searchcontroller.text.toLowerCase();
        return role.contains(searchLower);
      }).toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('No')),
                  DataColumn(
                    label: Text(
                      "Role",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Form Online",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Approval List",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Assignment Interviewer",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Document Company",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Employee",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Detail Plafon",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Application",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Announcement",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "User Administrator",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Performance Management",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Data Profile",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Change Password",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Dashboard Admin",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Dashboard User",
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Notification",
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
                      DataCell(Text(data['role'])),
                      DataCell(
                        Center(
                          child: data['form_online'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['approval_list'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['assignment_interviewer'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['document_company'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['employee'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['detail_plafon'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['application'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['announcement'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['user_administrator'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['performance_management'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['data_profile'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['change_password'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['dashboard_admin'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['dashboard_user'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: data['notification'] == "1"
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
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
                                    String id = data['id'].toString();
                                    String announcement = data['announcement'];
                                    String application = data['application'];
                                    String approval_list =
                                        data['approval_list'];
                                    String assignment_interviewer =
                                        data['assignment_interviewer'];
                                    String dashboard_admin =
                                        data['dashboard_admin'];
                                    String data_profile = data['data_profile'];
                                    String detail_plafon =
                                        data['detail_plafon'];
                                    String document_company =
                                        data['document_company'];
                                    String employee = data['employee'];
                                    String form_online = data['form_online'];
                                    String performance_management =
                                        data['performance_management'];
                                    String user_administrator =
                                        data['user_administrator'];
                                    String role = data['role'];

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
                                  child: const Icon(Icons.edit,
                                      color: Colors.white)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
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
                                              String id = data['id'].toString();
                                              await deleteData(id);
                                              // Perform delete action
                                              Navigator.pop(context);
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
        preferredSize: Size.fromHeight(190),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                surfaceTintColor: Colors.white,
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text('User Authorization'),
              ),
              content(),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
