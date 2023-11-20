import 'package:flutter/cupertino.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/screen_constant.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final String? buttonText;
  final Color? buttonBorderColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double? width;
  final double? height;
  final double? buttonRadius;
  final double? borderWidth;
  final double? buttonTextSize;
  final FontWeight? buttonFontWeight;

  const CustomButton({
    Key? key,
    required this.onPress,
    this.buttonText,
    this.buttonBorderColor,
    this.buttonColor,
    this.width,
    this.height,
    this.borderWidth,
    this.buttonTextSize,
    this.buttonFontWeight,
    this.buttonTextColor,
    this.buttonRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height ?? screenHeight * 0.055,
        width: width ?? screenWidth * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(buttonRadius ?? 25)),
          border: Border.all(color: buttonBorderColor ?? colorPrimary, width: borderWidth ?? 3),
          color: buttonColor ?? colorBackground
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              buttonText ?? "Continue ...",
              style: TextStyle(
                  color: buttonTextColor ?? colorText,
                  fontWeight: buttonFontWeight ?? FontWeight.bold,
                  fontSize: buttonTextSize ?? 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}