// Single product page

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/widgets.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class SingleProductScreen extends StatefulWidget {
  final data;
  SingleProductScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  int productQnt = 1;

  @override
  void initState() {
    Analytics()
        .logViewItem(
          widget.data['название'],
          widget.data['цена'].toDouble(),
          widget.data['название'],
          widget.data['категория товара'],
        )
        .then((value) =>
            debugPrint('Log event - view item: ${widget.data['название']}'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('${widget.data['название']}'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemImage(context),
            description(context),
            btn(),
          ],
        ),
      ),
    );
  }

  Widget itemImage(context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 100 * 100,
          child: Image(
            image: CachedNetworkImageProvider(
              widget.data['фото'],
            ),
          ),
        ),
      ),
    );
  }

  Widget description(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 100 * 10,
            // top: MediaQuery.of(context).size.height / 100 * 10,
          ),
          padding: EdgeInsets.only(right: 100),
          child: Text(
            '${widget.data['название']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 100 * 10,
            top: MediaQuery.of(context).size.height / 100 * 1,
          ),
          child: Text(
            widget.data['размер'] == ' '
                ? '${widget.data['категория товара']}'
                : '${widget.data['категория товара']}, ${widget.data['размер']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 100 * 10,
            top: MediaQuery.of(context).size.height / 100 * 1,
          ),
          padding: EdgeInsets.only(right: 70),
          child: Text(
            '${widget.data['описание']}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Visibility(
          visible: widget.data['бжу'] == ' ' ? false : true,
          child: Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 100 * 10,
              right: MediaQuery.of(context).size.width / 100 * 10,
              top: MediaQuery.of(context).size.height / 100 * 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вес',
                      style: descriptionTitleStyle,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '${widget.data['вес']}',
                        style: descriptionStyle,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'БЖУ',
                      style: descriptionTitleStyle,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '${widget.data['бжу']}',
                        style: descriptionStyle,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Калорийность',
                      style: descriptionTitleStyle,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        '${widget.data['калорийность']}',
                        style: descriptionStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget btn() {
    return Visibility(
      visible: widget.data['доступность товара'] == false ? false : true,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffFF9F38))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: decrimentQnt,
                    child: Text('-',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Text('$productQnt', style: descriptionTitleStyle),
                  TextButton(
                    onPressed: incrementQnt,
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff27282A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(140.0, 50.0),
                maximumSize: Size(160.0, 50.0),
              ),
              onPressed: () async {
                Provider.of<CartModel>(context, listen: false)
                    .obtainQntOfProduct(widget.data['название']);
                int singleProductQntInCart = 0;

                try {
                  singleProductQntInCart =
                      Provider.of<CartModel>(context, listen: false)
                          .cart
                          .getSpecificItemFromCart(widget.data['название'])!
                          .quantity;
                } catch (e) {
                  setState(() {
                    singleProductQntInCart = 0;
                  });
                }

                Provider.of<CartModel>(context, listen: false)
                    .addProductToCartQnt(
                        widget.data['название'],
                        widget.data['цена'],
                        widget.data['название'],
                        productQnt + singleProductQntInCart,
                        widget.data['фото'].toString());
                Analytics()
                    .logAddToCart(
                      widget.data['название'],
                      widget.data['категория товара'],
                      widget.data['название'],
                      productQnt + singleProductQntInCart,
                      (widget.data['цена'] * productQnt).toDouble(),
                    )
                    .then((value) => debugPrint(
                        'Log event - item ${widget.data['название']} added to cart'));

                Navigator.pop(context);
              },
              child: Text(
                '${widget.data['цена'] * productQnt}₽',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final descriptionTitleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
  );

  final descriptionStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  void incrementQnt() {
    setState(() {
      productQnt++;
    });
  }

  void decrimentQnt() {
    if (productQnt == 1) {
      setState(() {
        productQnt = 1;
      });
    } else {
      setState(() {
        productQnt--;
      });
    }
  }

  void resetProductQnt() {
    setState(() {
      productQnt = 1;
    });
  }
}
