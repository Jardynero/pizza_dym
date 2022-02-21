import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:provider/provider.dart';

class LoginCodeText extends StatelessWidget {
  const LoginCodeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // text widget
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 100 * 1.5,
            bottom: MediaQuery.of(context).size.height / 100 * 3,
          ),
          child: Text(
            'Подтверждение телефона',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 100 * 7,
            right: MediaQuery.of(context).size.width / 100 * 7,
            bottom: MediaQuery.of(context).size.height / 100 * 3,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  'На номер ${context.watch<FirebaseAuthInstance>().getUserPhoneNumber} отправлено СМС с кодом',
                ),
              ),
              Text(
                'Телефон важен, чтобы курьер мог с вами связаться',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
