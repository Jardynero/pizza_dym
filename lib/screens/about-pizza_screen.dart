// About pizza page

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';

class AboutPizzaScreen extends StatelessWidget {
  const AboutPizzaScreen({Key? key}) : super(key: key);

  final String _title = 'О нас';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff27282A),
      appBar: MainAppBar('$_title'),
      body: AboutUs(),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics().setCurrentScreen(screenName: 'О нас');
    return ListView(
      children: [
        logo(),
        title('Доставка пиццы из дровяной печи в Зеленограде', 10.0, 10.0, 10.0, 10.0),
        aboutUsPhoto('assets/img/pizzadym abous us 1.png', 20.0, 5.0),
        aboutUsPhoto('assets/img/pizzadym abous us 2.png', 10.0, 5.0),
        title('Неаполитанская пицца', 20.0, 20.0, 0.0, 0.0),
        textDescription('Тесто для нашей пиццы мы готовим по ', 'классическому рецепту. '),
        textDescription('В состав входит: ', 'итальянская мука высокого качества, вода очищенная, соль морская, дрожжи.'),
        textDescription('Тесто проходит ферментацию в течении 48 часов. Для соуса мы используем томаты ', 'из Неаполя.'),
        textDescription('Для начинки мы используем только качественные итальянские продукты ', '🇮🇹'),
        aboutUsPhoto('assets/img/pizzadym abous us 3.png', 20.0, 5.0),
        title('Пицца из дровяной печи', 30.0, 20.0, 0.0, 0.0),
        textDescription('Наша печь была ', 'изготовлена в Италии.'),
        textDescription('При выпекании Неаполитанской пиццы мы используем дрова высокого качества, что дает нам возможность поддерживать температуру ', 'не менее 400 градусов.'),
        textDescription('Тем самым мы придерживаемся ', 'классического Неаполитанского стиля.'),
        aboutUsPhoto('assets/img/pizzadym abous us 4.png', 20.0, 5.0),
        aboutUsPhoto('assets/img/pizzadym abous us 5.png', 20.0, 5.0),
      ],
    );
  }

  Widget logo() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          width: 150,
          height: 150,
          child: Image.asset('assets/img/company-logo black.png')),
    );
  }

  Widget title(text, paddingTop, paddingBot, paddingRight, paddingLeft) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBot, right: paddingRight, left: paddingLeft),
        child: Text(
          '$text',
          style: TextStyle(
            color: Color(0xffD3D3D3),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget aboutUsPhoto(image, double paddingTop, double paddingBot) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBot),
      child: Image.asset('$image'),
    );
  }

  Widget textDescription(text, boldText) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 10.0, bottom: 10.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$text',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: '$boldText',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
