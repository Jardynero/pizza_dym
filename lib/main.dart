// Import screens
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:pizza_dym/global_widgets/widgets.dart';
import 'package:pizza_dym/screens/about-pizza_screen.dart';
import 'package:pizza_dym/screens/cart_screen/adress_screen.dart';
import 'package:pizza_dym/screens/cart_screen/cart_screen.dart';

import 'package:pizza_dym/screens/cart_screen/delivery-methode_screen.dart';
import 'package:pizza_dym/screens/cart_screen/payment-methode_screen.dart';
import 'package:pizza_dym/screens/cart_screen/pickup_screen.dart';
import 'package:pizza_dym/screens/cart_screen/select-delivery-time.dart';
import 'package:pizza_dym/screens/nav_screen/navigation_screen.dart';
import 'package:pizza_dym/screens/profile/add-item.dart';
import 'package:pizza_dym/screens/profile/contacts_screen.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/login-code_screen.dart';
import 'package:pizza_dym/screens/login_screen/login-phone-screen/login-phone_screen.dart';

// Import models
import 'package:pizza_dym/models/cart_model.dart';
import 'package:pizza_dym/models/customer-data_model.dart';

// Import libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pizza_dym/screens/profile/main_screen.dart';
import 'package:pizza_dym/screens/profile/order-history_screen.dart';
import 'package:pizza_dym/screens/profile/user%20adress/user-adress_screen.dart';
import 'package:pizza_dym/screens/update_screen/update_screen.dart';
import 'package:pizza_dym/theme/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Import functions
import 'package:pizza_dym/functions/firebase_functions.dart';

// cloud messaging
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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

  void fcmOnmessage() async {
    await NotificationApi().foregroundNotifications();
  }
  @override
  void initState() {
    super.initState();
    initFirebaseMessaging(messaging);
    AppTrackingTransparency.requestTrackingAuthorization();
    Analytics().logAppOpen().then(
          (value) => debugPrint('log app open successfully'),
        );
    fcmOnmessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: context.read<CustomerData>().name,
      initialRoute: '/',
      routes: {
        '/': (context) => (NavigationScreen(index: 0,)),
        '/login-phone': (context) => LoginPhoneScreen(),
        '/login-code': (context) => LoginCodeScreen(),
        '/about-pizza': (context) => AboutPizzaScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/cart': (context) => CartScreen(totalAmount: null),
        '/delivery-methode': (context) => DeliveryMethode(),
        '/pickup': (context) => PickupScreen(),
        '/cart/select-delivery-time': (context) => SelectDeliveryTimeScreen(),
        '/cart/payment': (context) => PaymentMethodeScreen(),
        '/adress': (context) => AdressScreen(),
        '/profile': (context) => ProfileScreen(),
        '/order-history': (context) => OrderHistoryScreen(),
        '/profile/adress': (context) => ProfileUserAdressScreen(),
        '/profile/add-item-to-bd': (context) => AddItemToBdScreen(),
        '/update-app': (context) => UpdateAppScreen(),
      },
      theme: MainColorTheme().mainTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [Locale('ru', 'RU')],
    );
  }
}
