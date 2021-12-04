// Cart page
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount =
        Provider.of<CartModel>(context, listen: true).cart.getTotalAmount();
    var cart = Provider.of<CartModel>(context, listen: true).cart;

    return Scaffold(
      appBar: MainAppBar('Корзина'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 100 * 70,
            child: ListView.builder(
                itemCount: cart.message.cartItemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return itemList(cart, index);
                }),
          ),
          bottomBar(totalAmount),
        ],
      ),
    );
  }

  Widget itemList(FlutterCart cart, index) {
    return Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 100 * 3,
          vertical: MediaQuery.of(context).size.height / 100 * 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              '${cart.message.cartItemList[index].productDetails.toString()}',
              width: 100,
              height: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 100 * 40,
                  child: Text(
                    '${cart.message.cartItemList[index].productName}',
                    style: TextStyle(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffFF9F38)),
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        child: Text(
                          '-',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          if (cart.message.cartItemList[index].quantity == 1 &&
                              cart.message.cartItemList.length == 1) {
                            Provider.of<CartModel>(context, listen: false)
                                .decrementItemFromCart(
                                    cart.message.cartItemList[index].productId);
                            Navigator.pop(context);
                          } else {
                            Provider.of<CartModel>(context, listen: false)
                                .decrementItemFromCart(
                                    cart.message.cartItemList[index].productId);
                          }
                        },
                      ),
                      Text(
                        '${cart.message.cartItemList[index].quantity}',
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Provider.of<CartModel>(context, listen: false)
                              .incrementItemToCart(
                                  cart.message.cartItemList[index].productId);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              '${cart.message.cartItemList[index].unitPrice * cart.message.cartItemList[index].quantity}₽',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomBar(double totalAmount) {
    var cartModel = Provider.of<CartModel>(context, listen: false);
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 100 * 10,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 100 * 4,
        ),
        // color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${totalAmount.toInt()}₽',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('~60 мин'),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0),
              child: SizedBox(
                width: 190,
                height: 50,
                child: ElevatedButton(
                  child: Text(
                    'ПРОДОЛЖИТЬ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff27282A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    cartModel.getOrderNumber();
                    Navigator.pushNamed(context, '/delivery-methode');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
