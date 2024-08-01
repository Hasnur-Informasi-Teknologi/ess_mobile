import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormProvider with ChangeNotifier {
  final String _apiUrl = API_URL;

  Future<void> sumbitPengajuanCuti(
      String nrp, String nrpAtasan, String nrpPengganti) async {
    try {
      final ioClient = createIOClientWithInsecureConnection();

      final response = await ioClient.post(Uri.parse('$_apiUrl/add_cuti'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'nrp': nrp,
            // 'nrp_atasan': nrpAtasan,
            // 'nrp_pengganti': nrpPengganti,
          }));

      final responseData = jsonDecode(response.body);
      print(responseData);

      // if (responseData['status'] != true) {
      //   throw HttpException(responseData['status']);
      // }

      // notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
