import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/screens/menu_screen/widgets/item-list_screen.dart';

class CardCategories extends StatefulWidget {
  CardCategories({Key? key}) : super(key: key);

  @override
  _CardCategoriesState createState() => _CardCategoriesState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _CardCategoriesState extends State<CardCategories> {
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _categories =
        _firestore.collection('restaurant').doc('categories').snapshots();

    return StreamBuilder(
        stream: _categories,
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final _menuCategories = snapshot.data!.get('categories');
          Map _menuCategoriesSorted = {};
          int count = 1;

          sortMenuCategories(count, _menuCategories, _menuCategoriesSorted);

          return ListView(
            children: [
              Padding(padding: EdgeInsets.only(top: 30.0)),
              for (final categorie in _menuCategoriesSorted.values)
                categories(categorie),
              aboutUs(),
            ],
          );
        });
  }

  // Сортирует и выставляет нахвание категорий в правильном порядке
  void sortMenuCategories(count, _menuCategories, _menuCategoriesSorted) {
    while (count != _menuCategories.length + 1) {
      _menuCategoriesSorted[count] = _menuCategories['$count'];
      count++;
    }
  }

  Widget categories(categorie) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemListScreen(categorie[0]),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 140,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage('${categorie[1]}'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomRight,
            colorFilter: ColorFilter.mode(
                Color.fromRGBO(0, 0, 0, 0.5), BlendMode.multiply),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 30, top: 20, right: 150),
          child: Text('${categorie[0]}', style: _categoriesTitleStyle),
        ),
      ),
    );
  }

  Widget aboutUs() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              image: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/pizzadym-5ad61.appspot.com/o/categories%2FО%20нас.png?alt=media&token=f03dff60-7783-4c0b-9efc-aefa118a68ed',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.2), BlendMode.multiply)),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 30, top: 20, right: 140),
          child: Text('О нас', style: _categoriesTitleStyle),
        ),
      ),
    );
  }

  final _categoriesTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
  );
}