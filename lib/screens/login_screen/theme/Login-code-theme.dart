import 'package:flutter/material.dart';

class LoginCodeFormTheme {
  InputDecoration formDecoration = InputDecoration(
      hintText: "СМС код",
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Color(0xffB1B1B1), width: 1.0)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffFF7829)),
      ),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Color(0xffFF0000))),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Color(0xffFF0000))),
      contentPadding: EdgeInsets.only(left: 10.0));
}
