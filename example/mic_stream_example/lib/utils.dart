import 'package:flutter/material.dart';


class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double size5;
  static double size8;
  static double size10;
  static double size12;
  static double size14;
  static double size15;
  static double size16;
  static double size18;
  static double size20;
  static double size22;
  static double size25;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    size5 = screenHeight * 0.0075;
    size8 = screenHeight * 0.012;
    size10 = screenHeight * 0.0148;
    size12 = screenHeight * 0.0179;
    size14 = screenHeight * 0.0207;
    size15 = screenHeight * 0.0222;
    size16 = screenHeight * 0.02365;
    size18 = screenHeight * 0.0267;
    size20 = screenHeight * 0.0296;
    size22 = screenHeight * 0.0326;
    size25 = screenHeight * 0.03695;

  }
}
OutlineInputBorder outlineInputBorder(Color color,double borderRadius,double borderWidth) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    borderSide: BorderSide(color: color, width: borderWidth),
  );
}
