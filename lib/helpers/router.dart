import 'package:flutter/material.dart';
import 'package:mobile_ess/screens/authentication/signin_screen.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/detail_pengumuman_screen.dart';
import 'package:mobile_ess/screens/user/home/pengumuman/pengumuman_screen.dart';
import 'package:mobile_ess/screens/user/home/online_form/form_aplikasi_training_screen/form_aplikasi_training_screen.dart';
import 'package:mobile_ess/screens/user/home/online_form/online_form_screen.dart';
import 'package:mobile_ess/screens/user/home/request_attendance/request_attendance_karwayan_screen.dart';
import 'package:mobile_ess/screens/user/home/request_attendance/ubah_data_kehadiran_screen.dart';
import 'package:mobile_ess/screens/user/main/main_screen.dart';
import 'package:mobile_ess/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routers() {
  return {
    '/': (context) => const SignInScreen(),
    '/splash': (context) => const SplashScreen(),
    '/user/main': (context) => const MainScreen(),
    '/user/main/home/online_form': (context) => const OnlineFormScreen(),
    '/user/main/home/online_form/aplikasi_training': (context) =>
        const FormAplikasiTrainingScreen(),
    '/user/main/home/request_attendance': (context) =>
        const RequestAttendanceKaryawanScreen(),
    '/user/main/home/request_attendance/ubah_data_kehadiran': (context) =>
        const UbahDataKehadiranScreen(),
    '/user/main/home/pengumuman': (context) => const PengumumanScreen(),
    '/user/main/home/pengumuman/detail_pengumuman': (context) =>
        const DetailPengumumanScreen(),
  };
}
