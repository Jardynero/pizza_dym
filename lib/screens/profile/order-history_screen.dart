import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);
  final _nameController = TextEditingController(text: '');
  final _bjuController = TextEditingController(text: ' ');
  final _vesController = TextEditingController(text: 'г');
  final _caloriesController = TextEditingController(text: ' ');
  final _categorieGlobalController =
      TextEditingController(text: 'Неаполитанская пицца');
  final _categorieItemController =
      TextEditingController(text: 'Неаполитанская пицца');
  final _descriptionController = TextEditingController(text: '');
  final _indexController = TextEditingController(text: '');
  final _sizeController = TextEditingController(text: ' ');
  final _photoController = TextEditingController(text: ' ');
  final _priceController = TextEditingController(text: '');

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MainAppBar('История заказов'),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _main(),
            )
          ],
        ),
      ),
    );
  }

  Widget _main() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            field(widget._nameController, 'название'),
            field(widget._descriptionController, 'описание'),
            field(widget._priceController, 'стоимость'),
            field(widget._categorieItemController, 'категория товара'),
            field(widget._categorieGlobalController, 'категория глобальная'),
            field(widget._photoController, 'фото'),
            field(widget._indexController, 'индекс'),
            field(widget._vesController, 'вес'),
            field(widget._caloriesController, 'калорийность'),
            field(widget._bjuController, 'бжу'),
            field(widget._sizeController, 'размер'),
            btn(context),
          ],
        ),
      ),
    );
  }

  Widget btn(context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: ElevatedButton(
        child: Text('ДОБАВИТЬ ТОВАР',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addItemToBd();
          }
        },
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

  Future<void> addItemToBd() {
    CollectionReference newMenu =
        FirebaseFirestore.instance.collection('newMenu');
    return newMenu.doc(widget._nameController.text).set({
      'бжу': widget._bjuController.text,
      'вес': widget._vesController.text,
      'доступность товара': true,
      'калорийность': widget._caloriesController.text,
      'категория': widget._categorieGlobalController.text,
      'категория товара': widget._categorieItemController.text,
      'название': widget._nameController.text,
      'описание': widget._descriptionController.text,
      'порядок': int.parse(widget._indexController.text),
      'размер': widget._sizeController.text,
      'фото': widget._photoController.text,
      'цена': int.parse(widget._priceController.text),
    }).then((value) {
      setState(() {
        widget._nameController.text = '';
        widget._bjuController.text = ' ';
        widget._vesController.text = 'г';
        widget._caloriesController.text = ' ';
        widget._descriptionController.text = '';
        widget._indexController.text = '';
        widget._sizeController.text = ' ';
        widget._photoController.text = '';
        widget._priceController.text = '';
        widget._categorieGlobalController.text = 'Неаполитанская пицца';
        widget._categorieItemController.text = 'Неаполитанская пицца';
      });
    }).catchError((error) {
      print('Ошибка добавления товара в меню: $error');
    });
  }
}

Widget field(controller, label) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Обязательное поле!';
        }
      },
      controller: controller,
      decoration: fieldTheme(label),
    ),
  );
}

InputDecoration fieldTheme(label) {
  return InputDecoration(
    label: Text('$label'),
    labelStyle: TextStyle(fontSize: 14),
    isDense: true,
    contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
    floatingLabelStyle: TextStyle(
      color: Color(0xffFF9F38),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Color(0xffFF9F38),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Color(0xffC4C4C4),
      ),
    ),
  );
}
