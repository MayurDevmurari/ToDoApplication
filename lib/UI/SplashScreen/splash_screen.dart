import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tekyz_task/UI/SplashScreen/controller/splash_controller.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/images.dart';
import 'package:tekyz_task/helper/screen_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashController splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenConstant.setScreenConstant(context);
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
