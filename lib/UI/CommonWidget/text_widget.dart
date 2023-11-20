import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/fonts.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final Color? colors;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLine;
  final TextAlign? textAlign;
  final String? fontFamily;
  final bool? isLineThrough;

  const TextWidget({
    Key? key,
    required this.text,
    this.colors,
    this.fontSize,
    this.fontWeight,
    this.maxLine,
    this.textAlign,
    this.fontFamily,
    this.isLineThrough = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: colors ?? colorBackground,
        fontSize: fontSize ?? 12.0,
        fontWeight: fontWeight ?? FontWeight.bold,
        fontFamily: fontFamily ?? Fonts.poppinsRegular,
        decoration: isLineThrough == true ? TextDecoration.lineThrough : null
      ),
      maxLines: maxLine ?? 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
