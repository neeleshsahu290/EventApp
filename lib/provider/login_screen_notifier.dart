import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/helper/navigator_help.dart';
import 'package:flutterpoject/screens/home/ui/home_screen.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';




class LoginScreenNotifier extends ChangeNotifier{


  bool isLoading = false;


  Future login(BuildContext context,String email, String password) async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email:email.trim(),
            password: password.trim()
        );
        navigatorPushReplace(context, HomeScreen());

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          snackBarMsg("User doesn't exist", context);
          exitLoading();
        } else if (e.code == 'wrong-password') {
          snackBarMsg("YOu have entered a wrong password", context);
          exitLoading();
        } else if (e.code == 'too-many_requests') {
          snackBarMsg(
              'Too many times you have entered a wrong credentials. Try again after some time',
              context);
          exitLoading();
        } else {
          snackBarMsg(e.toString(), context);
          exitLoading();
        }
      } catch (e) {
        snackBarMsg(e.toString(), context);
        exitLoading();
      }
    }else{
      noInternetSnackbar(context);
      exitLoading();
    }

  }





  startLoading(){
    isLoading=true;
    notifyListeners();
  }





   exitLoading(){
    isLoading=false;
    notifyListeners();

  }



}