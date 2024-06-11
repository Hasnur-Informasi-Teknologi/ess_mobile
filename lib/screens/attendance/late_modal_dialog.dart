import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:mobile_ess/screens/attendance/take_selfie_screen.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:mobile_ess/widgets/text_form_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class LateModalDialog extends StatefulWidget {
  const LateModalDialog({super.key, required this.newData});

  final Map<String, dynamic> newData;

  @override
  State<LateModalDialog> createState() => _LateModalDialogState();
}

class _LateModalDialogState extends State<LateModalDialog> {
  final String _apiUrl = API_URL;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _alasanTerlambatController = TextEditingController();
  bool _isLoading = false;
  XFile? _imageFile;

  // Metode untuk mengambil gambar dari kamera
  Future<void> _getImage() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    File rotatedImage =
        await FlutterExifRotation.rotateImage(path: _imageFile!.path);
    File imageFile = File(rotatedImage.path);
    // Periksa ukuran berkas
    int fileSizeInBytes = imageFile.lengthSync();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 5) {
      // Kompresi gambar jika ukuran melebihi 5 MB
      imageFile = await _compressImage(imageFile);
    }

    Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
    final ioClient = createIOClientWithInsecureConnection();
    var request = http.MultipartRequest('POST', Uri.parse('$_apiUrl/absen'))
      ..headers.addAll(headers)
      ..fields['nrp'] = widget.newData['nrp']
      ..fields['lat'] = widget.newData['lat']
      ..fields['long'] = widget.newData['long']
      ..fields['hari'] = widget.newData['hari']
      ..fields['clock_time'] = widget.newData['clock_time']
      ..fields['working_location'] = widget.newData['working_location']
      ..fields['address'] = widget.newData['address']
      ..fields['late_reason'] = _alasanTerlambatController.text
      ..files.add(http.MultipartFile.fromBytes(
          'late_attachment', imageFile.readAsBytesSync(),
          filename: imageFile.path.split('/').last))
      ..files.add(http.MultipartFile.fromBytes(
          'image', widget.newData['image'].readAsBytesSync(),
          filename: widget.newData['image'].path.split('/').last));
    // var response = await request.send();
    // final responseData = await response.stream.bytesToString();
    var streamedResponse = await ioClient.send(request);
    final responseData = await streamedResponse.stream.bytesToString();
    final responseDataMessage = json.decode(responseData);
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
    if (responseDataMessage['message'] == 'Success') {
      Get.offAllNamed('/user/main');
    }
  }

  Future<File> _compressImage(File imageFile) async {
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      throw Exception('Error decoding image.');
    }

    // Kompresi gambar dengan kualitas 70%
    List<int> compressedImage = img.encodeJpg(image, quality: 70);

    // Simpan gambar yang diperkecil ke file
    File compressedFile = File(imageFile.path)
      ..writeAsBytesSync(compressedImage);

    return compressedFile;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double sizedBoxHeightTall = size.height * 0.015;
    double sizedBoxHeightExtraTall = size.height * 0.02;
    double padding5 = size.width * 0.0115;

    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.grey,
            body: AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: sizedBoxHeightTall,
                  ),
                  Center(
                    child: Text(
                      'Anda Terlambat',
                      style: TextStyle(
                        color: const Color(primaryBlack),
                        fontSize: textLarge,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  _imageFile != null
                      ? Center(
                          child: Image.file(
                            File(_imageFile!.path),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _getImage,
                      child: Text('Take Picture'),
                    ),
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  TextFormFieldWidget(
                    controller: _alasanTerlambatController,
                    maxHeightConstraints: 40,
                    hintText: 'Alasan Terlambat',
                  ),
                  SizedBox(
                    height: sizedBoxHeightExtraTall,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      setState(() {
                        _submit();
                      });
                    },
                    child: Container(
                      height: size.height * 0.04,
                      padding: EdgeInsets.all(padding5),
                      decoration: BoxDecoration(
                        color: const Color(primaryYellow),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Color(primaryBlack),
                            fontSize: textMedium,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
