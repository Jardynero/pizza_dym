// Login phone screen page

// Import libraries
import 'package:flutter/material.dart';

//import widgets
import 'package:pizza_dym/screens/login_screen/login-phone-screen/widgets/login-form.dart';
import 'package:pizza_dym/screens/login_screen/login-phone-screen/widgets/Image-logo.dart';
import 'package:pizza_dym/screens/login_screen/login-phone-screen/widgets/login-text.dart';


class LoginPhoneScreen extends StatelessWidget {
  const LoginPhoneScreen({Key? key}) : super(key: key);

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
                LoginText(),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
