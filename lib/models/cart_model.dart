// cart model

import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';

class CartModel extends ChangeNotifier {
  
  var cart = FlutterCart();

  double get getTotalItemsPrice => cart.getTotalAmount();

  void addProductToCart(productId, unitPrice, productName,) {
    cart.addToCart(productId: productId, unitPrice: unitPrice, productName: productName);

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

  void addProductToCartQnt(itemId, unitPrice, productName, quantity) {
    cart.addToCart(productId: itemId, unitPrice: unitPrice, productName: productName, quantity: quantity);

    notifyListeners();
  }

  // Количество кокнертного товара в корзине
  int _singleProductQntInCart = 0;

  int get singleProductQntInCart => _singleProductQntInCart;

  void obtainQntOfProduct(itemId) {
    try {
      _singleProductQntInCart =  cart.getSpecificItemFromCart(itemId)!.quantity;
    } catch (e) {
      debugPrint('$e');
    }

    notifyListeners();
  }
}
