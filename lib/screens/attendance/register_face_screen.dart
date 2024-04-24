// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

import 'package:mobile_ess/widgets/error_dialog.dart';

class RegisterFaceScreen extends StatefulWidget {
  const RegisterFaceScreen({Key? key}) : super(key: key);

  @override
  State<RegisterFaceScreen> createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {
  CameraController? _cameraController;
  bool _isLoading = false;
  bool _isDuplicate = false;
  bool _isSuccess = false;
  bool _camera = true;

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

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium,
        enableAudio: false);
    await _cameraController!.initialize();
  }

  Future<void> captureSelfie() async {
    setState(() => _isLoading = true);
    var force = _isDuplicate ? 'true' : 'false';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var karyawan = jsonDecode(prefs.getString('userData').toString())['data'];
    final userId = karyawan['pernr'];

    final entity = prefs.getString('entity');
    print('====1=====');
    print('====2=====');
    // XFile image = await _cameraController!.takePicture();
    final image = await _cameraController!.takePicture();
    // print(image);
    print('====3=====');
    if (image != null && image.path != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      print(rotatedImage.path);

      print('Capture Berhasil');

      File imageFile = File(rotatedImage.path);
      print('====4=====');

      //========================================================================
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://hitfaceapi.my.id/api/face/extract'));
      print('====5=====');
      request.fields['id_user'] = userId.toString();
      request.fields['entity'] = entity.toString();
      request.fields['force'] = force;
      print('====6=====');
      print(request.fields);
      print('====7=====');
      request.files.add(http.MultipartFile.fromBytes(
          'file', imageFile.readAsBytesSync(),
          filename: imageFile.path.split('/').last));
      print('====8=====');
      var res = await request.send();
      print('====9=====');
      var respStr = await res.stream.bytesToString();
      final result = jsonDecode(respStr) as Map<dynamic, dynamic>;
      var status = result['status'] ?? '';
      var message = result['message'] ?? '';
      var duplicate = result['duplicate'] ?? '';
      var entity2 = result['entity'] ?? '';
      var confidence = result['confidence'] ?? '';
      // var idUser = result['id_user'] ?? '';
      // print(
      // 'status : $status , message : $message , duplicate : $duplicate, confidence : $confidence, entity : $entity2');
      print(result);
      if (status == false) {
        _showErrorDialog(message);
        setState(() => _isDuplicate = false);
      } else {
        if (duplicate == true) {
          _showErrorDialog(message);
          setState(() => _isDuplicate = true);
        } else {
          setState(() => _isDuplicate = false);
          setState(() => _isSuccess = true);
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal:
                                15), //EdgeInsets.all(10), EdgeInsets.only(right: 10)
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Text('$message'),
                            ),
                            status == true
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.black87,
                                      elevation: 5,
                                      primary: Colors.blue[300],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                    onPressed: () {
                                      _cameraController!.dispose();
                                      setState(() {
                                        _camera = false;
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const MainScreenWithAnimation()));
                                    },
                                    child: const Text('Kembali Ke Beranda'),
                                  )
                                : const Text(''),
                          ],
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        }
      }
    }
    //========================================================================
    // if (status != 'false') {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (ctx) => const MainScreenWithAnimation()));
    // }

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
        title: const Text('Daftar Wajah'),
        centerTitle: true,
        backgroundColor: const Color(primaryYellow),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('/user/main');
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: inizializza(),
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
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: MediaQuery.of(context).size.height /
                            //       _cameraController!.value.aspectRatio,
                            //   child: _camera? CameraPreview(_cameraController!):Text(''),
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
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                              child: const Text(
                                'Mohon lepas dulu masker Sebelum mendaftarkan wajah',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _isSuccess
                                ? SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(primaryYellow),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Kembali ke Dashboard',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(primaryBlack)),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _camera = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const MainScreenWithAnimation()));
                                      },
                                    ),
                                  )
                                : _isDuplicate
                                    ? SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(
                                                255, 171, 25, 37),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Tetap Daftarkan Wajah di user ini?',
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
                                    : SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color(primaryYellow),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Daftarkan Wajah',
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
