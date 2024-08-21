import 'package:baby_steps/LoadingScreen.dart';
import 'package:baby_steps/components/MealCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleMeal extends StatefulWidget {
  const ScheduleMeal({super.key});

  @override
  State<ScheduleMeal> createState() => _ScheduleMealState();
}

class _ScheduleMealState extends State<ScheduleMeal> {
  late DateTime now;
  late DateTime futureDate;
  late DateTime pastDate; 

  DateTime _selectedDay = DateTime.now().toUtc();
  DateTime _focusedDay = DateTime.now().toUtc();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  void initState() {
    super.initState();
    now = DateTime.now().toUtc();
    futureDate = addMonths(now, 5);
    pastDate = addMonths(now, -5);
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

    // Ensure the new date is valid (handles cases where the day might be out of range for the new month)
    int newDay = date.day;
    int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day; // Get the last day of the new month
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth;
    }

    return DateTime.utc(newYear, newMonth, newDay);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).collection("babies").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white,),
              backgroundColor: Color.fromRGBO(60, 141, 250, 1),
              onPressed: () {
                
              },
            ),
            appBar: AppBar(
              title: Text(snapshot.data!.docs[0].get('babyName') + "'s feeding schedule"),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    TableCalendar(
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color.fromRGBO(60, 141, 250, 1),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Color.fromRGBO(110, 172, 255, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay; // update `_focusedDay` here as well
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
                      focusedDay: _focusedDay,
                    ),
                    SizedBox(height: 15),
                    MealCard(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoadingScreen(); 
        }
      }
    );
  }
}