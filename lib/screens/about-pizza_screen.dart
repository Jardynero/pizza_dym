// About pizza page

import 'package:flutter/cupertino.dart';

class AboutPizzaScreen extends StatelessWidget {
  const AboutPizzaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Text('Страница о нас'),
      ),
    );
  }
}
