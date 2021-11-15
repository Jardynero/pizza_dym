import 'package:flutter/material.dart';

class MainColorTheme {
  Color scaffoldBackgroundColor = Color.fromRGBO(39, 40, 42, 1.0);
  Color navBackgroundColor = Colors.black;
  Color primaryColor = Color.fromRGBO(255, 120, 41, 1.0);
  Color fontColor = Color.fromRGBO(255, 255, 255, 1.0);
  double paragraphFontSize = 17.0;
  double secondaryFontSize = 15.0;

  ThemeData mainTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffE5E5E5),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff27282A),
      elevation: 0,
    ),
    tabBarTheme: TabBarTheme(
      labelPadding: EdgeInsets.symmetric(horizontal: 20),
      unselectedLabelColor: Color(0xffffffff),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffFF9F38),
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xff000000),
        selectedItemColor: Color(0xffFF9F38)),
        unselectedWidgetColor: Color(0xffffffff),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xffFF9F38),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Color(0xffFF7829))),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.black,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xffB1B1B1),
    ),
  );
}
