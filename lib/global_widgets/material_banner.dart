import 'package:flutter/material.dart';
import 'package:pizza_dym/models/cart_model.dart';

class DeliveryAdressAlert extends StatelessWidget {
  final int minimalAmount;
  final int totalAmount = CartModel().cart.getTotalAmount().toInt();
  DeliveryAdressAlert(this.minimalAmount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Минимальная сумма заказа'),
      content: Text(
          'Минимальная сумма заказа для доставки по указанному адресу - $minimalAmount руб. Ваш текущий заказ на $totalAmount руб.'),
      actions: [
        TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text('Понятно'))
      ],
    );
  }
}

