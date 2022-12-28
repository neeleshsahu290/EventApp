
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class WriteTextField extends StatelessWidget{
  String? hint;
  final TextEditingController? controller;



  WriteTextField({Key? key,this.hint,this.controller});
  @override
  Widget build(BuildContext context) {
   return TextField(          cursorColor: Colors.white,
       decoration: InputDecoration(
         hintText: hint,
         hintStyle: TextStyle(
             fontSize: 18.sp,
             color: AppColor.lightGrey),
         enabledBorder: UnderlineInputBorder(
           borderSide: BorderSide(color: AppColor.black),
         ),
         focusedBorder: UnderlineInputBorder(
           borderSide: BorderSide(color: AppColor.lightGrey),
         ),

       ),
       style:
       TextStyle(fontSize: 18.sp,
           color: AppColor.commonTextWhiteColor),
       controller: controller

   );
  }

}

Widget textWidget(BuildContext context,  _controller,String hintString){
  return  TextField(          cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: TextStyle(
            fontSize: 18.sp,
            color: AppColor.lightGrey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.lightGrey),
        ),

      ),
      style:
      TextStyle(fontSize: 18.sp,
          color: AppColor.commonTextWhiteColor),
      controller: _controller

  );
}


