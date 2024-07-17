import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';

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

      // final responseData = jsonDecode(response.body);
      jsonDecode(response.body);

      // if (responseData['status'] != true) {
      //   throw HttpException(responseData['status']);
      // }

      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
