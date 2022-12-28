
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterpoject/assets/constants.dart';
import 'package:flutterpoject/helper/navigator_help.dart';
import 'package:flutterpoject/screens/home/ui/home_screen.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CreateAccountNotifier extends ChangeNotifier{

  bool isLoading = false;

  //  createLogin(username, password);
  Future CreateAccount(BuildContext context,String name,String email, String password) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if(isConnected) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        storedData(email,name,context);
        debugPrint("Successfully done");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          exitLoading();
          debugPrint('error : The password provided is too weak.');
          snackBarMsg('The password provided is too weak.', context);
        } else if (e.code == 'email-already-in-use') {
          exitLoading();
          debugPrint('error : The account already exists for that email.');
          snackBarMsg('The account already exists for that email.', context);
        } else {
          exitLoading();
          debugPrint('error : ${e.toString()}');
          snackBarMsg(e.code, context);
        }
      } catch (e) {
        exitLoading();
        debugPrint('error : ' + e.toString());
        snackBarMsg(e.toString(), context);
      }
    }else{
      exitLoading();
      noInternetSnackbar(context);
    }
  }

  Future storedData(String email, String name, BuildContext context) async {

    var db = FirebaseFirestore.instance;
    debugPrint('error :Second Reach.');

    final user = FirebaseAuth.instance.currentUser;

    final data = <String, dynamic>{
      KEY_USERNAME: name,
      KEY_EMAIL: email,
      KEY_UID: user?.uid
    };

    // Add a new document with a generated ID
    db.collection(KEY_COLLECTION_USERS).doc(user?.uid).set(data).then(
            (value) {
          print("DocumentSnapshot successfully updated!");
          exitLoading();
          snackBarMsg("Successfully Account Created".toString(), context);
          navigatorPushReplace(context,HomeScreen());

        }, onError: (e) {
      exitLoading();
      snackBarMsg(e.toString(), context);
    });
    //  .onError((e, _) => print("Error writing document: $e"));
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