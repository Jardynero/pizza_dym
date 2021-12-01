import 'package:flutter/material.dart';

Widget profileAppBarAction(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: IconButton(
      icon: Image.asset('assets/icons/userProfile.png', width: 35, height: 35),
      onPressed: () => Navigator.pushNamed(context, '/profile'),
    ),
  );
}
