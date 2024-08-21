import 'package:baby_steps/FlutterFireFuncs.dart';
import 'package:baby_steps/HomeScreen.dart';
import 'package:baby_steps/components/CustomTextFieldDate.dart';
import 'package:baby_steps/components/GenderDropdown.dart';
import 'package:baby_steps/components/GradientButtonFb1.dart';
import 'package:baby_steps/components/TextInputFB2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class AddBabyInfo extends StatefulWidget {
  const AddBabyInfo({super.key});

  @override
  State<AddBabyInfo> createState() => _AddBabyInfoState();
}

class _AddBabyInfoState extends State<AddBabyInfo> {
  final TextEditingController _babyNameController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  // final TextEditingController _babyBirthdayController = TextEditingController();
  String errorText = ""; 

  final List<String> items = ['Male', 'Female'];
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    // Format current date as 'Month day, year'
    String formattedDate = DateFormat('MMMM dd, yyyy').format(now);
    _birthday.text = formattedDate;
  }

  final TextEditingController genderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add your baby"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: width * 0.65,
                    height: height * 0.20,
                    child: SvgPicture.asset(
                      "assets/images/undraw_family_vg76.svg",
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                  TextInputFb2(
                      inputController: _parentNameController,
                      labelText: "Enter your name (parent)",
                      hintText: "John Doe"),
                  SizedBox(height: 25),
                  TextInputFb2(
                      inputController: _babyNameController,
                      labelText: "Enter your baby's name",
                      hintText: "Ryan"),
                  SizedBox(height: 25),
                  GenderDropdown(controller: genderController, options: items, hintText: "Baby's Gender",),
                  SizedBox(height: 25),
                  CustomTextFieldDate(
                    isStart: true,
                    controller: _birthday,
                    leadingIcon: const Icon(
                      Icons.cake_outlined,
                      color: Colors.orangeAccent,
                      size: 25,
                    ),
                    onlyRead: true,
                    name: "",
                    inputType: TextInputType.text,
                    maxLen: 80,
                    numLines: 1,
                  ),
                  SizedBox(height: 15),
                  GradientButtonFb1(text: "Add to Family", onPressed: () async {
                    if (_babyNameController.text != "" && genderController.text != "" && _birthday.text != "") {
              
                      dynamic res = await addBaby(_babyNameController.text, _parentNameController.text, genderController.text, _birthday.text);
                      if (res.runtimeType == String) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(uid: FirebaseAuth.instance.currentUser!.uid)));
                      } else {
                        
                        setState(() {
                          errorText = "Internal Error. Please try again later!";
                        });
                      }
                    } else {
                      setState(() {
                        errorText = "One or more fields cannot be empty!";
                      });
                    }
                  }),
                  if (errorText != "")
                    SizedBox(height: 15),
                    Text(errorText, style: TextStyle(color: Colors.red, fontSize: 16),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
