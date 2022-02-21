// order function
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_telegram_bot/dart_telegram_bot.dart';
import 'package:dart_telegram_bot/telegram_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

String header(context) {
  var cartModel = Provider.of<CartModel>(context, listen: false);
  double totalAmountDouble = cartModel.cart.getTotalAmount();
  int totalAmount = totalAmountDouble.toInt();
  int lastOrderNumber = cartModel.orderNumber;
  int currentOrderNumber = lastOrderNumber + 1;

  return 'Новый заказ #$currentOrderNumber \nна сумму $totalAmount р.\n----';
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

String userName(context) {
  String userName = Provider.of<CartModel>(context, listen: false).userName;
  return 'Имя: $userName';
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
        'Детали: дом: $userHouse/корпус: $userBlock/$userEntrance/$userIntercom/$userFloor/$userAppartment';
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

String geo(context) {
  String result = '';
  var cartModel = Provider.of<CartModel>(context, listen: false);
  int deliveryMethode = cartModel.deliveryMethode;
  String deliveryGeo = cartModel.deliveryGeo;
  if (deliveryMethode == 1) {
    result = deliveryGeo;
  } else if (deliveryMethode == 2) {
    result = 'Координаты не требуются';
  }

  return result;
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
  String result = '';
  var cartModel = Provider.of<CartModel>(context, listen: false);
  int deliveryMethode = cartModel.deliveryMethode;
  int deliveryTimeType = cartModel.deliveryTimeType;
  DateTime deliveryChosenTime = cartModel.deliveryChosenTime;
  DateTime chosenTimeInterval = deliveryChosenTime.add(Duration(minutes: 30));
  dynamic deliveryTimeMinute = fixMinuteTime(deliveryChosenTime.minute);
  dynamic deliveryTimeMinuteInterval = fixMinuteTime(chosenTimeInterval.minute);
  DateTime pickupChosenTime = cartModel.pickupChosenTime;
  dynamic pickupTimeMinute = fixMinuteTime(pickupChosenTime.minute);
  // Если доставка на дом
  if (deliveryMethode == 1) {
    // Если доставка как можно скоррее
    if (deliveryTimeType == 1) {
      result = 'Время доставки: Как можно скорее';
    }
    // Если доставка ко времени
    else if (deliveryTimeType == 2) {
      result = 'Время доставки; ' +
          '${deliveryChosenTime.hour}:$deliveryTimeMinute' +
          ' - ' +
          '${chosenTimeInterval.hour}:$deliveryTimeMinuteInterval';
    }
  }
  // Если самовывоз
  else if (deliveryMethode == 2) {
    result =
        'Время самовывоза: ${pickupChosenTime.day}.${pickupChosenTime.month} в ${pickupChosenTime.hour}:$pickupTimeMinute';
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
      '${header(context)}\n${itemList(cart)}\n${userName(context)}\n${userPhoneNumber(auth)}\n${userAdress(context)}\n${deliveryCoordinate(context)}\n${deliveryMethode(context)}\n${paymentMethode(context)}\n${deliveryTime(context)}\n${comment(context)}';

  return order;
}

// send order for deliveryMan in Cloud Firestore
Future<void> sendOrderToDeliveryMans(context) async {
  var cartModel = Provider.of<CartModel>(context, listen: false);
  final CollectionReference deliveryMansCollection =
      FirebaseFirestore.instance.collection('deliveryManOrders');
  String userFullAdress = cartModel.userFullAdress;
  String userHouse = cartModel.userHouse;
  String userBlock = cartModel.userBlock;
  String userEntrance = cartModel.userEntrance;
  String userFloor = cartModel.userFloor;
  String userAppartment = cartModel.userAppartment;
  String userIntercom = cartModel.userIntercom;
  int orderNumber = cartModel.orderNumber + 1;
  int totalAmount = cartModel.cart.getTotalAmount().toInt();
  String? token = await FirebaseMessaging.instance.getToken();
  String clientName = cartModel.userName;
  String? phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
  String deliveryMethode = cartModel.deliveryMethode == 1
      ? 'Доставка'
      : cartModel.deliveryMethode == 2
          ? 'Самовывоз'
          : 'Вариант доставки не распознан!';
  String comment = cartModel.userComment;
  String adressDetailsFull =
      'дом: $userHouse/корпус: $userBlock/$userEntrance/$userIntercom/$userFloor/$userAppartment';
  dynamic adress = deliveryMethode == 'Доставка' ? userFullAdress : null;

  dynamic adressDetails =
      deliveryMethode == 'Доставка' ? adressDetailsFull : null;
  List itemList = cartModel.cart.cartItem
      .map((item) => '${item.productName} (${item.quantity} шт.)')
      .toList();
  dynamic changeFrom = cartModel.changeFrom == '' ? null : cartModel.changeFrom;
  String paymentMethod = cartModel.paymentMethode == 1 ? 'картой' : 'наличные';
  return deliveryMansCollection.doc('$orderNumber').set(
    {
      'orderNumber': orderNumber,
      'deliveryMethod': deliveryMethode,
      'deliveryTime': deliveryTime(context),
      'orderItems': itemList,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'changeFrom': changeFrom,
      'comment': comment,
      'token': token,
      'clientName': clientName,
      'clientPhoneNumber': phoneNumber,
      'adress': adress,
      'adressDetails': adressDetails,
      'push_order_confirmed': false,
      'push_order_in_delivery': false,
      'push_order_delivered': false,
    },
  );
}

// SendOrderToDelegram
void sendOrderToTelegram(String message) {
  final String token = '1986877443:AAF_InoNq1RjIRZgURJMbg1U0KAUwKzvfTo';
  final int chatID = -1001360381141;
  Bot(
    token: token,
    onReady: (bot) => bot.start(),
  ).sendMessage(ChatID(chatID), message).catchError((error) {
    print('Возникла ошбика: $error');
  });
}

void sendGeoToTelegram(String geo) {
  final String token = '1986877443:AAF_InoNq1RjIRZgURJMbg1U0KAUwKzvfTo';
  final int chatID = -1001360381141;
  Bot(
    token: token,
    onReady: (bot) => bot.start(),
  ).sendMessage(ChatID(chatID), geo).catchError((error) {
    debugPrint(
        'Во время отправки геолокации в телеграм возникла ошибка: $error');
  });
}

String fixMinuteTime(timeMinute) {
  String result = '';
  if (timeMinute < 10) {
    result = '0$timeMinute';
  } else {
    result = timeMinute.toString();
  }

  return result;
}

Future showOrderConfirmation(context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 100 * 70,
          child: orderInfo(context),
        );
      });
}

Widget orderInfo(context) {
  var cartModel = Provider.of<CartModel>(context, listen: false);
  FlutterCart cart = cartModel.cart;

  int sum = cart.getTotalAmount().toInt();
  int orderNumber = cartModel.orderNumber + 1;
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 100 * 10,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Заказ № $orderNumber принят ✅\n',
                    style: titleStyle,
                  ),
                  TextSpan(text: 'Вам придет пуш с подтверждением заказа'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      orderList(cart, context),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 100 * 20,
        child: Container(
          color: Colors.grey.shade300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Итого\n', style: totalStyle),
                    TextSpan(text: '$sum ₽', style: sumStyle),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

TextStyle titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle totalStyle = TextStyle(fontSize: 16, color: Colors.grey);
TextStyle sumStyle =
    TextStyle(fontSize: 34, color: Colors.black, fontWeight: FontWeight.bold);

Map cartItems(FlutterCart cart) {
  Map result = {};
  int counter = 1;
  for (final element in cart.cartItem) {
    result['$counter'] = [
      element.productName,
      element.quantity,
      element.subTotal,
      element.productDetails,
    ];
    counter++;
  }
  return result;
}

Widget orderList(FlutterCart cart, context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height / 100 * 40,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
        itemCount: cartItems(cart).length,
        itemBuilder: (BuildContext context, index) {
          List item = cartItems(cart)['${index + 1}'];
          String name = item[0];
          String subtitle = '${item[1]} шт. ${item[2]}₽';
          String imageUrl = item[3];
          return ListTile(
            leading: Image(image: CachedNetworkImageProvider(imageUrl)),
            title: Text(name),
            subtitle: Text(subtitle),
          );
        }),
  );
}
