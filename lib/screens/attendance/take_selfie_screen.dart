// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
      {Key? key, required this.clockInType, required this.attendanceData,  this.shift='false'})
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

  Future<void> inizializza() async {
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.last;
    // To display the current output from the Camera,
    // create a CameraController.
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false);

    // Next, initialize the controller. This returns a Future.
    await _cameraController!.initialize();
  }

  Future initializeCamera() async {
    var cameras = await availableCameras();
    print(cameras);
    print(cameras[1]);
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium,
        enableAudio: false);
    print(_cameraController);
    await _cameraController!.initialize();
    print('------all good----');
    return _cameraController;
  }

  Future<void> captureSelfie() async {
    setState(() => _isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var karyawan=jsonDecode(prefs.getString('userData').toString())['data'];
    final userId = karyawan['pernr'];


    // Directory root = await getTemporaryDirectory();
    // String directoryPath = '${root.path}/hg_selfie';
    // Directory(directoryPath).create(recursive: true);

    final image = await _cameraController!.takePicture();
    if (image != null && image.path != null) {
      // Note error ini cuma bug dari flutter, package exifrotation aman dipakai
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);
      print(rotatedImage.path);
      print('Capture Berhasil');

      File imageFile = File(rotatedImage.path);

      print(imageFile);

      Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
      Map<String, dynamic> attendanceData = widget.attendanceData;
      var nrp = attendanceData['nrp'] ?? attendanceData['pernr'];
      var lat = attendanceData['lat'];
      var long = attendanceData['long'];

      List<Placemark> getAlamat =
          await placemarkFromCoordinates(double.parse(lat), double.parse(long));
      // alamat = "";
      alamat = getAlamat[2].toString();
      print('alamat:');
      print(alamat);
      // malik : Add Face Recognition
      //========================================================================
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://hitfaceapi.my.id/api/face/recognition'));
      request.fields['id_user'] = userId as String;
      request.fields['force'] = 'true';
      request.files.add(http.MultipartFile.fromBytes(
          'file', imageFile.readAsBytesSync(),
          filename: imageFile.path.split('/').last));
      var res = await request.send();
      print("Check disini 4");
      var respStr = await res.stream.bytesToString();
      print("Check disini 5");

      final result = jsonDecode(respStr) as Map<dynamic, dynamic>;
      print("Check disini 6");
      var status = result['status'] ?? '';
      print(result);
      var message = result['message'] ?? '';
      var confidence = result['confidence'] ?? '0';
      var duplicate = result['duplicate'] ?? 'false';
      var idUser = result['id_user'] ?? '';
      DateTime date = DateTime.now();
      print("Check disini 7A");
      String hari = DateFormat('EEEE').format(date).toLowerCase();
      print(hari);
      print("Check disini 7B");

      // if (hari == 'minggu') {
      //   return hari = 'sunday';
      // }

      print(
          'status : $status , message : $message , confidence : $confidence , duplicate : $duplicate');
      if (status == false) {
        // wajah gagal terdeteksi
        _showErrorDialog(message);
      } else {
        // berhasil wajah detect
        if (idUser != userId) {
          // wajah bukan milik userid terkait
          _showErrorDialog('Wajah terdetect bukan milik user ini !');
        } else {
          // wajah milik user id
          if (confidence.round() < 55) {
            // cek confidence data
            _showErrorDialog('Confidence Data Kurang dari 50%!');
          } else {
            // proses absen
            print('Proses absen id_user : $idUser');
            // =====================================================
            if (widget.clockInType == 'In') {
              var clockInTime = attendanceData['clock_in_time'];
              var workingLocation = attendanceData['working_location'];
              var obj = {
                "nrp": nrp,
                "lat": lat,
                "long": long,
                "clockInTime": clockInTime,
                "workingLocation": workingLocation,
                "address": alamat
              };
              var request =
                  http.MultipartRequest('POST', Uri.parse('http://hg-attendance.hasnurgroup.com/api/clock_in'))
                    ..headers.addAll(headers)
                    ..fields['nrp'] = nrp
                    ..fields['lat'] = lat
                    ..fields['long'] = long
                    ..fields['hari'] = hari + 'in'
                    ..fields['clock_in_time'] = clockInTime
                    ..fields['working_location'] = workingLocation
                    ..fields['address'] = alamat.toString()
                    ..files.add(http.MultipartFile.fromBytes(
                        'image', imageFile.readAsBytesSync(),
                        filename: imageFile.path.split('/').last));
              var response = await request.send();

              final responseData = await response.stream.bytesToString();
              print('Response clock in: $responseData');
            } else if (widget.clockInType == 'Out') {
              var clockOutTime = attendanceData['clock_out_time'];
              var obj = {
                "nrp": nrp,
                "lat": lat,
                "long": long,
                "clockInTime": clockOutTime,
                "address": alamat
              };
              var request =
                  http.MultipartRequest('POST', Uri.parse('http://hg-attendance.hasnurgroup.com/api/clock_out'))
                    ..headers.addAll(headers)
                    ..fields['nrp'] = nrp
                    ..fields['lat'] = lat
                    ..fields['shift']=widget.shift
                    ..fields['long'] = long
                    ..fields['hari'] = hari + 'out'
                    ..fields['clock_out_time'] = clockOutTime
                    ..fields['address'] = alamat.toString()
                    ..files.add(http.MultipartFile.fromBytes(
                        'image', imageFile.readAsBytesSync(),
                        filename: imageFile.path.split('/').last));
              var response = await request.send();

              final responseData = await response.stream.bytesToString();
              print('Response clock out: $responseData');
            }
            _cameraController!.dispose();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) => const MainScreenWithAnimation()));
            setState(() {
              _camera = false;
            });
            // =====================================================
          }
        }
      }
    }
    //========================================================================

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
        title: const Text('Take Picture').tr(),
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
                            // Stack(
                            //   children: [
                            //     SizedBox(
                            //       width: MediaQuery.of(context).size.width,
                            //       height: MediaQuery.of(context).size.height /
                            //           _cameraController!.value.aspectRatio,
                            //       child: _camera
                            //           ? CameraPreview(_cameraController!)
                            //           : Text(''),
                            //     ),
                            //     Align(
                            //       alignment: Alignment.center,
                            //       child: Image.asset('assets/images/Box.png'),
                            //     )
                            //   ],
                            // ),
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
                                    // Align(
                                    //   alignment: Alignment.center,
                                    //   child:
                                    //       Image.asset('assets/images/Box2.png'),
                                    // )
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
                                      fontWeight: FontWeight.w700,
                                      color: Color(primaryBlack)),
                                ).tr(),
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
                    )),
    );
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    print('Camera Disposed!');
    super.dispose();
  }
}
