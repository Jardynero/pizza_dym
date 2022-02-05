import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/screens/single-product_screen.dart';

class SmallItemCard extends StatelessWidget {
  final String image;
  final String title;
  final int price;
  final Map fullItemData;

  const SmallItemCard({
    required this.image,
    required this.title,
    required this.price,
    required this.fullItemData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SingleProductScreen(fullItemData),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 16.0, bottom: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          shadowColor: Colors.grey[300],
          child: Row(
            children: [
              Image(
                image: CachedNetworkImageProvider(this.image),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(this.title,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SingleProductScreen(fullItemData))),
                      child: Text('${this.price} ₽'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
