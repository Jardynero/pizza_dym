// Import screens
import 'package:pizza_dym/screens/about-pizza_screen.dart';
import 'package:pizza_dym/screens/cart_screen/adress_screen.dart';
import 'package:pizza_dym/screens/cart_screen/cart_screen.dart';

import 'package:pizza_dym/screens/cart_screen/delivery-methode_screen.dart';
import 'package:pizza_dym/screens/cart_screen/pickup_screen.dart';
import 'package:pizza_dym/screens/profile/contacts_screen.dart';
import 'package:pizza_dym/screens/index_screen/index_screen.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/login-code_screen.dart';
import 'package:pizza_dym/screens/login_screen/login-phone-screen/login-phone_screen.dart';

// Import models
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/models/customer-data_model.dart';

// Import libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pizza_dym/screens/profile/main_screen.dart';
import 'package:pizza_dym/screens/profile/user-adress_screen.dart';
import 'package:pizza_dym/theme/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

// Import functions
import 'package:pizza_dym/functions/firebase_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CartModel()),
      ChangeNotifierProvider(create: (context) => CustomerData()),
      ChangeNotifierProvider(create: (context) => FirebaseAuthInstance()),
      ChangeNotifierProvider(create: (context) => CloudFirestore()),
    ],
    child: Pizzadym(),
  ));
}

// Main App class
class Pizzadym extends StatefulWidget {
  const Pizzadym({Key? key}) : super(key: key);

  @override
  _PizzadymState createState() => _PizzadymState();
}

class _PizzadymState extends State<Pizzadym> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    initFirebaseMessaging(messaging);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    Provider.of<CloudFirestore>(context, listen: false).obtainRestautantSettings();
    AppTrackingTransparency.requestTrackingAuthorization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: context.read<CustomerData>().name,
      initialRoute: '/',
      routes: {
        '/': (context) => IndexScreen(),
        '/login-phone': (context) => LoginPhoneScreen(),
        '/login-code': (context) => LoginCodeScreen(),
        '/about-pizza': (context) => AboutPizzaScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/cart': (context) => CartScreen(),
        '/delivery-methode': (context) => DeliveryMethode(),
        '/pickup' : (context) => PickupScreen(),
        '/adress' : (context) => AdressScreen(),
        '/profile': (context) => ProfileScreen(),
        '/profile/useradress': (context) => ProfileUserAdressScreen(),
      },
      theme: MainColorTheme().mainTheme,
    );
  }
}
