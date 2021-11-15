import 'package:flutter/material.dart';

class ImageLogo extends StatelessWidget {
  const ImageLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 4,
      ),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/img/company-logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}