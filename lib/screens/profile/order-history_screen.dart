import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:provider/provider.dart';

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
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return orderItem(data);
          }).toList(),
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
              context: context,
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 100 * 70,
                  child: orderInfo(data, context),
                );
              });
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
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 100 * 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Заказ № $orderNumber от $orderDay $orderMonthName $orderYear',
              style: titleStyle,
            ),
          ],
        ),
      ),
      orderList(data, context),
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

Widget orderList(data, context) {
  Map orderList = data['Состав заказа'];

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 100 * 40,
    child: Container(
      child: ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (BuildContext context, index) {
            List item = orderList['${index + 1}'];
            String name = item[0];
            String subtitle = '${item[1]} шт. ${item[2]}₽';
            String imageUrl = item[3];
            return ListTile(
              leading: Image.network(imageUrl),
              title: Text(name),
              subtitle: Text(subtitle),
            );
          }),
    ),
  );
}
