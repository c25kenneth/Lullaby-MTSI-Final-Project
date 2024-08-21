import 'package:baby_steps/FlutterFireFuncs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NapCard extends StatefulWidget {
  final String title;
  final DateTime time;
  final String postID;
  final String babyID; 
  final String option;
  const NapCard(
      {super.key,
      required this.title,
      required this.time,
      required this.option,
      required this.babyID,
      required this.postID});

  @override
  State<NapCard> createState() => _NapCardState();
}

class _NapCardState extends State<NapCard> {
  String getOrdinalSuffix(int day) {
    if (!(day >= 1 && day <= 31)) {
      throw ArgumentError('Invalid day of month');
    }
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String formatDateTime(DateTime dateTime) {
    String day = dateTime.day.toString();
    String ordinalSuffix = getOrdinalSuffix(dateTime.day);
    String formattedDay = day + ordinalSuffix;
    String formattedDate =
        DateFormat('MMMM').format(dateTime) + " " + formattedDay;
    String formattedTime =
        DateFormat.jm().format(dateTime); // 'jm' stands for 'Hour:Minute AM/PM'
    return "$formattedDate, $formattedTime";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
          decoration: BoxDecoration(
              color: (widget.option == "Nap Time")
                  ? Color.fromRGBO(255, 125, 157, 1)
                  : Color.fromRGBO(110, 172, 255, 1)),
          child: Dismissible(
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Delete", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            key: ValueKey(widget.postID),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await deleteFromSchedule(widget.postID, widget.babyID); 
            },
            child: ListTile(
                onTap: () {},
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(
                    (widget.option == "Nap Time")
                        ? Icons.snooze_outlined
                        : Icons.restaurant_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    Text(formatDateTime(widget.time),
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0)),
          )),
    );
  }
}
