// Profile page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/profile/user%20adress/user-adress_screen.dart';
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _auth.signOut(),
              child: Text("Выйти"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/contacts'),
              child: Text("Контакты"),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/delivery-methode'),
              child: Text("Данные о заказе"),
            ),
            ElevatedButton(
              onPressed: () {
                getUserAdress(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfileUserAdressScreen(),
                  ),
                );
              },
              child: Text("Адрес доставки"),
            ),
          ],
        ),
      ),
    );
  }
}
