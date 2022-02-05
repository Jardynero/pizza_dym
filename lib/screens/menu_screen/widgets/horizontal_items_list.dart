import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class HorizontalItemsList extends StatelessWidget {
  final String categorieName;

  const HorizontalItemsList({
    required this.categorieName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _menu = FirebaseFirestore.instance
        .collection('newMenu')
        .where('категория', isEqualTo: categorieName)
        .get();
    return SliverToBoxAdapter(
      child: Container(
        height: 120,
        child: FutureBuilder<QuerySnapshot>(
          future: _menu,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return SmallItemCard(
                    title: data['название'],
                    image: data['фото'],
                    price: data['цена'],
                    fullItemData: data,
                  );
                }).toList(),
              );
            }
            return ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(3, (index) => SmallItemCardShimmer()),
            );
          },
        ),
      ),
    );
  }
}
