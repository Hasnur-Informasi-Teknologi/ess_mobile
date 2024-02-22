import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_ess/services/log_service.dart';

// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

class NotifService {
  // awesomeNotif(clockIn, clockOut) async {
  //   // INITIALIZE AWESOME NOTIFICAITON
  //   AwesomeNotifications().initialize(
  //       // set the icon to null if you want to use the default app icon
  //       'resource://drawable/logo',
  //       // null,
  //       [
  //         NotificationChannel(
  //             channelGroupKey: 'basic_channel_group',
  //             channelKey: 'basic_channel',
  //             channelName: 'Basic notifications',
  //             channelDescription: 'Notification channel for basic tests',
  //             defaultColor: Color.fromARGB(255, 255, 255, 56),
  //             playSound: true,
  //             soundSource: 'resource://raw/alarm',
  //             enableVibration: true,
  //             enableLights: true,
  //             ledColor: Colors.white)
  //       ],
  //       // Channel groups are only visual and are not required
  //       // channelGroups: [
  //       //   NotificationChannelGroup(
  //       //       channelGroupkey: 'basic_channel_group',
  //       //       channelGroupName: 'Basic group')
  //       // ],
  //       debug: false);

  //   AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //     if (!isAllowed) {
  //       // This is just a basic example. For real apps, you must show some
  //       // friendly dialog box before call the request method.
  //       // This is very important to not harm the user experience
  //       AwesomeNotifications().requestPermissionToSendNotifications();
  //     }
  //   });

  //   final today = DateTime.now();
  //   clockIn = today.toString().split(' ')[0] + ' ' + clockIn + '.000';
  //   clockOut = today.toString().split(' ')[0] + ' ' + clockOut + '.000';
  //   try {
  //     clockIn = DateTime.parse(clockIn.split(':').join('.'));
  //     clockOut = DateTime.parse(clockOut.split(':').join('.'));
  //     print('jalur 1');
  //   } catch (e) {
  //     clockIn = DateTime.parse(clockIn);
  //     clockOut = DateTime.parse(clockOut);
  //     print('jalur 2');
  //   }

  //   var clockIn1 = clockIn.add(const Duration(minutes: -15));
  //   var clockIn2 =
  //       clockIn.add(const Duration(days: 1, minutes: -15)); // 1 hari besok -15
  //   var clockIn3 =
  //       clockIn.add(const Duration(days: 2, minutes: -15)); // 1 hari besok -15
  //   var clockIn4 =
  //       clockIn.add(const Duration(days: 3, minutes: -15)); // 1 hari besok -15

  //   var clockOut1 = clockOut;
  //   var clockOut2 = clockOut.add(const Duration(days: 1)); // 1 hari besok
  //   var clockOut3 = clockOut.add(const Duration(days: 2)); // 1 hari besok
  //   var clockOut4 = clockOut.add(const Duration(days: 3)); // 1 hari besok
  //   //   // LogS().logLocal('clockIn1 $clockIn1');
  //   //   // LogS().logLocal('clockIn2 $clockIn2');
  //   //   // LogS().logLocal('clockIn3 $clockIn3');
  //   //   // LogS().logLocal('clockIn4 $clockIn4');

  //   //   // LogS().logLocal('clockOut1 $clockOut1');
  //   //   // LogS().logLocal('clockOut2 $clockOut2');
  //   //   // LogS().logLocal('clockOut3 $clockOut3');
  //   //   // LogS().logLocal('clockOut4 $clockOut4');
  //   //   //   //  IN
  //   await createNotifChannel(
  //       1, clockIn1, 'Info Absen', 'Jangan lupa untuk melakukan Absen Masuk!');
  //   await createNotifChannel(
  //       2, clockIn2, 'Info Absen', 'Jangan lupa untuk melakukan Absen Masuk!');
  //   await createNotifChannel(
  //       3, clockIn3, 'Info Absen', 'Jangan lupa untuk melakukan Absen Masuk!');
  //   await createNotifChannel(
  //       4, clockIn4, 'Info Absen', 'Jangan lupa untuk melakukan Absen Masuk!');
  //   // OUT
  //   await createNotifChannel(5, clockOut1, 'Info Absen',
  //       'Jangan lupa untuk melakukan Absen Keluar!');
  //   await createNotifChannel(6, clockOut2, 'Info Absen',
  //       'Jangan lupa untuk melakukan Absen Keluar!');
  //   await createNotifChannel(7, clockOut3, 'Info Absen',
  //       'Jangan lupa untuk melakukan Absen Keluar!');
  //   await createNotifChannel(8, clockOut4, 'Info Absen',
  //       'Jangan lupa untuk melakukan Absen Keluar!');

  //   print('Berhasil menambahkan notifikasi schedule');
  // }

  // createNotifChannel(ids, tanggal, titles, bodys) async {
  //   return await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: ids,
  //       channelKey: 'basic_channel',
  //       title: titles,
  //       body: bodys,
  //       locked: false,
  //       criticalAlert: true,
  //       category: NotificationCategory.Reminder, //NotificationCategory.Alarm
  //       wakeUpScreen: true,
  //     ),
  //     schedule:
  //         NotificationCalendar.fromDate(date: tanggal, preciseAlarm: true),
  //     actionButtons: <NotificationActionButton>[
  //       NotificationActionButton(
  //         key: 'remove',
  //         label: 'Stop',
  //       ),
  //     ],
  //   );
  // }
}
