
import 'package:flutter/material.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';

Widget textWidget(BuildContext context,  _controller,String hintString){
  return  TextField(          cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: TextStyle(
            fontSize: TextSize().mediumText,
            color: AppColors().colorTextWhiteLight),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors().colorTextFieldUnderline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors().colorTextFieldUnderline),
        ),

      ),
      style:
      TextStyle(fontSize: TextSize().mediumText,
          color: AppColors().colorTextWhiteDark),
      //  decoration: InputDecoration(border: OutlineInputBorder()),
      controller: _controller

  );
}


