import 'package:flutter/material.dart';

class GradientButtonFb1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GradientButtonFb1({required this.text, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(	55, 202, 236, 1);
    const secondaryColor = Color.fromRGBO(	55, 202, 236, 1);
    Color? accentColor = Colors.white;
   
    const double borderRadius = 15;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient:
                  const LinearGradient(colors: [primaryColor, secondaryColor])),
          child: ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                alignment: Alignment.center,
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    right: 75, left: 75, top: 15, bottom: 15)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                )),
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: accentColor, fontSize: 20),
            ),
          )),
    );
  }
}