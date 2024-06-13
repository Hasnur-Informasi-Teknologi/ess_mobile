// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:io';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/screens/attendance/late_modal_dialog.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Note error ini cuma bug dari flutter, package exifrotation aman dipakai
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/widgets/error_dialog.dart';
import 'package:geocoding/geocoding.dart';

class TakeSelfieScreen extends StatefulWidget {
  const TakeSelfieScreen(
      {Key? key,
      required this.clockInType,
      required this.attendanceData,
      this.shift = 'false'})
      : super(key: key);

  final String clockInType;
  final String shift;
  final Map<String, Object> attendanceData;

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  final String _apiUrl = API_URL;
  bool _camera = true;
  CameraController? _cameraController;
  bool _isLoading = false;
  String? alamat;
  String? clockInToleransi;
  String? workSchedule;

  @override
  void initState() {
    super.initState();
    getDataWorkSchedule();
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
        print(responseData);
        if (responseData["data"] != null) {
          final responseDataApi = responseData["data"]["toleransiin"];
          print(responseDataApi);
          setState(() {
            clockInToleransi = responseDataApi;
            workSchedule = 'Ada Work Schedule';
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

  Future<void> inizializza() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false);

    await _cameraController!.initialize();
  }

  Future initializeCamera() async {
    var cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium,
        enableAudio: false);
    await _cameraController!.initialize();
    return _cameraController;
  }

  Future<void> captureSelfie() async {
    setState(() => _isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final userId = karyawan['pernr'];

    final image = await _cameraController!.takePicture();
    if (image != null && image.path != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);
      File imageFile = File(rotatedImage.path);

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      };
      Map<String, dynamic> attendanceData = widget.attendanceData;
      var nrp = attendanceData['nrp'] ?? attendanceData['pernr'];
      var lat = attendanceData['lat'];
      var long = attendanceData['long'];

      List<Placemark> getAlamat =
          await placemarkFromCoordinates(double.parse(lat), double.parse(long));
      print(getAlamat);
      if (getAlamat.length > 2) {
        alamat = getAlamat[2].toString();
      } else {
        alamat = getAlamat.isNotEmpty
            ? getAlamat.last.toString()
            : 'Alamat tidak ditemukan';
      }

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://hitfaceapi.my.id/api/face/recognition'));
      request.fields['id_user'] = userId as String;
      request.fields['force'] = 'true';
      request.files.add(http.MultipartFile.fromBytes(
          'file', imageFile.readAsBytesSync(),
          filename: imageFile.path.split('/').last));
      final ioClient = createIOClientWithInsecureConnection();

      var res = await ioClient.send(request);
      var respStr = await res.stream.bytesToString();

      final result = jsonDecode(respStr) as Map<dynamic, dynamic>;
      var status = result['status'] ?? '';
      var message = result['message'] ?? '';
      var confidence = result['confidence'] ?? '0';
      var duplicate = result['duplicate'] ?? 'false';
      var idUser = result['id_user'] ?? '';
      print(
          'status : $status , message : $message , confidence : $confidence , duplicate : $duplicate');
      if (status == false) {
        _showErrorDialog(message);
      } else {
        if (idUser != userId) {
          _showErrorDialog('Wajah terdetect bukan milik user ini !');
        } else {
          if (confidence.round() < 55) {
            _showErrorDialog('Confidence Data Kurang dari 50%!');
          } else {
            // proses absen
            _cameraController!.dispose();
            var clockInTime = attendanceData['clock_in_time'] ?? '';
            var workingLocation = attendanceData['working_location'] ?? '';
            String dateString = clockInTime.toString();
            String clockInTimeOnly = dateString.substring(11, 19);
            List<String> timeParts = clockInTimeOnly.split(':');
            int timeHour = int.parse(timeParts[0]);
            int timeMinute = int.parse(timeParts[1]);
            int timeSecond = int.parse(timeParts[2]);

            List<String>? clockInToleransiParts;

            if (widget.clockInType == 'In') {
              if (workSchedule != null) {
                if (clockInToleransi != null) {
                  clockInToleransiParts = clockInToleransi!.split(':');
                  // Membandingkan hanya jam, menit, dan detik
                  int clockInToleransiHour =
                      int.parse(clockInToleransiParts[0]);
                  int clockInToleransiMinute =
                      int.parse(clockInToleransiParts[1]);
                  int clockInToleransiSecond =
                      int.parse(clockInToleransiParts[2]);

                  if (timeHour > clockInToleransiHour ||
                      (timeHour == clockInToleransiHour &&
                          timeMinute > clockInToleransiMinute) ||
                      (timeHour == clockInToleransiHour &&
                          timeMinute == clockInToleransiMinute &&
                          timeSecond > clockInToleransiSecond)) {
                    // Kalau Terlambat

                    Map<String, dynamic> newData = {
                      "nrp": nrp,
                      "lat": lat,
                      "long": long,
                      "clock_time": clockInTime,
                      "working_location": workingLocation,
                      "address": alamat.toString(),
                      "image": imageFile,
                    };

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                LateModalDialog(newData: newData)));
                    setState(() {
                      _camera = false;
                    });
                  } else {
                    // Kalau Ontime
                    final ioClient = createIOClientWithInsecureConnection();
                    var request = http.MultipartRequest(
                        'POST', Uri.parse('$_apiUrl/absen'))
                      ..headers.addAll(headers)
                      ..fields['nrp'] = nrp
                      ..fields['lat'] = lat
                      ..fields['long'] = long
                      ..fields['clock_time'] = clockInTime
                      ..fields['working_location'] = workingLocation
                      ..fields['address'] = alamat.toString();

                    var streamedResponse = await ioClient.send(request);
                    final responseData =
                        await streamedResponse.stream.bytesToString();
                    final responseDataMessage = json.decode(responseData);
                    print(responseDataMessage);

                    Get.snackbar('Infomation', responseDataMessage['message'],
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.amber,
                        icon: const Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        shouldIconPulse: false);
                    setState(() {
                      _isLoading = false;
                    });
                    Get.offAllNamed('/user/main');
                  }
                } else {
                  Get.snackbar('Warning', 'Toleransi Masuk Tidak Di temukan',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      icon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      colorText: Colors.white,
                      duration: Duration(seconds: 15),
                      shouldIconPulse: false);
                  setState(() {
                    _isLoading = false;
                    _camera = false;
                  });
                  Get.offAllNamed('/user/main');
                }
              } else {
                Get.snackbar('Warning', 'Work Schedule Tidak Di temukan',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    icon: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    colorText: Colors.white,
                    duration: Duration(seconds: 15),
                    shouldIconPulse: false);
                setState(() {
                  _isLoading = false;
                  _camera = false;
                });
                Get.offAllNamed('/user/main');
              }
            } else {
              print('out');
              final ioClient = createIOClientWithInsecureConnection();
              var request =
                  http.MultipartRequest('POST', Uri.parse('$_apiUrl/absen'))
                    ..headers.addAll(headers)
                    ..fields['nrp'] = nrp
                    ..fields['lat'] = lat
                    ..fields['long'] = long
                    ..fields['clock_time'] = clockInTime
                    ..fields['working_location'] = workingLocation
                    ..fields['address'] = alamat.toString();

              var streamedResponse = await ioClient.send(request);
              final responseData =
                  await streamedResponse.stream.bytesToString();

              final responseDataMessage = json.decode(responseData);
              print(responseDataMessage);

              Get.snackbar('Infomation', responseDataMessage['message'],
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.amber,
                  icon: const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  shouldIconPulse: false);
              setState(() {
                _isLoading = false;
              });
              Get.offAllNamed('/user/main');
            }
          }
        }
      }
    }

    setState(() => _isLoading = false);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Take Picture'),
        centerTitle: true,
        backgroundColor: const Color(primaryYellow),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: initializeCamera(),
              builder: (_, snapshot) => (snapshot.connectionState ==
                      ConnectionState.waiting)
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height /
                                    _cameraController!.value.aspectRatio,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: _camera
                                          ? CameraPreview(_cameraController!)
                                          : Text(''),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(primaryYellow),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Take Picture',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(primaryBlack)),
                                ),
                                onPressed: () async {
                                  if (!_cameraController!
                                      .value.isTakingPicture) {
                                    captureSelfie();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    print('Camera Disposed!');
    super.dispose();
  }
}
