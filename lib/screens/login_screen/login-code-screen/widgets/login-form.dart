import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:pizza_dym/functions/firebase_functions.dart';
import 'package:pizza_dym/screens/login_screen/theme/Login-code-theme.dart';
import 'package:pizza_dym/screens/nav_screen/navigation_screen.dart';
import 'package:provider/provider.dart';

class LoginCodeForm extends StatefulWidget {
  LoginCodeForm({Key? key}) : super(key: key);
  final FlutterCart cart = FlutterCart();

  @override
  _LoginCodeFormState createState() => _LoginCodeFormState();
}

class _LoginCodeFormState extends State<LoginCodeForm> {
  TextEditingController _smsCode = TextEditingController();
  bool activityIndicator = false;
  bool _confirmBtnState = false;
  bool _timeoutFinish = false;
  int _timeoutSec = 60;

  // Firebase sms code error
  String _smsCodeError = '[firebase_auth/invalid-verification-code]';

  @override
  void initState() {
    reSendSmsCodeTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _userVerificationId =
        Provider.of<FirebaseAuthInstance>(context, listen: false)
            .getVerificationId;
    final _auth =
        Provider.of<FirebaseAuthInstance>(context, listen: false).auth;

    final _userPhoneNumber =
        Provider.of<FirebaseAuthInstance>(context, listen: false)
            .getUserPhoneNumber;

    return activityIndicator
        ? CircularProgressIndicator()
        : Form(
            child: Column(
              children: [
                // Поле ввода СМС кода
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 100 * 7),
                  child: SizedBox(
                    height: 60.0,
                    child: TextFormField(
                      decoration: LoginCodeFormTheme().formDecoration,
                      controller: _smsCode,
                      maxLength: 6,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        if (value.length == 6) {
                          setState(() {
                            _confirmBtnState = true;
                          });
                        } else {
                          setState(() {
                            _confirmBtnState = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
                // Таймер обратного отчета для отправки нового кода
                Visibility(
                  visible: _timeoutSec == 0 ? false : true,
                  child: Container(
                    margin: EdgeInsets.only(
                      // top: MediaQuery.of(context).size.height / 100 * 1.5,
                      left: MediaQuery.of(context).size.width / 100 * 7,
                      right: MediaQuery.of(context).size.width / 100 * 7,
                    ),
                    child: Text(
                      'Если SMS не пришла, повторный код можно запросить через: $_timeoutSec сек',
                    ),
                  ),
                ),
                // Кнопка отправки повторного кода
                Visibility(
                  visible: _timeoutFinish,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 100 * 7,
                      right: MediaQuery.of(context).size.width / 100 * 7,
                    ),
                    child: TextButton(
                      child: Text('Получить нвоый код'),
                      onPressed: () {
                        try {
                          sendNewCode(_auth, _userPhoneNumber);
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ),
                // Кнопка Продолжить
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 100 * 3,
                    left: MediaQuery.of(context).size.width / 100 * 7,
                    right: MediaQuery.of(context).size.width / 100 * 7,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                        child: Text('Продолжить'),
                        onPressed: _confirmBtnState
                            ? () => authenticateUser(_userVerificationId, _auth)
                            : null),
                  ),
                )
              ],
            ),
          );
  }

  // Авторизировать пользователя - кнопка продолжить
  Future authenticateUser(_userVerificationId, _auth) async {
    var _firestoreModel = Provider.of<CloudFirestore>(context, listen: false);
    final String lastPageBeforeLogin = _firestoreModel.lastPageBeforeLogin;
    setState(() {
      activityIndicator = true;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _userVerificationId, smsCode: _smsCode.text);

    // Sign the user in (or link) with the credential
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      setState(() {
        activityIndicator = false;
        if (e.toString().contains('$_smsCodeError') == true) {
          _smsCode.text = '';
          _confirmBtnState = false;

          // Показать Поп Ап
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return incorrectSmsCode();
              });
        }
      });
    }
    if (_auth.currentUser != null) {
      setState(() {
        activityIndicator = false;
      });
      FirebaseAnalytics().logSignUp(signUpMethod: 'Phone Number');
      if (lastPageBeforeLogin == '/cart') {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return NavigationScreen(index: 1);
        }), (route) => false);
      } else if (lastPageBeforeLogin == '/profile') {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return NavigationScreen(index: 2);
        }), (route) => false);
      }
    } else {
      print('error');
    }
  }

  // Таймер отправки повторного кода
  Future reSendSmsCodeTimer() async {
    while (_timeoutSec != 0) {
      if (this.mounted) {
        setState(() {
          _timeoutSec--;
        });
      }
      await Future.delayed(Duration(seconds: 1));
    }
    setState(() {
      _timeoutFinish = true;
    });
  }

  // Запрос нового кода
  Future sendNewCode(_auth, _userPhoneNumber) async {
    var _firestoreModel = Provider.of<CloudFirestore>(context, listen: false);
    final String lastPageBeforeLogin = _firestoreModel.lastPageBeforeLogin;
    await _auth.verifyPhoneNumber(
      phoneNumber: _userPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        if (_auth.currentUser != null) {
          setState(() {
            activityIndicator = false;
          });
          print('Android auth done!');
          Navigator.pushNamedAndRemoveUntil(
              context, '$lastPageBeforeLogin', (route) => false);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _timeoutSec = 60;
          _timeoutFinish = false;
        });
        reSendSmsCodeTimer();
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Alert Dialog - неправильный пароль
  Widget incorrectSmsCode() {
    return AlertDialog(
      title: Text('Неверный код. Попробуйте еще раз'),
      actions: [
        TextButton(
          child: Text('Закрыть'),
          onPressed: () => Navigator.pop(context),
        )
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
