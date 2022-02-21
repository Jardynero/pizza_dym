import 'package:flutter/material.dart';

class LoginPhoneFormTheme {
  InputDecoration formDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Color(0xffB1B1B1), width: 1.0)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffFF7829)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffFF0000))
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffFF0000))
      ),
      contentPadding: EdgeInsets.only(left: 10.0));


  InputDecoration fieldTheme(label) {
    return InputDecoration(
      label: Text('$label'),
      labelStyle: TextStyle(fontSize: 14),
      isDense: true,
      contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
      floatingLabelStyle: TextStyle(
        color: Color(0xffFF9F38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color(0xffFF9F38),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color(0xffC4C4C4),
        ),
      ),
    );
  }
}
