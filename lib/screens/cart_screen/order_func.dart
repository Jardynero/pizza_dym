// order function
import 'package:dart_telegram_bot/dart_telegram_bot.dart';
import 'package:dart_telegram_bot/telegram_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

String header(FlutterCart cart) {
  double totalAmountDouble = cart.getTotalAmount();
  int totalAmount = totalAmountDouble.toInt();

  return 'Новый заказ \nна сумму $totalAmount р.\n----';
}

String itemList(FlutterCart cart) {
  String itemList = '';
  int counter = 1;
  for (final item in cart.cartItem) {
    itemList =
        itemList + '$counter. ${item.productName} (${item.quantity} шт.)\n';
    counter++;
  }
  itemList = itemList + '\n----';
  return itemList.trim();
}

String userPhoneNumber(FirebaseAuth auth) {
  String? phoneNumber = auth.currentUser!.phoneNumber;

  return 'Телефон: $phoneNumber';
}

String userName() {
  return 'Имя:';
}

String userAdress(context) {
  var cartModel = Provider.of<CartModel>(context, listen: false);

  int deliveryMethode = cartModel.deliveryMethode;
  String userFullAdress = cartModel.userFullAdress;
  String userHouse = cartModel.userHouse;
  String userBlock = cartModel.userBlock;
  String userEntrance = cartModel.userEntrance;
  String userFloor = cartModel.userFloor;
  String userAppartment = cartModel.userAppartment;
  String userIntercom = cartModel.userIntercom;

  String adress = 'Адрес: ';
  // Если доставка на дом
  if (deliveryMethode == 1) {
    adress = adress +
        '$userFullAdress' +
        '\n' +
        'Детали: дом: $userHouse/корпус: $userBlock/подъезд: $userEntrance/этаж: $userFloor/кв: $userAppartment/домофон: $userIntercom';
  }
  // Если самовывоз
  else if (deliveryMethode == 2) {
    adress = 'Адрес:\nДетали:';
  }

  return adress;
}

String deliveryCoordinate(context) {
  var cartModel = Provider.of<CartModel>(context, listen: false);
  String deliveryGeo = cartModel.deliveryGeo;
  int deliveryMethode = cartModel.deliveryMethode;

  String result = '';
  if (deliveryMethode == 1) {
    result = 'Координаты доставки: $deliveryGeo';
  } else if (deliveryMethode == 2) {
    result = 'Координаты доставки:';
  }
  return '$result';
}

String deliveryMethode(context) {
  late String result;
  var cartModel = Provider.of<CartModel>(context, listen: false);
  int deliveryMethode = cartModel.deliveryMethode;
  // Если доставка на дом
  if (deliveryMethode == 1) {
    result = 'Доставка: Доставка';
  }
  // Если самовывоз
  else if (deliveryMethode == 2) {
    result = 'Доставка: Самовывоз';
  }
  return result;
}

String paymentMethode(context) {
  late String result;
  var cartModel = Provider.of<CartModel>(context, listen: false);
  int paymentMethode = cartModel.paymentMethode;
  int deliveryMethode = cartModel.deliveryMethode;
  String changeFrom = cartModel.changeFrom;
  // Если доставка на дом
  if (deliveryMethode == 1) {
    //Если оплата картой
    if (paymentMethode == 1) {
      result =
          'Оплата: Оплата банковской картой' + '\n' + 'Сдача с какой купюры:';
    }
    // Если оплата наличными
    else if (paymentMethode == 2) {
      result = 'Оплата: Оплата наличными при получение' +
          '\n' +
          'Сдача с какой купюры: $changeFrom';
    }
  }
  // Если самовывоз
  else if (deliveryMethode == 2) {
    result = 'Оплата:' + '\n' + 'Сдача с какой купюры:';
  }
  return result;
}

String deliveryTime(context) {
  late String result;
  var cartModel = Provider.of<CartModel>(context, listen: false);
  int deliveryMethode = cartModel.deliveryMethode;
  int deliveryTimeType = cartModel.deliveryTimeType;
  DateTime deliveryChosenTime = cartModel.deliveryChosenTime;
  DateTime chosenTimeInterval = deliveryChosenTime.add(Duration(minutes: 30));
  DateTime pickupChosenTime = cartModel.pickupChosenTime;

  // Если доставка на дом
  if (deliveryMethode == 1) {
    // Если доставка как можно скоррее
    if (deliveryTimeType == 1) {
      result = 'Время доставки: Как можно скорее';
    }
    // Если доставка ко времени
    else if (deliveryTimeType == 2) {
      result = 'Время доставки; ' +
          '${deliveryChosenTime.hour}:${deliveryChosenTime.minute}' +
          ' - ' +
          '${chosenTimeInterval.hour}:${chosenTimeInterval.minute}';
    }
  }
  // Если самовывоз
  else if (deliveryMethode == 2) {
    result =
        'Время самовывоза: ${pickupChosenTime.day}.${pickupChosenTime.month} в ${pickupChosenTime.hour}:${pickupChosenTime.minute}';
  }

  return result;
}

String comment(context) {
  late String result;
  var cartModel = Provider.of<CartModel>(context, listen: false);
  String userComment = cartModel.userComment;
  result = 'Комментарий: $userComment';
  return result;
}

String sendOrder(context) {
  FlutterCart cart = Provider.of<CartModel>(context, listen: false).cart;
  FirebaseAuth auth =
      Provider.of<FirebaseAuthInstance>(context, listen: false).auth;
  String order =
      '${header(cart)}\n${itemList(cart)}\n${userName()}\n${userPhoneNumber(auth)}\n${userAdress(context)}\n${deliveryCoordinate(context)}\n${deliveryMethode(context)}\n${paymentMethode(context)}\n${deliveryTime(context)}\n${comment(context)}';

  return order;
}

// SendOrderToDelegram
void sendOrderToTelegram(String message) {
  final String token = '5041704631:AAFvDqd2YzP_u5dwXGoF_Vi-HL0jpYmt1EU';
  final int chatID = -1001644242694;
  Bot(
    token: token,
    onReady: (bot) => bot.start(),
  ).sendMessage(ChatID(chatID), message).catchError((error) {
    print('Возникла ошбика: $error');
  });
}
