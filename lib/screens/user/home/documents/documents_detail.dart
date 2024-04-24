import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DetailDokumenScreen extends StatefulWidget {
  final String lampiran;

  const DetailDokumenScreen({required this.lampiran});

  @override
  _DetailDokumenScreenState createState() => _DetailDokumenScreenState();
}

class _DetailDokumenScreenState extends State<DetailDokumenScreen> {
  late File _file;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _decodeAndSaveFile();
  }

  Future<void> _decodeAndSaveFile() async {
    try {
      final bytes1 = base64.decode(widget.lampiran);
      final data1 = utf8.decode(bytes1);
      final bytes2 = base64.decode(data1);

      final dir = await getTemporaryDirectory();
      _file = File('${dir.path}/dokumen.pdf');
      await _file.writeAsBytes(bytes2);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Dokumen'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _file != null
                ? ElevatedButton(
                    onPressed: () {
                      if (_file != null) {
                        _showPdfPreview(context, _file);
                      }
                    },
                    child: Text('Open PDF'),
                  )
                : Text('Failed to load PDF'),
      ),
    );
  }

  Future<void> _showPdfPreview(BuildContext context, File file) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PDF Preview'),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: SizedBox(),
            // PDFView(
            //   filePath: file.path,
            // ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
