import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/app-review.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/global_widgets/notification_api.dart';
import 'package:pizza_dym/global_widgets/snackbar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/cart_screen/order_func.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class PickupScreen extends StatefulWidget {
  PickupScreen({Key? key}) : super(key: key);

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  String dayOf = '';
  bool isChoseTimeOk = true;
  bool onChangedTime = false;
  int maxPickupMinutes = 20;
  int interval = 15;
  String message = '';
  String soonTimeMessage = '';
  DateTime chosenTime = DateTime.now();
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context, {locale: const Locale('ru', 'RU')}) {
    return Scaffold(
      appBar: MainAppBar('Самовывоз'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          dateTimePicker(),
          btn(),
        ],
      ),
    );
  }

  Widget title() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 20),
            child: Text('Выберите время самовывоза')),
        soonTime(),
      ],
    );
  }

  Widget soonTime() {
    int closingTime =
        Provider.of<CloudFirestore>(context, listen: true).closingTime;
    int openingTime =
        Provider.of<CloudFirestore>(context, listen: true).openingTime;
    return Text(
        'Забрать заказ можно с $openingTime:$interval до $closingTime:$interval');
  }

  Widget dateTimePicker() {
    return Column(
      children: [title(), dateTimeWidget()],
    );
  }

  Widget dateTimeWidget() {
    int closingTime =
        Provider.of<CloudFirestore>(context, listen: true).closingTime;
    int openingTime =
        Provider.of<CloudFirestore>(context, listen: true).openingTime;
    bool isOpen = Provider.of<CloudFirestore>(context, listen: true).isOpen;
    Map workingDays =
        Provider.of<CloudFirestore>(context, listen: true).workingDays;

    DateTime initialDateTime = DateTime.now().add(
      Duration(minutes: interval),
    );
    // Самый ранний самовывоз
    firstPickup(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, openingTime, interval);
    }

    // Самый поздний самовывоз
    finalPickup(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, closingTime, interval);
    }

    // сегодня рабочий день?
    workingDays.forEach((key, value) {
      if (value == false) {
        setState(() {
          dayOf = key;
        });
      }
    });

    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        minimumDate: DateTime.now(),
        initialDateTime: initialDateTime,
        use24hFormat: true,
        onDateTimeChanged: (DateTime dt) {
          setState(() {
            chosenTime = dt;
          });
          if (dt.weekday.toString() == dayOf) {
            setState(() {
              message =
                  'В этот день мы не работаем, оформить заказ на сегодня нельзя!';
              isChoseTimeOk = false;
              onChangedTime = true;
            });
          } else if (dt.day == DateTime.now().day && isOpen == false) {
            setState(() {
              message = 'Извините, на сегодня мы больше не принимаем заказов!';
              isChoseTimeOk = false;
              onChangedTime = true;
            });
          } else if (dt.isBefore(firstPickup(dt))) {
            setState(() {
              message =
                  'В выбранное время мы еще закрыты! Ближайшее доступное время ${firstPickup(dt).hour}:${firstPickup(dt).minute}';
              isChoseTimeOk = false;
              onChangedTime = true;
            });
          } else if (dt.isAfter(finalPickup(dt))) {
            setState(() {
              message =
                  'В выбранное время мы уже закрыты! Последний самовывоз возможен в ${finalPickup(dt).hour}:${finalPickup(dt).minute}';
              isChoseTimeOk = false;
              onChangedTime = true;
            });
          } else if (dt.difference(initialDateTime).inMinutes < 0) {
            setState(() {
              message =
                  'Так быстро мы не успеем приготовить ваш заказ! Ближайшее время самовывоза ${initialDateTime.hour}:${initialDateTime.minute}';
              isChoseTimeOk = false;
              onChangedTime = true;
            });
          } else {
            setState(() {
              isChoseTimeOk = true;
              onChangedTime = true;
              message = '';
            });
          }
        },
      ),
    );
  }

  Widget btn() {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 5),
      child: ElevatedButton(
        child: Text('ОФОРМИТЬ ЗАКАЗ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        onPressed: () async {
          var cartModel = Provider.of<CartModel>(context, listen: false);
          double totalAmount = cartModel.cart.getTotalAmount();
          cartModel.getPickupChosenTime(chosenTime);
          if (onChangedTime == false) {
            ScaffoldMessenger.of(context).showSnackBar(reUsableSnackBar(
                'Пожалуйста, выберите время самовывоза', context));
          } else if (isChoseTimeOk == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              reUsableSnackBar(message, context),
            );
          } else {
            cartModel.saveOrderToHistory(context);
            sendOrderToTelegram(sendOrder(context));
            sendGeoToTelegram(geo(context));
            cartModel.sendNewOrderNumber();
            await NotificationApi.showNotification(
                title: 'Пицца Дым',
                body: 'Спасибо за заказ🍕 Через 5 минут пришлем смс-ку с подтверждением заказа!',
                payload: 'pizza dym'
              );
            await FirebaseAnalytics()
                .logEcommercePurchase(currency: 'RUB', value: totalAmount)
                .then((value) =>
                    debugPrint('Google analytics: Log:Event (e-commerce)'));
            showOrderConfirmation(context)
                .then((value) => cartModel.cart.deleteAllCart())
                .then((value) => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false)).then((value) => reviewApp());
            debugPrint('Заказ на самовывоз оформлен');

            // Оформить заказ
            // Отправить в телегу заказ (готово)
            // отправить смс клиенту
            // очистить корзину (готово)
            // сохранить заказ в историю заказов (готово)
            // попап об успешном заказе (готово)
            // переход на главную (готово)
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xff27282A),
          fixedSize: Size(
            MediaQuery.of(context).size.width / 100 * 80,
            MediaQuery.of(context).size.height / 100 * 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
