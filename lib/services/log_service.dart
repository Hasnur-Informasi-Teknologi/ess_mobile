import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogS {
  logLocal(message) async {
    print(message);
    var logLocal = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logLocal = prefs.getString('logLocal').toString();
    print(logLocal);
    prefs.setString('logLocal', logLocal + message + ' \n ');
  }

  pushDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final logLocal = prefs.getString('logLocal');
    Map<String, String> headers = {"Content-type": "application/json"};
    final ioClient = createIOClientWithInsecureConnection();

    final response = await ioClient.post(
        Uri.parse(
            'https://hasnur-b7714-default-rtdb.firebaseio.com/logflutter.json'),
        headers: headers,
        body: jsonEncode(<String, String>{
          'message': logLocal!,
        }));
    // final responseData = json.decode(response.body);
    print(response.body);
  }
}
