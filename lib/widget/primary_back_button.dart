import 'package:flutter/material.dart';
import 'package:flutterpoject/res/Colors.dart';


class PrimaryBackButton extends StatelessWidget {
  final Function() onTap;
  const PrimaryBackButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Back",
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 32),
        child: Card(
          color: const Color(0xffF3F3F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            highlightColor: AppColor.colorPrimaryAccent,
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
