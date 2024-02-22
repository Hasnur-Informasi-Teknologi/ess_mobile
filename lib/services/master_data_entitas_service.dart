import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/models/user_management_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterDataEntitasService {
  final String apiUrl = API_URL;
  Future<DatakuModel> fetchData({
    String? searchQuery,
    int? pageIn,
    int? rPP,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String query = '';
    if (searchQuery != null) {
      query = searchQuery;
    }
    print(
        "$apiUrl/user-management/get?page=$pageIn&perPage=$rPP&search=$query");
    final response = await http.get(
      Uri.parse(
          "$apiUrl/master/entity/get?page=$pageIn&perPage=$rPP&search=$query"),
      headers: <String, String>{
        "Content-Type": "application/json;charset=UTF-8",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      return DatakuModel.fromJson(responseData);
    } else {
      throw ('Error get data');
    }
  }
}
