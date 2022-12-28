import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/assets/constants.dart' as Constants;
import 'package:flutterpoject/helper/navigator_help.dart';
import 'package:flutterpoject/provider/create_event_notifier.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/screens/event/models/event_data.dart';
import 'package:flutterpoject/screens/event/models/event_type_data.dart';
import 'package:flutterpoject/screens/event/ui/create_event_screen.dart';
import 'package:flutterpoject/screens/event/ui/update_event_screen.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:flutterpoject/widget/custom_container.dart';
import 'package:flutterpoject/widget/my_text.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/drawer.dart';

final completedTasksProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ExpandableController controller;
  var completedCount = 0;

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
      drawer: drawer(context),

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
                    background: Image.asset(
                      'assets/images/nature.png',
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: _body(context)),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.colorPrimary,
        onPressed: () {
          navigatorPush(context, CreateEventScreen());
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => TaskScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

// close listener after 30 seconds, so the program doesn't run forever

  Widget _body(BuildContext context) {
    return Container( width: 100.w,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: MyText(text: 'INBOX'),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(Constants.KEY_COLLECTION_EVENTS)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Consumer(builder: ((context, ref, child) {
                    Future.delayed(Duration(seconds: 1), () async {
                      ref.read(completedTasksProvider.notifier).state =
                          completedCount;
                    });
                    completedCount = 0;
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: snapshot.data!.docs.map((document) {
                        var isCompleted = false;
                        var currentTimeInMills =
                            DateTime.now().millisecondsSinceEpoch;

                        var title = document[Constants.KEY_TITLE];
                        var description = document[Constants.KEY_DESCRIPTION];
                        var eventTypeId = document[Constants.KEY_EVENT_TYPE_ID];
                        var place = document[Constants.KEY_PLACE];
                        var timeStamp = document[Constants.KEY_TIME_STAMP];
                        String uid = document[Constants.KEY_UID];
                        debugPrint("coming timemills  " + timeStamp.toString());
                        debugPrint("current timemills  " + currentTimeInMills.toString());

                        if (currentTimeInMills > timeStamp) {
                          completedCount = completedCount + 1;
                          isCompleted = true;
                        }

                        final DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(timeStamp);
                        var uidUser = FirebaseAuth.instance.currentUser?.uid.toString();

                        EventType eventType = eventTypeLS[0];
                        for (var item in eventTypeLS) {
                          if (item.id == eventTypeId) {
                            eventType = item;
                            break;
                          }
                        }


                        return isCompleted
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                            child: Icon(eventType.icon),
                                            height: 60.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColor.black,
                                                    width: 1.0),
                                                borderRadius: const BorderRadius
                                                        .all(
                                                    Radius.circular(30.0)))),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                25.0, 0.0, 0.0, 0.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: AppColor
                                                            .commonTextColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        0.0, 5.0, 0.0, 0.0),
                                                    child: Text(
                                                      place,
                                                      style: const TextStyle(
                                                          fontSize: 12.0,
                                                          color: AppColor
                                                              .commonTextColor),
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (uid == uidUser) ...[
                                              Container(
                                                width: 30,
                                                height: 30,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Material(
                                                    color: Colors.white,
                                                    child: PopupMenuButton(
                                                      iconSize: 50,
                                                      padding: EdgeInsets.zero,
                                                      icon: const Icon(
                                                          Icons.more_horiz),
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry>[
                                                        PopupMenuItem(
                                                            onTap: () {
                                                              var eventData =
                                                                  EventData(
                                                                description:
                                                                    description,
                                                                title: title,
                                                                place: place,
                                                                uid: uid,
                                                                eventTpye:
                                                                    eventType,
                                                                dateTime: date,
                                                              );
                                                              navigatorPush(
                                                                  context,
                                                                  UpdateEventScreen(
                                                                    eventData:
                                                                        eventData,
                                                                    eventID:
                                                                        document
                                                                            .id,
                                                                  ));
                                                            },
                                                            child: const Text(
                                                                'Update')),
                                                        PopupMenuItem(
                                                            onTap: () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .runTransaction(
                                                                      (Transaction
                                                                          myTransaction) async {
                                                                myTransaction
                                                                    .delete(document
                                                                        .reference);
                                                              });
                                                            },
                                                            child: const Text(
                                                                'Delete')),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child:  Text(
                                                formatDateTime(date),
                                                style: TextStyle(
                                                    color: AppColor.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    ExpandablePanel(
                                      theme: ExpandableThemeData(
                                          alignment: Alignment.center,
                                          tapHeaderToExpand: true,
                                          headerAlignment:
                                              ExpandablePanelHeaderAlignment
                                                  .center),
                                      header: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: MyText(
                                            text: "View more",
                                            fontSize: 15.sp,
                                            color: AppColor.darkGrey),
                                      ),
                                      collapsed: const SizedBox(),
                                      expanded: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(description.toString()),
                                      ),
                                    ),
                                    const Divider(
                                      color: AppColor.black,
                                    )
                                  ],
                                ),
                              );
                      }).toList(),
                    );
                  }));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const Center(child: CircularProgressIndicator());
              }),
        ),
        Consumer(
            builder: ((context, ref, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25.0,
                    ),
                    MyText(text: 'Completed  '),
                    CustomContainer(
                      verticalPadding: 0.0,
                      horizontalPadding: 0.0,
                      width: 30.0,
                      height: 30.0,
                      radius: 20.0,
                      color: AppColor.darkGrey,
                      child: Align(
                          alignment: Alignment.center,
                          child: MyText(
                            text: '${ref.watch(completedTasksProvider)}',
                            color: AppColor.commonTextWhiteColor,
                          )),
                    )
                  ],
                ))),
        SizedBox(
          height: 20.0,
        )
      ],
    ));
    // );
  }
}
