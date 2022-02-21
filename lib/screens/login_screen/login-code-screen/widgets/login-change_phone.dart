import 'package:flutter/material.dart';

class ChangePhone extends StatelessWidget {
  const ChangePhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 100 * 5),
      child: TextButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/login-phone',
        ),
        child: Text(
          'Изменить номер телефона',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
