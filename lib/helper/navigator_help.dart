import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/custom_page_route.dart';

Future navigatorPush(context, widgetScreen) async {
  await Future.delayed(const Duration(milliseconds: 30));
  return await Navigator.push(
      context, CustomPageRoute(builder: (_) => widgetScreen));
}

navigatorPushReplace(context, widgetScreen) async {
  return await Navigator.of(context).pushAndRemoveUntil(
      CustomPageRoute(builder: (_) => widgetScreen),
      (Route<dynamic> route) => false);
}

goBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}

goPreviousScreen(BuildContext context, {int popCount = 0}) {
  int count = 0;
  Navigator.of(context).popUntil((_) => count++ >= popCount);
}

void exitApp() {
  try {
    Platform.isAndroid ? SystemNavigator.pop() : exit(0);
    // ignore: empty_catches
  } catch (error) {}
}
