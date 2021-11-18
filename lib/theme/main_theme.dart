import 'package:flutter/material.dart';

class MainColorTheme {
  ThemeData mainTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffffffff),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.grey, size: 30),
      backgroundColor: Color(0xffffffff),
      titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      elevation: 4,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Color(0xffFF9F38)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xffFF9F38),
        textStyle: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w500,),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Color(0xffFF9F38))),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.black,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xffB1B1B1),
    ),
  );
}
