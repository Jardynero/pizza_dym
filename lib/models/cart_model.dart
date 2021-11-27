// cart model

import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:provider/provider.dart';

class CartModel extends ChangeNotifier {
  var cart = FlutterCart();

  double get getTotalItemsPrice => cart.getTotalAmount();

  void addProductToCart(productId, unitPrice, productName, String imageUrl) {
    cart.addToCart(
        productId: productId,
        unitPrice: unitPrice,
        productName: productName,
        productDetailsObject: imageUrl);

    notifyListeners();
  }

  void incrementItemToCart(itemId) {
    cart.incrementItemToCart(cart.findItemIndexFromCart(itemId)!);

    notifyListeners();
  }

  void decrementItemFromCart(itemId) {
    cart.decrementItemFromCart(cart.findItemIndexFromCart(itemId)!);

    notifyListeners();
  }

  void addProductToCartQnt(
      itemId, unitPrice, productName, quantity, String imageUrl) {
    cart.addToCart(
        productId: itemId,
        unitPrice: unitPrice,
        productName: productName,
        quantity: quantity,
        productDetailsObject: imageUrl);

    notifyListeners();
  }

  // Количество кокнертного товара в корзине
  int _singleProductQntInCart = 0;

  int get singleProductQntInCart => _singleProductQntInCart;

  void obtainQntOfProduct(itemId) {
    try {
      _singleProductQntInCart = cart.getSpecificItemFromCart(itemId)!.quantity;
    } catch (e) {
      debugPrint('$e');
    }

    notifyListeners();
  }

  bool _restaurantStatus = true;

  bool get restaurantStatus => _restaurantStatus;

  String _restaurantStatusMessage = '';

  String get restaurantStatusMessage => _restaurantStatusMessage;

  void checkRestaurantStatus(context) {
    final bool isOpen =
        Provider.of<CloudFirestore>(context, listen: false).isOpen;

    final int openingTime =
        Provider.of<CloudFirestore>(context, listen: false).openingTime;

    final int closingTime =
        Provider.of<CloudFirestore>(context, listen: false).closingTime;

    final Map workingDays =
        Provider.of<CloudFirestore>(context, listen: false).workingDays;

    int timeNow = DateTime.now().hour;

    int dayTooday = DateTime.now().weekday;

    if (isOpen == false || timeNow < openingTime || timeNow >= closingTime) {
      _restaurantStatus = false;
      _restaurantStatusMessage = 'Мы закрыты';
    }
    workingDays.forEach((key, value) {
      if (key.toString() == dayTooday.toString() && value == false) {
        _restaurantStatus = false;
        _restaurantStatusMessage = 'У нас выходной';
      }
    });

    notifyListeners();
  }
}
