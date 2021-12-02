// Single product page

import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar.dart';
import 'package:pizza_dym/models/cart_model.dart';
import 'package:provider/provider.dart';

class SingleProductScreen extends StatefulWidget {
  final List data;
  SingleProductScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  int productQnt = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar('${widget.data[0]}'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          width: MediaQuery.of(context).size.width / 100 * 80,
          height: MediaQuery.of(context).size.height / 100 * 30,
          child: Image.network('${widget.data[4]}'),
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
            '${widget.data[0]}',
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
            widget.data[7] == ' '
                ? '${widget.data[6]}'
                : '${widget.data[6]}, ${widget.data[7]}',
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
            '${widget.data[1]}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Visibility(
          visible: widget.data[9] == ' ' ? false : true,
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
                        '${widget.data[8]}',
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
                        '${widget.data[9]}',
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
                        '${widget.data[10]}',
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
      visible: widget.data[5] == false ? false : true,
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
            onPressed: () {
              Provider.of<CartModel>(context, listen: false)
                  .obtainQntOfProduct(widget.data[0]);
              int singleProductQntInCart = 0;

              try {
                singleProductQntInCart = Provider.of<CartModel>(context, listen: false).cart.getSpecificItemFromCart(widget.data[0])!.quantity;
              } catch (e) {
                setState(() {
                  singleProductQntInCart = 0;
                });
              }

              
              
              print(singleProductQntInCart);
    
              Provider.of<CartModel>(context, listen: false).addProductToCartQnt(
                  widget.data[0],
                  widget.data[2],
                  widget.data[0],
                  productQnt + singleProductQntInCart,
                  widget.data[4].toString());
              
              
              Navigator.pop(context);
            },
            child: Text('${widget.data[2] * productQnt}₽',
                style: TextStyle(
                  fontSize: 15,
                )),
          ),
        ],
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
