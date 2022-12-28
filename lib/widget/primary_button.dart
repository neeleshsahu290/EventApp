import 'package:flutter/material.dart';
import 'package:flutterpoject/res/Colors.dart';

import 'my_text.dart';

class PrimaryButton extends StatefulWidget {
  final String? btnText;
  final double? width;
  final double height;
  final Function()? onPressed;
  final bool disablePadding;
  final Color? color;
  final bool hasBorder;
  final Color textColor;
  final double textSize;
  final Widget? child;
  final bool isLoading;
  final double cornerRadius;
  final double elevation;
  final double borderWidth;
  final Color borderColor;
  final FontWeight fontWeight;

  const PrimaryButton({
    Key? key,
    this.btnText,
    this.width,
    this.height = 55.0,
    this.onPressed,
    this.disablePadding = false,
    this.color,
    this.child,
    this.isLoading = false,
    this.hasBorder = false,
    this.textColor = AppColor.white,
    this.textSize = 16.0,
    this.cornerRadius = 12.0,
    this.elevation = 1.0,
    this.borderColor = AppColor.lightGrey,
    this.borderWidth = 1.0,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool isEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.disablePadding
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0.0),
            foregroundColor: Colors.black,
            elevation: widget.elevation,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.cornerRadius)),
          ),
          onPressed: widget.isLoading
              ? null
              : () {
                  //Preventing double from simultaneous clicks (Debouncing)
                  if (isEnabled) {
                    if (!widget.isLoading) {
                      widget.onPressed?.call();
                      setState(() {
                        isEnabled = false;
                        Future.delayed(const Duration(milliseconds: 500))
                            .then((value) {
                          if (mounted) {
                            setState(() {
                              isEnabled = true;
                            });
                          }
                            });
                      });
                    }
                  }
                  // isEnabled
                  //   ? widget.isLoading
                  //       ? null
                  //       : widget.onPressed
                  //   : null
                  // widget.onPressed?.call();
                },
          child: Ink(
            decoration: BoxDecoration(
              border: widget.hasBorder
                  ? Border.all(
                      width: widget.borderWidth, color: widget.borderColor)
                  : const Border(),
              borderRadius: BorderRadius.circular(widget.cornerRadius),
              gradient: LinearGradient(
                colors: widget.isLoading
                    ? [Colors.grey.shade300, Colors.grey.shade300]
                    : (widget.color != null)
                        ? [widget.color!, widget.color!]
                        : [AppColor.colorPrimary, AppColor.colorPrimary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: widget.child != null
                ? SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: widget.child,
                  )
                : Container(
                    width: widget.width,
                    height: widget.height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.cornerRadius)),
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator(
                              color: Colors.green,
                              strokeWidth: 3,
                            ),
                          )
                        : MyText(
                            text: widget.btnText!,
                            textAlignment: TextAlign.center,
                            color: widget.textColor,
                            fontSize: widget.textSize,
                            fontWeight: widget.fontWeight,
                          ),
                  ),
          ),
        ),
      ),
    );
  }
}
