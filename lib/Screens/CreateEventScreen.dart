
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterpoject/assets/constants.dart' as Constants;
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:flutterpoject/utils/Widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';


class EventType{
  const EventType(this.id,this.name,this.icon);
  final  int id;
  final String name;
 final  Icon icon;
}




class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskScreenState();
}

/*const List<String> list = <String>['Business', 'Party', 'Travelling', 'Sports'];
const List<Icon> iconList = [Icon(Icons.business),Icon(Icons.music_note_outlined),Icon(Icons.directions_bus),Icon(Icons.sports_football)];*/


List<EventType> eventTypeList = [EventType(1,'Business', Icon(Icons.business, color: AppColors().colorTextFieldUnderline,)),EventType(2,'Party', Icon(Icons.music_note_outlined,color: AppColors().colorTextFieldUnderline,)),EventType(3,'Travelling', Icon(Icons.directions_bus,color: AppColors().colorTextFieldUnderline,),),EventType(4,'Sports', Icon(Icons.sports_football,color: AppColors().colorTextFieldUnderline,))];

class _TaskScreenState extends State<TaskScreen> {
 // DateTime dateTime = DateTime(2022, 12, 24, 5 ,30);
  DateTime dateTime = DateTime.now();
  late String hours, minutes;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late Color textColor;
  late double textFontSize;
  late Color textHintColor;
  late TextEditingController _controllerPlace, _controllerDescription, _controllerTitle;
  String? place,title,description;
  EventType dropdownValue = eventTypeList.first;
  int index=0;

  @override
  void initState() {
    super.initState();
    textColor =AppColors().colorTextWhiteDark;
    textFontSize=  TextSize().mediumText;
    textHintColor= AppColors().colorTextWhiteLight;
    _controllerPlace = TextEditingController();
    _controllerTitle = TextEditingController();
    _controllerDescription = TextEditingController();
  }

  @override
  void dispose() {
    _controllerPlace.dispose();
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:AppColors().colorBackground,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0x3f216e),
          title: const Text("Create New Event")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MarginSize().bigMargin),
          child: Form( key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 70.0, width: 70.0,decoration: BoxDecoration(border: Border.all(width: 1.0,color: AppColors().colorTextFieldUnderline),

                      borderRadius: BorderRadius.all(
                          Radius.circular(35.0))),
                    child: dropdownValue.icon,
                  ),

                  dropDown(context),
                  textWidget(context,_controllerTitle,"Title"),
                  textWidget(context,_controllerPlace,"Place"),
                  textWidget(context, _controllerDescription, "Description"),

                  /*TextField(
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                          fontSize: textFontSize,
                          color: textHintColor),
                    ),
                    style:
                        TextStyle(fontSize: textFontSize,
                        color: textColor),
                    //  decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: _controllerTitle,

                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Place",
                      hintStyle: TextStyle(
                          fontSize: textFontSize,
                          color: textHintColor),
                    ),
                    style:
                        TextStyle(fontSize: textFontSize,
                          color: textColor
                        ),
                    controller: _controllerPlace,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(
                          fontSize: textFontSize,
                          color: textHintColor),
                    ),
                    style:
                        TextStyle(fontSize: textFontSize,
                            color:textColor),
                    //  decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: _controllerDescription

                  ),*/
                  dateWidget(context),
                  timeWidget(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: isLoading?CircularProgressIndicator():ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45),primary: AppColors().colorWhite),
                      onPressed: () async {
                        title = _controllerTitle.text;
                        place= _controllerPlace.text;
                        description=_controllerDescription.text;
                        if(isValid()){
                          setState(() {
                            isLoading = true;
                          });
                          await saveEvent();
                        }
                      },
                      child:  Text('Create Event',style: TextStyle(color: AppColors().colorTextDark)),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValid(){
    bool valid = true;
    if(title == null || title==""){
      valid =false;
      snackBarMsg("Please enter a title", context);
    }else if(place==null || place==""){
      snackBarMsg("Please enter a place Name", context);
      valid =false;
    }else if(description==null || description==""){
      snackBarMsg("Please enter a description", context);
      valid = false;
    }else if(dateTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch){
   //  debugPrint("now: ${DateTime.now().millisecondsSinceEpoch}, date:${dateTime.millisecondsSinceEpoch}");
      snackBarMsg("Please enter a date and time greater than Current date Time", context);
      valid = false;
    }
    return  valid;
  }

  Widget timeWidget(BuildContext context){
     hours = dateTime.hour.toString().padLeft(2,'0');
     minutes = dateTime.minute.toString().padLeft(2,'0');
    return TextButton(
        style:    TextButton.styleFrom(
          minimumSize: Size.zero, // Set this
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0), // and this
        ),
        onPressed: () async {
          final time = await pickTime();
          if (time == null) {
            return;
          } else {

            final newDateTime = DateTime(dateTime.year,
            dateTime.month,
            dateTime.day,
            time.hour,
              time.minute
            );
            setState(() => dateTime = newDateTime);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:MainAxisAlignment.start ,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.jm().format(dateTime)
             /* '$hours::$minutes'*/,
              style: TextStyle(color: textColor),
            ),
             Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Divider(
                color: AppColors().colorTextFieldUnderline,
                thickness: 0.5,
              ),
            ),

          ],
        ));
  }
  Widget dateWidget(BuildContext context) {


    return TextButton(
      style:    TextButton.styleFrom(
        minimumSize: Size.zero, // Set this
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0), // and this
      ),
        onPressed: () async {
          final date = await pickDate();
          if (date == null) {
            return;
          } else {
            final newDateTime = DateTime(date.year, date.month, date.day, dateTime.hour, dateTime.minute);
            setState(() => dateTime = newDateTime);
          }
        },
        child:Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:MainAxisAlignment.start ,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
        Text( DateFormat.yMMMEd().format(dateTime),
             // '${dateTime.year}/${dateTime.month}/${dateTime.day}',
              style: TextStyle(color: textColor
              ),
            ),
           Padding(
            padding:  EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Divider(color: AppColors().colorTextFieldUnderline, thickness: 0.5,),
          )
        ])
        );
  }
  Widget dropDown(BuildContext context) {
    return Container(
      width: double.infinity,
      child: DropdownButton<EventType>(
        isExpanded: true,
        dropdownColor: Colors.white,
        alignment: Alignment.centerLeft,


        value: dropdownValue,
        // icon: const Icon(Icons.arrow_downward),
        elevation: 16,
          style:  TextStyle(color: AppColors().colorTextDark),
        underline: Container(
          width: double.infinity,
          height: 1,
          color: AppColors().colorTextFieldUnderline,
        ),
        onChanged: (EventType? value) {
          // This is called when the user selects an item.
          setState(() {

            dropdownValue = value!;

          });

        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors().colorTextWhiteDark, // <-- SEE HERE
        ),
        selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
          return
              eventTypeList.map((EventType value) {
            return Container( alignment: Alignment.centerLeft,
              child: Text(
                dropdownValue.name,
                style:  TextStyle(color: AppColors().colorTextWhiteDark, fontSize: textFontSize),
              ),
            );
          }).toList();
        },
   /*     items: eventTypeList.map((EventType type) {
          return  DropdownMenuItem<EventType>(
            value: type,
            child: new Text(
              type.name,
              style: new TextStyle(color: Colors.black),
            ),
          );
        }).toList(),*/
        items: eventTypeList.map<DropdownMenuItem<EventType>>((EventType value) {
          return DropdownMenuItem<EventType>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),



        focusColor: Colors.white,
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
//      firstDate: DateTime(1900),
  firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime()=> showTimePicker(context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  Future saveEvent() async {
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
        setState(() {
          isLoading = true;
        });
        snackBarMsg("Successfully Created Event", context);
        finishCurrentView(context);
      }).onError((error, stackTrace) {
        snackBarMsg(error.toString(), context);
      });
    }else{
      setState(() {
        isLoading = false;
      });
      noInternetSnackbar(context);
    }
  }
}

