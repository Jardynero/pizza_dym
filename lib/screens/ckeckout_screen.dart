// Checkout page

import 'package:flutter/cupertino.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Text('Оформление заказа'),
      ),
    );
  }
}