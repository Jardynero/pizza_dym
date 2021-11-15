import 'package:flutter/material.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/widgets/Image-logo.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/widgets/login-change_phone.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/widgets/login-form.dart';
import 'package:pizza_dym/screens/login_screen/login-code-screen/widgets/login-text.dart';

class LoginCodeScreen extends StatelessWidget {
  const LoginCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                ImageLogo(),
                LoginCodeText(),
                LoginCodeForm(),
                ChangePhone(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
