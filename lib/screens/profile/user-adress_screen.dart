import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:provider/provider.dart';

class ProfileUserAdressScreen extends StatefulWidget {
  const ProfileUserAdressScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUserAdressScreen> createState() =>
      _ProfileUserAdressScreenState();
}

class _ProfileUserAdressScreenState extends State<ProfileUserAdressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _streetController = TextEditingController(text: '');
  TextEditingController _entranceController = TextEditingController(text: '');
  TextEditingController _appartmentController = TextEditingController(text: '');
  TextEditingController _floorController = TextEditingController(text: '');
  TextEditingController _intercomController = TextEditingController(text: '');
  TextEditingController _commentController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    String? _userPhoneNumber = Provider.of<FirebaseAuthInstance>(context, listen: false).auth.currentUser!.phoneNumber;
    return Scaffold(
      appBar: MainAppBar('Адрес доставки'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            adressForm(),
            btn(_userPhoneNumber),
          ],
        ),
      ),
    );
  }

  Widget streetField() {
    return TextFormField(
      controller: _streetController,
      decoration: InputDecoration(
          labelText: 'Улица, дом, корпус',
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  Widget entrancetField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 40,
      child: TextFormField(
        controller: _entranceController,
        decoration: InputDecoration(
            labelText: 'Подъезд',
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }

  Widget appartmentField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 40,
      child: TextFormField(
        controller: _appartmentController,
        decoration: InputDecoration(
            labelText: 'Кв/офис',
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }

  Widget floorField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 40,
      child: TextFormField(
        controller: _floorController,
        decoration: InputDecoration(
          labelText: 'Этаж',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  Widget intercomField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 40,
      child: TextFormField(
        controller: _intercomController,
        decoration: InputDecoration(
            labelText: 'Домофон',
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }

  Widget commentField() {
    return Container(
      height: 55,
      padding: EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xff27282A),
        ),
      ),
      child: TextFormField(
        controller: _commentController,
        decoration: InputDecoration(
            labelText: 'Комментарий',
            labelStyle: TextStyle(color: Colors.grey),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none),
      ),
    );
  }

  Widget adressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          streetField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              entrancetField(),
              appartmentField(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              floorField(),
              intercomField(),
            ],
          ),
          commentField(),
        ],
      ),
    );
  }

  Widget btn(_userPhoneNumber) {
    return ElevatedButton(
      child: Text('Сохранить'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print('Saved!');
          print(Provider.of<FirebaseAuthInstance>(context, listen: false).auth.currentUser!.phoneNumber);
          updateUserDeliveryAdress(_userPhoneNumber);
        }
      },
    );
  }
  Future updateUserDeliveryAdress(_userPhoneNumber) async {
    FirebaseFirestore.instance.collection('users').doc('+79175334077').set({
      'Удица дом корпус':'${_streetController.text}',
      'Подъезд':'${_entranceController.text}',
      'Кв/Офис':'${_appartmentController.text}',
      'Этаж':'${_floorController.text}',
      'Домофон':'${_intercomController.text}',
      'Комментарий':'${_commentController.text}',
    });

  }
}
