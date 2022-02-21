import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/global_widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:im_stepper/stepper.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('История заказов'),
      body: _main(),
    );
  }

  Widget _main() {
    String userPhoneNumber =
        Provider.of<FirebaseAuthInstance>(context, listen: false)
            .auth
            .currentUser!
            .phoneNumber!;

    final Stream<QuerySnapshot> userOrders = FirebaseFirestore.instance
        .collection('users')
        .doc('$userPhoneNumber')
        .collection('orders')
        .orderBy('Дата заказа', descending: true)
        .snapshots();

    return StreamBuilder(
      stream: userOrders,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
                'Произошла ошибка, попробуйте перезагрузить приложение и попробовать снова!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs.map(
            (DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return orderItem(data);
            },
          ).toList(),
        );
      },
    );
  }

  Widget orderItem(data) {
    int sum = data['Сумма заказа'];
    int orderNumber = data['Номер заказа'];
    Timestamp orderTimestamp = data['Дата заказа'];
    DateTime orderDt = orderTimestamp.toDate();
    int orderHour = orderDt.hour;
    dynamic orderMinute = orderDt.minute;
    int orderDay = orderDt.day;
    int orderMonth = orderDt.month;
    int orderYear = orderDt.year;
    String orderMonthName = monthName(orderMonth);
    if (orderMinute < 10) {
      orderMinute = '0$orderMinute';
    }
    TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    TextStyle orderDateStyle = TextStyle(color: Colors.grey, fontSize: 14);
    TextStyle subtitle = TextStyle(color: Colors.black);
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return orderInfo(data, context);
            },
          );
        },
        child: Card(
          child: ListTile(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        '$orderHour:$orderMinute $orderDay $orderMonthName $orderYear\n',
                    style: orderDateStyle,
                  ),
                  TextSpan(text: 'Заказ №$orderNumber', style: titleStyle),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text('$sum ₽', style: subtitle),
            ),
            trailing: Icon(Icons.arrow_right_outlined),
          ),
        ),
      );
    });
  }
}

String monthName(monthInt) {
  String result = '';
  Map<int, String> month = {
    1: 'января',
    2: 'февраля',
    3: 'марта',
    4: 'апреля',
    5: 'мая',
    6: 'июня',
    7: 'июля',
    8: 'августа',
    9: 'сентября',
    10: 'октября',
    11: 'ноября',
    12: 'декабря',
  };

  month.forEach((key, value) {
    if (key == monthInt) {
      result = value;
    }
  });
  return result;
}

Widget orderInfo(data, context) {
  int sum = data['Сумма заказа'];
  int orderNumber = data['Номер заказа'];
  Timestamp orderTimestamp = data['Дата заказа'];
  DateTime orderDt = orderTimestamp.toDate();
  int orderDay = orderDt.day;
  int orderMonth = orderDt.month;
  int orderYear = orderDt.year;
  String orderMonthName = monthName(orderMonth);
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Заказ № $orderNumber от $orderDay $orderMonthName $orderYear',
              style: titleStyle,
            ),
          ),
          OrderStapIndicator(data: data),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Состав заказа',
              style: titleStyle,
            ),
          ),
          orderList(data, context),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
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
        ],
      ),
    ),
  );
}

TextStyle titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle totalStyle = TextStyle(fontSize: 16, color: Colors.grey);
TextStyle sumStyle =
    TextStyle(fontSize: 34, color: Colors.black, fontWeight: FontWeight.bold);

Widget orderList(data, context) {
  Map orderList = data['Состав заказа'];

  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: orderList.length,
    itemBuilder: (BuildContext context, index) {
      List item = orderList['${index + 1}'];
      String name = item[0];
      String subtitle = '${item[1]} шт. ${item[2]}₽';
      String imageUrl = item[3];
      return ListTile(
        leading: Image(
          image: CachedNetworkImageProvider(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(subtitle),
      );
    },
  );
}

class OrderStapIndicator extends StatefulWidget {
  final data;
  OrderStapIndicator({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderStapIndicator> createState() => _OrderStapIndicatorState();
}

class _OrderStapIndicatorState extends State<OrderStapIndicator> {
  int _activeStep = 0;
  final List<ImageProvider<dynamic>> images = [
    AssetImage('assets/img/company-logo black.png'),
    AssetImage('assets/img/pizzadym abous us 4.png'),
    AssetImage('assets/img/photo_2022-02-21 19.15.37.jpeg'),
    AssetImage('assets/img/photo_2022-02-21 19.22.58.jpeg'),
  ];

  final List<Icon> icons = [
    Icon(Icons.check_circle),
    Icon(Icons.local_pizza_outlined),
    Icon(Icons.local_shipping_outlined),
    Icon(Icons.sports_score_outlined),
  ];

  final String? phone = FirebaseAuth.instance.currentUser!.phoneNumber;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(phone)
        .collection('orders')
        .doc('${widget.data['Номер заказа']}')
        .snapshots()
        .listen((event) {
      setState(() {
        _activeStep = event.get('Статус заказа');
      });
    });
    return Column(
      children: [
        SizedBox(
          height: 16.0,
        ),
        Text('Статус заказа',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        IconStepper(
          activeStep: _activeStep,
          icons: icons,
          enableNextPreviousButtons: false,
          enableStepTapping: false,
          scrollingDisabled: true,
          stepColor: Colors.grey[400],
          activeStepColor: Colors.green,
          activeStepBorderColor: Colors.green,
          activeStepBorderPadding: 3,
          activeStepBorderWidth: 3,
          lineColor: Colors.grey,
        ),
      ],
    );
  }
}
