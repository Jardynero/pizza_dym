import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartListItems extends StatefulWidget {
  final int index;
  CartListItems({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<CartListItems> createState() => _CartListItemsState();
}

class _CartListItemsState extends State<CartListItems> {
  @override
  Widget build(BuildContext context) {
    FlutterCart cart = Provider.of<CartModel>(context, listen: false).cart;
    String cartImage = cart.message.cartItemList[widget.index].productDetails;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      elevation: 4,
      shadowColor: Colors.grey[100],
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
                image: CachedNetworkImageProvider(cartImage),
                width: 100,
                height: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 100 * 40,
                  child: Text(
                    '${cart.message.cartItemList[widget.index].productName}',
                    style: TextStyle(fontSize: 18),
                    maxLines: 1,
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
                          if (cart.message.cartItemList[widget.index]
                                      .quantity ==
                                  1 &&
                              cart.message.cartItemList.length == 1) {
                            Provider.of<CartModel>(context, listen: false)
                                .decrementItemFromCart(
                              cart.message.cartItemList[widget.index].productId,
                            );
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          } else {
                            Provider.of<CartModel>(context, listen: false)
                                .decrementItemFromCart(
                              cart.message.cartItemList[widget.index].productId,
                            );
                          }
                        },
                      ),
                      Text(
                        '${cart.message.cartItemList[widget.index].quantity}',
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
                            cart.message.cartItemList[widget.index].productId,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              '${cart.message.cartItemList[widget.index].unitPrice * cart.message.cartItemList[widget.index].quantity}₽',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
