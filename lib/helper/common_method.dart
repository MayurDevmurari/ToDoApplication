import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tekyz_task/helper/colors.dart';

void writeLog(String? msg){
  if(kDebugMode) {
    log(msg ?? '');
  }
}

class CommonMethod{
  // show snack bar in screen with dynamic message and title
  void showToast(String msg,{bool? showInCenter = false}){
    if(msg.isNotEmpty){
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: showInCenter == true ? ToastGravity.CENTER : ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: colorBackground,
          fontSize: 14.0
      );
    }
  }

  //hide the keyboard
  void hideKeyboard(){
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //show datePicker
  Future<String> showDatePickerDialog({String? date}) async {
    String selectDate = '';
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      locale: const Locale('en', 'GB'),
      lastDate: DateTime.now(),
      fieldHintText: 'DD-MM-YYYY',
      keyboardType: TextInputType.datetime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorPrimary, // header background color
              onPrimary: colorBackground, // header text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorPrimary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      selectDate = DateFormat('dd-MM-yyyy').format(selectedDate).toString();
    }

    return selectDate;
  }

  // serialize TimeOfDay to an integer
  int timeOfDayToInteger(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  // deserialize integer to TimeOfDay in hh:mm a format
  String integerToTimeOfDay(int value) {
    final hours = value ~/ 60;
    final minutes = value % 60;

    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: minutes);

    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}