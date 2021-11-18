// Main page

// sys import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar-actions.dart';

// Import screens
import 'package:pizza_dym/screens/menu_screen/menu_screen.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth instance
    final _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: false).auth;

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, '/login-phone');
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text('Пиццерия Дым'),
        centerTitle: true,
        actions: [
          profileAppBarAction(context),
        ],
      ),
      body: MenuScreen(),
    );
  }
}