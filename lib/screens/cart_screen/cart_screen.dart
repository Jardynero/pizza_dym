// Cart page
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/global_widgets/widgets.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/cart_screen/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final int? totalAmount;
  CartScreen({
    required this.totalAmount,
    Key? key,
  }) : super(key: key);

  final FlutterCart cart = FlutterCart();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Корзина'),
      body: totalAmount! > 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Consumer<CartModel>(
                    builder: (BuildContext context, cartModel, _) {
                      return ListView.builder(
                        itemCount: cartModel.cart.message.cartItemList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CartListItems(index: index);
                        },
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    UpsaleHeading(
                      title: 'Добавить к заказу?',
                      categorieName: 'Напитки',
                    ),
                    UpSale(
                      categorieName: 'Напитки',
                    ),
                  ],
                ),
                CartBottomBar(),
              ],
            )
          : Center(
              child: Text(
                'Корзина пуста!',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
    );
  }
}
