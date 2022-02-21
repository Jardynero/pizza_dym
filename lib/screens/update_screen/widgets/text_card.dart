import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 40.0, 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/img/pizzadym AppIcon.png',
                width: 50,
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Пиццерия Дым',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text.rich(
              TextSpan(
                text: 'Пожалуйста обновите приложение',
                children: [
                  TextSpan(
                    text: ' Пицца Дым ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'до последней версии, что бы продолжить пользоваться приложением.',
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
