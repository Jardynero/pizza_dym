// Main page

// sys import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/global_widgets/floating-action-btn.dart';
import 'package:pizza_dym/models/customer-data_model.dart';

// Import screens
import 'package:pizza_dym/screens/menu_screen/menu_screen.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth instance
    final _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: true).auth;

    final _title = Provider.of<CustomerData>(context, listen: false).name;

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(context, '/login-phone', (route) => false);
      }
    });
    return Scaffold(
      appBar: MainAppBar('$_title'),
      floatingActionButton: FloatingActionBtn(),
      body: MenuScreen(),
    );
  }
}