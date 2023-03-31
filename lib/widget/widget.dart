import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 22),
        children: <TextSpan>[
          TextSpan(
              text: 'Quiz',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54)),
          TextSpan(
              text: 'App',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
        ],
      ),
    );
  }
}

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
);
