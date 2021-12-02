// Profile page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/screens/profile/user%20adress/user-adress_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _title = 'Профиль';
  late final _auth =
      Provider.of<FirebaseAuthInstance>(context, listen: false).auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(_title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _main(),
          btn(),
        ],
      ),
    );
  }

  Widget _main() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 100 * 70,
      child: ListView(
        children: [
          menuItem(
            'Адрес доставки',
            'assets/icons/icons8-доставка-пиццы-100.png',
            '/profile/adress',
          ),
          menuItem(
            'История заказов',
            'assets/icons/icons8-заказ-на-покупку-100.png',
            '/order-history',
          ),
          menuItemUrl('Наш сайт', 'assets/icons/icons8-домен-100.png',
              'https://pizzadym.ru'),
          menuItemUrl('Наш Инстаграм', 'assets/icons/icons8-instagram-384.png',
              'https://instagram.com/pizzadym'),
          menuItemUrl('Мы на Я.Картах', 'assets/icons/icons8-маркер-96.png',
              'https://yandex.ru/maps/-/CCUujWtlsA'),
          
        ],
      ),
    );
  }

  Widget menuItem(title, String iconPath, dynamic route) {
    return GestureDetector(
      onTap: () {
        if (route == '/profile/adress') {
          getUserAdress(context);
        }
        Navigator.pushNamed(context, route);
      },
      child: Container(
        height: 80,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff27282A),
                    fontSize: 16,
                  ),
                ),
                horizontalTitleGap: 50,
                leading: Image.asset(iconPath, width: 40, height: 40),
                trailing: Icon(Icons.arrow_right_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItemUrl(title, String iconPath, String route) {
    return GestureDetector(
      onTap: () => launchUrl(route),
      child: Container(
        height: 80,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff27282A),
                    fontSize: 16,
                  ),
                ),
                horizontalTitleGap: 50,
                leading: Image.asset(iconPath, width: 40, height: 40),
                trailing: Icon(Icons.arrow_right_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btn() {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100 * 5),
      child: ElevatedButton(
        child: Text(
          'ВЫЙТИ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => _auth.signOut(),
        style: ElevatedButton.styleFrom(
          primary: Color(0xff27282A),
          fixedSize: Size(
            MediaQuery.of(context).size.width / 100 * 80,
            MediaQuery.of(context).size.height / 100 * 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void launchUrl(String url) async {
    await launch(url);
  }
}
