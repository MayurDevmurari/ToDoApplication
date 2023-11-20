import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tekyz_task/helper/common_method.dart';
import 'package:tekyz_task/helper/string_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';

import 'package:tekyz_task/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddTodoController extends GetxController{
  RxBool loading = false.obs;
  RxBool isAlarmRequire = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late Box<TodoModel> todoBox;

  @override
  void onInit() {
    super.onInit();
    todoBox = Hive.box<TodoModel>(StringConstant.boxName);
  }

  // select date
  Future selectDate(BuildContext context, Function(DateTime) onDatePicked) async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      onDatePicked(pickedDate);
    }
  }

  // select time
  Future selectTime(BuildContext context, Function(TimeOfDay) onTimePicked) async {
    var pickedTime = await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null) {
      onTimePicked(pickedTime);
    }
  }

  // adding new task into hive storage
  Future<void> addTask() async {
    loading.value = true;
    // add delay here for showing loading widget
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      TodoModel todoModel = TodoModel(
          titleController.text,
          descriptionController.text,
          isAlarmRequire.value,
          selectedDate,
          CommonMethod().timeOfDayToInteger(selectedTime),
          false,
          DateFormat("yyyy-MM-dd HH:mm:ss.SSS Z").format(DateTime.now()),
      );

      await todoBox.put(todoModel.createdAt, todoModel);

      if(isAlarmRequire.value == true){
        DateTime alarmDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
        setNotificationAlarm(alarmDateTime, todoModel);
      }

      resetForm();
      CommonMethod().showToast('Task added...');
      Get.back();
      loading.value = false;
    });
  }

  //reset current form
  void resetForm(){
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    timeController.clear();
    isAlarmRequire.value = false;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    CommonMethod().hideKeyboard();
  }

  Future<void> setNotificationAlarm(DateTime alarmDateTime,TodoModel todoModel) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      alarmDateTime.year,
      alarmDateTime.month,
      alarmDateTime.day,
      alarmDateTime.hour,
      alarmDateTime.minute,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      todoModel.createdAt,
      todoModel.title,
      channelDescription: todoModel.description,
      sound: const RawResourceAndroidNotificationSound('alarm_tone_2'),
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      sound: 'alarm_tone_2.aiff',
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id++,
        todoModel.title,
        todoModel.description,
        scheduleDate,
        notificationDetails,androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );
  }
}