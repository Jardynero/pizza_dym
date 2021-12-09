import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:provider/provider.dart';

Widget profileAppBarAction(context) {
  var _auth = Provider.of<FirebaseAuthInstance>(context, listen: false).auth;
  var _firestoreModel = Provider.of<CloudFirestore>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.only(right: 15.0),
    child: IconButton(
      icon: Image.asset('assets/icons/userProfile.png', width: 25, height: 25),
      onPressed: () {
        if (_auth.currentUser == null) {
          _firestoreModel.saveLastPageBeforeLogin('/profile');
          Navigator.pushNamed(context, '/login-phone');
        } else {
          Navigator.pushNamed(context, '/profile');
        }
      },
    ),
  );
}

Widget menuAppBarAction(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: IconButton(
        icon: Icon(Icons.restaurant_menu_outlined, size: 25, color: Colors.black),
        onPressed: () => Navigator.pushNamed(context, '/')
    ),
  );
}