import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tekyz_task/UI/AddTodoScreen/controller/add_todo_controller.dart';
import 'package:tekyz_task/UI/CommonWidget/app_bar_widget.dart';
import 'package:tekyz_task/UI/CommonWidget/custom_button.dart';
import 'package:tekyz_task/UI/CommonWidget/custom_textfield.dart';
import 'package:tekyz_task/UI/CommonWidget/loading_widget.dart';
import 'package:tekyz_task/UI/CommonWidget/text_widget.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/fonts.dart';
import 'package:tekyz_task/helper/screen_constant.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final AddTodoController addTodoController = Get.put(AddTodoController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    }else{
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarWidget(
              isShowBack: true,
            )
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: 'Title',
                colors: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: Fonts.poppinsSemiBold,
                maxLine: 1,
                textAlign: TextAlign.start,
              ),
              CustomTextField(
                controller: addTodoController.titleController,
                hintText: 'Task title',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                iconAndTextColor: colorText,
                prefixIcon: Icon(
                  CupertinoIcons.t_bubble,
                  color: colorText,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              TextWidget(
                text: 'Description',
                colors: colorBlack,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: Fonts.poppinsSemiBold,
                maxLine: 1,
                textAlign: TextAlign.start,
              ),
              CustomTextField(
                controller: addTodoController.descriptionController,
                hintText: 'Task Description',
                height: screenHeight * 0.1,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                iconAndTextColor: colorText,
                prefixIcon: Icon(
                  CupertinoIcons.line_horizontal_3_decrease,
                  color: colorText,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Is Alarm Required?',
                    colors: colorBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: Fonts.poppinsSemiBold,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                  ),
                  Obx(
                    ()=> Switch(
                      value: addTodoController.isAlarmRequire.value,
                      activeColor: colorPrimary,
                      onChanged: (bool value) {
                        addTodoController.isAlarmRequire.value = !addTodoController.isAlarmRequire.value;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Obx(
                ()=> Visibility(
                  visible: addTodoController.isAlarmRequire.value,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            addTodoController.selectDate(context, (date){
                              String formattedDate = DateFormat('EEE dd MMM yyyy').format(date);
                              addTodoController.selectedDate = date;
                              addTodoController.dateController.text = formattedDate;
                            });
                          },
                          behavior: HitTestBehavior.translucent,
                          child: CustomTextField(
                            controller: addTodoController.dateController,
                            hintText: 'Select Date',
                            isDateFormat: true,
                            enable: false,
                            textInputType: TextInputType.none,
                            textInputAction: TextInputAction.none,
                            iconAndTextColor: colorText,
                            prefixIcon: Icon(
                              CupertinoIcons.calendar,
                              color: colorText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.015,
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            addTodoController.selectTime(context, (time){
                              addTodoController.timeController.text = time.format(context);
                              addTodoController.selectedTime = time;
                            });
                          },
                          behavior: HitTestBehavior.translucent,
                          child: CustomTextField(
                            controller: addTodoController.timeController,
                            hintText: 'Select Time',
                            enable: false,
                            textInputType: TextInputType.none,
                            textInputAction: TextInputAction.none,
                            iconAndTextColor: colorText,
                            prefixIcon: Icon(
                              CupertinoIcons.time,
                              color: colorText,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                        ()=> addTodoController.loading.value == true ? const LoadingWidget() : CustomButton(
                          buttonText: 'Add Task',
                          buttonColor: colorPrimary,
                          buttonBorderColor: colorPrimary,
                          buttonTextColor: colorBackground,
                          onPress: (){
                            //block of code
                            addTodoController.addTask();
                          },
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
