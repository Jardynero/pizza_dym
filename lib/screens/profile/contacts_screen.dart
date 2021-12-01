// Contacts page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var heightSize = MediaQuery.of(context).size.height;
    print(heightSize);
    double height25 = heightSize / 100 * 25;
    return Scaffold(
      appBar: MainAppBar('Контакты'),
      body: Contacts(),
    );
  }
}

class Contacts extends StatelessWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double appBarMaxHeight = Scaffold.of(context).appBarMaxHeight!;
    double height25 =
        (MediaQuery.of(context).size.height - appBarMaxHeight) / 100 * 25;
    return Column(children: [
      Center(
        child: Text(
          '${Provider.of<CartModel>(context, listen: true).deliveryMethode}',
        ),
      ),
    ]);
  }
}
