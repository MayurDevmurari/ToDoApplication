import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tekyz_task/UI/SplashScreen/controller/splash_controller.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/images.dart';
import 'package:tekyz_task/helper/screen_constant.dart';
import 'package:tekyz_task/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashController splashController = Get.put(SplashController());
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenConstant.setScreenConstant(context);
      _isAndroidPermissionGranted();
      _requestPermissions();
      _configureDidReceiveLocalNotificationSubject();
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }else{
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    }

    ScreenConstant.setScreenConstant(context);

    return Scaffold(
      backgroundColor: colorPrimary,
      body: Center(
        child: Image.asset(
          Images.logo,
          color: colorBackground,
        ),
      ),
    );
  }
}
