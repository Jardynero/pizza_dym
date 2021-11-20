// cart model

import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';

class CartModel extends ChangeNotifier {
  // Переменная содержить все позиции закаха
  // _orderList[[0]] = Название позиции
  // _orderList[[1]] = количество данного товара
  // _orderList[[2]] = стоимость товара
  // _orderList[[3]] = фото товара
  
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
}
