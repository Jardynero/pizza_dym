// Profile page
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/global_widgets/widgets.dart';
import 'package:pizza_dym/screens/login_screen/login-phone-screen/login-phone_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _title = 'Профиль';
  final InAppReview inAppReview = InAppReview.instance;

  late final _auth =
      Provider.of<FirebaseAuthInstance>(context, listen: false).auth;

  @override
  Widget build(BuildContext context) {
    var _firestoreModel = Provider.of<CloudFirestore>(context, listen: false);

    if (_auth.currentUser != null) {
      return Scaffold(
        appBar: MenuAppBar(_title),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _main(),
            btn(),
          ],
        ),
      );
    }
    _firestoreModel.saveLastPageBeforeLogin('/profile');
    return LoginPhoneScreen();
  }

  Widget _main() {
    String currentUserPhoneNumber =
        Provider.of<FirebaseAuthInstance>(context, listen: false)
            .auth
            .currentUser!
            .phoneNumber!;
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          menuItem(
            'О пиццерии Дым',
            'assets/img/pizzadym AppIcon.png',
            '/about-pizza',
          ),
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
          requestReview(),
          menuItemUrl('Наш сайт', 'assets/icons/icons8-домен-100.png',
              'https://pizzadym.ru'),
          menuItemUrl('Наш Инстаграм', 'assets/icons/icons8-instagram-384.png',
              'https://instagram.com/pizzadym'),
          menuItemUrl('Мы на Я.Картах', 'assets/icons/icons8-маркер-96.png',
              'https://yandex.ru/maps/-/CCUujWtlsA'),
          if (currentUserPhoneNumber == '+79164164179')
            menuItem(
              'Добавить товар',
              'assets/icons/add.png',
              '/profile/add-item-to-bd',
            ),
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

  Widget requestReview() {
    return GestureDetector(
      onTap: () => inAppReview.openStoreListing(appStoreId: '1585336500'),
      child: Container(
        height: 80,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  'Оценить пиццу',
                  style: TextStyle(
                    color: Color(0xff27282A),
                    fontSize: 16,
                  ),
                ),
                horizontalTitleGap: 50,
                leading: Icon(Icons.reviews_outlined, size: 40),
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
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        child: Text(
          'ВЫЙТИ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          await _auth.signOut().then((value) =>
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false));
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xff27282A),
          fixedSize: Size(
            MediaQuery.of(context).size.width / 100 * 80,
            MediaQuery.of(context).size.height / 100 * 6,
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
