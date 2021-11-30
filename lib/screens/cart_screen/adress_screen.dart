import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';

class AdressScreen extends StatelessWidget {
  const AdressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('Доставка на дом')
    );
  }
}