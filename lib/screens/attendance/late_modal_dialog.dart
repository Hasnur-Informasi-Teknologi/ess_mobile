import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/attendance/take_selfie_screen.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';

class LateModalDialog extends StatefulWidget {
  const LateModalDialog({super.key, required this.newData});

  final Map<String, dynamic> newData;

  @override
  State<LateModalDialog> createState() => _LateModalDialogState();
}

class _LateModalDialogState extends State<LateModalDialog> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _alasanTerlambatController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
    var request = http.MultipartRequest('POST', Uri.parse('$_apiUrl/absen'))
      ..headers.addAll(headers)
      ..fields['nrp'] = widget.newData['nrp']
      ..fields['lat'] = widget.newData['lat']
      ..fields['long'] = widget.newData['long']
      ..fields['hari'] = widget.newData['hari']
      ..fields['clock_time'] = widget.newData['clock_time']
      ..fields['working_location'] = widget.newData['working_location']
      ..fields['address'] = widget.newData['address']
      ..files.add(http.MultipartFile.fromBytes(
          'image', widget.newData['image'].readAsBytesSync(),
          filename: widget.newData['image'].path.split('/').last));
    var response = await request.send();

    final responseData = await response.stream.bytesToString();
    final responseDataMessage = json.decode(responseData);
    Get.snackbar('Infomation', responseDataMessage['message'],
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false);
    setState(() {
      _isLoading = false;
    });
    print('Message $responseDataMessage');
    if (responseDataMessage['message'] == 'Success') {
      Get.offAllNamed('/user/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.grey,
            body: AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Center(
                    child: Text(
                      'Anda Terlambat',
                      style: TextStyle(
                        color: const Color(primaryBlack),
                        fontSize: textLarge,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  TextFormFieldWidget(
                    controller: _alasanTerlambatController,
                    maxHeightConstraints: 40,
                    hintText: 'Alasan Terlambat',
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      setState(() {
                        _submit();
                      });
                    },
                    child: Container(
                      height: size.height * 0.04,
                      padding: EdgeInsets.all(padding5),
                      decoration: BoxDecoration(
                        color: const Color(primaryYellow),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Color(primaryBlack),
                            fontSize: textMedium,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
