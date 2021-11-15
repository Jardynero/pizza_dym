import 'package:flutter/material.dart';

class MenuTabBarViev extends StatelessWidget {
  const MenuTabBarViev({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: TabBarView(
        children: [
          Center(child: Text('data')),
          Center(child: Text('data')),
        ]
      ),
    );
  }
}