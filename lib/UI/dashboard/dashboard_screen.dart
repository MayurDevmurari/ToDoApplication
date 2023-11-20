import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tekyz_task/UI/CommonWidget/app_bar_widget.dart';
import 'package:tekyz_task/UI/CommonWidget/custom_textfield.dart';
import 'package:tekyz_task/UI/CommonWidget/text_widget.dart';
import 'package:tekyz_task/UI/dashboard/controller/dashboard_controller.dart';
import 'package:tekyz_task/UI/dashboard/widget/todo_item_widget.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/fonts.dart';
import 'package:tekyz_task/helper/screen_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';
import 'package:tekyz_task/routes/app_pages.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    dashboardController.searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      dashboardController.filteredTodoModelList.clear();
      dashboardController.filteredTodoModelList.addAll(dashboardController.filterData(dashboardController.searchController.text));
    });
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
        floatingActionButton: Container(
          height: screenHeight * 0.06,
          width: screenHeight * 0.06,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            color: colorPrimary,
          ),
          child: InkWell(
            onTap: (){
              Get.toNamed(Routes.addTodoScreen);
            },
            child: Center(
              child: Icon(
                CupertinoIcons.add_circled,
                color: colorBackground,
              ),
            ),
          ),
        ),
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBarWidget()
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.005),
              child: CustomTextField(
                controller: dashboardController.searchController,
                hintText: 'Search',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.search,
                iconAndTextColor: colorText,
                prefixIcon: Icon(
                  CupertinoIcons.search_circle,
                  color: colorText,
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: dashboardController.todoBox.listenable(),
                  builder: (context, Box<TodoModel> box, _) {
                    if(dashboardController.searchController.text.isNotEmpty){
                      dashboardController.todoModelList.clear();
                      dashboardController.todoModelList.addAll(dashboardController.filteredTodoModelList);
                    }else{
                      dashboardController.todoModelList.clear();
                      dashboardController.todoModelList.addAll(box.values.toList());
                    }
                    if(dashboardController.todoModelList.isEmpty){
                      return Center(
                        child: TextWidget(
                          text: 'No Data Found',
                          colors: colorBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: Fonts.poppinsSemiBold,
                          maxLine: 1,
                          textAlign: TextAlign.start,
                        ),
                      );
                    }else{
                      return ListView.builder(
                        itemCount: dashboardController.todoModelList.length,
                        itemBuilder: (context, index){
                          return TodoItemWidget(
                            todoModel: dashboardController.todoModelList[index],
                          );
                        },
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
