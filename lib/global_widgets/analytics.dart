import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/rendering.dart';

class Analytics {
  // String itemName;
  // String itemCategory;
  final String currency = 'RUB';
  // String itemId;
  // double price;
  // double totalAmount;
  // int quantity;

  static final facebookAppEvents = FacebookAppEvents();
  static final googleAnalytics = FirebaseAnalytics();

  Future logAppOpen() async {
    await facebookAppEvents.logEvent(name: 'App Open').catchError(
          (error) => debugPrint('log event error (log app open) $error'),
        );
    await googleAnalytics.logAppOpen().catchError(
          (error) => debugPrint('log event error (log app open) $error'),
        );
  }

  Future logAddToCart(
    itemId,
    itemCategory,
    itemName,
    quantity,
    price,
  ) async {
    await facebookAppEvents
        .logAddToCart(
          id: itemId,
          type: itemCategory,
          currency: currency,
          price: price,
        )
        .catchError(
          (error) => debugPrint('log event error (log add to cart): $error'),
        );
    await googleAnalytics
        .logAddToCart(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          quantity: quantity,
          value: price,
          currency: currency,
        )
        .catchError(
          (error) => debugPrint('log event error (log add to cart): $error'),
        );
  }

  Future logPurchase(totalAmount) async {
    await facebookAppEvents
        .logPurchase(
          amount: totalAmount,
          currency: currency,
        )
        .catchError(
          (error) => debugPrint('log event error (log purchase): $error'),
        );
    await googleAnalytics
        .logEcommercePurchase(
          currency: currency,
          value: totalAmount,
        )
        .catchError(
          (error) => debugPrint('log event error (log purchase): $error'),
        );
  }

  Future logViewItem(
    String itemId,
    double price,
    String itemName,
    String itemCategory,
  ) async {
    await facebookAppEvents
        .logViewContent(
          id: itemId,
          currency: currency,
          price: price,
        )
        .catchError(
          (error) => debugPrint('log event error (log view item): $error'),
        );
    await googleAnalytics
        .logViewItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          currency: currency,
          price: price,
        )
        .catchError(
          (error) => debugPrint('log event error (log view item): $error'),
        );
  }
}
