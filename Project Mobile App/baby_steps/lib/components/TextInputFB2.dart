import 'package:flutter/material.dart';

class TextInputFb2 extends StatefulWidget {
  final TextEditingController inputController;
  final String labelText; 
  final String hintText; 
  const TextInputFb2({Key? key,required this.inputController, required this.labelText, required this.hintText}) : super(key: key);

  @override
  State<TextInputFb2> createState() => _TextInputFb2State();
}

class _TextInputFb2State extends State<TextInputFb2> {
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
                  color: Colors.grey.withOpacity(.1)
                ),
            ]),
            child: TextField(
              controller: widget.inputController,
              onChanged: (value) {
                //Do something wi
              },
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                label: Text(widget.labelText),
                labelStyle: const TextStyle(color: primaryColor),
                filled: true,
                fillColor: accentColor,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
               errorBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ) ,
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
}

class TextInputFbMultiLine extends StatefulWidget {
  final TextEditingController inputController;
  final String labelText; 
  final String hintText; 
  final int maxLines; 
  const TextInputFbMultiLine({Key? key,required this.inputController, required this.labelText, required this.hintText, required this.maxLines}) : super(key: key);

  @override
  State<TextInputFbMultiLine> createState() => _TextInputFbMultiLineState();
}

class _TextInputFbMultiLineState extends State<TextInputFbMultiLine> {
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
                  color: Colors.grey.withOpacity(.1)
                ),
            ]),
            child: TextField(
              minLines: widget.maxLines,
              maxLines: widget.maxLines,
              controller: widget.inputController,
              onChanged: (value) {
                //Do something wi
              },
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                label: Text(widget.labelText),
                labelStyle: const TextStyle(color: primaryColor),
                filled: true,
                fillColor: accentColor,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
               errorBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ) ,
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
}