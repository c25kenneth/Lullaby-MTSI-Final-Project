import 'package:flutter/material.dart';

class HeaderFb1 extends StatelessWidget {
  final String text;
  final String subtitle;
  const HeaderFb1({required this.text,this.subtitle="", Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey[500]),
          ),
        ],
    );
  }
}