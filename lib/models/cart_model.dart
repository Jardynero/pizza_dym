// cart model

import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (cart.getSpecificItemFromCart(itemId)!.quantity == 1) {
      cart.deleteItemFromCart(cart.findItemIndexFromCart(itemId)!);
    } else {
      cart.decrementItemFromCart(cart.findItemIndexFromCart(itemId)!);
    }

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

  // Количество конкретного товара в корзине
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

  // var == 1 ? доставка на дом
  // var == 2 ? самовывоз из ресторана
  int _deliveryMethode = 0;
  int get deliveryMethode => _deliveryMethode;

  void checkDeliveryMethode(int deliveryMethode) {
    _deliveryMethode = deliveryMethode;
  }

  // var == 1 ? Оплата картой
  // var == 2 ? Оплата наличкой
  int _paymentMethode = 0;
  int get paymentMethode => _paymentMethode;

  void getPaymentMethode(int paymentMethode) {
    _paymentMethode = paymentMethode;
  }

  // С какой купюры нужна сдача
  String _changeFrom = '';
  String get changeFrom => _changeFrom;

  void getChangeFrom(changeFrom) {
    _changeFrom = changeFrom;
  }

  // Время самовывоза
  DateTime _pickupChosenTime = DateTime.now();
  DateTime get pickupChosenTime => _pickupChosenTime;

  void getPickupChosenTime(chosenTime) {
    _pickupChosenTime = chosenTime;
  }

  // Время доставки
  //Вариант времени доставки на дом (сейчас или ко времени)
  // int == 1 ? Как можно скорее
  // int == 2 ? Доставка ко времени
  int _deliveryTimeType = 0;
  int get deliveryTimeType => _deliveryTimeType;

  void getDeliveryTimeType(deliveryTimeType) {
    _deliveryTimeType = deliveryTimeType;
  }

  // Выбранное время доставки
  DateTime _deliveryChosenTime = DateTime.now();
  DateTime get deliveryChosenTime => _deliveryChosenTime;

  void getdeliveryChosenTime(chosenTime) {
    _deliveryChosenTime = chosenTime;
  }

  // Текущий номер заказа
  int _orderNumber = 0;
  int get orderNumber => _orderNumber;

  void getOrderNumber() {
    DocumentReference order =
        FirebaseFirestore.instance.collection('restaurant').doc('order');

    order.get().then((value) => value.get('Номер заказа')).then((value) {
      _orderNumber = value;
    }).catchError((error) {
      debugPrint('$error');
    });

    notifyListeners();
  }

  void sendNewOrderNumber() {
    int currentOrderNumber = _orderNumber + 1;
    FirebaseFirestore.instance
        .collection('restaurant')
        .doc('order')
        .update({'Номер заказа': currentOrderNumber})
        .then((value) => debugPrint(
            'Номер заказа обновлен с $_orderNumber на $currentOrderNumber'))
        .catchError((error) => debugPrint('Возникла ошибка: $error'));
  }

  Map<String, List> orderList() {
    int counter = 1;
    Map<String, List> result = {};
    cart.cartItem.forEach((element) {
      result['$counter'] = [element.productName, element.quantity, element.subTotal, element.productDetails];
      counter ++;
    });
    return result;
  }
  void saveOrderToHistory(context) {
    DateTime timeNow = DateTime.now();
    double totalOrderAmount = cart.getTotalAmount();
    int totalOrderAmountInt = totalOrderAmount.toInt();
    int currentOrderNumber = _orderNumber + 1;
    String userPhoneNumber =
        Provider.of<FirebaseAuthInstance>(context, listen: false)
            .auth
            .currentUser!
            .phoneNumber!;
    var userOrders = FirebaseFirestore.instance
        .collection('users')
        .doc('$userPhoneNumber')
        .collection('orders');

    userOrders
        .doc('Заказ от $timeNow')
        .set(
          {
            'Номер заказа': currentOrderNumber,
            'Дата заказа': timeNow,
            'Сумма заказа': totalOrderAmountInt,
            'Состав заказа': orderList(),
          },
        )
        .then((value) => debugPrint(
            'Заказ от $timeNow под номером $currentOrderNumber, Был успешно записан в Бд'))
        .catchError((error) => debugPrint(
            'Произошла ошибки во время сохранения заказа в БД: $error'));
  }

  String _userStreet = '';
  String _userHouse = '';
  String _userBlock = '';
  String _userEntrance = '';
  String _userAppartment = '';
  String _userIntercom = '';
  String _userFloor = '';
  String _userFullAdress = '';
  String _deliveryGeo = '';
  String _userComment = '';
  String _userName = '';
  String get userStreet => _userStreet;
  String get userHouse => _userHouse;
  String get userBlock => _userBlock;
  String get userEntrance => _userEntrance;
  String get userAppartment => _userAppartment;
  String get userIntercom => _userIntercom;
  String get userFloor => _userFloor;
  String get userFullAdress => _userFullAdress;
  String get deliveryGeo => _deliveryGeo;
  String get userComment => _userComment;
  String get userName => _userName;

  void getUserComment(userComment) {
    _userComment = userComment;
  }
  void getUserName(userName) {
    _userName = userName;

    notifyListeners();
  }
  void getUserAdressData(
    userStreet,
    userHouse,
    userBlock,
    userEntrance,
    userAppartment,
    userIntercom,
    userFloor,
    userFullAdress,
    deliveryGeo,
  ) {
    _userStreet = userStreet;
    _userHouse = userHouse;
    _userBlock = userBlock;
    _userEntrance = userEntrance;
    _userAppartment = userAppartment;
    _userIntercom = userIntercom;
    _userFloor = userFloor;
    _userFullAdress = userFullAdress;
    _deliveryGeo = deliveryGeo;

    notifyListeners();
  }

  void changeStreetAdress(newValue) {
    _userStreet = newValue;

    notifyListeners();
  }

  void changeHouseAdress(newValue) {
    _userHouse = newValue;

    notifyListeners();
  }

  void changeBlockAdress(newValue) {
    _userBlock = newValue;

    notifyListeners();
  }

  void changeEntranceAdress(newValue) {
    _userEntrance = newValue;

    notifyListeners();
  }

  void changeAppartmentAdress(newValue) {
    _userAppartment = newValue;

    notifyListeners();
  }

  void changeIntercomAdress(newValue) {
    _userIntercom = newValue;

    notifyListeners();
  }

  void changeFloorAdress(newValue) {
    _userFloor = newValue;

    notifyListeners();
  }

  void changeFullAdress(newValue) {
    _userFullAdress = newValue;

    notifyListeners();
  }

  void changeDeliveryGeo(newValue) {
    _deliveryGeo = newValue;

    notifyListeners();
  }

  double _appBarMaxHeight = 0.0;
  double get appBarMaxHeight => _appBarMaxHeight;

  void getAppBarMaxHeight(appBarMaxHeight) {
    _appBarMaxHeight = appBarMaxHeight;

    notifyListeners();
  }
}
