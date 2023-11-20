import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tekyz_task/helper/common_method.dart';
import 'package:tekyz_task/helper/images.dart';
import 'package:tekyz_task/helper/string_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';

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
        firstDate: DateTime(1950),
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
        final alarmDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);

        writeLog('Alarm Date and Time $alarmDateTime');

        final alarmSettings = AlarmSettings(
          id: 1,
          dateTime: alarmDateTime,
          assetAudioPath: Images.alarmTone1,
          loopAudio: true,
          vibrate: true,
          volumeMax: true,
          fadeDuration: 3.0,
          notificationTitle: todoModel.title,
          notificationBody: todoModel.description,
          enableNotificationOnKill: true,
        );
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
}