import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tekyz_task/helper/string_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';

class  DashboardController extends GetxController{
  RxBool loading = false.obs;

  late Box<TodoModel> todoBox;
  RxList<TodoModel> todoModelList = <TodoModel>[].obs;

  TextEditingController searchController = TextEditingController();
  RxList<TodoModel> filteredTodoModelList = <TodoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    todoBox = Hive.box<TodoModel>(StringConstant.boxName);
  }

  List<TodoModel> filterData(String query) {
    return todoBox.values.where((todoTask) => todoTask.title.toLowerCase().contains(query.toLowerCase())
        || todoTask.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<void> deleteData(String createdAt) async {
    await todoBox.delete(createdAt);
  }

  Future<void> updateData(TodoModel todoModel) async {
    await todoBox.put(todoModel.createdAt, todoModel);
  }
}