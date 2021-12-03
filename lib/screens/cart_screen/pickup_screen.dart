import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
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
  late DateTime chosenTime;

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
        // Container(
        //   margin: EdgeInsets.only(top: 20, bottom: 10),
        //   child: Text(
        //     'Данные о заказе',
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
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
        onPressed: () {
          var cartModel = Provider.of<CartModel>(context, listen: false);
          cartModel.getPickupChosenTime(chosenTime);
          if (onChangedTime == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              reUsableSnackBar(
                  'Пожалуйста, выберите время самовывоза', context),
            );
          } else if (isChoseTimeOk == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              reUsableSnackBar(message, context),
            );
          } else {
            
            
            print('OK!');

            sendOrderToTelegram(sendOrder(context));
            // Оформить заказ
            // Отправить в телегу заказ
            // отправить смс клиенту
            // очистить корзину
            // сохранить закмз в историю заказов
            // попап об успешном заказе
            // переход на главную
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
