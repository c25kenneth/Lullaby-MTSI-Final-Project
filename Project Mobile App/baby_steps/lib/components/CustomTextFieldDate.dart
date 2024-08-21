import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CustomTextFieldDate extends StatelessWidget {
  final bool isStart; 
  final TextEditingController controller;
  final String name;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final int numLines;
  final int maxLen;
  final bool onlyRead;
  final Icon leadingIcon;

  const CustomTextFieldDate({
    Key? key,
    required this.isStart,
    required this.controller,
    required this.name,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    required this.numLines,
    required this.maxLen,
    required this.onlyRead,
    required this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        onTap: () async {
          DateTime? dateTime = await showOmniDateTimePicker(
            context: context,
            type: OmniDateTimePickerType.date, // This should limit to date selection
            theme: ThemeData.light().copyWith(
              primaryColor: const Color(0xff4338CA), // Header background color
              hintColor: const Color(0xff4338CA), // Accent color
              colorScheme: const ColorScheme.light(
                primary: Color.fromRGBO(	55, 202, 236, 1), // Header background color
                onPrimary: Colors.black, // Header text color
                onSurface: Colors.black, // Text color
                surfaceTint: Colors.transparent, // Surface tint color
              ),
              dialogBackgroundColor: Colors.white, // Dialog background color
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff4338CA), // Text color for buttons
                ),
              ),
              buttonTheme: const ButtonThemeData(
                buttonColor: Color(0xff4338CA), // Button background color
              ),
              cardColor: Colors.white, // Card background color
            ),
          );

          if (dateTime != null) {
            // Format the date as 'Month day, year'
            String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
            controller.text = formattedDate;
          }
        },
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: maxLen,
        maxLines: numLines,
        obscureText: obscureText,
        keyboardType: inputType,
        readOnly: onlyRead,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: name,
          isDense: true,
          labelText: "",
          counterText: "",
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff4338CA)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff4338CA)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff4338CA)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
