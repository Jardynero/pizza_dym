import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<FirebaseAuthInstance>(context, listen: false).auth;
    var firebaseModel = Provider.of<CloudFirestore>(context, listen: false);
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 100 * 10,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 100 * 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<CartModel>(
                  builder: (BuildContext context, cartModel, _) {
                    return Text(
                      '${cartModel.cart.getTotalAmount().toInt()}₽',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
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
                    Provider.of<CartModel>(context, listen: false).getOrderNumber();
                    if (_auth.currentUser == null) {
                      firebaseModel.saveLastPageBeforeLogin('/cart');
                      Navigator.pushNamed(context, '/login-phone');
                    } else {
                      Navigator.pushNamed(context, '/delivery-methode');
                    }
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
