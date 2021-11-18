// About pizza page

import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';

class AboutPizzaScreen extends StatelessWidget {
  const AboutPizzaScreen({Key? key}) : super(key: key);

  final String _title = 'О нас';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('$_title'),
      body: Center(child: Text('О нас'),)
    );
  }
}
