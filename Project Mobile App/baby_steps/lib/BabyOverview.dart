import 'package:baby_steps/LoadingScreen.dart';
import 'package:baby_steps/components/HeaderFb1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BabyOverview extends StatefulWidget {
  final List graphData; 
  const BabyOverview({super.key, required this.graphData});

  @override
  State<BabyOverview> createState() => _BabyOverviewState();
}

class _BabyOverviewState extends State<BabyOverview> {
  double hungerSlider = 40;
  double sleepSlider = 80;
  String reason = "";
    String whyIsBabyCrying(List<FlSpot> sleepData, List<FlSpot> mealData) {
    // Define thresholds
    const double maxAwakeTime = 2.0; // in hours, adjust based on age and needs
    const double maxNotEatingTime = 3.0; // in hours
    const double minTotalSleep = 14.0; // in hours per day
    const int minTotalMeals = 8; // in feedings per day

    // Calculate continuous awake and not eating periods
    double continuousAwake = 0;
    double maxContinuousAwake = 0;
    double continuousNotEating = 0;
    double maxContinuousNotEating = 0;

    double totalSleep = 0;
    int totalMeals = 0;

    for (int i = 1; i < sleepData.length; i++) {
      // Sleep data analysis
      if (sleepData[i].y == 0) { // Baby is awake
        continuousAwake += sleepData[i].x - sleepData[i - 1].x;
      } else { // Baby is sleeping
        totalSleep += sleepData[i].x - sleepData[i - 1].x;
        continuousAwake = 0;
      }
      maxContinuousAwake = continuousAwake > maxContinuousAwake ? continuousAwake : maxContinuousAwake;

      // Meal data analysis
      if (mealData[i].y == 0) { // Baby is not eating
        continuousNotEating += mealData[i].x - mealData[i - 1].x;
      } else { // Baby is eating
        totalMeals += 1;
        continuousNotEating = 0;
      }
      maxContinuousNotEating = continuousNotEating > maxContinuousNotEating ? continuousNotEating : maxContinuousNotEating;
    }

    // Determine the reason for crying
    if (maxContinuousNotEating > maxNotEatingTime) {
      return "Hungry";
    } else if (maxContinuousAwake > maxAwakeTime) {
      return "Tired";
    } else if (totalSleep < minTotalSleep) {
      return "Tired";
    } else if (totalMeals < minTotalMeals) {
      return "Hungry";
    } else {
      return "Discomfort";
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      reason = whyIsBabyCrying(widget.graphData[0], widget.graphData[1]);
    });
    print(reason);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("babies")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(title: Text("About your baby")),
              body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          snapshot.data!.docs[0].get('babyName') +
                              "'s Recommendations",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          "Get insights into your baby’s well-being.",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[500]),
                        ),
                        SizedBox(height: 35),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.sentiment_neutral_outlined,
                                color: Colors.yellow[600],
                                size: MediaQuery.of(context).size.width * 0.25,
                              ),
                              Text(
                                snapshot.data!.docs[0].get('babyName') +
                                    " Needs Attention",
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.yellow[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Why is " +
                              snapshot.data!.docs[0].get('babyName') +
                              " Crying?",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text("Sleep", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: (hungerSlider >= 75)
                                    ? Colors.green
                                    : (hungerSlider >= 50)
                                        ? Colors.yellow[600]
                                        : Colors.red,),),
                                        Spacer(),
                                        Icon(Icons.sentiment_dissatisfied_outlined, size: 40, color: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,)
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            activeTrackColor: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            thumbColor: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            overlayColor: ((hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red),
                            disabledActiveTrackColor: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            disabledInactiveTrackColor: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            disabledThumbColor: (hungerSlider >= 75)
                                ? Colors.green
                                : (hungerSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors
                                        .red, // Ensures the thumb color changes
                          ),
                          child: Slider(
                            value: hungerSlider,
                            max: 100,
                            divisions: 5,
                            onChanged: null,
                          ),
                        ), 
                    
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text("Nutrition", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: (sleepSlider >= 75)
                                    ? Colors.green
                                    : (sleepSlider >= 50)
                                        ? Colors.yellow[600]
                                        : Colors.red,),),
                                        Spacer(),
                                        Icon(Icons.sentiment_very_satisfied_outlined, size: 40, color: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,)
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            activeTrackColor: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            thumbColor: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            overlayColor: ((sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red),
                            disabledActiveTrackColor: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            disabledInactiveTrackColor: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors.red,
                            disabledThumbColor: (sleepSlider >= 75)
                                ? Colors.green
                                : (sleepSlider >= 50)
                                    ? Colors.yellow[600]
                                    : Colors
                                        .red, // Ensures the thumb color changes
                          ),
                          child: Slider(
                            value: sleepSlider,
                            max: 100,
                            divisions: 5,
                            onChanged: null,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Based on the data you've shown us, " + snapshot.data!.docs[0].get('babyName') + " is tired!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                        SizedBox(height: 5),
                        Text("Infants need anywhere from 14-17 hours of sleep a day. Consider laying your child down for a nap!", style: TextStyle(fontSize: 16,),)
                      ],
                    
                    ),
                  )),
            );
          } else {
            return LoadingScreen();
          }
        });
  }
}
