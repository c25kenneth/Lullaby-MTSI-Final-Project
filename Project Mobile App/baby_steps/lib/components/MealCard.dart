import 'package:flutter/material.dart';

class MealCard extends StatefulWidget {
  const MealCard({super.key});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(60, 141, 250, 1)),
            child: ListTile(
                onTap: () {
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(Icons.crib_outlined, color: Colors.white, size: 35,),
                ),
                title: const Text(
                  "Meal Time",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: const Row(
                  children: <Widget>[
                    Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    Text("June 3rd, 6:00 PM", style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: const Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0))),
      );
  }
}