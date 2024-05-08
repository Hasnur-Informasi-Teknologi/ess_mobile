// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_ess/screens/authentication/signin_screen.dart';
import 'package:mobile_ess/themes/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackTransparency extends StatefulWidget {
  const TrackTransparency({Key? key}) : super(key: key);

  @override
  State<TrackTransparency> createState() => _TrackTransparencyState();
}

class _TrackTransparencyState extends State<TrackTransparency> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Allow Mobile ESS to use your app activity?',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Color(primaryBlack)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 20)),
                            Icon(
                              Icons.location_on,
                              size: 30.0,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              // 'track and take your GPS position to\nretrieve employee position data',
                              'HG Attendance collects location\ndata to enable location tracking\nof absent employees,Get\nLocation Map when app\nis always in use',
                              style: TextStyle(
                                  color: Color(primaryBlack),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 20)),
                            Icon(
                              Icons.photo_camera,
                              size: 30.0,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              // 'take photos and identify or\nrecognize employee facial data',
                              'Mobile ESS collects camera data\nto enable Facial Recognition\n API to identify employees when\n the app is always in use',
                              style: TextStyle(
                                  color: Color(primaryBlack),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'For the functional use of our application, we need to retrieve photo and GPS data to perform employee absences in this application.',
                          style: TextStyle(
                              color: Color(primaryBlack),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Learn more about the permission requirements used by this application here.',
                          style: TextStyle(
                              color: Color(primaryBlack),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'ess-dev.hasnurgroup.com:8081/privacy_policy',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("This Permission is recomended")));

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const SignInScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Don\'t Allow',
                          style: TextStyle(
                              color: Color(primaryBlack),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          PermissionStatus statusLocation =
                              await Permission.location.request();

                          PermissionStatus statusCamera =
                              await Permission.camera.request();

                          if (statusLocation.isGranted &&
                              statusCamera.isGranted) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('permission', true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const SignInScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("This Permission is recomended")));

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const SignInScreen()));
                          }

                          // PermissionStatus status = await Permission
                          //     .appTrackingTransparency
                          //     .request();

                          // if (status.isGranted) {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (ctx) => const SignInScreen()));
                          // } else if (status.isPermanentlyDenied) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           content:
                          //               Text("This Permission is recomended")));

                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (ctx) => const SignInScreen()));
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Allow',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
