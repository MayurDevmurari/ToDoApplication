import 'package:get/get.dart';
import 'package:tekyz_task/UI/AddTodoScreen/add_todo_screen.dart';
import 'package:tekyz_task/UI/SplashScreen/splash_screen.dart';
import 'package:tekyz_task/UI/dashboard/dashboard_screen.dart';
part 'app_routes.dart';

class AppPages {
  static const initialRoute = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: Routes.addTodoScreen,
      page: () => const AddTodoScreen(),
    ),
    GetPage(
      name: Routes.dashboardScreen,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
    ),
  ];
}
