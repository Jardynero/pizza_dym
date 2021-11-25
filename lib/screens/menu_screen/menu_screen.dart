import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/screens/menu_screen/widgets/cardCategories.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    CloudFirestore().isRestaurantOpen(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CardCategories();
  }
}
