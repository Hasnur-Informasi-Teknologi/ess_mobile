import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen_with_animation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:mobile_ess/screens/attendance/wfo_location_screen.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _camera = true;
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
              title: const Text('Scan QR'),
              centerTitle: true,
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
          body: _camera
              ? MobileScanner(
                  controller: _cameraController,
                  onDetect: (capture) {
                    _cameraController.stop();
                    _cameraController.dispose();
                    setState(() {
                      _camera = false;
                    });
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      Get.to(WFOLocationScreen(
                          qrLocation: barcode.rawValue!,
                          workLocation: 'Office'));
                    }
                  },
                )
              : Text('')),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    print('Camera Disposed!');
    super.dispose();
  }
}
