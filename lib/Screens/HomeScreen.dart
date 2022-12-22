


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterpoject/Screens/LoginScreen.dart';
import 'package:flutterpoject/Screens/UpdateEventScreen.dart';
import 'package:flutterpoject/assets/constants.dart' as Constants;
import 'package:flutterpoject/res/Colors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../utils/Utility.dart';
import 'CreateEventScreen.dart';

List<EventType> eventTypeList1 = [EventType(1,'Business', Icon(Icons.business, color: AppColors().colorMedDark,)),EventType(2,'Party', Icon(Icons.music_note_outlined,color: AppColors().colorMedDark,)),EventType(3,'Travelling', Icon(Icons.directions_bus,color: AppColors().colorMedDark,),),EventType(4,'Sports', Icon(Icons.sports_football,color: AppColors().colorMedDark,))];

class Event{
  const Event(this.eventType,this.eventTypeId,this.place,this.title,this.uid,this.timeStamp,this.description);
  final  String eventType;
  final int eventTypeId;
  final String place;
  final  String title;
  final  String uid;
  final int timeStamp;
  final String description;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
late ExpandableController controller;

@override
void initState() {
  controller = ExpandableController();
    super.initState();
  InternetConnectionChecker().onStatusChange.listen(
        (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:

        // ignore: avoid_print
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          noInternetSnackbar(context);
          print('You are disconnected from the internet.');
          break;
      }
    },
  );
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      /* appBar: AppBar(

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      drawer: Drawer(

        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(

                color: AppColors().colorBackground,
              ),
              child: Image.asset('assets/images/logoproject.png'),
            ),
            ListTile(
              title: const Text('Share App'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Rate App'),
              onTap: () {
                // Update the state of the app.
                // ...
              },

            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {



                AlertDialog(
                  title: const Text('Logout User'),
                  content: const Text('Are you sure do you really want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut();

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false);
                },
                      child: const Text('Logout'),
                    ),
                  ],
                );

                // Update the state of the app.
                // ...
              },

            ),
          ],
        ),
      ),

      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const Text(
                      "Events",
                    ),

                    background:
                    Image.asset(
                      'assets/images/nature.png', fit: BoxFit.cover,)),
              ),
            ];
          },
          body:
          _body(context)
      ),

      floatingActionButton: FloatingActionButton(backgroundColor: AppColors().colorBackground,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



// close listener after 30 seconds, so the program doesn't run forever

  String formatDateTime(DateTime date) {
    var str = "";
    var currentDate = DateTime.now();

    if (date.year == currentDate.year && date.month == currentDate.month
        && date.day == currentDate.day) {
      str = DateFormat.jm().format(date);
    } else
    if (date.year == currentDate.year && date.month == currentDate.month) {
      str = DateFormat('d MMM').format(date);
    } else {
      str = DateFormat('MMM yy').format(date);
    }
    return str;
  }

  Widget _body(BuildContext context) {
    return Container(color: Colors.white,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(
              Constants.KEY_COLLECTION_EVENTS).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
         /*     List<Event> eventList = [];
              snapshot.data!.docs.map((document) {
                var event= Event(document[Constants.KEY_EVENT_TYPE],document[Constants.KEY_EVENT_TYPE_ID],document[Constants.KEY_PLACE],document[Constants.KEY_TITLE]
                ,document[Constants.KEY_UID],document[Constants.KEY_TIME_STAMP],document[Constants.KEY_DESCRIPTION]
                );
                eventList.add(event);
              });*/
                  return ListView(
                  children: snapshot.data!.docs.map((document) {
                var title = document[Constants.KEY_TITLE];
                var description = document[Constants.KEY_DESCRIPTION];
                var eventTypeId = document[Constants.KEY_EVENT_TYPE_ID];
                var place = document[Constants.KEY_PLACE];
                var timeStamp = document[Constants.KEY_TIME_STAMP];
                String uid = document[Constants.KEY_UID];
                final DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    timeStamp);
                var dateTimeStr = formatDateTime(date);
                var uidUser =FirebaseAuth.instance.currentUser?.uid.toString();


               Icon icon= eventTypeList1[0].icon;
                for(var item in eventTypeList1){

                  if(item.id==eventTypeId){
                    icon = item.icon;
                        break;
                  }
                }

                var event= Event(document[Constants.KEY_EVENT_TYPE],document[Constants.KEY_EVENT_TYPE_ID],document[Constants.KEY_PLACE],document[Constants.KEY_TITLE]
                    ,document[Constants.KEY_UID],document[Constants.KEY_TIME_STAMP],document[Constants.KEY_DESCRIPTION]
                );



                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 5.0),
                  child: Column(mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(child:icon ,
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration( border: Border.all( color: AppColors().colorMedDark,
                                  width: 1.0),

                                  borderRadius:  const BorderRadius.all(
                                      Radius.circular(30.0)))),
                          Expanded(flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 0.0, 0.0, 0.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(title, style: TextStyle(fontSize: 16.0,
                                        color: AppColors().colorTextDark,
                                        fontWeight: FontWeight.w500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 5.0, 0.0, 0.0),
                                      child: Text(place, style: TextStyle(
                                          fontSize: 12.0,
                                          color: AppColors().colorTextLight),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [


                              if (uid==uidUser) ... [
                              Container( width: 30,height: 30,
                                child: FittedBox(fit: BoxFit.fill,
                                  child: Material(color: Colors.white,

                                    child:PopupMenuButton(
                                      iconSize:50,
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.more_horiz),
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                        PopupMenuItem(onTap: (){
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => UpdateEventScreen(event, document.id)));
                                        },child: Text('Update')),
                                        PopupMenuItem(onTap: () async{
                                          await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                            await myTransaction.delete(document.reference);
                                          });
                                        },child: Text('Delete')),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],

                              Container(alignment: Alignment.centerLeft,
                                child: Text(dateTimeStr, style: TextStyle(
                                    color: AppColors().colorMedDark,
                                    fontWeight: FontWeight.w600),),),
                          /*    Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 5.0, 0.0, 0.0),
                                child: Icon(Icons.arrow_circle_down_rounded,
                                  color: AppColors().colorMedDark,),
                              )*/
                            ],

                          )
                        ],
                      ),
                      ExpandablePanel(
                        header: Container(padding: EdgeInsets.all(8.0),alignment: Alignment.topLeft,child: Text("View more")),
                        collapsed:SizedBox(),expanded: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(description.toString()),
                        ),

                      ),
                      Divider(color: AppColors().colorBlack,)
                    ],
                  ),
                );
              }).toList(),
            );
            }else if (snapshot.hasError) {
            return Text('${snapshot.error}');
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}










