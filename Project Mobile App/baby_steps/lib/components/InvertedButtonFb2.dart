import 'package:flutter/material.dart';

class InvertedButtonFb2 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  InvertedButtonFb2({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const primaryColor = const Color.fromRGBO(255, 64, 111, 1);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: OutlinedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                const BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                right: 75, left: 75, top: 12.5, bottom: 12.5)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)))),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: primaryColor, fontSize: 16),
        ),
      ),
    );
  }
}