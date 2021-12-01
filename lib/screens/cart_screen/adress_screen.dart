// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:dadata_suggestions/dadata_suggestions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class AdressScreen extends StatefulWidget {
  final String token = 'fa643a0217437e7dccd6dc79c889e264261414ae';

  const AdressScreen({Key? key}) : super(key: key);

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _streetController = TextEditingController();
  late TextEditingController _houseController = TextEditingController();
  late TextEditingController _blockController = TextEditingController();
  late TextEditingController _entranceController = TextEditingController();
  late TextEditingController _appartmentController = TextEditingController();
  late TextEditingController _floorController = TextEditingController();
  late TextEditingController _intercomController = TextEditingController();
  late TextEditingController _commentController = TextEditingController();
  late DadataSuggestions _suggestions;

  @override
  void initState() {
    _suggestions = DadataSuggestions(widget.token);
    super.initState();
    Future.delayed(Duration(milliseconds: 700), () {
      _streetController.text =
          Provider.of<CartModel>(context, listen: false).userStreet;
      _houseController.text =
          Provider.of<CartModel>(context, listen: false).userHouse;
      _blockController.text =
          Provider.of<CartModel>(context, listen: false).userBlock;
      _entranceController.text =
          Provider.of<CartModel>(context, listen: false).userIntercom;
      _appartmentController.text =
          Provider.of<CartModel>(context, listen: false).userAppartment;
      _floorController.text =
          Provider.of<CartModel>(context, listen: false).userFloor;
      _intercomController.text =
          Provider.of<CartModel>(context, listen: false).userIntercom;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? _userPhoneNumber =
        Provider.of<FirebaseAuthInstance>(context, listen: false)
            .auth
            .currentUser!
            .phoneNumber;
    return Scaffold(
      appBar: MainAppBar('Доставка на дом'),
      body: _main(_userPhoneNumber),
    );
  }

  Widget _main(_userPhoneNumber) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                adressForm(),
                btn(_userPhoneNumber),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget title() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Данные о заказе',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Text(
            'Адрес доставки',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget streetField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _streetController,
        onChanged: (value) {
          setState(() {
            _streetController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        cursorColor: Color(0xffFF9F38),
        decoration: fieldTheme('Улица дом корпус'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Это поле обязательное!';
        }
      },
      debounceDuration: Duration(milliseconds: 600),
      suggestionsCallback: _startSuggesting,
      itemBuilder: (context, suggestion) {
        final s = suggestion as AddressSuggestion;
        return Container(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(s.unrestrictedValue),
          ),
        );
      },
      onSuggestionSelected: (AddressSuggestion a) {
        setState(() {
          _streetController.text = '${a.data.street}';
          if (a.data.house != null) {
            _houseController.text = a.data.house;
          }
          if (a.data.block != null) {
            _blockController.text = a.data.block;
          }
          if (a.data.flat != null) {
            _appartmentController.text = a.data.flat;
          }
        });
      },
    );
  }

  Widget houseField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 30,
      child: TextFormField(
        controller: _houseController,
        onFieldSubmitted: (value) {
          setState(() {
            _houseController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Это поле обязательное!';
          }
        },
        decoration: fieldTheme('Дом'),
      ),
    );
  }

  Widget blockField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 30,
      child: TextFormField(
        controller: _blockController,
        onFieldSubmitted: (value) {
          setState(() {
            _blockController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        decoration: fieldTheme('Корпус'),
      ),
    );
  }

  Widget entrancetField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 30,
      child: TextFormField(
        controller: _entranceController,
        onFieldSubmitted: (value) {
          setState(() {
            _entranceController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        decoration: fieldTheme('Подъезд'),
      ),
    );
  }

  Widget appartmentField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 30,
      child: TextFormField(
        controller: _appartmentController,
        onFieldSubmitted: (value) {
          setState(() {
            _appartmentController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        decoration: fieldTheme('Кв/Офис'),
      ),
    );
  }

  Widget floorField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 30,
      child: TextFormField(
        controller: _floorController,
        onFieldSubmitted: (value) {
          setState(() {
            _floorController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        decoration: fieldTheme('Этаж'),
      ),
    );
  }

  Widget intercomField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 100 * 30,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _intercomController,
        onFieldSubmitted: (value) {
          setState(() {
            _intercomController.value = TextEditingValue(
              text: value,
              selection: TextSelection(
                baseOffset: value.length,
                extentOffset: value.length,
              ),
            );
          });
        },
        decoration: fieldTheme('Домофон'),
      ),
    );
  }

  Widget commentField() {
    return TextFormField(
      controller: _commentController,
      onFieldSubmitted: (value) {
        setState(() {
          _commentController.value = TextEditingValue(
            text: value,
            selection: TextSelection(
              baseOffset: value.length,
              extentOffset: value.length,
            ),
          );
        });
      },
      decoration: fieldTheme('Комментарий'),
    );
  }

  Widget adressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          title(),
          Container(margin: EdgeInsets.only(top: 10), child: streetField()),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                houseField(),
                blockField(),
                entrancetField(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appartmentField(),
                intercomField(),
                floorField(),
              ],
            ),
          ),
          commentField(),
        ],
      ),
    );
  }

  Widget btn(_userPhoneNumber) {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 100 * 2.8, top: 30),
      child: ElevatedButton(
        child: Text('Продолжить', style: TextStyle(fontSize: 20)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print('Saved!');
            updateUserDeliveryAdress(_userPhoneNumber);
            Navigator.pushNamed(context, '/cart/select-delivery-time');
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xff27282A),
          fixedSize: Size(
            MediaQuery.of(context).size.width / 100 * 54,
            MediaQuery.of(context).size.height / 100 * 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future updateUserDeliveryAdress(_userPhoneNumber) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc('$_userPhoneNumber')
        .set({
      'Улица': '${_streetController.text}',
      'Дом': '${_houseController.text}',
      'Корпус': '${_blockController.text}',
      'Подъезд': '${_entranceController.text}',
      'Квартира': '${_appartmentController.text}',
      'Этаж': '${_floorController.text}',
      'Домофон': '${_intercomController.text}',
    });
  }

  Future<List<AddressSuggestion>> _startSuggesting(String text) async {
    final tpts = text.split(',');
    if (tpts.length == 2) {
      final lat = double.tryParse(tpts[0]);
      final lon = double.tryParse(tpts[1]);
      print("found lat $lat lon $lon");
      if (lat != null && lon != null) {
        try {
          final resp = await _suggestions.revGeocode(
            RevgeocodeSuggestionRequest(
              latitude: lat,
              longitude: lon,
            ),
          );
          if (resp != null && resp.suggestions.isNotEmpty) {
            return resp.suggestions;
          }
        } catch (e) {
          print("Caught error in revgeocode $e");
        }
      }
    }
    try {
      final resp = await _suggestions.suggest(
        AddressSuggestionRequest(
          text,
        ),
      );
      if (resp != null && resp.suggestions.isNotEmpty) {
        return resp.suggestions;
      }
    } catch (e) {
      print("Caught error in suggestion query $e");
    }
    return [];
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
}
