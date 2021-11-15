// Main page

// sys import
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';

// Import screens
import 'package:pizza_dym/screens/about-pizza_screen.dart';
import 'package:pizza_dym/screens/cart_screen.dart';
import 'package:pizza_dym/screens/contacts_screen.dart';
import 'package:pizza_dym/screens/menu_screen/menu_screen.dart';
import 'package:pizza_dym/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth instance
    final _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: false).auth;

    // CloudFirestore instance
    final _firestore =
        Provider.of<CloudFirestore>(context, listen: false).firestore;

    final Stream<QuerySnapshot> _restaurantData =
        _firestore.collection('restaurant').snapshots();

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, '/login-phone');
      }
    });
    return StreamBuilder<QuerySnapshot>(
        stream: _restaurantData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final _restaurantDb = snapshot.data!.docs;
          return DefaultTabController(
            length: _restaurantDb[0].get('categories').length,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _currentIndex > 0
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(200),
                      child: AppBar(
                        toolbarHeight:
                            MediaQuery.of(context).size.height / 100 * 25,
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Image.asset(
                            'assets/img/company-logo.png',
                            width: MediaQuery.of(context).size.width / 100 * 35,
                            height:
                                MediaQuery.of(context).size.height / 100 * 35,
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(180),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TabBar(
                              isScrollable: true,
                              tabs: [
                                for (var categorie
                                    in _restaurantDb[0].get('categories'))
                                  Tab(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text(
                                        '$categorie',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.restaurant_outlined),
                    label: 'Меню',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.business),
                    label: 'О нас',
                  ),
                  BottomNavigationBarItem(
                    icon: Badge(
                      showBadge: true,
                      badgeContent: Text('1'),
                      animationType: BadgeAnimationType.scale,
                      child: Icon(Icons.shopping_bag_outlined),
                    ),
                    label: 'Корзина',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone),
                    label: 'Контакты',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outlined),
                    label: 'Профиль',
                  ),
                ],
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              body: scaffoldBody(),
            ),
          );
        });
  }

  Widget scaffoldBody() {
    if (_currentIndex == 1) {
      return AboutPizzaScreen();
    }
    if (_currentIndex == 2) {
      return CartScreen();
    }
    if (_currentIndex == 3) {
      return ContactsScreen();
    }
    if (_currentIndex == 4) {
      return ProfileScreen();
    }
    return MenuScreen();
  }
}
