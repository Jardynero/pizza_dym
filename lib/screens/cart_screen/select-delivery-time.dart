import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/global_widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class SelectDeliveryTimeScreen extends StatefulWidget {
  SelectDeliveryTimeScreen({Key? key}) : super(key: key);

  @override
  _SelectDeliveryTimeScreenState createState() =>
      _SelectDeliveryTimeScreenState();
}

class _SelectDeliveryTimeScreenState extends State<SelectDeliveryTimeScreen> {
  int? _groupValue = 1;
  int _asSoonAsPossible = 1;
  bool _asSoonAsPossibleAvailable = true;
  int _onTime = 2;
  String dayOf = '';
  bool isChoseTimeOk = true;
  bool onChangedTime = false;
  int maxPickupMinutes = 20;
  int interval = 60;
  String message = '';
  String soonTimeMessage = '';
  @override
  void initState() {
    super.initState();
    checkAsSoonAsPossibleAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Время доставки'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _main(),
          btn(),
        ],
      ),
    );
  }

  Widget title() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              'Данные о заказе',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text('Выберите время доставки'),
        ],
      ),
    );
  }

  Widget deliveryMethode(title, int value, Icon iconPath, subtitle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _groupValue = value;
        });
      },
      child: Container(
        height: 80,
        child: Center(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      color: Color(0xff27282A),
                      fontSize: 16,
                    ),
                  ),
                  horizontalTitleGap: 16,
                  // leading: Image.asset('$iconPath', width: 40, height: 40),
                  leading: iconPath,
                  subtitle: Text('$subtitle'),
                  trailing: Radio(
                    value: value,
                    groupValue: _groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        _groupValue = value;
                      });
                    },
                    activeColor: Color(0xffFF9F38),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btn() {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 5),
      child: ElevatedButton(
        child: Text(
          _groupValue == _asSoonAsPossible &&
                  _asSoonAsPossibleAvailable == false
              ? 'МЫ ЗАКРЫТЫ'
              : 'ПРОДОЛЖИТЬ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onPressed: _groupValue == _asSoonAsPossible &&
                _asSoonAsPossibleAvailable == false
            ? null
            : () {
                if (_groupValue == _asSoonAsPossible) {
                  Navigator.pushNamed(context, '/cart/payment');
                } else if (_groupValue == _onTime) {
                  if (onChangedTime == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      reUsableSnackBar(
                          'Пожалуйста, выберите время доставки', context),
                    );
                  } else if (isChoseTimeOk == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      reUsableSnackBar(message, context),
                    );
                  } else {
                    print('OK!');
                    Navigator.pushNamed(context, '/cart/payment');
                  }
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

  Widget dateTimeWidget() {
    int closingTime =
        Provider.of<CloudFirestore>(context, listen: true).closingTime;
    int openingTime =
        Provider.of<CloudFirestore>(context, listen: true).openingTime;
    bool isOpen = Provider.of<CloudFirestore>(context, listen: true).isOpen;
    Map workingDays =
        Provider.of<CloudFirestore>(context, listen: true).workingDays;

    DateTime initialDateTime = DateTime.now().add(
      Duration(minutes: interval - DateTime.now().minute % 30),
    );
    // Самая ранняя доставка
    firstPickup(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, openingTime, 30);
    }

    // Самый поздняя доставка
    finalPickup(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, closingTime - 1, 45);
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
      height: 220,
      width: MediaQuery.of(context).size.width,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        minimumDate: DateTime.now(),
        minuteInterval: 30,
        initialDateTime: initialDateTime,
        use24hFormat: true,
        onDateTimeChanged: (DateTime dt) {
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
                  'В выбранное время мы уже закрыты! Последний заказ можем доставить в ${finalPickup(dt).hour}:${finalPickup(dt).minute}';
              isChoseTimeOk = false;
              onChangedTime = true;
            });
          } else if (dt.difference(initialDateTime).inMinutes < 0) {
            setState(() {
              message =
                  'Так быстро мы не успеем приготовить ваш заказ! Ближайшее время доставки ${initialDateTime.hour}:${initialDateTime.minute}';
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

  Widget _main() {
    return Column(
      children: [
        deliveryMethode(
            'Как можно скорее',
            _asSoonAsPossible,
            Icon(Icons.sixty_fps_outlined, size: 40),
            'Привезем в течение 60 минут. Точнее время пришлем в смс'),
        deliveryMethode(
            'Доставка ко времени',
            _onTime,
            Icon(Icons.schedule_outlined, size: 40),
            'Привезем ко времени с интервалом в 30 минут'),
        Visibility(
          visible: _groupValue == _onTime ? true : false,
          child: dateTimeWidget(),
        )
      ],
    );
  }

  void checkAsSoonAsPossibleAvailable() {
    Future.delayed(Duration(milliseconds: 500));
    DateTime dt = DateTime.now();
    int closingTime =
        Provider.of<CloudFirestore>(context, listen: false).closingTime;
    int openingTime =
        Provider.of<CloudFirestore>(context, listen: false).openingTime;
    bool isOpen = Provider.of<CloudFirestore>(context, listen: false).isOpen;
    Map workingDays =
        Provider.of<CloudFirestore>(context, listen: false).workingDays;

    // Самая ранняя доставка
    firstPickup(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, openingTime, 30);
    }

    // Самый поздняя доставка
    finalPickup(DateTime dt) {
      return DateTime(dt.year, dt.month, dt.day, closingTime - 1, 45);
    }

    // сегодня рабочий день?
    workingDays.forEach((key, value) {
      if (value == false) {
        setState(() {
          dayOf = key;
        });
      }
    });
    if (dt.weekday.toString() == dayOf || isOpen == false) {
      setState(() {
        _asSoonAsPossibleAvailable = false;
      });
    } else if (dt.isBefore(firstPickup(dt)) || dt.isAfter(finalPickup(dt))) {
      setState(() {
        _asSoonAsPossibleAvailable = false;
      });
    }
  }

  @override
  void dispose() {
    _asSoonAsPossibleAvailable = true;
    super.dispose();
  }
}
