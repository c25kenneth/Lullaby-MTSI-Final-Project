import 'package:baby_steps/FlutterFireFuncs.dart';
import 'package:baby_steps/components/GenderDropdown.dart';
import 'package:baby_steps/components/InvertedButtonFb2.dart';
import 'package:baby_steps/components/NapCard.dart';
import 'package:baby_steps/components/TextInputFB2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleNapTime extends StatefulWidget {
  const ScheduleNapTime({Key? key}) : super(key: key);

  @override
  State<ScheduleNapTime> createState() => _ScheduleNapTimeState();
}

class _ScheduleNapTimeState extends State<ScheduleNapTime> {
  late DateTime now;
  late DateTime futureDate;
  late DateTime pastDate;

  DateTime _selectedDay = DateTime.now().toUtc();
  DateTime _focusedDay = DateTime.now().toUtc();

  final TextEditingController _napTime = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scheduleOptionController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  static const primaryColor = Color(0xff4338CA);
  static const secondaryColor = Color(0xff6D28D9);
  static const accentColor = Color(0xffffffff);
  static const errorColor = Color(0xffEF4444);

  @override
  void initState() {
    super.initState();
    now = DateTime.now().toUtc();
    _scheduleOptionController.text = "Nap Time";
    futureDate = addMonths(now, 5);
    pastDate = addMonths(now, -5);
    _napTime.text = formatTimeOfDay(TimeOfDay.now());
  }

  DateTime addMonths(DateTime date, int months) {
    int newYear = date.year;
    int newMonth = date.month + months;

    while (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }

    while (newMonth < 1) {
      newYear--;
      newMonth += 12;
    }

    int newDay = date.day;
    int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }

    return DateTime.utc(newYear, newMonth, newDay);
  }

  TimeOfDay _timeOfDay = TimeOfDay.now();

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("babies")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: const Color.fromRGBO(255, 64, 111, 1),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: 24.0,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add to " +
                                      snapshot.data!.docs[0].get('babyName') +
                                      "'s Schedule",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                TextInputFb2(
                                    inputController: _titleController,
                                    labelText: "Title",
                                    hintText:
                                        snapshot.data!.docs[0].get('babyName') +
                                            "'s evening nap!"),
                                SizedBox(height: 40),
                                TextInputFbMultiLine(
                                    maxLines: 2,
                                    inputController: _descriptionController,
                                    labelText: "Description",
                                    hintText:
                                        snapshot.data!.docs[0].get('babyName') +
                                            "'s evening nap!"),
                                const SizedBox(height: 40),
                                Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ]),
          child: TextField(
            controller: _napTime,
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                  _napTime.text = formatTimeOfDay(pickedTime);
              }
              setState(() {
                _timeOfDay = pickedTime!; 
              });
            },
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              label: Text("Pick a time"),
              labelStyle: const TextStyle(color: primaryColor),
              filled: true,
              fillColor: accentColor,
              hintText: "",
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    ),
                                const SizedBox(height: 40),
                                GenderDropdown(
                                    controller: _scheduleOptionController,
                                    hintText: "Nap Time",
                                    options: ["Nap Time", "Meal Time"]),
                                const SizedBox(height: 32),
                                Center(
                                    child: InvertedButtonFb2(
                                        onPressed: () async {
                                              DateTime scheduledNapTime = combineDateAndTime(
                                                  _selectedDay, _timeOfDay);

                                          if (_titleController.text != "" &&
                                              _scheduleOptionController.text !=
                                                  "" &&
                                              _descriptionController.text !=
                                                  "") {
                                            await addToSchedule(
                                                scheduledNapTime,
                                                _titleController.text,
                                                snapshot.data!.docs[0].id,
                                                _scheduleOptionController.text);
                                            final Event event = Event(
                                              title: _titleController.text,
                                              description:
                                                  _descriptionController.text,
                                              startDate: scheduledNapTime,
                                              endDate: scheduledNapTime
                                                  .add(Duration(minutes: 30)),
                                            );
                                            await Add2Calendar.addEvent2Cal(
                                                event);
                                              _napTime.text = "";
                                              _titleController.text = "";
                                              _descriptionController.text = "";
                                              _scheduleOptionController.text = "";
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        text:"Add to calendar!"))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              appBar: AppBar(
                title: Text(
                    snapshot.data!.docs[0].get('babyName') + "'s Schedule"),
              ),
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('babies')
                      .doc(snapshot.data!.docs[0].id)
                      .collection('nap')
                      .where('time',
                          isGreaterThanOrEqualTo: DateTime(_selectedDay.year,
                              _selectedDay.month, _selectedDay.day))
                      .where('time',
                          isLessThanOrEqualTo: DateTime(
                              _selectedDay.year,
                              _selectedDay.month,
                              _selectedDay.day,
                              23,
                              59,
                              59,
                              999))
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TableCalendar(
                                daysOfWeekVisible: false,
                                calendarStyle: const CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 64, 111, 1),
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: Color(0xFFFF7D9D),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay =
                                        focusedDay; // update `_focusedDay` here as well
                                  });
                                },
                                calendarFormat: _calendarFormat,
                                onFormatChanged: (format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                },
                                firstDay: pastDate,
                                lastDay: futureDate,
                                focusedDay: now,
                              ),
                              SizedBox(height: 15),
                              Text(
                                "On Board For Today",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              (snapshot2.data!.docs.isNotEmpty)
                                  ? Expanded(
                                      child: ListView.builder(
                                          itemCount:
                                              snapshot2.data!.docs.length,
                                          itemBuilder: ((context, index) {
                                            return NapCard(
                                              babyID: snapshot.data!.docs[0].id,
                                              postID: snapshot2
                                                  .data!.docs[index].id,
                                              title: snapshot2.data!.docs[index]
                                                  .get('title'),
                                              time: snapshot2.data!.docs[index]
                                                  .get('time')
                                                  .toDate(),
                                              option: snapshot2
                                                  .data!.docs[index]
                                                  .get('scheduleType'),
                                            );
                                          })),
                                    )
                                  : Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: height * 0.15,
                                            child: SvgPicture.asset(
                                                "assets/images/undraw_not_found_re_bh2e.svg"),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Nothing scheduled for today!",
                                            style: TextStyle(fontSize: 18.0),
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class CustomTextFieldTime extends StatefulWidget { 
  final TextEditingController inputController;
  final String labelText; 
  final String hintText; 

  const CustomTextFieldTime({Key? key, required this.inputController, required this.labelText, required this.hintText}) : super(key: key);

  @override
  State<CustomTextFieldTime> createState() => _CustomTextFieldTimeState();
}

class _CustomTextFieldTimeState extends State<CustomTextFieldTime> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ]),
          child: TextField(
            controller: widget.inputController,
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                  widget.inputController.text = formatTimeOfDay(pickedTime);
              }
            },
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              label: Text(widget.labelText),
              labelStyle: const TextStyle(color: primaryColor),
              filled: true,
              fillColor: accentColor,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: errorColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
