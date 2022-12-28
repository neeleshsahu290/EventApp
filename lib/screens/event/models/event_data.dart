import 'package:flutterpoject/screens/event/models/event_type_data.dart';

class EventData {
  String description;
 // String event_type;
  EventType eventTpye;
  String place;
  DateTime dateTime;
  String title;
  String uid;

  EventData({required this.description, required this.title,required this.place, required this.uid , required this.eventTpye, required this.dateTime});

}