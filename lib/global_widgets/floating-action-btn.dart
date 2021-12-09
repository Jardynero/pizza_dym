import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class FloatingActionBtn extends StatefulWidget {
  const FloatingActionBtn({Key? key}) : super(key: key);

  @override
  State<FloatingActionBtn> createState() => _FloatingActionBtnState();
}

class _FloatingActionBtnState extends State<FloatingActionBtn> {
  late int _totalItemsPrice;
  @override
  void initState() {
    _totalItemsPrice = Provider.of<CartModel>(context, listen: false).cart.getTotalAmount().toInt();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Общая стоимость всех товаров в корзине
    FlutterCart cart = Provider.of<CartModel>(context, listen: true).cart;
    _totalItemsPrice = cart.getTotalAmount().toInt();

    return Visibility(
      visible: cart.getCartItemCount() == 0? false : true,
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 3),
        child: FloatingActionButton.extended(
          onPressed: () {
            Provider.of<CartModel>(context, listen: false).checkRestaurantStatus(context);
            Navigator.pushNamed(context, '/cart');
          },
          icon: Icon(Icons.shopping_bag_outlined),
          label: Text('$_totalItemsPrice₽', style: TextStyle(fontSize: 14, fontWeight:FontWeight.w500)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          backgroundColor: Color(0xff27282A),
          tooltip: 'Корзина',
        ),
      ),
    );
  }

  void dispose() {

    super.dispose();
  }
}
