import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/global_widgets/floating-action-btn.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/single-product_screen.dart';
import 'package:provider/provider.dart';

class ItemListScreen extends StatelessWidget {
  final String categorieName;
  ItemListScreen(this.categorieName, {Key? key}) : super(key: key);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _menuItems =
        _firestore.collection('restaurant').doc('menu').snapshots();
    int _counter = 1;
    Map _menuItemsSorted = {};
    List<List> _menuItemsSortedList = [];
    return Scaffold(
      appBar: MainAppBar(categorieName),
      floatingActionButton: FloatingActionBtn(),
      body: StreamBuilder(
        stream: _menuItems,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          sortMenuItems(
              _counter, snapshot, _menuItemsSorted, _menuItemsSortedList);
          return ListView.builder(
            itemCount: _menuItemsSortedList.length,
            itemBuilder: (BuildContext context, index) {
              if (_menuItemsSortedList[index][3] == categorieName) {
                return ItemCard(_menuItemsSortedList[index]);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  void sortMenuItems(
      _counter, snapshot, _menuItemsSorted, List _menuItemsSortedList) {
    while (_counter != snapshot.data!.get('menu').length + 1) {
      _menuItemsSorted[_counter] = snapshot.data!.get('menu')['$_counter'];
      _counter++;
    }
    for (final item in _menuItemsSorted.values) {
      _menuItemsSortedList.add(item);
    }
  }
}

class ItemCard extends StatefulWidget {
  final _itemData;
  ItemCard(this._itemData, {Key? key}) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final String itemName = widget._itemData[0];
    final String itemPhotoUrl = widget._itemData[4];
    final int itemCost = widget._itemData[2];
    final bool availableToBuy = widget._itemData[5];
    var cart = Provider.of<CartModel>(context, listen: true).cart;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleProductScreen(widget._itemData),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 7.0,
          shadowColor: Color(0xffEBEBEB),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: 170,
                  height: 170,
                  child: Image.network('$itemPhotoUrl')),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '$itemName',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (cart.findItemIndexFromCart(itemName) == null)
                        SizedBox(
                          width: 165,
                          height: 45,
                          child: Container(
                            child: ElevatedButton(
                              onPressed: availableToBuy == false
                                  ? null
                                  : () {
                                      Provider.of<CartModel>(
                                        context,
                                        listen: false,
                                      ).addProductToCart(
                                        itemName,
                                        itemCost,
                                        itemName,
                                        itemPhotoUrl,
                                      );
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
                          height: 45,
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
                                  onPressed: () {
                                    Provider.of<CartModel>(context,
                                            listen: false)
                                        .incrementItemToCart(itemName);
                                  },
                                  child:
                                      Text('+', style: TextStyle(fontSize: 18)),
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
