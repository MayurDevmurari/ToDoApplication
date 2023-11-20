import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tekyz_task/UI/CommonWidget/text_widget.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/common_method.dart';
import 'package:tekyz_task/helper/screen_constant.dart';

class AppBarWidget extends StatelessWidget {
  final bool? isShowBack;

  const AppBarWidget({
    super.key,
    this.isShowBack = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.05,
            width: screenHeight * 0.04,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color:  colorPrimary,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: isShowBack == true ? (){
                Get.back();
              } : (){},
              child: Center(
                child: Icon(
                  isShowBack == true ? CupertinoIcons.back : CupertinoIcons.line_horizontal_3_decrease_circle,
                  color: colorBackground,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextWidget(
              text: 'Homepage',
              colors: colorBlack,
              fontSize: 18,
              maxLine: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: screenHeight * 0.05,
            width: screenHeight * 0.04,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: colorPrimary,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                CommonMethod().showToast('Notification goes here...');
              },
              child: Center(
                child: Icon(
                  CupertinoIcons.bell_circle,
                  color: colorBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
