import 'package:baby_steps/FlutterFireFuncs.dart';
import 'package:baby_steps/HomeScreen.dart';
import 'package:baby_steps/auth/AddBabyInfo.dart';
import 'package:baby_steps/components/AppleSignInButton.dart';
import 'package:baby_steps/components/GoogleSignInButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final String assetName = 'assets/images/undraw_baby_re_fr9r.svg';
  String errorString = ""; 
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
        children: [

          Container(
            margin: EdgeInsets.only(top: height * 0.2),
            width: width * 0.75,
            height: height * 0.25,
            child: Image.asset("assets/images/451094122_1903705700039853_3196435292529556483_n.png"),
          ),
          SizedBox(height: height * 0.01,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Protecting infants, understandng parents. Everything you need to grow as a family in one place.',
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w400, fontSize: 18),
            ),
          ),
          SizedBox(height: height * 0.1),
          GoogleBtn1(
            onPressed: () async {
                  dynamic credGoogle = await signInWithGoogle();

                  if (credGoogle.runtimeType != String) {
                    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection("user").doc(credGoogle.user.uid).collection("babies").get();
                    if (userSnapshot.docs.isNotEmpty) {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(uid: credGoogle.user!.uid,)), (route) => false);
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AddBabyInfo()), (route) => false);
                    }
                  } else {
                    setState(() {
                      errorString = "Please try again"; 
                    });
                  }
                }
                ),
          AppleBtn1(
            onPressed: () async {
                  // dynamic credApple = await signInWithApple();

                  // if (credApple.runtimeType != String) {
                  //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(uid: credApple.user!.uid,)), (route) => false);
                  // } else {
                  //   setState(() {
                  //     errorString = "Please Try Again"; 
                  //   });
                  // }
                }
                ),
                SizedBox(height: 10),
           Center(child: (errorString != "") ? Text(errorString, style: const TextStyle(fontSize: 14, color: Colors.red), textAlign: TextAlign.center,) : const SizedBox()),
          // const SizedBox(
          //   height: 15,
          // ),
        ]),
      ),
    );
  }
}
