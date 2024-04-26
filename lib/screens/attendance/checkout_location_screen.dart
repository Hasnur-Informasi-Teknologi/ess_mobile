import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_ess/screens/attendance/take_selfie_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trust_location/trust_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:mobile_ess/services/location_service.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/error_dialog.dart';
import 'package:trust_location/trust_location.dart';

class CheckoutLocationScreen extends StatefulWidget {
  final String attendanceType;
  final String shift;

  const CheckoutLocationScreen(
      {Key? key, required this.attendanceType, this.shift = 'false'})
      : super(key: key);

  @override
  State<CheckoutLocationScreen> createState() => _CheckoutLocationScreenState();
}

class _CheckoutLocationScreenState extends State<CheckoutLocationScreen> {
  String? lat, long, address;
  bool _isLoading = false;

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

  Future<void> clockOutProcess() async {
    // bool isMockLocation = await TrustLocation.isMockLocation;
    // if (isMockLocation) {
    //   _showErrorDialog('Ayo nakal yaa, ketahuan mau fake GPS ya?');
    //   return;
    // }
    setState(() => _isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.get(
        Uri.parse('https://hitfaceapi.my.id/api/get/server_date'),
        headers: headers);
    print('=======TIMESTAMP ======');
    DateTime sdate = DateTime.parse(response.body);
    int stimestamp = sdate.millisecondsSinceEpoch;
    var timeZone = prefs.getString('timeZone');
    var timezone = await FlutterTimezone.getLocalTimezone();
    if (timezone == 'Asia/Jakarta') {
      timeZone='WIB'; // Western Indonesia Time
    } else if (timezone == 'Asia/Makassar') {
      timeZone='WITA'; // Central Indonesia Time
    } else if (timezone == 'Asia/Jayapura') {
      timeZone='WIT'; // Eastern Indonesia Time
    } else {
      timeZone='Unknown'; // Unknown or not applicable
    }
    if (timeZone == 'WITA') {
      stimestamp = stimestamp + (1 * 60 * 60 * 1000);
    } else if (timeZone == 'WIT') {
      stimestamp = stimestamp + (2 * 60 * 60 * 1000);
    }
    var clockOut = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(stimestamp));
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final userId = karyawan['pernr'];

    Map<String, Object> clockOutData = {
      'nrp': userId.toString(),
      'lat': lat!,
      'long': long!,
      'clock_out_time': clockOut,
    };
    print('shift ' + widget.shift);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => TakeSelfieScreen(
                clockInType: 'Out',
                shift: widget.shift,
                attendanceData: clockOutData)));

    setState(() => _isLoading = false);
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
              title: const Text('Location').tr(),
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
                                        subdomains: [
                                          'mt0',
                                          'mt1',
                                          'mt2',
                                          'mt3'
                                        ],
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 50.0,
                                            height: 50.0,
                                            point: LatLng(double.parse(lat!),
                                                double.parse(long!)),
                                            builder: (ctx) => Image.asset(
                                                'assets/images/logo-hasnur.png'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(primaryYellow),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: const Text(
                                        'Button Proses Absen',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ).tr(namedArgs: {
                                        'check': widget.attendanceType
                                      }),
                                    ),
                                    onPressed: clockOutProcess,
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            const Text(
                                              'Position',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ).tr(namedArgs: {
                                              'check': widget.attendanceType
                                            }),
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
                  })),
    );
  }
}
