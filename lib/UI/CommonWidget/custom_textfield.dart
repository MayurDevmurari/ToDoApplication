import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tekyz_task/helper/colors.dart';
import 'package:tekyz_task/helper/screen_constant.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Color? iconAndTextColor;
  final TextInputType? textInputType;
  final double? height;
  final bool? isPassword;
  final bool? isDateFormat;
  final bool? enable;
  final bool? isOnPrimary;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixIcon;

  const CustomTextField({
    Key? key,
    this.controller,
    this.iconAndTextColor,
    this.hintText,
    this.textInputType,
    this.height,
    this.isPassword = false,
    this.onChanged,
    this.isDateFormat = false,
    this.textInputAction = TextInputAction.next,
    this.inputFormatter,
    this.enable = true,
    this.isOnPrimary = false,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
      child: Container(
        height: widget.height ?? 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: colorBorder,
            width: 1.0,
          ),
          color: widget.isOnPrimary == false ? colorBackground : colorPrimary,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              inputFormatters: widget.inputFormatter ?? (widget.isDateFormat == true ? [
                MaskTextInputFormatter(
                    mask: '##-##-####',
                    filter: { "#": RegExp(r'\d') },
                    type: MaskAutoCompletionType.lazy
                )
              ] :[]),
              enabled: widget.enable,
              obscureText: widget.isPassword == true ? !passVisible : false,
              obscuringCharacter: '●',
              controller: widget.controller,
              style: TextStyle(
                  fontSize: 14,
                  color: colorBlack.withOpacity(0.6),
                  fontWeight: FontWeight.w500
              ),
              onChanged: (value) {
                // block of code
                if(value.isNotEmpty) {
                  widget.onChanged?.call(value);
                }
              },
              cursorColor: colorBorder,
              cursorWidth: 2,
              maxLines: widget.textInputType == null ? 1 : widget.textInputType == TextInputType.multiline ? 5 : 1,
              keyboardType: widget.textInputType ?? TextInputType.text,
              textInputAction: widget.textInputAction,
              decoration: InputDecoration(
                  suffixIcon: widget.enable == false ? null : GestureDetector(
                    onTap: (){
                      passVisible = !passVisible;
                      setState(() {});
                    },
                    child: widget.isPassword == true ? Icon(
                      passVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_solid,
                      color: colorPrimary,
                    ) : const SizedBox(),
                  ),
                  prefixIcon: widget.prefixIcon,
                  prefixIconConstraints: const BoxConstraints(
                    maxWidth: 40,
                    minWidth: 30
                  ),
                  // suffixIconConstraints: const BoxConstraints(
                  //   maxWidth: 40,
                  //   minWidth: 30
                  // ),
                  focusColor: widget.iconAndTextColor ?? colorBlack,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: widget.enable == false ? -5 : 2),
                  hintText: widget.hintText ?? '',
                  hintMaxLines: 1,
                  hintStyle: TextStyle(
                      color: colorBorder,
                      fontSize: 12
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}