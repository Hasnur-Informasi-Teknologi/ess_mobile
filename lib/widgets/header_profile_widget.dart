// ignore_for_file: unused_field, must_be_immutable
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_ess/helpers/http_override.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/helpers/url_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderProfileWidget extends StatefulWidget {
  final String? _userName;
  final String? _posision;
  final String? _imageUrl;
  final String? _webUrl;

  const HeaderProfileWidget({
    Key? key,
    required String? userName,
    required String? posision,
    required String? imageUrl,
    required String? webUrl,
  })  : _userName = userName,
        _posision = posision,
        _imageUrl = imageUrl,
        _webUrl = webUrl,
        super(key: key);

  @override
  State<HeaderProfileWidget> createState() => _HeaderProfileWidgetState();
}

class _HeaderProfileWidgetState extends State<HeaderProfileWidget> {
  final String _apiUrl = API_URL;
  Uint8List? _imageBytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final ioClient = createIOClientWithInsecureConnection();

    final response = await ioClient.get(
      Uri.parse('$_apiUrl/master/profile/get_photo'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _imageBytes = response.bodyBytes;
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String _apiUrl = API_URL;
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;

    ImageProvider<Object>? imageProvider;

    if (_imageBytes == null) {
      imageProvider =
          const AssetImage('assets/images/user-profile-default.png');
    } else {
      imageProvider = MemoryImage(_imageBytes!);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding20, vertical: padding20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget._userName!.toUpperCase(),
                  style: TextStyle(
                      color: Color(primaryBlack),
                      fontSize: textLarge,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  '${widget._posision}',
                  style: TextStyle(
                      color: Color(primaryBlack),
                      fontSize: textMedium,
                      letterSpacing: 0.9,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 33,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 30,
                backgroundImage: imageProvider),
          )
        ],
      ),
    );
  }
}
