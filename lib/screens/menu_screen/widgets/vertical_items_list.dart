import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class VerticalItemsList extends StatelessWidget {
  final String categorieName;

  const VerticalItemsList({
    required this.categorieName,
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
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return SliverList(
            delegate: SliverChildListDelegate.fixed(
              snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ItemCard(data);
                },
              ).toList(),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildListDelegate.fixed(
            List.generate(30, (index) => ItemCardShimmer()),
          ),
        );
      },
    );
  }
}
