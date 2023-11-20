import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tekyz_task/helper/string_constant.dart';
import 'package:tekyz_task/hive/todo_model.dart';

class  DashboardController extends GetxController{
  RxBool loading = false.obs;

  late Box<TodoModel> todoBox;
  RxList<TodoModel> todoModelList = <TodoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    todoBox = Hive.box<TodoModel>(StringConstant.boxName);
  }

  Future<void> deleteData(String createdAt) async {
    await todoBox.delete(createdAt);
  }

  Future<void> updateData(TodoModel todoModel) async {
    await todoBox.put(todoModel.createdAt, todoModel);
  }
}