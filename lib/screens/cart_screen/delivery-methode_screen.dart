// Checkout page

import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class DeliveryMethode extends StatefulWidget {
  const DeliveryMethode({Key? key}) : super(key: key);

  @override
  State<DeliveryMethode> createState() => _DeliveryMethodeState();
}

class _DeliveryMethodeState extends State<DeliveryMethode> {
  String _pickupIcon = 'assets/icons/pickup.png';
  String _takeAvayIcon = 'assets/icons/take-away.png';
  int? _groupValue = 1;
  int _delivery = 1;
  int _pickup = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Способ доставки'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          deliveryMethodes(),
          btn(),
        ],
      ),
    );
  }

  Widget title() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Данные о заказе',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            'Выберите способ доставки',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget deliveryMethode(title, int value, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _groupValue = value;
        });
      },
      child: Container(
        height: 80,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff27282A),
                    fontSize: 18,
                  ),
                ),
                horizontalTitleGap: 32,
                leading: Image.asset('$iconPath', width: 40, height: 40),
                trailing: Radio(
                  value: value,
                  groupValue: _groupValue,
                  onChanged: (int? value) {
                    setState(() {
                      _groupValue = value;
                    });
                  },
                  activeColor: Color(0xffFF9F38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deliveryMethodes() {
    return Column(
      children: [
        title(),
        deliveryMethode('Доставка на дом', _delivery, _takeAvayIcon),
        deliveryMethode('Самовывоз', _pickup, _pickupIcon),
      ],
    );
  }

  Widget btn() {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 5),
      child: ElevatedButton(
        child: Text('Далее', style: TextStyle(fontSize: 20)),
        onPressed: () {
          Provider.of<CartModel>(context, listen: false)
              .checkDeliveryMethode(_groupValue!);
          if (_groupValue == 1) {
            getUserAdress(context);
            Navigator.pushNamed(context, '/adress');
          } else if (_groupValue == 2) {
            Navigator.pushNamed(context, '/pickup');
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xff27282A),
          fixedSize: Size(
            MediaQuery.of(context).size.width / 100 * 54,
            MediaQuery.of(context).size.height / 100 * 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
