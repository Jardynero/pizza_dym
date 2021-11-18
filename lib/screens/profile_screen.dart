// Profile page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  final String _title = 'Профиль';

  @override
  Widget build(BuildContext context) {
    final _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: false).auth;
    return Scaffold(
      appBar: MainAppBar(_title),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _auth.signOut(),
          child: Text("Выйти"),
        ),
      ),
    );
  }
}
