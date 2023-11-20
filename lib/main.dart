import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tekyz_task/helper/fonts.dart';
import 'package:tekyz_task/helper/string_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';

import 'routes/app_pages.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async{
  await Hive.initFlutter();
  await Alarm.init();
  HttpOverrides.global = MyHttpOverrides();
  Hive.registerAdapter(TodoModelAdapter());
  Hive.openBox<TodoModel>(StringConstant.boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      theme: ThemeData(
        fontFamily: Fonts.fontFamily,
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale('en', 'GB'),
      ],
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
      title: StringConstant.appName,
    );
  }
}
