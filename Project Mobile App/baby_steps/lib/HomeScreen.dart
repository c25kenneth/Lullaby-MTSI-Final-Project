import 'package:baby_steps/BabyOverview.dart';
import 'package:baby_steps/LoadingScreen.dart';
import 'package:baby_steps/PostFeed.dart';
import 'package:baby_steps/ResourcesMapScreen.dart';
import 'package:baby_steps/ScheduleNapTime.dart';
import 'package:baby_steps/auth/Welcome.dart';
import 'package:baby_steps/components/HeaderFb1.dart';
import 'package:baby_steps/components/LineChart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    final List<String> menuOptions = [
    "Sleep",
    "Meal",
  ];

  final List points = [
    
    [
      FlSpot(0, 1),
      FlSpot(1.4, 1),
      FlSpot(2, 1),
      FlSpot(3.0, 1),
      FlSpot(3.2, 0),
      FlSpot(4, 0),
      FlSpot(5, 0),
      FlSpot(6, 1),
      FlSpot(6.2, 1),
      FlSpot(6.8, 1),
      FlSpot(7, 0),
      FlSpot(8, 0),
      FlSpot(9, 1),
      FlSpot(10, 1),
      FlSpot(11, 0),
      FlSpot(12, 1)
    ],
    [
  FlSpot(0.0, 0),
  FlSpot(0.5, 0),
  FlSpot(1.0, 1),
  FlSpot(1.5, 1),
  FlSpot(1.75, 1),
  FlSpot(2.0, 0),
  FlSpot(2.5, 0),
  FlSpot(3.0, 0),
  FlSpot(3.5, 0),
  FlSpot(4.0, 1),
  FlSpot(4.3, 1),
  FlSpot(4.5, 0),
  FlSpot(5.0, 0),
  FlSpot(5.5, 0),
  FlSpot(6.0, 0),
  FlSpot(6.5, 0),
  FlSpot(7.0, 0),
  FlSpot(7.5, 0),
  FlSpot(8.0, 0),
  FlSpot(8.5, 0),
  FlSpot(9.0, 0),
  FlSpot(9.5, 0),
  FlSpot(10.0, 0),
]
  ];
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("babies")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        SafeArea(
                          child: HeaderFb1(
                            text: "Welcome back,",
                            subtitle: "We're here for " +
                                snapshot.data!.docs[0].get('babyName'),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Welcome()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout_outlined),
                        ),
                      ],
                    ),
                  ),
                 CarouselSlider.builder(
  itemCount: menuOptions.length,
  options: CarouselOptions(
    enableInfiniteScroll: false,
    height: MediaQuery.of(context).size.width / 2,
    viewportFraction: 0.8, // Adjust this to control the space between items
    enlargeCenterPage: true, // Optional: Make the centered item larger
  ),
  itemBuilder: (BuildContext context, int index, int realIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0), // Adjust horizontal padding as needed
      child: LineChartSample2(
        label: snapshot.data!.docs[0].get('babyName') + "'s " + "Last " + menuOptions[index],
        option: menuOptions[index],
        points: points[index],
      ),
    );
  },
),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: 
                          Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        children: [
                          // Row with the large Schedule Nap card
                          AspectRatio(
                            aspectRatio:
                                2.2, // Adjust this value to control the height
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ScheduleNapTime(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(255, 125, 157, 1),
                                          Color.fromRGBO(110, 172, 255, 1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.white,
                                            size: 45,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            snapshot.data!.docs[0]
                                                    .get('babyName') +
                                                "'s Schedule",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Row with the other two cards
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PostFeed(
                                                userName: snapshot.data!.docs[0]
                                                    .get('parentName'),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 125, 157, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.group_outlined,
                                                  color: Colors.white,
                                                  size: 45,
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  "Ask Other Parents",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ResourcesMapScreen(),
                                          //   ),
                                          // );
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BabyOverview(graphData: points,)));
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                110, 172, 255, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.sentiment_dissatisfied_outlined,
                                                  color: Colors.white,
                                                  size: 45,
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  "Why's My Baby Crying?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
