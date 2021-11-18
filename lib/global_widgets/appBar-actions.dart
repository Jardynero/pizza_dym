import 'package:flutter/material.dart';

Widget profileAppBarAction(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: IconButton(
      icon: Icon(Icons.account_circle, size: 35),
      onPressed: () => Navigator.pushNamed(context, '/profile'),
    ),
  );
}
