// ignore_for_file: unused_field, must_be_immutable
import 'package:flutter/material.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/helpers/url_helper.dart';

class HeaderProfileWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final String _apiUrl = API_URL;
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double textLarge = size.width * 0.04;
    double padding20 = size.width * 0.047;

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
                  _userName!.toUpperCase(),
                  style: TextStyle(
                      color: Color(primaryBlack),
                      fontSize: textLarge,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  '$_posision',
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
                backgroundImage: _imageUrl == ''
                    ? const AssetImage('assets/images/user-profile-default.png')
                        as ImageProvider
                    : NetworkImage(
                        '$_apiUrl/get_photo2?nrp=$_imageUrl',
                      )),
          )
        ],
      ),
    );
  }
}
