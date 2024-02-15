import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_ess/models/user_management_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagementService {
  Future<String?> getToken() async {
    final SharedPreferences token = await SharedPreferences.getInstance();
    return token.getString('token');
  }

  static Future<List<UserManagementModel>> getData(
    String token,
    int page,
    int perPage,
  ) async {
    String baseUrl = "http://ess-dev.hasnurgroup.com:8081/api";
    var url = Uri.parse(
        '$baseUrl/user-management/get?page=$page&perPage=$perPage&search=');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)["dataku"];
      final List<UserManagementModel> user = [];
      for (var item in data) {
        user.add(UserManagementModel.fromJson(item));
      }
      print(user);
      return user;
      // return data.map((e) => UserManagementModel.fromJson(e)).toList();
    } else {
      throw Exception("Response failed UserManagementService");
    }
  }
}
