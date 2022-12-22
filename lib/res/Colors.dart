import 'package:flutter/material.dart';




class AppColor {
  AppColor._();
  static const colorPrimary = Color(0xff186F8F);
  static const MaterialColor colorPrimaryAccent = MaterialColor(0xff186F8F, {
    50:  Color.fromRGBO(24, 111, 143, 0.1),
    100: Color.fromRGBO(24, 111, 143, 0.2),
    200: Color.fromRGBO(24, 111, 143, 0.3),
    300: Color.fromRGBO(24, 111, 143,0.4),
    400: Color.fromRGBO(24, 111, 143, 0.5),
    500: Color.fromRGBO(24, 111, 143, 0.6),
    600: Color.fromRGBO(24, 111, 143, 0.7),
    700: Color.fromRGBO(24, 111, 143, 0.8),
    800: Color.fromRGBO(24, 111, 143, 0.9),
    900: Color.fromRGBO(24, 111, 143, 1.0),
  });
  static const errorColor = Color(0xFF808080);
  static const secondaryColor = Color.fromARGB(255, 247, 221, 107);
  static const categoryBtnColor = Color(0xFF444444);

  static const textGreenColor = Color(0xff0FA654);
  static const textRedColor = Color(0xffCC3D36);
  static const commonTextGreyColor = Color(0xFF7C7B7B);
  static const Color commonTextColor = Color(0xFF4D4D4D);


  static const Color darkGrey = Color.fromARGB(255, 86, 86, 87);
  static const Color lightGrey = Color.fromARGB(255, 201, 199, 199);
  static const Color rippleColor = Color.fromARGB(255, 224, 224, 224);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color lightGreen = Color(0xFFDAF6E7);
  static const Color listingScreenBGColor = Color(0xFFF1F1F1);
}