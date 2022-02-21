import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppButton extends StatelessWidget {
  UpdateAppButton({Key? key}) : super(key: key);

  final inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () {
          if (Platform.isIOS) {
            launch('https://apps.apple.com/ru/app/%D0%BF%D0%B8%D1%86%D1%86%D0%B0-%D0%B4%D1%8B%D0%BC/id1585336500');
          }
          else if (Platform.isAndroid) {
            launch('https://play.google.com/store/apps/details?id=com.pizzadym.pizzadym');
          }
        },
        child: Text(
          'Обновить приложение',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
