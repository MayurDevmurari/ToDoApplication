import 'package:flutter/material.dart';

Size? screenSize;
double defaultScreenWidth = 380.0;
double defaultScreenHeight = 800.0;
double screenWidth = defaultScreenWidth;
double screenHeight = defaultScreenHeight;

class ScreenConstant {

  static void setScreenConstant(context){
    screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize?.width ?? 0;
    screenHeight = screenSize?.height ?? 0;
  }
}
