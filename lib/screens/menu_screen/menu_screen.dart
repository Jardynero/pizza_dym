import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'widgets/widgets.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  GlobalKey bbqKey = GlobalKey();
  GlobalKey neapolitanaKey = GlobalKey();
  GlobalKey sitsiliyaKey = GlobalKey();
  GlobalKey soupsKey = GlobalKey();
  GlobalKey extrasKey = GlobalKey();
  GlobalKey drinksKey = GlobalKey();
  late List<GlobalKey> _categoriesKeys;

  @override
  void initState() {
    CloudFirestore().isRestaurantOpen(context);
    Provider.of<CloudFirestore>(context, listen: false)
        .obtainRestautantSettings();
    super.initState();
    _categoriesKeys = _categoriesKeys = [
      bbqKey,
      neapolitanaKey,
      sitsiliyaKey,
      soupsKey,
      extrasKey,
      drinksKey,
    ];
  }

  final List<String> _categories = [
    'BBQ',
    'Неаполитанская пицца',
    'Сицилийская пицца',
    'Супы',
    'Закуски',
    'Напитки'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MenuAppBar(
            categories: _categories,
            categoriesKeys: _categoriesKeys,
          ),
          SliverVisibility(
            visible: _happyHours() == true ? true : false,
            sliver: CategorieHeading(
              title: 'Акция 2 пиццы за 800 руб',
              categorieName: 'Счастливые часы'
            ),
          ),
          SliverVisibility(
            visible: _happyHours() == true ? true : false,
            sliver: HorizontalItemsList(
              categorieName: 'Счастливые часы',
            ),
          ),
          CategorieHeading(title: 'Самые популярные', categorieName: 'Хиты',),
          HorizontalItemsList(categorieName: 'Хиты'),

          CategorieHeading(title: _categories[0], gKey: _categoriesKeys[0], categorieName: 'bbq'),
          VerticalItemsList(categorieName: 'bbq'),

          CategorieHeading(title: _categories[1], gKey: _categoriesKeys[1], categorieName: 'Неаполитанская пицца'),
          VerticalItemsList(categorieName: 'Неаполитанская пицца'),

          CategorieHeading(title: _categories[2], gKey: _categoriesKeys[2], categorieName: 'Сицилийская пицца'),
          VerticalItemsList(categorieName: 'Сицилийская пицца'),

          CategorieHeading(title: _categories[3], gKey: _categoriesKeys[3], categorieName: 'Супы'),
          VerticalItemsList(categorieName: 'Супы'),

          CategorieHeading(title: _categories[4], gKey: _categoriesKeys[4], categorieName: 'Закуски'),
          VerticalItemsList(categorieName: 'Закуски'),

          CategorieHeading(title: _categories[5], gKey: _categoriesKeys[5],categorieName: 'Напитки'),
          VerticalItemsList(categorieName: 'Напитки'),
        ],
      ),
    );
  }
  _happyHours() {
    bool result;
    DateTime dt = DateTime.now();
    int weekday = DateTime.now().weekday;
    if (weekday == 2 || weekday == 3 || weekday == 4) {
      if (dt.hour >= 12 && dt.hour < 25) {
        result = true;
        return result;
      }
    } else {
      result = false;
      return result;
    }
  }
}
