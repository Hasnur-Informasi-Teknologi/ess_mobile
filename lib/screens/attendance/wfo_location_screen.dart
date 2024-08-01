// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/screens/attendance/take_selfie_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_ess/services/location_service.dart';
import 'package:trust_location/trust_location.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/error_dialog.dart';

class WFOLocationScreen extends StatefulWidget {
  final String qrLocation;
  final String workLocation;

  const WFOLocationScreen(
      {Key? key, required this.qrLocation, required this.workLocation})
      : super(key: key);

  @override
  State<WFOLocationScreen> createState() => _WFOLocationScreenState();
}

class _WFOLocationScreenState extends State<WFOLocationScreen> {
  var lat, long;
  var latString, longString, address;
  var _isLoading = false;
  var _qrTime, _systemTime;
  var latUser, longUser;
  var circleMarkers;
  double circleRadius = 100;

  Future getLocation() async {
    // GET USER LOCATION
    final locationService = LocationService();
    final locationData = await locationService.getLocation();

    latUser = locationData!.latitude!.toStringAsFixed(7);
    longUser = locationData.longitude!.toStringAsFixed(7);
    print('lokasi user');
    print(locationData);
    // GET QR LOCATION
    Map<String, dynamic> qrLocationData = await json.decode(widget.qrLocation);
    print('lokasi qr');
    print(qrLocationData);
    // _qrTime = DateFormat('yyyy-MM-dd').parse(qrLocationData['attendance_period']);
    // _systemTime = DateTime.now();

    // if (_systemTime!.month != _qrTime!.month) {
    //   _showErrorDialog('QR Code is expired');
    // } else if (_systemTime!.day != _qrTime!.day) {
    //   _showErrorDialog('QR Code is expired');
    // }
    // posisi QR
    print(double.parse(qrLocationData['lat']));
    lat = double.parse(qrLocationData['lat']);
    long = double.parse(qrLocationData['long']);
    latString = lat!.toStringAsFixed(7);
    longString = long!.toStringAsFixed(7);

    // =====================================================
    List<Placemark> newPlace = await placemarkFromCoordinates(lat!, long!);

    if (newPlace != null && newPlace.isNotEmpty) {
      Placemark placeMark = newPlace[0];
      address =
          '${placeMark.street}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.subAdministrativeArea}, ${placeMark.administrativeArea}, ${placeMark.postalCode}';
    }
    return newPlace;
  }

  Future<void> clockInProcess() async {
    // bool isMockLocation = await TrustLocation.isMockLocation;
    // if (isMockLocation) {
    //   _showErrorDialog('Ayo nakal yaa, ketahuan mau fake GPS ya?');
    //   return;
    // }
    setState(() => _isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {"Content-type": "application/json"};
    final ioClient = createIOClientWithInsecureConnection();
    final response = await ioClient.get(
        Uri.parse('https://hitfaceapi.my.id/api/get/server_date'),
        headers: headers);
    print('=======TIMESTAMP ======');
    DateTime sdate = DateTime.parse(response.body);
    int stimestamp = sdate.millisecondsSinceEpoch;
    print(sdate);
    print(stimestamp);
    var timeZone = prefs.getString('timeZone');
    // var timezone = await FlutterTimezone.getLocalTimezone();
    // if (timezone == 'Asia/Jakarta') {
    //   timeZone = 'WIB'; // Western Indonesia Time
    // } else if (timezone == 'Asia/Makassar') {
    //   timeZone = 'WITA'; // Central Indonesia Time
    // } else if (timezone == 'Asia/Jayapura') {
    //   timeZone = 'WIT'; // Eastern Indonesia Time
    // } else {
    //   timeZone = 'Unknown'; // Unknown or not applicable
    // }
    if (timeZone == 'WITA') {
      stimestamp = stimestamp + (1 * 60 * 60 * 1000);
    } else if (timeZone == 'WIT') {
      stimestamp = stimestamp + (2 * 60 * 60 * 1000);
    }
    var clockIn = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(stimestamp));

    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final userId = karyawan['pernr'];

    Map<String, Object> clockInData = {
      'pernr': userId.toString(),
      'lat': latString!,
      'long': longString!,
      'clock_in_time': clockIn,
      'working_location': widget.workLocation,
    };
    var point = {"lat": latUser.toString(), "lng": longUser.toString()};
    var radiuspoint = {"lat": lat.toString(), "lng": long.toString()};
    var n = arePointsNear(point, radiuspoint, circleRadius / 1000);
    if (n) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => TakeSelfieScreen(
                  clockInType: 'In', attendanceData: clockInData)));
    } else {
      _showErrorDialog('Lokasi anda berada diluar dari wilayah absensi!');
    }

    setState(() => _isLoading = false);
  }

  arePointsNear(checkPoint, centerPoint, km) {
    var ky = 40000 / 360;
    const double pi = 3.1415926535897932;
    var kx = cos((pi * double.parse(centerPoint['lat'])) / 180.0) * ky;
    var dx =
        ((double.parse(centerPoint["lng"]) - double.parse(checkPoint["lng"])) *
                kx)
            .abs();
    var dy =
        ((double.parse(centerPoint['lat']) - double.parse(checkPoint['lat'])) *
                ky)
            .abs();
    return sqrt(dx * dx + dy * dy) <= km;
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return ErrorDialog(message: errorMessage);
        });
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;
    return Scaffold(
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
                        builder: (context) => const MainScreenWithAnimation()));
              },
            )),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: getLocation(),
                builder: (ctx, snapshot) {
                  print(snapshot.hasData);
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
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
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.width,
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng(lat != null ? lat : 00.00,
                                        long != null ? long : 00.00),
                                    zoom: 17.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                                    ),
                                    CircleLayer(circles: [
                                      CircleMarker(
                                          point: LatLng(
                                              lat != null ? lat : 00.00,
                                              long != null ? long : 00.00),
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
                                              lat != null ? lat : 00.00,
                                              long != null ? long : 00.00),
                                          builder: (ctx) => Image.asset(
                                              'assets/images/logo-hasnur.png'),
                                        ),
                                        Marker(
                                          width: 50.0,
                                          height: 50.0,
                                          point: LatLng(double.parse(latUser),
                                              double.parse(longUser)),
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
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(primaryYellow),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: clockInProcess,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 12, right: 12),
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
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          const Text(
                                            'Position',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ).tr(
                                              namedArgs: {'check': 'Check-In'}),
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
                }));
  }
}
