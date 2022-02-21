import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final List<List> items;
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterCart cart = Provider.of<CartModel>(context, listen: true).cart;
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: items
          .map(
            (e) => BottomNavigationBarItem(
              icon: e[1] == 'Корзина' && cart.getCartItemCount() != 0
                  ? Badge(
                      badgeContent: Text(
                        '${cart.getCartItemCount()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(e[0]),
                    )
                  : Icon(e[0]),
              label: e[1],
            ),
          )
          .toList(),
    );
  }
}
