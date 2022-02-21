import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpsaleHeading extends StatelessWidget {
  final String title;
  final String categorieName;
  final GlobalKey? gKey;

  const UpsaleHeading({
    required this.title,
    required this.categorieName,
    this.gKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot> _menu = FirebaseFirestore.instance
        .collection('newMenu')
        .where('категория', isEqualTo: categorieName)
        .orderBy(
          'цена',
          descending: false,
        )
        .get();
    return FutureBuilder<QuerySnapshot>(
      future: _menu,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length == 0) {
          return SizedBox.shrink();
        }
        return Padding(
          key: gKey,
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        );
      },
    );
  }
}
