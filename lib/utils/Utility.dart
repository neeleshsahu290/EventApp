
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void snackBarMsg(String msg,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
void noInternetSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(backgroundColor: Colors.redAccent,content: Text('No Internet Found')),
  );
}

void finishCurrentView(BuildContext context){
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

