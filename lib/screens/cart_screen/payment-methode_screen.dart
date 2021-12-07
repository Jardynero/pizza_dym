import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/app-review.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/cart_screen/order_func.dart';
import 'package:provider/provider.dart';

class PaymentMethodeScreen extends StatefulWidget {
  PaymentMethodeScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodeScreenState createState() => _PaymentMethodeScreenState();
}

class _PaymentMethodeScreenState extends State<PaymentMethodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _cashController = TextEditingController();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  int? _groupValue = 1;
  int _payByCardUponReciept = 1;
  int _payByCash = 2;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MainAppBar('Метод оплаты'),
        body: _main(),
      ),
    );
  }

  Widget _main() {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              paymentMethodes(),
              btn(),
            ],
          ),
        )
      ],
    );
  }

  Widget paymentMethodes() {
    return Column(
      children: [
        paymentMethode(
          'Картой курьеру',
          _payByCardUponReciept,
          'assets/icons/payByCard.png',
        ),
        paymentMethode(
          'Наличными курьеру',
          _payByCash,
          'assets/icons/payByCash.png',
        ),
        Visibility(
          visible: _groupValue == 2 ? true : false,
          child: cashFieldAndSubtitle(),
        )
      ],
    );
  }

  Widget cashSubtitle() {
    return Align(
      alignment: Alignment.center,
      child: Text('С какой суммы понадобится сдача?'),
    );
  }

  Widget cashField() {
    double totalAmount =
        Provider.of<CartModel>(context, listen: false).cart.getTotalAmount();
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 100 * 80,
        child: TextFormField(
          controller: _cashController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (_groupValue == 2) {
              if (value == null || value.isEmpty) {
                return 'Укажите с какой суммы нужна сдача!';
              }
              int _inputValue = int.parse(value);
              if (_inputValue < totalAmount.toInt()) {
                return 'Число не может быть меньше ${totalAmount.toInt()}';
              }
            }
          },
          onChanged: (value) {
            setState(() {
              _cashController.value = TextEditingValue(
                text: value,
                selection: TextSelection(
                  baseOffset: value.length,
                  extentOffset: value.length,
                ),
              );
            });
          },
          decoration: fieldTheme('Сдача'),
        ),
      ),
    );
  }

  Widget cashFieldAndSubtitle() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30, bottom: 10),
          child: cashSubtitle(),
        ),
        cashField(),
      ],
    );
  }

  InputDecoration fieldTheme(label) {
    double totalAmount =
        Provider.of<CartModel>(context, listen: false).cart.getTotalAmount();
    return InputDecoration(
      label: Text('$label'),
      labelStyle: TextStyle(fontSize: 14),
      isDense: true,
      hintText: 'Стоимость вашего заказк: ${totalAmount.toInt()}₽',
      contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
      floatingLabelStyle: TextStyle(
        color: Color(0xffFF9F38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Color(0xffFF9F38),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Color(0xffC4C4C4),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget paymentMethode(title, int value, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _groupValue = value;
          _cashController.text = '';
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
                  horizontalTitleGap: 40,
                  leading: Image.asset('$iconPath', width: 35, height: 35),
                  // leading: iconPath,
                  trailing: Radio(
                    value: value,
                    groupValue: _groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        _groupValue = value;
                        _cashController.text = '';
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
    var cartModel = Provider.of<CartModel>(context, listen: false);
    double totalAmount = cartModel.cart.getTotalAmount();
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 5),
      child: ElevatedButton(
        child: Text(
          'ОФОРМИТЬ ЗАКАЗ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onPressed: () async{
          cartModel.getPaymentMethode(_groupValue!);
          if (_groupValue == 1) {
            debugPrint('Оплата банковской картой при получение!');
            cartModel.saveOrderToHistory(context);
            sendOrderToTelegram(sendOrder(context));
            sendGeoToTelegram(geo(context));
            cartModel.sendNewOrderNumber();
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            showOrderConfirmation(context)
                .then((value) => cartModel.cart.deleteAllCart()).then((value) => reviewApp());
          } else if (_groupValue == 2) {
            if (_formKey.currentState!.validate()) {
              debugPrint('Оплата наличными');
              cartModel.getChangeFrom(_cashController.text);
              cartModel.saveOrderToHistory(context);
              sendOrderToTelegram(sendOrder(context));
              sendGeoToTelegram(geo(context));
              cartModel.sendNewOrderNumber();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              showOrderConfirmation(context)
                  .then((value) => cartModel.cart.deleteAllCart()).then((value) => reviewApp());
            }
          }
          await analytics.logEcommercePurchase(currency: 'RUB', value: totalAmount);
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
