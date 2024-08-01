import 'dart:io';

import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String path;

  ImageScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: Image.file(File(path)),
      ),
    );
  }
}
