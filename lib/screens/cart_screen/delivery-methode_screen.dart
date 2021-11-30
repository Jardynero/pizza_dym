// Checkout page

import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class DeliveryMethode extends StatefulWidget {
  const DeliveryMethode({Key? key}) : super(key: key);

  @override
  State<DeliveryMethode> createState() => _DeliveryMethodeState();
}

class _DeliveryMethodeState extends State<DeliveryMethode> {
  int? _groupValue = 1;
  int _delivery = 1;
  int _pickup = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Способ доставки'),
      body: Column(
        children: [
          deliveryMethode('Доставка на дом', _delivery),
          deliveryMethode('Самовывоз', _pickup),
          btn(),
        ],
      ),
    );
  }

  Widget deliveryMethode(title, int value) {
    return Card(
      child: ListTile(
        title: Text(title),
        leading: Radio(
          value: value,
          groupValue: _groupValue,
          onChanged: (int? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
      ),
    );
  }

  Widget btn() {
    return ElevatedButton(
      child: Text('Далее'),
      onPressed: () {
        Provider.of<CartModel>(context, listen: false).checkDeliveryMethode(_groupValue!);
        if (_groupValue == 1) {
          Navigator.pushNamed(context, '/adress');
        }
        else if (_groupValue == 2) {
          Navigator.pushNamed(context, '/pickup');
        }
      },
    );
  }
}

