// ignore_for_file: prefer_final_fields, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/attendance/take_selfie_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_location/trust_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

// import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:mobile_ess/services/location_service.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/error_dialog.dart';

class WFOLocationNewScreen extends StatefulWidget {
  final String workLocation;

  const WFOLocationNewScreen({Key? key, required this.workLocation})
      : super(key: key);

  @override
  State<WFOLocationNewScreen> createState() => _WFOLocationNewScreenState();
}

class _WFOLocationNewScreenState extends State<WFOLocationNewScreen> {
  final String _apiUrl = API_URL;
  // String? lat, long, address;
  bool _isLoading = false;
  var lat, long;
  var latString, longString, address;
  var latUser, longUser;
  var circleMarkers;
  double circleRadius = 100;
  final double radius = 0.2; // Radius dalam kilometer (100 meter = 0.1 km)
  String _timeZone = 'WIB';

  @override
  void initState() {
    super.initState();
    getDataWorkSchedule();
    _getTimeZone();
  }

  void _getTimeZone() {
    var now = DateTime.now();
    var timeZoneName = now.timeZoneName;
    setState(() {
      _timeZone = timeZoneName;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Pi/180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> getDataWorkSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final nrp = karyawan['pernr'];
    if (token != null) {
      try {
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
          Uri.parse('$_apiUrl/get_work_schedules/$nrp'),
          headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
        );
        final responseData = jsonDecode(response.body);
        if (responseData["data"] != null) {
          setState(() {
            latString = responseData["data"][0]["latitude"] ?? 00.00;
            longString = responseData["data"][0]["longitude"] ?? 00.00;
          });
        } else {
          print('Data is empty');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('tidak ada token home');
    }
  }

  Future<void> getLocation() async {
    final locationService = LocationService();
    final locationData = await locationService.getLocation();

    if (locationData != null) {
      final placeMark =
          await locationService.getPlaceMark(locationData: locationData);

      lat = locationData.latitude!.toStringAsFixed(7);
      long = locationData.longitude!.toStringAsFixed(7);

      address =
          '${placeMark?.street}, ${placeMark?.subLocality}, ${placeMark?.locality}, ${placeMark?.subAdministrativeArea}, ${placeMark?.administrativeArea}, ${placeMark?.postalCode}';
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return ErrorDialog(message: errorMessage);
        });
  }

  Future<void> clockInProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    if (lat != null &&
        long != null &&
        latString != null &&
        longString != null) {
      double distance = calculateDistance(double.parse(lat), double.parse(long),
          double.parse(latString), double.parse(longString));

      if (distance > radius) {
        Get.snackbar('Infomation',
            'Maaf, Anda berada di luar dari jangkauan lokasi kerja. Harap menghubungi HC Entitas untuk informasi lebih lanjut',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false);
      } else {
        Map<String, String> headers = {"Content-type": "application/json"};
        final ioClient = createIOClientWithInsecureConnection();
        final response = await ioClient.get(
            Uri.parse('https://hitfaceapi.my.id/api/get/server_date'),
            headers: headers);
        DateTime sdate = DateTime.parse(response.body);
        int stimestamp = sdate.millisecondsSinceEpoch;
        // var timeZone = prefs.getString('timeZone');
        var timeZone = _timeZone;
        print(timeZone);
        if (timeZone == 'WITA') {
          stimestamp = stimestamp + (1 * 60 * 60 * 1000);
        } else if (timeZone == 'WIT') {
          stimestamp = stimestamp + (2 * 60 * 60 * 1000);
        }
        var clockIn = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(stimestamp));

        var karyawan =
            jsonDecode(prefs.getString('userData').toString())['data'];
        final userId = karyawan['pernr'];

        Map<String, Object> clockInData = {
          'nrp': userId.toString(),
          'lat': lat!,
          'long': long!,
          'clock_in_time': clockIn,
          'working_location': widget.workLocation,
        };
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => TakeSelfieScreen(
                    clockInType: 'In', attendanceData: clockInData)));
      }
    } else {
      Get.snackbar('Infomation',
          'Maaf, Lokasi anda atau Lokasi kerja anda tidak di temukan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          shouldIconPulse: false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainScreenWithAnimation()));
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Location'),
              centerTitle: true,
              backgroundColor: const Color(primaryYellow),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MainScreenWithAnimation()));
                },
              )),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder(
                  future: getLocation(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(0),
                            child: Column(
                              children: <Widget>[
                                // SizedBox(
                                //   width: double.infinity,
                                //   height: MediaQuery.of(context).size.width,
                                //   child: FlutterMap(
                                //     options: MapOptions(
                                //       center: LatLng(double.parse(lat!),
                                //           double.parse(long!)),
                                //       zoom: 17.0,
                                //     ),
                                //     children: [
                                //       TileLayer(
                                //         urlTemplate:
                                //             'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                //         subdomains: const [
                                //           'mt0',
                                //           'mt1',
                                //           'mt2',
                                //           'mt3'
                                //         ],
                                //       ),
                                //       MarkerLayer(
                                //         markers: [
                                //           Marker(
                                //             width: 50.0,
                                //             height: 50.0,
                                //             point: LatLng(double.parse(lat!),
                                //                 double.parse(long!)),
                                //             builder: (ctx) => Image.asset(
                                //                 'assets/images/logo-hasnur.png'),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.width,
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(double.parse(lat!),
                                          double.parse(long!)),
                                      zoom: 17.0,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                        subdomains: const [
                                          'mt0',
                                          'mt1',
                                          'mt2',
                                          'mt3'
                                        ],
                                      ),
                                      CircleLayer(circles: [
                                        CircleMarker(
                                            point: LatLng(
                                                latString != null
                                                    ? double.parse(latString)
                                                    : 00.00,
                                                longString != null
                                                    ? double.parse(longString)
                                                    : 00.00),
                                            color: Colors.blue.withOpacity(0.7),
                                            borderStrokeWidth: 2,
                                            useRadiusInMeter: true,
                                            radius:
                                                circleRadius // 2000 meters | 2 km
                                            ),
                                      ]),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 50.0,
                                            height: 50.0,
                                            point: LatLng(
                                                latString != null
                                                    ? double.parse(latString)
                                                    : 00.00,
                                                longString != null
                                                    ? double.parse(longString)
                                                    : 00.00),
                                            builder: (ctx) => Image.asset(
                                                'assets/images/logo-hasnur.png'),
                                          ),
                                          Marker(
                                            width: 50.0,
                                            height: 50.0,
                                            point: LatLng(double.parse(lat!),
                                                double.parse(long!)),
                                            builder: (ctx) => Container(
                                              child: Icon(
                                                Icons.location_history_rounded,
                                                size: 40.0,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(primaryYellow),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: clockInProcess,
                                    child: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Clock In',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            const Text(
                                              'Position',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: <Widget>[
                                                const Icon(
                                                  Icons.map,
                                                  color: Color(primaryBlack),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    '$address',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black38),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  })),
    );
  }
}
