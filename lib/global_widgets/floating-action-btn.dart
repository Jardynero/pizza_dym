import 'package:flutter/material.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class FloatingActionBtn extends StatelessWidget {
  const FloatingActionBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Общая стоимость всех товаров в корзине
    double _totalItemsPrice = Provider.of<CartModel>(context, listen: true).getTotalItemsPrice;

    return Visibility(
      visible: _totalItemsPrice == 0? false : true,
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 3),
        child: FloatingActionButton.extended(
          onPressed: () {
            Provider.of<CartModel>(context, listen: false).checkRestaurantStatus(context);
            Navigator.pushNamed(context, '/cart');
          },
          icon: Icon(Icons.shopping_bag_outlined),
          label: Text('${Provider.of<CartModel>(context, listen: true).getTotalItemsPrice.toInt()}₽', style: TextStyle(fontSize: 14, fontWeight:FontWeight.w500)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          backgroundColor: Color(0xff27282A),
          tooltip: 'Корзина',
        ),
      ),
    );
  }
}
