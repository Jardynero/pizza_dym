import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar-actions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';

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
    return Scaffold(
      appBar: MainAppBar(categorieName),
      body: StreamBuilder(
        stream: _menuItems,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          sortMenuItems(_counter, snapshot, _menuItemsSorted);
          return ListView(
            children: [
              for (final item in _menuItemsSorted.values)
                if (item[3] == categorieName) ItemCard(item),
            ],
          );
        },
      ),
    );
  }

  void sortMenuItems(_counter, snapshot, _menuItemsSorted) {
    while (_counter != snapshot.data!.get('menu').length + 1) {
      _menuItemsSorted[_counter] = snapshot.data!.get('menu')['$_counter'];
      _counter++;
    }
  }
}

class ItemCard extends StatelessWidget {
  final _itemData;
  ItemCard(this._itemData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String itemName = _itemData[0];
    final String itemPhotoUrl = _itemData[4];
    final int itemCost = _itemData[2];
    final bool availableToBuy = _itemData[5];
    return Container(
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
                width: 170, height: 170, child: Image.network('$itemPhotoUrl')),
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
                    addToCartBtn(itemCost, availableToBuy),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectQntBtn() {
    return SizedBox(
      width: 140,
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffFF9F38)),
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Text('-', style: TextStyle(fontSize: 18)),
            ),
            Text('1', style: TextStyle(fontSize: 18)),
            TextButton(
              onPressed: () {},
              child: Text('+', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget addToCartBtn(itemCost, availableToBuy) {
    return SizedBox(
      width: 165,
      height: 45,
      child: Container(
        child: ElevatedButton(
          onPressed: availableToBuy == false ? null : () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            availableToBuy == false ? 'Только в кафе' : '$itemCost₽',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
