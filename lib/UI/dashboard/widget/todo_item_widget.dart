import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:tekyz_task/UI/CommonWidget/text_widget.dart';
import 'package:tekyz_task/UI/dashboard/controller/dashboard_controller.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/common_method.dart';
import 'package:tekyz_task/helper/fonts.dart';
import 'package:tekyz_task/helper/screen_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';

class TodoItemWidget extends StatefulWidget {
  final TodoModel todoModel;
  const TodoItemWidget({
    super.key,
    required this.todoModel
  });

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  final DashboardController dashboardController = Get.find();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.todoModel.isComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.005),
      child: Slidable(
        key: ValueKey(widget.todoModel.createdAt),
        endActionPane: ActionPane(
          dragDismissible: false,
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context){
                dashboardController.deleteData(widget.todoModel.createdAt);
              },
              foregroundColor: colorPrimary,
              backgroundColor: colorBackground,
              icon: CupertinoIcons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Material(
          elevation: 3,
          shadowColor: colorSecondary,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            //height: screenHeight * 0.08,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: colorBackground,
            ),
            child: Row(
              children: [
                Container(
                  height: screenHeight * 0.075,
                  width: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color:  colorPrimary.withOpacity(0.8),
                  ),
                  child: Center(
                    child: Icon(
                      widget.todoModel.isComplete == true ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.timelapse,
                      color: colorBackground,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.001),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: widget.todoModel.title,
                                    colors: colorText,
                                    fontSize: 14,
                                    maxLine: 1,
                                    isLineThrough: widget.todoModel.isComplete,
                                    textAlign: TextAlign.start,
                                  ),
                                  widget.todoModel.isAlarmRequired == false ? const SizedBox() : TextWidget(
                                    text: '${DateFormat("EEE dd MMM yyyy").format(widget.todoModel.selectedDate)} '
                                        '${CommonMethod().integerToTimeOfDay(widget.todoModel.selectedTime)}',
                                    colors: colorText,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 12,
                                    fontFamily: Fonts.poppinsSemiBold,
                                    maxLine: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            MSHCheckbox(
                              size: 25,
                              value: isChecked,
                              colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                                checkedColor: colorPrimary,
                              ),
                              style: MSHCheckboxStyle.stroke,
                              onChanged: (selected) {
                                TodoModel todoModel = TodoModel(
                                  widget.todoModel.title,
                                  widget.todoModel.description,
                                  widget.todoModel.isAlarmRequired,
                                  widget.todoModel.selectedDate,
                                  widget.todoModel.selectedTime,
                                  selected,
                                  widget.todoModel.createdAt,
                                );

                                dashboardController.updateData(todoModel).then((value){
                                  setState(() {
                                    isChecked = selected;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                        TextWidget(
                          text: widget.todoModel.description,
                          colors: colorText,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          maxLine: 2,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
