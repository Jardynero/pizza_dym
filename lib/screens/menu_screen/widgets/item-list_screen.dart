import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/single-product_screen.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatefulWidget {
  final _itemData;
  ItemCard(this._itemData, {Key? key}) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final String categorieName = widget._itemData['категория товара'];
    final String itemName = widget._itemData['название'];
    final String itemPhotoUrl = widget._itemData['фото'];
    final String itemDescription = widget._itemData['описание'];
    final int itemCost = widget._itemData['цена'];
    final bool availableToBuy = widget._itemData['доступность товара'];
    var cart = Provider.of<CartModel>(context, listen: true).cart;
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleProductScreen(widget._itemData),
        ),
      ),
      child: Container(
        // color: Colors.red,
        width: MediaQuery.of(context).size.width,
        height: 170,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 4.0,
          shadowColor: Colors.grey[100],
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: CachedNetworkImageProvider(itemPhotoUrl)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flexible(
                      //   child: Text(
                      //     '$itemName',
                      //     style: TextStyle(
                      //         fontSize: 20, fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                      Text(itemName, style: Theme.of(context).textTheme.subtitle1),
                      Text(itemDescription, style: Theme.of(context).textTheme.bodyText1, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      if (cart.findItemIndexFromCart(itemName) == null)
                        SizedBox(
                          width: 165,
                          height: 40,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: availableToBuy == false
                                  ? null
                                  : () async {
                                      Provider.of<CartModel>(
                                        context,
                                        listen: false,
                                      ).addProductToCart(
                                        itemName,
                                        itemCost,
                                        itemName,
                                        itemPhotoUrl,
                                      );
                                      await analytics.logAddToCart(
                                          itemId: itemName,
                                          itemName: itemName,
                                          itemCategory: categorieName,
                                          quantity: 1,
                                          currency: 'RUB',
                                          price: itemCost.toDouble());
                                    },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                availableToBuy == false
                                    ? 'Только в кафе'
                                    : '$itemCost₽',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: 165,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xffFF9F38)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Provider.of<CartModel>(context,
                                            listen: false)
                                        .decrementItemFromCart(itemName);
                                  },
                                  child: Text(
                                    '-',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Text(
                                    '${cart.getSpecificItemFromCart(itemName)!.quantity}',
                                    style: TextStyle(fontSize: 18)),
                                TextButton(
                                  onPressed: () async {
                                    Provider.of<CartModel>(context,
                                            listen: false)
                                        .incrementItemToCart(itemName);
                                    await analytics.logAddToCart(
                                        itemId: itemName,
                                        itemName: itemName,
                                        itemCategory: categorieName,
                                        quantity: 1,
                                        currency: 'RUB',
                                        price: itemCost.toDouble());
                                  },
                                  child: Text(
                                    '+',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
