import 'package:flutter/material.dart';

SnackBar reUsableSnackBar(message, context) {
  return SnackBar(
      content: Text('$message'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 5),
      action: SnackBarAction(
        label: 'Закрыть',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
}
