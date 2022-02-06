// Main page

// sys import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/screens/cart_screen/cart_screen.dart';

// Import screens
import 'package:pizza_dym/screens/menu_screen/menu_screen.dart';
import 'package:pizza_dym/screens/profile/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:pizza_dym/screens/nav_screen/widgets/widgets.dart';
import 'package:update_available/update_available.dart';

class NavigationScreen extends StatefulWidget {
  NavigationScreen({Key? key}) : super(key: key);
  final FlutterCart cart = FlutterCart();

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> _screens() {
    return [MenuScreen(),
    CartScreen(totalAmount: widget.cart.getTotalAmount().toInt(),),
    ProfileScreen(),];
  }

  final List<List> _navBarItems = [
    [Icons.restaurant_outlined, 'Меню'],
    [Icons.shopping_bag, 'Корзина'],
    [Icons.person, 'Профиль']
  ];

  int _currentIndex = 0;

  void updateApp() async {
    final updateAvailability = await getUpdateAvailability();

    updateAvailability.fold(
      available: () => Navigator.pushNamedAndRemoveUntil(
          context, '/update-app', (route) => false),
      notAvailable: () {
        debugPrint('No new update for this app');
      },
      unknown: () {
        debugPrint('check for app update result: unknow');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateApp();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth instance
    FirebaseAuth _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: true).auth;

    _auth.setLanguageCode('ru');

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens()),
      bottomNavigationBar: BottomNavBar(
          items: _navBarItems,
          selectedIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index)),
    );
  }
}
