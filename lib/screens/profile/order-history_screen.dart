import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('История заказов'),
    );
  }
}