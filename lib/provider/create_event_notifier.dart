import 'package:flutterpoject/assets/constants.dart' as Constants;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpoject/screens/event/models/event_type_data.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

List<EventType> eventTypeLS = [EventType(1,'Business', Icons.business,),EventType(2,'Party',Icons.music_note_outlined,),EventType(3,'Travelling', Icons.directions_bus,),EventType(4,'Sports',Icons.sports_football,)];


class CreateEventNotifier extends ChangeNotifier{

  List<EventType> eventTypeList= eventTypeLS;

  EventType dropdownValue  =eventTypeLS.first;

   setDropDownValue(EventType type) async{
     dropdownValue = type;
     notifyListeners();
   }

  DateTime dateTime = DateTime.now();
  bool isLoading = false;

  setNewDateTime(DateTime newDateTime) async{
    dateTime=newDateTime;
    notifyListeners();
  }

  startLoading() async {
    isLoading =true;
    notifyListeners();
  }

  stopLoading() async {
    isLoading =false;
    notifyListeners();
  }




  Future saveEvent({required String title, required String place, required String description,required BuildContext context}) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      var db = FirebaseFirestore.instance;
      //  Timestamp myTimeStamp = Timestamp.fromDate(dateTime); //To TimeStamp
      int dfk = dateTime.millisecondsSinceEpoch;
      var uid = FirebaseAuth.instance.currentUser?.uid.toString();
      final data = <String, dynamic>{
        Constants.KEY_EVENT_TYPE: dropdownValue.name,
        Constants.KEY_EVENT_TYPE_ID: dropdownValue.id,
        Constants.KEY_TITLE: title,
        Constants.KEY_PLACE: place,
        Constants.KEY_DESCRIPTION: description,
        Constants.KEY_UID: uid,
        Constants.KEY_TIME_STAMP: dateTime.millisecondsSinceEpoch
      };
      db.collection('events').add(data).then((value) {
        stopLoading();

        snackBarMsg("Successfully Created Event", context);
        finishCurrentView(context);
      }).onError((error, stackTrace) {
        stopLoading();

        snackBarMsg(error.toString(), context);
      });
    } else {
      stopLoading();
      noInternetSnackbar(context);
    }
  }


  Future updateEvent({required String title, required String place, required String description,required BuildContext context, required String eventID }) async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected) {
      var db = FirebaseFirestore.instance;
      //  Timestamp myTimeStamp = Timestamp.fromDate(dateTime); //To TimeStamp
      int dfk = dateTime.millisecondsSinceEpoch;
      var uid = FirebaseAuth.instance.currentUser?.uid.toString();
      final data = <String, dynamic>{
        Constants.KEY_EVENT_TYPE: dropdownValue.name,
        Constants.KEY_EVENT_TYPE_ID: dropdownValue.id,
        Constants.KEY_TITLE: title,
        Constants.KEY_PLACE: place,
        Constants.KEY_DESCRIPTION: description,
        Constants.KEY_UID: uid,
        Constants.KEY_TIME_STAMP: dateTime.millisecondsSinceEpoch
      };
      db.collection('events').doc(eventID).update(data).then((value) {

        stopLoading();
        snackBarMsg("Successfully Updated Event", context);
        finishCurrentView(context);
      }).onError((error, stackTrace) {
        snackBarMsg(error.toString(), context);
      });
    }else{
      stopLoading();
      noInternetSnackbar(context);

    }
  }
}


