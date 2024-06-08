import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RequestAttendanceTableWidget extends StatefulWidget {
  const RequestAttendanceTableWidget({super.key});

  @override
  State<RequestAttendanceTableWidget> createState() =>
      _RequestAttendanceTableWidgetState();
}

class _RequestAttendanceTableWidgetState
    extends State<RequestAttendanceTableWidget> {
  final String _apiUrl = API_URL;
  List<Map<String, dynamic>> masterDataAttendance = [];
  bool _isLoading = false;

  Future<void> getDataAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse('$_apiUrl/master/profile/get_attendance_personal_yearly'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
        );
        final responseData = jsonDecode(response.body);
        final dataAttendanceApi = responseData['data'];
        setState(() {
          masterDataAttendance =
              List<Map<String, dynamic>>.from(dataAttendanceApi);
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    } else {
      print('tidak ada token home');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataAttendance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textSmall = size.width * 0.027;
    double sizedBoxHeightTall = size.height * 0.0163;
    double padding5 = size.width * 0.0115;
    double padding10 = size.width * 0.023;

    return _isLoading
        ? SizedBox(
            height: size.height / 2,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: sizedBoxHeightTall,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: masterDataAttendance.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: sizedBoxHeightTall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 1 / 7,
                              padding: EdgeInsets.all(padding5),
                              child: Text(
                                '${masterDataAttendance[index]['in_date']}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 1 / 7,
                              padding: EdgeInsets.all(padding5),
                              child: Text(
                                '${masterDataAttendance[index]['in_time_hg'] ?? '-'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 1 / 7,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: masterDataAttendance[index]
                                            ['in_status_hg'] ==
                                        'NORMAL'
                                    ? Colors.green[600]
                                    : masterDataAttendance[index]
                                                ['in_status_hg'] ==
                                            'LATE'
                                        ? Colors.red[400]
                                        : Colors.grey[400],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                '${masterDataAttendance[index]['in_status_hg'] ?? '-'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 1 / 7,
                              padding: EdgeInsets.all(padding5),
                              child: Text(
                                '${masterDataAttendance[index]['out_time_hg'] ?? '-'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 1 / 7,
                              padding: EdgeInsets.all(padding5),
                              decoration: BoxDecoration(
                                color: masterDataAttendance[index]
                                            ['out_status_hg'] ==
                                        'NORMAL'
                                    ? Colors.green[600]
                                    : masterDataAttendance[index]
                                                ['out_status_hg'] ==
                                            'EARLY OUT'
                                        ? Colors.blue[400]
                                        : Colors.grey[400],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                '${masterDataAttendance[index]['out_status_hg'] ?? '-'}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: textSmall,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
  }
}
