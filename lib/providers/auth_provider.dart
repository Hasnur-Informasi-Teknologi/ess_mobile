import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/http_exception.dart';
import 'package:mobile_ess/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final String _apiUrl = API_URL;

  Future signIn(String nrp, String password) async {
    try {
      final ioClient = createIOClientWithInsecureConnection();

      // print(_apiUrl);

      final response = await ioClient.post(Uri.parse('$_apiUrl/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'nrp': nrp,
            'password': password,
          }));

      final responseData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(responseData['message'] ?? 'Unknown error');
      }

      String? token = responseData['token'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
      prefs.setString('nrp', nrp);
      final user = await ioClient.get(
        Uri.parse('$_apiUrl/master/profile/get_employee'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      final user_auth = await ioClient.get(
        Uri.parse('$_apiUrl/master/profile/get_user?nrp=$nrp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      final userData = user.body;
      prefs.setString('userData', userData);
      prefs.setBool('permission', true);
      prefs.setInt('role_id', jsonDecode(user_auth.body)['data']['role_id']);
      notifyListeners();
      return jsonDecode(user_auth.body)['data']['role_id'];
    } catch (e) {
      // throw e;
      if (e is HttpException) {
        throw e;
      } else {
        throw HttpException('Authentication failed. Please try again later.');
      }
    }
  }

  // Future<void> signOut() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final userId = prefs.getString('userId');

  //     final response = await http.get(Uri.parse('$_apiUrl/sign_out/$userId'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8'
  //         });
  //     final responseData = jsonDecode(response.body);

  //     if (responseData['message'] != 'Success') {
  //       throw HttpException(responseData['message']);
  //     }

  //     prefs.remove('isUserLogin');
  //     prefs.remove('userId');
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<void> checkDeviceId(String nrp, dynamic deviceDataId) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final userId = prefs.getString('userId');
      final ioClient = createIOClientWithInsecureConnection();

      final response = await ioClient.post(
          Uri.parse('http://ess-dev.hasnurgroup.com:8081/api/check_device'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'nrp': nrp, 'deviceid': deviceDataId}));

      final responseData = jsonDecode(response.body);

      if (responseData['message'] != 'Success') {
        throw HttpException(responseData['message']);
      }
    } catch (e) {
      throw e;
    }
  }
}
