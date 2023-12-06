// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_ess/themes/constant.dart';
import 'package:mobile_ess/track_transparency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isUserLogin = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceDataId = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _initCheck();
  }

  Future<void> _initCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var role_id=prefs.getInt('role_id');
    var permission = prefs.getBool('permission');
    if(permission==null){
      return Get.to(TrackTransparency());
    }

    var deviceData = <String, dynamic>{};
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }

    // if (prefs.getString('token') != null) {
    //   setState(() {
    //     _isUserLogin = prefs.getBool('isUserLogin')!;
    //     deviceDataId = deviceData;
    //   });
    // }

    if (prefs.getString('token') != null) {
      // final userId = prefs.getString('userId');
      try {
        if(role_id==1){
          Future.delayed(const Duration(seconds: 2), () => {Get.offAllNamed('/admin/main')});
        }else if(role_id==4){
          Future.delayed(const Duration(seconds: 2), () => {Get.offAllNamed('/user/main')});
        }

        // await Provider.of<AuthProvider>(context, listen: false)
        //     .checkDeviceId(
        //         userId!,
        //         (Platform.isAndroid)
        //             ? deviceDataId['id']
        //             : deviceDataId['identifierForVendor'])
        //     .then(
        //       (_) => Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (ctx) => const HomeScreen(),
        //         ),
        //       ),
        //     );
      } catch (e) {
        print('belum ada token 1');
        Get.offAllNamed('/');

        // Future.delayed(
        //   const Duration(seconds: 1),
        //   () => Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (ctx) => const SignInScreen(),
        //     ),
        //   ),
        // );
      }
    } else {
      print('belum ada token 2');

      Future.delayed(const Duration(seconds: 2), () => {Get.offAllNamed('/')});
    }
  }

  // device id
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(primaryYellow),
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(primaryYellow),
        body: Center(
          child: Image.asset('assets/images/logo-hasnur.png', width: 150),
        ),
      ),
    );
  }
}
