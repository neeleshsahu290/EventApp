import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/provider/create_event_notifier.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/screens/event/models/event_type_data.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:flutterpoject/widget/primary_button.dart';
import 'package:flutterpoject/widget/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final createEventProvider =
    ChangeNotifierProvider.autoDispose<CreateEventNotifier>((ref) {
  return CreateEventNotifier();
});

class CreateEventScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEventScreen> {
  String? place, title, description;

  final _formKey = GlobalKey<FormState>();


  late TextEditingController _controllerPlace,
      _controllerDescription,
      _controllerTitle;
  int index = 0;

  @override
  void initState() {
    super.initState();

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

  bool isValid(DateTime dateTime) {
    bool valid = true;
    if (title == null || title == "") {
      valid = false;
      snackBarMsg("Please enter a title", context);
    } else if (place == null || place == "") {
      snackBarMsg("Please enter a place Name", context);
      valid = false;
    } else if (description == null || description == "") {
      snackBarMsg("Please enter a description", context);
      valid = false;
    } else if (dateTime.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      //  debugPrint("now: ${DateTime.now().millisecondsSinceEpoch}, date:${dateTime.millisecondsSinceEpoch}");
      snackBarMsg("Please enter a date and time greater than Current date Time",
          context);
      valid = false;
    }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorPrimary,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0x3f216e),
          title: const Text("Create New Event")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Consumer(builder: ((context, ref, child) {
              List<EventType> eventTypeList =
                  ref.read(createEventProvider).eventTypeList;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0, color: AppColor.commonTextWhiteColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(35.0))),
                    child: Icon(
                      ref.watch(createEventProvider).dropdownValue.icon,
                      size: 45.0,
                      color: AppColor.commonTextWhiteColor,
                    ),
                  ),
                  dropDown(context, ref),
                  WriteTextField(controller: _controllerTitle, hint: "Title"),
                  WriteTextField(controller: _controllerPlace, hint: "Place"),
                  WriteTextField(
                      controller: _controllerDescription, hint: "Description"),
                  dateWidget(context, ref),
                  timeWidget(context, ref),
                  SizedBox(
                    height: 30.0,
                  ),
                  PrimaryButton(
                      isLoading: ref.watch(createEventProvider).isLoading,
                      disablePadding: true,
                      btnText: 'Create Event',
                      color: AppColor.white,
                      textColor: AppColor.commonTextColor,
                      onPressed: () async {
                        title = _controllerTitle.text;
                        place = _controllerPlace.text;
                        description = _controllerDescription.text;
                        var dateTime = ref.read(createEventProvider).dateTime;
                        if (isValid(dateTime)) {
                          await ref.read(createEventProvider).startLoading();
                          ref.read(createEventProvider).saveEvent(
                              context: context,
                              title: title ?? "",
                              description: description ?? "",
                              place: place ?? "");
                        }
                      })
                ],
              );
            })),
          ),
        ),
      ),
    );
  }

  Widget timeWidget(BuildContext context, WidgetRef ref) {
    var dateTime = ref.watch(createEventProvider).dateTime;

    String hours, minutes;

    hours = dateTime.hour.toString().padLeft(2, '0');
    minutes = dateTime.minute.toString().padLeft(2, '0');
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero, // Set this
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0), // and this
        ),
        onPressed: () async {
          final time = await pickTime(dateTime);
          if (time == null) {
            return;
          } else {
            final newDateTime = DateTime(dateTime.year, dateTime.month,
                dateTime.day, time.hour, time.minute);

            ref.read(createEventProvider).setNewDateTime(newDateTime);

          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.jm().format(dateTime) /* '$hours::$minutes'*/,
              style: const TextStyle(color: AppColor.commonTextWhiteColor),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Divider(
                color: AppColor.black,
                thickness: 0.5,
              ),
            ),
          ],
        ));
  }

  Widget dateWidget(BuildContext context, WidgetRef ref) {
    return TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero, // Set this
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0), // and this
        ),
        onPressed: () async {
          DateTime dateTime = ref.read(createEventProvider).dateTime;

          final date = await pickDate(dateTime);
          if (date == null) {
            return;
          } else {
            final newDateTime = DateTime(date.year, date.month, date.day,
                dateTime.hour, dateTime.minute);
            ref.read(createEventProvider).setNewDateTime(newDateTime);

            // setState(() => dateTime = newDateTime);
          }
        },
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMEd()
                    .format(ref.watch(createEventProvider).dateTime),
                // '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                style: const TextStyle(color: AppColor.commonTextWhiteColor),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Divider(
                  color: AppColor.black,
                  thickness: 0.5,
                ),
              )
            ]));
  }

  Widget dropDown(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      child: DropdownButton<EventType>(
        isExpanded: true,
        dropdownColor: Colors.white,
        alignment: Alignment.centerLeft,

        value: ref.read(createEventProvider).dropdownValue,
        // icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: AppColor.commonTextColor),
        underline: Container(
          width: double.infinity,
          height: 1,
          color: AppColor.black,
        ),
        onChanged: (EventType? value) {
          if (value != null) {
            ref.read(createEventProvider).setDropDownValue(value);
          }
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColor.commonTextWhiteColor, // <-- SEE HERE
        ),
        selectedItemBuilder: (BuildContext context) {
          //<-- SEE HERE
          return ref
              .read(createEventProvider)
              .eventTypeList
              .map((EventType value) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                ref.read(createEventProvider).dropdownValue.name,
                style: TextStyle(
                    color: AppColor.commonTextWhiteColor, fontSize: 18.sp),
              ),
            );
          }).toList();
        },

        items: ref
            .read(createEventProvider)
            .eventTypeList
            .map<DropdownMenuItem<EventType>>((EventType value) {
          return DropdownMenuItem<EventType>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),

        focusColor: Colors.white,
      ),
    );
  }

  Future<DateTime?> pickDate(DateTime dateTime) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime(DateTime dateTime) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
