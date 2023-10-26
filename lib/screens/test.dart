import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  void sendFormData() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile2 = await _picker.pickImage(source: ImageSource.gallery);
    File imageFile = File(imageFile2!.path);
    print(imageFile);
    print(imageFile.path);
    print(imageFile2.path);
    if(imageFile == null) {
      print('No image selected.');
      return;
    }

    Map<String, String> headers = {'Content-Type': 'multipart/form-data', 'Authorization': 'Bearer 103|qHAYA823Emp4WBsk3WT0MRoIMOHOmUNS8eycKb1S',};
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.106.147:8000/api/rawat/jalan/create'));
      request.headers.addAll(headers);
      request.fields['nama'] = 'RIFKI NAZAR FIRDAUS';
      request.fields['pernr'] = '78230012';
      request.fields['pt'] = 'Hasnur Informasi Teknologi';
      request.fields['lokasi'] = 'BANJARBARU';
      request.fields['pangkat'] = 'Senior Officer';
      request.fields['hire_date'] = '2023-09-01';
      request.fields['prd_rawat'] = '2023-01-03';
      request.fields['tgl_pengajuan'] = '2023-10-11';
      request.fields['approved_by1'] = '78160001';
      request.fields['detail[0][id_md_jp_rawat_jalan]'] = '2';
      request.fields['detail[0][detail_penggantian]'] = 'Frame';
      request.fields['detail[0][no_kuitansi]'] = 'Qui est reprehenderit';
      request.fields['detail[0][tgl_kuitansi]'] = '1976-06-26';
      request.fields['detail[0][nm_pasien]'] = 'RIFKI NAZAR FIRDAUS';
      request.fields['detail[0][hub_karyawan]'] = 'Diri Sendiri';
      request.fields['detail[0][jumlah]'] = '200000';
      request.fields['detail[0][keterangan]'] = 'Dignissimos excepturi';
      request.files.add(http.MultipartFile.fromBytes(
          'lampiran', imageFile.readAsBytesSync(),
          filename: imageFile.path.split('/').last));
      var res = await request.send();
      var respStr = await res.stream.bytesToString();
      // final result = jsonDecode(respStr) as Map<dynamic, dynamic>;
      print("================result===================");
      print("================result===================");
      print("================result===================");
      print("================result===================");
      print(respStr);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Component Selector'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('woke'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              elevation: 5,
              primary: Colors.blue[300],
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            onPressed: () {
              sendFormData();
            },
            child: Text('Click'),
          ),
        ],
      ),
    );
  }
}
