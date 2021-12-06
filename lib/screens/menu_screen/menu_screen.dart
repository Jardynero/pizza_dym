import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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
    AppTrackingTransparency.requestTrackingAuthorization();
    Provider.of<CloudFirestore>(context, listen: false)
        .obtainRestautantSettings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CardCategories();
  }
}
