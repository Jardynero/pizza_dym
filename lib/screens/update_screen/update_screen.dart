import 'package:flutter/material.dart';
import 'package:pizza_dym/screens/update_screen/widgets/widgets.dart';


class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  String text = 'Нажать что бы проверить';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: UpdateAppBar(),
      body: Column(
        children: [
          TextCard(),
          UpdateAppButton(),
        ],
      ),
    );
  }
}
