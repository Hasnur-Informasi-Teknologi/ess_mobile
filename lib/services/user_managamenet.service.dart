import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/models/user_management_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class UserManagementService extends GetxController {
  var items;
  final String _apiUrl = API_URL;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
            Uri.parse("$_apiUrl/master/profile/get_user"),
            headers: <String, String>{
              'Content-Type': 'application/json;charset=UTF-8',
              'Authorization': 'Bearer $token'
            });
        final responseData = jsonDecode(response.body);
        final masterDataApi = responseData["dataku"];
        getData();
      } catch (e) {
        print(e);
      }
    }
  }

  // Future<String?> getToken() async {
  //   final SharedPreferences token = await SharedPreferences.getInstance();
  //   return token.getString('token');
  // }

  // static Future<List<UserManagementModel>> getData(
  //   String token,
  //   int page,
  //   int perPage,
  // ) async {
  //   String baseUrl = "http://ess-dev.hasnurgroup.com:8081/api";
  //   var url = Uri.parse(
  //       '$baseUrl/user-management/get?page=$page&perPage=$perPage&search=');
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': token,
  //   };

  //   final response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     List data = jsonDecode(response.body)["dataku"];
  //     final List<UserManagementModel> user = [];
  //     for (var item in data) {
  //       user.add(UserManagementModel.fromJson(item));
  //     }
  //     print(user);
  //     return user;
  //     // return data.map((e) => UserManagementModel.fromJson(e)).toList();
  //   } else {
  //     throw Exception("Response failed UserManagementService");
  //   }
  // }
}
