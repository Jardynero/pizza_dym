import 'package:flutter/material.dart';
import 'package:pizza_dym/theme/main_theme.dart';

class LoginText extends StatelessWidget {
  const LoginText({Key? key}) : super(key: key);

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
            'Вход',
            style: TextStyle(
              fontSize: MainColorTheme().paragraphFontSize,
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
          child: Text(
            'Введите номер телефона, чтобы войти или зарегистрироваться',
            style: TextStyle(
              fontSize: MainColorTheme().secondaryFontSize,
            ),
          ),
        ),
      ],
    );
  }
}