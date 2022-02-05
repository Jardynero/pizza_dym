// Main page

// sys import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/screens/cart_screen/cart_screen.dart';

// Import screens
import 'package:pizza_dym/screens/menu_screen/menu_screen.dart';
import 'package:pizza_dym/screens/profile/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:pizza_dym/screens/nav_screen/widgets/widgets.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  final List<Widget> _screens = [
      MenuScreen(),
      CartScreen(),
      ProfileScreen(),
    ];

    final List<List> _navBarItems = [
      [Icons.restaurant_outlined, 'Меню'],
      [Icons.shopping_bag, 'Корзина'],
      [Icons.person, 'Профиль']
    ];

    int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth instance
    FirebaseAuth _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: true).auth;

    _auth.setLanguageCode('ru');


    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        items: _navBarItems,
        selectedIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index)
      ),
    );
  }
}
