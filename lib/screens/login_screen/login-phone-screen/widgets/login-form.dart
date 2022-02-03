import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/screens/login_screen/theme/Login-phone-theme.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _phone = TextEditingController(text: '');
  TextEditingController _name = TextEditingController(text: '');
  bool activityIndicator = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: false).auth;
    double horizontalmargin = MediaQuery.of(context).size.width / 100 * 7;

    return activityIndicator == true
        ? CircularProgressIndicator()

        // Поле ввода номера телефона
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: horizontalmargin,
                      right: horizontalmargin,
                      bottom: 20),
                  child: TextFormField(
                    controller: _name,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите ваше имя';
                      }
                    },
                    decoration: LoginPhoneFormTheme().fieldTheme('Имя'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 100 * 7),
                  child: TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 12,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 12) {
                        return 'Пожалуйста, введите номер телефона';
                      }
                      if (value.startsWith('+7') != true) {
                        return 'Номер телефона должен начинаться с +7';
                      }
                    },
                    decoration:
                        LoginPhoneFormTheme().fieldTheme('Номер телефона'),
                  ),
                ),
                // Кнопка продолжить
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 100 * 1.5,
                    left: MediaQuery.of(context).size.width / 100 * 7,
                    right: MediaQuery.of(context).size.width / 100 * 7,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      child: Text('Войти'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            activityIndicator = true;
                          });
                          authenticateUser(_auth);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // Аутентификация пользователя (по кнопке продолжить)
  Future authenticateUser(_auth) async {
    // Начало верификации
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phone.text,

        // Андроид авто верификация
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },

        // Ошибка верификации
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            activityIndicator = false;
          });
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            Alert(context: context, title: 'ошибка', desc: e.message).show();
          }
        },

        // Код отправлен
        codeSent: (String verificationId, int? resendToken) async {
          context
              .read<FirebaseAuthInstance>()
              .obtainVerificationId(verificationId);
          context
              .read<FirebaseAuthInstance>()
              .obtainUserPhoneNumber(_phone.text);
          setState(() {
            activityIndicator = false;
          });
          await sendUserNameToFirebase();
          Navigator.pushNamed(context, '/login-code');
        },
        timeout: Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Alert(context: context, title: 'ошибка', desc: e.toString()).show();
    }
  }

  Future sendUserNameToFirebase() async {
    String phoneNumber = _phone.text;
    String userName = _name.text;
    FirebaseFirestore.instance.collection('users').doc('$phoneNumber').set({
      'Имя': userName,
    }, SetOptions(merge: true)).catchError(
        (error) => debugPrint('Произошла ошибка записи имени в БД: $error'));
  }
}
