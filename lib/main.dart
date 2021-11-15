// Import screens
import 'package:pizza_dym/screens/about-pizza_screen.dart';
import 'package:pizza_dym/screens/cart_screen.dart';
import 'package:pizza_dym/screens/ckeckout_screen.dart';
import 'package:pizza_dym/screens/contacts_screen.dart';
import 'package:pizza_dym/screens/index_screen/index_screen.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/login-code_screen.dart';
import 'package:pizza_dym/screens/login_screen/login-phone-screen/login-phone_screen.dart';
import 'package:pizza_dym/screens/single-product_screen.dart';

// Import models
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/models/customer-data_model.dart';

// Import libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pizza_dym/theme/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.read<CustomerData>().name,
      initialRoute: '/',
      routes: {
        '/': (context) => IndexScreen(),
        '/login-phone': (context) => LoginPhoneScreen(),
        '/login-code': (context) => LoginCodeScreen(),
        '/about-pizza': (context) => AboutPizzaScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/single-product': (context) => SingleProductScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutScreen(),
      },
      theme: MainColorTheme().mainTheme,
    );
  }
}
