import 'package:flutter/material.dart';

Widget profileAppBarAction(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: IconButton(
      icon: Image.asset('assets/icons/userProfile.png', width: 25, height: 25),
      onPressed: () => Navigator.pushNamed(context, '/profile'),
    ),
  );
}
