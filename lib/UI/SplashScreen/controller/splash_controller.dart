import 'package:get/get.dart';
import 'package:tekyz_task/routes/app_pages.dart';

class  SplashController extends GetxController{
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSettings();
  }
  
  void getSettings(){
    Future.delayed(const Duration(seconds: 3)).then((value){
      Get.offAllNamed(Routes.dashboardScreen);
    });
  }
}