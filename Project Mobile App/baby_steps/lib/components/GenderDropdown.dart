import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final String hintText; 
  final List options; 
  final TextEditingController controller;

  const GenderDropdown({Key? key, required this.controller, required this.hintText, required this.options}) : super(key: key);

  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue!;
            widget.controller.text = newValue;
          });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          isDense: true,
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
        items: widget.options.map<DropdownMenuItem<String>>((option) {
          final value = option.toString(); // Convert option to string
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
