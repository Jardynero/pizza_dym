import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/snackbar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

// request permission for notifications
Future initFirebaseMessaging(firebaseMessagingInstance) async {
  NotificationSettings settings =
      await firebaseMessagingInstance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');
}


// Firebase AUTH
class FirebaseAuthInstance extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  String _verificationId = '';
  String _userPhoneNumber = '';

  String get getVerificationId => _verificationId;
  String get getUserPhoneNumber => _userPhoneNumber;

  void obtainVerificationId(verificationId) {
    _verificationId = verificationId;
  }

  void obtainUserPhoneNumber(userPhoneNumber) {
    _userPhoneNumber = userPhoneNumber;
  }
}

class CloudFirestore extends ChangeNotifier {
  // Cloud Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Время открытия
  int _openingTime = 0;
  int get openingTime => _openingTime;

  // Время закрытия
  int _closingTime = 0;
  int get closingTime => _closingTime;

  // Принимаем ли сейчас заказы
  bool _isOpen = true;
  bool get isOpen => _isOpen;

  // Дни недели
  Map _workingDays = {};
  Map get workingDays => _workingDays;

  int _minDeliveryOrderPrice = 0;
  int get minDeliveryOrderPrice => _minDeliveryOrderPrice;

  String _lastPageBeforeLogin = '';
  String get lastPageBeforeLogin => _lastPageBeforeLogin;

  void saveLastPageBeforeLogin(String route) {
    _lastPageBeforeLogin = route;
  }

  // ПЕРЕМЕННЫЕ АКЦИИ СЧАСТЛИВЫЕ ЧАСЫ //
  bool _happyHours = true;
  bool get happyHours => _happyHours;

  int _happyHoursStartHour = 12;
  int get happyHoursStartHour => _happyHoursStartHour;

  int _happyHoursEndHour = 17;
  int get happyHoursEndHour => _happyHoursEndHour;

  Map _happyHoursDays = {};
  Map get happyHoursDays => _happyHoursDays;
  // ПЕРЕМЕННЫЕ АКЦИИ СЧАСТЛИВЫЕ ЧАСЫ //

  Future<void> obtainRestautantSettings() async {
    DocumentReference docReference =
        firestore.collection('restaurant').doc('settings');

    var docInstance = await docReference.get();

    int openTime = docInstance.get('openingTime');
    _openingTime = openTime;

    int closingTime = docInstance.get('closingTime');
    _closingTime = closingTime;

    bool isOpen = docInstance.get('isOpen');
    _isOpen = isOpen;

    Map workingDays = docInstance.get('workingDays');
    _workingDays = workingDays;

    int minDeliveryOrderPrice = docInstance.get('minDeliveryOrderPrice');
    _minDeliveryOrderPrice = minDeliveryOrderPrice;

    // НАСТРОЙКИ АКЦИИ СЧАСТЛИВЫЕ ЧАСЫ //

    bool happyHours = docInstance.get('happyHours');
    int happyHoursStartHour = docInstance.get('happyHoursStartHour');
    int happyHoursEndHour = docInstance.get('happyHoursEndHour');
    Map happyHoursDays = docInstance.get('HappyHoursDays');

    _happyHours = happyHours;
    _happyHoursStartHour = happyHoursStartHour;
    _happyHoursEndHour = happyHoursEndHour;
    _happyHoursDays = happyHoursDays;
    
    // НАСТРОЙКИ АКЦИИ СЧАСТЛИВЫЕ ЧАСЫ //

    notifyListeners();
  }

  Future isRestaurantOpen(context) async {
    DocumentReference docReference =
        firestore.collection('restaurant').doc('settings');

    var docInstance = await docReference.get();
    bool isOpen = docInstance.get('isOpen');
    Map<String, dynamic> workingDays = docInstance.get('workingDays');
    int openingTime = docInstance.get('openingTime');
    int closingTime = docInstance.get('closingTime');
    int timeNowHour = DateTime.now().hour;
    int weekdayToday = DateTime.now().weekday;

    workingDays.forEach((key, value) {
      if (weekdayToday.toString() == key && value == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          reUsableSnackBar(
            'Извините, сегодня у нас выходной, но можно заказать на другой день!',
            context,
          ),
        );
      }
    });
    if (isOpen == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        reUsableSnackBar(
          'Сегодня мы больше не принимаем заказы, но можно заказать на другой день!',
          context,
        ),
      );
    } else if (timeNowHour < openingTime) {
      ScaffoldMessenger.of(context).showSnackBar(
        reUsableSnackBar(
          'Сейчас мы еще закрыты, но оформить заказ можно!',
          context,
        ),
      );
    } else if (timeNowHour >= closingTime) {
      ScaffoldMessenger.of(context).showSnackBar(
        reUsableSnackBar(
          'Сейчас мы уже закрыты, но можно оформить заказ на другой день!',
          context,
        ),
      );
    }
  }
}

Future<void> getUserAdress(context) async {
  DocumentReference _currentUser = FirebaseFirestore.instance
      .collection('users')
      .doc(
          '${Provider.of<FirebaseAuthInstance>(context, listen: false).auth.currentUser!.phoneNumber}');
  _currentUser.get().then((value) {
    if (value.exists) {
      try {
        String userStreet = value.get('Улица');
        String userHouse = value.get('Дом');
        String userBlock = value.get('Корпус');
        String userEntrance = value.get('Подъезд');
        String userAppartment = value.get('Квартира');
        String userIntercom = value.get('Домофон');
        String userFloor = value.get('Этаж');
        String fullAdress = value.get('Полный адрес');
        String deliveryGeo = value.get('Координаты доставки');
        String userName = value.get('Имя');
        Provider.of<CartModel>(context, listen: false).getUserAdressData(
            userStreet,
            userHouse,
            userBlock,
            userEntrance,
            userAppartment,
            userIntercom,
            userFloor,
            fullAdress,
            deliveryGeo,);
        Provider.of<CartModel>(context, listen:false).getUserName(userName);
      } catch (e) {
        debugPrint('$e');
      }
    }
  });
}
